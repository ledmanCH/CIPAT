UNIT uApiDiff;

{$mode delphi}{$H+}

INTERFACE

USES
  Classes, SysUtils, Contnrs, fpjson, jsonparser;

TYPE
  TDiffKind = (dkAdded, dkRemoved, dkChanged);

  TDiffOptions = RECORD
    IgnoreInfoVersion: Boolean;
    IgnoreTexts: Boolean;
    IgnoreRefCase: Boolean;
  END;

  TDiffItem = CLASS
  PUBLIC
    Kind: TDiffKind;
    Category: STRING;
    Element: STRING;
    Path: STRING;
    OldValue: STRING;
    NewValue: STRING;
    OldShort: STRING;
    NewShort: STRING;
    FUNCTION KindText: STRING;
    FUNCTION MatchesFilter(CONST AFilter: STRING): Boolean;
  END;

  TApiComparer = CLASS
  PRIVATE
    FItems: TObjectList;
    FOptions: TDiffOptions;
    FUNCTION GetCount: Integer;
    FUNCTION GetItem(AIndex: Integer): TDiffItem;
    PROCEDURE AddItem(AKind: TDiffKind; CONST ASegs: TStringArray; AOld, ANew: TJSONData);
    FUNCTION FindMember(CONST ASegs: TStringArray; AObj, AOther: TJSONObject; CONST AKey: STRING): TJSONData;
    FUNCTION IsIgnoredKey(CONST ASegs: TStringArray; CONST AKey: STRING; AOld, ANew: TJSONData): Boolean;
    FUNCTION ArrayItemKey(AItem: TJSONData): STRING;
    FUNCTION ScalarEqual(CONST ASegs: TStringArray; AOld, ANew: TJSONData): Boolean;
    PROCEDURE CompareNode(CONST ASegs: TStringArray; AOld, ANew: TJSONData);
    PROCEDURE CompareObject(CONST ASegs: TStringArray; AOld, ANew: TJSONObject);
    PROCEDURE CompareArray(CONST ASegs: TStringArray; AOld, ANew: TJSONArray);
  PUBLIC
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    PROCEDURE Compare(AOld, ANew: TJSONData; CONST AOptions: TDiffOptions);
    PROCEDURE CompareFiles(CONST AOldFile, ANewFile: STRING; CONST AOptions: TDiffOptions);
    FUNCTION Summary: STRING;
    FUNCTION ToMarkdown(CONST ATitle: STRING): STRING;
    PROPERTY Count: Integer READ GetCount;
    PROPERTY Items[AIndex: Integer]: TDiffItem READ GetItem; DEFAULT;
  END;

FUNCTION LoadJsonFile(CONST AFileName: STRING): TJSONData;
FUNCTION CompareVersionText(CONST A, B: STRING): Integer;
FUNCTION VersionFromFileName(CONST AFileName: STRING): STRING;
FUNCTION OneLine(CONST AText: STRING; AMaxLen: Integer): STRING;

IMPLEMENTATION

CONST
  HTTP_METHODS: ARRAY[0..7] OF STRING = ('get', 'put', 'post', 'delete', 'patch', 'head', 'options', 'trace');
  KIND_RANK: ARRAY[TDiffKind] OF Integer = (2, 0, 1);

FUNCTION LoadJsonFile(CONST AFileName: STRING): TJSONData;
// Parse a JSON file (UTF-8)
VAR
  Stream: TFileStream;
BEGIN
  Stream := TFileStream.Create(AFileName, fmOpenRead OR fmShareDenyWrite);
  TRY
    Result := GetJSON(Stream, True);
  FINALLY
    Stream.Free;
  END;
END;

FUNCTION CompareVersionText(CONST A, B: STRING): Integer;
// Compare dotted versions numerically ("2025.6.7" < "2025.11.2"), text fallback
VAR
  PartsA, PartsB: TStringArray;
  I, NA, NB: Integer;
BEGIN
  PartsA := A.Split(['.']);
  PartsB := B.Split(['.']);
  I := 0;
  WHILE (I < Length(PartsA)) AND (I < Length(PartsB)) DO
  BEGIN
    IF TryStrToInt(PartsA[I], NA) AND TryStrToInt(PartsB[I], NB) THEN
      Result := NA - NB
    ELSE
      Result := CompareText(PartsA[I], PartsB[I]);
    IF Result <> 0 THEN
      Exit;
    Inc(I);
  END;
  Result := Length(PartsA) - Length(PartsB);
END;

FUNCTION VersionFromFileName(CONST AFileName: STRING): STRING;
// "Cockpit ITSM Portal - Public API - 2026.08.4.json" -> "2026.08.4"
VAR
  P: Integer;
BEGIN
  Result := ChangeFileExt(ExtractFileName(AFileName), '');
  P := Result.LastIndexOf(' - ');
  IF P >= 0 THEN
    Result := Trim(Copy(Result, P + 4, MaxInt));
END;

FUNCTION OneLine(CONST AText: STRING; AMaxLen: Integer): STRING;
// Single-line, truncated representation for list display
BEGIN
  Result := StringReplace(AText, #13, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
  IF (AMaxLen > 0) AND (Length(Result) > AMaxLen) THEN
    Result := Copy(Result, 1, AMaxLen) + '…';
END;

FUNCTION AddSeg(CONST ASegs: TStringArray; CONST ASeg: STRING): TStringArray;
// Return a copy of ASegs with ASeg appended
BEGIN
  Result := Copy(ASegs);
  SetLength(Result, Length(Result) + 1);
  Result[High(Result)] := ASeg;
END;

FUNCTION JoinSegs(CONST ASegs: TStringArray; AFrom: Integer): STRING;
// Human readable path: "properties.tags.items" / "parameters[query:id]"
VAR
  I: Integer;
BEGIN
  Result := '';
  FOR I := AFrom TO High(ASegs) DO
  BEGIN
    IF (Result <> '') AND NOT ASegs[I].StartsWith('[') THEN
      Result := Result + '.';
    Result := Result + ASegs[I];
  END;
END;

FUNCTION ValueText(AData: TJSONData): STRING;
// Full text of a value: plain for strings, formatted JSON otherwise
BEGIN
  IF AData = NIL THEN
    Result := ''
  ELSE IF AData.JSONType = jtString THEN
    Result := AData.AsString
  ELSE IF AData.JSONType IN [jtObject, jtArray] THEN
    Result := AData.FormatJSON
  ELSE
    Result := AData.AsJSON;
END;

FUNCTION ValueShort(AData: TJSONData): STRING;
// Compact single-line text of a value
BEGIN
  IF AData = NIL THEN
    Result := ''
  ELSE IF AData.JSONType = jtString THEN
    Result := OneLine(AData.AsString, 0)
  ELSE
    Result := AData.AsJSON;
END;

FUNCTION IsHttpMethod(CONST S: STRING): Boolean;
VAR
  M: STRING;
BEGIN
  Result := False;
  FOR M IN HTTP_METHODS DO
    IF S = M THEN
      Exit(True);
END;

FUNCTION SortItems(Item1, Item2: Pointer): Integer;
// Order by category, element, path
VAR
  A, B: TDiffItem;
BEGIN
  A := TDiffItem(Item1);
  B := TDiffItem(Item2);
  Result := CompareText(A.Category, B.Category);
  IF Result = 0 THEN
    Result := CompareText(A.Element, B.Element);
  IF Result = 0 THEN
    Result := CompareStr(A.Element, B.Element);
  IF Result = 0 THEN
    Result := CompareText(A.Path, B.Path);
  IF Result = 0 THEN
    Result := KIND_RANK[A.Kind] - KIND_RANK[B.Kind];
  IF Result = 0 THEN
    Result := CompareText(A.OldShort + A.NewShort, B.OldShort + B.NewShort);
END;

{ TDiffItem }

FUNCTION TDiffItem.KindText: STRING;
BEGIN
  CASE Kind OF
    dkAdded: Result := 'Added';
    dkRemoved: Result := 'Removed';
  ELSE
    Result := 'Changed';
  END;
END;

FUNCTION TDiffItem.MatchesFilter(CONST AFilter: STRING): Boolean;
// Case-insensitive search in every column
VAR
  F: STRING;
BEGIN
  IF AFilter = '' THEN
    Exit(True);
  F := LowerCase(AFilter);
  Result := (Pos(F, LowerCase(KindText)) > 0) OR (Pos(F, LowerCase(Category)) > 0)
    OR (Pos(F, LowerCase(Element)) > 0) OR (Pos(F, LowerCase(Path)) > 0)
    OR (Pos(F, LowerCase(OldValue)) > 0) OR (Pos(F, LowerCase(NewValue)) > 0);
END;

{ TApiComparer }

CONSTRUCTOR TApiComparer.Create;
BEGIN
  INHERITED Create;
  FItems := TObjectList.Create(True);
END;

DESTRUCTOR TApiComparer.Destroy;
BEGIN
  FItems.Free;
  INHERITED Destroy;
END;

FUNCTION TApiComparer.GetCount: Integer;
BEGIN
  Result := FItems.Count;
END;

FUNCTION TApiComparer.GetItem(AIndex: Integer): TDiffItem;
BEGIN
  Result := TDiffItem(FItems[AIndex]);
END;

PROCEDURE TApiComparer.AddItem(AKind: TDiffKind; CONST ASegs: TStringArray; AOld, ANew: TJSONData);
// Build a diff item, splitting the path into category / element / sub-path
VAR
  Item: TDiffItem;
  N: Integer;
BEGIN
  Item := TDiffItem.Create;
  Item.Kind := AKind;
  Item.OldValue := ValueText(AOld);
  Item.NewValue := ValueText(ANew);
  Item.OldShort := ValueShort(AOld);
  Item.NewShort := ValueShort(ANew);
  N := Length(ASegs);
  IF (N >= 2) AND (ASegs[0] = 'paths') THEN
  BEGIN
    Item.Category := 'Endpoint';
    IF (N >= 3) AND IsHttpMethod(ASegs[2]) THEN
    BEGIN
      Item.Element := UpperCase(ASegs[2]) + ' ' + ASegs[1];
      Item.Path := JoinSegs(ASegs, 3);
    END
    ELSE
    BEGIN
      Item.Element := ASegs[1];
      Item.Path := JoinSegs(ASegs, 2);
    END;
  END
  ELSE IF (N >= 3) AND (ASegs[0] = 'components') AND (ASegs[1] = 'schemas') THEN
  BEGIN
    Item.Category := 'Schema';
    Item.Element := ASegs[2];
    Item.Path := JoinSegs(ASegs, 3);
  END
  ELSE IF (N >= 3) AND (ASegs[0] = 'components') THEN
  BEGIN
    Item.Category := 'Component';
    Item.Element := ASegs[1] + '.' + ASegs[2];
    Item.Path := JoinSegs(ASegs, 3);
  END
  ELSE IF (N >= 1) AND (ASegs[0] = 'info') THEN
  BEGIN
    Item.Category := 'Info';
    Item.Element := 'info';
    Item.Path := JoinSegs(ASegs, 1);
  END
  ELSE IF (N >= 1) AND (ASegs[0] = 'tags') THEN
  BEGIN
    Item.Category := 'Tag';
    Item.Element := 'tags';
    Item.Path := JoinSegs(ASegs, 1);
  END
  ELSE
  BEGIN
    Item.Category := 'Other';
    Item.Element := JoinSegs(ASegs, 0);
    Item.Path := '';
  END;
  FItems.Add(Item);
END;

FUNCTION TApiComparer.FindMember(CONST ASegs: TStringArray; AObj, AOther: TJSONObject; CONST AKey: STRING): TJSONData;
// Find AKey in AObj; for schema names, optionally match case-insensitively
// when the exact name does not exist in AOther (renamed schema)
VAR
  I: Integer;
BEGIN
  Result := AObj.Find(AKey);
  IF (Result <> NIL) OR NOT FOptions.IgnoreRefCase OR (Length(ASegs) <> 2)
    OR (ASegs[0] <> 'components') OR (ASegs[1] <> 'schemas') THEN
    Exit;
  FOR I := 0 TO AObj.Count - 1 DO
    IF SameText(AObj.Names[I], AKey) AND (AOther.IndexOfName(AObj.Names[I]) < 0) THEN
      Exit(AObj.Items[I]);
END;

FUNCTION TApiComparer.IsIgnoredKey(CONST ASegs: TStringArray; CONST AKey: STRING; AOld, ANew: TJSONData): Boolean;
// Keys excluded from the comparison
BEGIN
  IF AKey = 'operationId' THEN
    Exit(True);
  IF (Length(ASegs) >= 1) AND (ASegs[0] = 'servers') AND (AKey = 'url') THEN
    Exit(True);
  IF FOptions.IgnoreInfoVersion AND (Length(ASegs) = 1) AND (ASegs[0] = 'info') AND (AKey = 'version') THEN
    Exit(True);
  // Text-only keys: a property *named* "description" is an object, not a string
  IF FOptions.IgnoreTexts AND ((AKey = 'description') OR (AKey = 'summary'))
    AND ((AOld = NIL) OR (AOld.JSONType = jtString))
    AND ((ANew = NIL) OR (ANew.JSONType = jtString)) THEN
    Exit(True);
  Result := False;
END;

FUNCTION TApiComparer.ArrayItemKey(AItem: TJSONData): STRING;
// Identity of an array element: parameter (in + name), named object, $ref, or '' if none
VAR
  Obj: TJSONObject;
  Data: TJSONData;
BEGIN
  Result := '';
  IF AItem.JSONType <> jtObject THEN
    Exit;
  Obj := TJSONObject(AItem);
  Data := Obj.Find('name');
  IF (Data <> NIL) AND (Data.JSONType = jtString) THEN
  BEGIN
    Result := Data.AsString;
    Data := Obj.Find('in');
    IF (Data <> NIL) AND (Data.JSONType = jtString) THEN
      Result := Data.AsString + ':' + Result;
    Exit;
  END;
  Data := Obj.Find('$ref');
  IF (Data <> NIL) AND (Data.JSONType = jtString) THEN
  BEGIN
    Result := Data.AsString;
    IF FOptions.IgnoreRefCase THEN
      Result := LowerCase(Result);
  END;
END;

FUNCTION TApiComparer.ScalarEqual(CONST ASegs: TStringArray; AOld, ANew: TJSONData): Boolean;
BEGIN
  IF FOptions.IgnoreRefCase AND (Length(ASegs) > 0) AND (ASegs[High(ASegs)] = '$ref')
    AND (AOld.JSONType = jtString) AND (ANew.JSONType = jtString) THEN
    Result := SameText(AOld.AsString, ANew.AsString)
  ELSE
    Result := AOld.AsJSON = ANew.AsJSON;
END;

PROCEDURE TApiComparer.CompareNode(CONST ASegs: TStringArray; AOld, ANew: TJSONData);
BEGIN
  IF (AOld.JSONType = jtObject) AND (ANew.JSONType = jtObject) THEN
    CompareObject(ASegs, TJSONObject(AOld), TJSONObject(ANew))
  ELSE IF (AOld.JSONType = jtArray) AND (ANew.JSONType = jtArray) THEN
    CompareArray(ASegs, TJSONArray(AOld), TJSONArray(ANew))
  ELSE IF (AOld.JSONType IN [jtObject, jtArray]) OR (ANew.JSONType IN [jtObject, jtArray]) THEN
    AddItem(dkChanged, ASegs, AOld, ANew)
  ELSE IF NOT ScalarEqual(ASegs, AOld, ANew) THEN
    AddItem(dkChanged, ASegs, AOld, ANew);
END;

PROCEDURE TApiComparer.CompareObject(CONST ASegs: TStringArray; AOld, ANew: TJSONObject);
VAR
  I: Integer;
  Key: STRING;
  Other: TJSONData;
BEGIN
  FOR I := 0 TO AOld.Count - 1 DO
  BEGIN
    Key := AOld.Names[I];
    Other := FindMember(ASegs, ANew, AOld, Key);
    IF IsIgnoredKey(ASegs, Key, AOld.Items[I], Other) THEN
      Continue;
    IF Other = NIL THEN
      AddItem(dkRemoved, AddSeg(ASegs, Key), AOld.Items[I], NIL)
    ELSE
      CompareNode(AddSeg(ASegs, Key), AOld.Items[I], Other);
  END;
  FOR I := 0 TO ANew.Count - 1 DO
  BEGIN
    Key := ANew.Names[I];
    IF (FindMember(ASegs, AOld, ANew, Key) = NIL) AND NOT IsIgnoredKey(ASegs, Key, NIL, ANew.Items[I]) THEN
      AddItem(dkAdded, AddSeg(ASegs, Key), NIL, ANew.Items[I]);
  END;
END;

PROCEDURE TApiComparer.CompareArray(CONST ASegs: TStringArray; AOld, ANew: TJSONArray);
// Order-insensitive: scalars as sets, objects by identity key, otherwise by index
VAR
  I, J: Integer;
  AllScalar, AllKeyed: Boolean;
  OldKeys, NewKeys: TStringList;
BEGIN
  AllScalar := True;
  AllKeyed := True;
  OldKeys := TStringList.Create;
  NewKeys := TStringList.Create;
  TRY
    FOR I := 0 TO AOld.Count - 1 DO
    BEGIN
      IF AOld.Items[I].JSONType IN [jtObject, jtArray] THEN
        AllScalar := False;
      OldKeys.Add(ArrayItemKey(AOld.Items[I]));
      IF OldKeys[I] = '' THEN
        AllKeyed := False;
    END;
    FOR I := 0 TO ANew.Count - 1 DO
    BEGIN
      IF ANew.Items[I].JSONType IN [jtObject, jtArray] THEN
        AllScalar := False;
      NewKeys.Add(ArrayItemKey(ANew.Items[I]));
      IF NewKeys[I] = '' THEN
        AllKeyed := False;
    END;

    IF AllScalar THEN
    BEGIN
      OldKeys.Clear;
      NewKeys.Clear;
      FOR I := 0 TO AOld.Count - 1 DO
        OldKeys.Add(AOld.Items[I].AsJSON);
      FOR I := 0 TO ANew.Count - 1 DO
        NewKeys.Add(ANew.Items[I].AsJSON);
      FOR I := 0 TO AOld.Count - 1 DO
        IF NewKeys.IndexOf(OldKeys[I]) < 0 THEN
          AddItem(dkRemoved, AddSeg(ASegs, '[]'), AOld.Items[I], NIL);
      FOR I := 0 TO ANew.Count - 1 DO
        IF OldKeys.IndexOf(NewKeys[I]) < 0 THEN
          AddItem(dkAdded, AddSeg(ASegs, '[]'), NIL, ANew.Items[I]);
    END
    ELSE IF AllKeyed THEN
    BEGIN
      FOR I := 0 TO AOld.Count - 1 DO
      BEGIN
        J := NewKeys.IndexOf(OldKeys[I]);
        IF J < 0 THEN
          AddItem(dkRemoved, AddSeg(ASegs, '[' + OldKeys[I] + ']'), AOld.Items[I], NIL)
        ELSE
          CompareNode(AddSeg(ASegs, '[' + OldKeys[I] + ']'), AOld.Items[I], ANew.Items[J]);
      END;
      FOR I := 0 TO ANew.Count - 1 DO
        IF OldKeys.IndexOf(NewKeys[I]) < 0 THEN
          AddItem(dkAdded, AddSeg(ASegs, '[' + NewKeys[I] + ']'), NIL, ANew.Items[I]);
    END
    ELSE
    BEGIN
      FOR I := 0 TO AOld.Count - 1 DO
        IF I < ANew.Count THEN
          CompareNode(AddSeg(ASegs, '[' + IntToStr(I) + ']'), AOld.Items[I], ANew.Items[I])
        ELSE
          AddItem(dkRemoved, AddSeg(ASegs, '[' + IntToStr(I) + ']'), AOld.Items[I], NIL);
      FOR I := AOld.Count TO ANew.Count - 1 DO
        AddItem(dkAdded, AddSeg(ASegs, '[' + IntToStr(I) + ']'), NIL, ANew.Items[I]);
    END;
  FINALLY
    OldKeys.Free;
    NewKeys.Free;
  END;
END;

PROCEDURE TApiComparer.Compare(AOld, ANew: TJSONData; CONST AOptions: TDiffOptions);
BEGIN
  FItems.Clear;
  FOptions := AOptions;
  CompareNode(NIL, AOld, ANew);
  FItems.Sort(SortItems);
END;

PROCEDURE TApiComparer.CompareFiles(CONST AOldFile, ANewFile: STRING; CONST AOptions: TDiffOptions);
VAR
  OldData, NewData: TJSONData;
BEGIN
  OldData := NIL;
  NewData := NIL;
  TRY
    OldData := LoadJsonFile(AOldFile);
    NewData := LoadJsonFile(ANewFile);
    Compare(OldData, NewData, AOptions);
  FINALLY
    OldData.Free;
    NewData.Free;
  END;
END;

FUNCTION TApiComparer.Summary: STRING;
// Counters: totals, endpoints and schemas added/removed
VAR
  I, NAdd, NDel, NChg, EpAdd, EpDel, ScAdd, ScDel: Integer;
  Item: TDiffItem;
BEGIN
  NAdd := 0; NDel := 0; NChg := 0;
  EpAdd := 0; EpDel := 0; ScAdd := 0; ScDel := 0;
  FOR I := 0 TO Count - 1 DO
  BEGIN
    Item := Items[I];
    CASE Item.Kind OF
      dkAdded: Inc(NAdd);
      dkRemoved: Inc(NDel);
      dkChanged: Inc(NChg);
    END;
    IF Item.Path = '' THEN
    BEGIN
      IF Item.Category = 'Endpoint' THEN
      BEGIN
        IF Item.Kind = dkAdded THEN Inc(EpAdd) ELSE IF Item.Kind = dkRemoved THEN Inc(EpDel);
      END
      ELSE IF Item.Category = 'Schema' THEN
      BEGIN
        IF Item.Kind = dkAdded THEN Inc(ScAdd) ELSE IF Item.Kind = dkRemoved THEN Inc(ScDel);
      END;
    END;
  END;
  Result := Format('%d difference(s): %d added, %d removed, %d changed  —  ' +
    'Endpoints +%d / -%d  —  Schemas +%d / -%d', [Count, NAdd, NDel, NChg, EpAdd, EpDel, ScAdd, ScDel]);
END;

FUNCTION TApiComparer.ToMarkdown(CONST ATitle: STRING): STRING;
// Markdown report grouped by element
VAR
  SL: TStringList;
  I: Integer;
  Item: TDiffItem;
  LastGroup, Group, Line: STRING;
BEGIN
  SL := TStringList.Create;
  TRY
    SL.Add('## ' + ATitle);
    SL.Add('');
    IF Count = 0 THEN
      SL.Add('_No difference._')
    ELSE
    BEGIN
      SL.Add(Summary);
      LastGroup := '';
      FOR I := 0 TO Count - 1 DO
      BEGIN
        Item := Items[I];
        Group := Item.Category + ' ' + Item.Element;
        IF Group <> LastGroup THEN
        BEGIN
          SL.Add('');
          SL.Add('### ' + Group);
          LastGroup := Group;
        END;
        Line := '- **' + Item.KindText + '**';
        IF Item.Path <> '' THEN
          Line := Line + ' `' + Item.Path + '`';
        CASE Item.Kind OF
          dkAdded: Line := Line + ': `' + OneLine(Item.NewShort, 300) + '`';
          dkRemoved: Line := Line + ': `' + OneLine(Item.OldShort, 300) + '`';
          dkChanged: Line := Line + ': `' + OneLine(Item.OldShort, 300) + '` → `' + OneLine(Item.NewShort, 300) + '`';
        END;
        SL.Add(Line);
      END;
    END;
    SL.Add('');
    Result := SL.Text;
  FINALLY
    SL.Free;
  END;
END;

END.
