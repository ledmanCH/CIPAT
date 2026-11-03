UNIT uMain;

{$mode delphi}{$H+}

INTERFACE

USES
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Grids, Buttons, Menus, IniFiles, laz.VirtualTrees,
  SynEdit, SynHighlighterJSON, SynHighlighterPas, SynHighlighterJava, SynHighlighterPython, SynHighlighterJScript, SynHighlighterCS, SynHighlighterPowerShell, SynHighlighterVB, fpjson, jsonparser, uApiDiff,
  uApiGen, uCockpitItsmCore, SynEditHighlighter, SynColorDialogForm,
  SynEditOptionsDialog, SynEditSettings, uAbout;

TYPE

  // Language of the generated file
  TGenLanguage = (glPascal, glPython, glJava, glNode, glCSharp, glPowerShell, glVB);

  // Endpoint tree node: tag group (Ep = NIL) or endpoint
  TNodeData = RECORD
    Ep: TEndpoint;
    Tag: STRING;
    Count: Integer;
  END;
  PNodeData = ^TNodeData;

  { TfrmMain }

  TfrmMain = CLASS(TForm)
    btnBrowse: TButton;
    btnCompare: TBitBtn;
    btnExport: TBitBtn;
    btnGenerate: TBitBtn;
    cbLanguage: TComboBox;
    imgLanguage: TImage;
    lblLanguage: TLabel;
    mnuColorJava: TMenuItem;
    mnuColorPython: TMenuItem;
    mnuColorJScript: TMenuItem;
    mnuColorCSharp: TMenuItem;
    mnuColorPowerShell: TMenuItem;
    mnuColorVB: TMenuItem;
    synJava: TSynJavaSyn;
    synPython: TSynPythonSyn;
    synJScript: TSynJScriptSyn;
    synCS: TSynCSSyn;
    synVB: TSynVBSyn;
    btnHistory: TBitBtn;
    btnSend: TBitBtn;
    btnTestConn: TBitBtn;
    btnUncheckAll: TBitBtn;
    btnUnitBrowse: TButton;
    cbGenVersion: TComboBox;
    cbNew: TComboBox;
    cbOld: TComboBox;
    chkAllPages: TCheckBox;
    chkGenDeprecated: TCheckBox;
    chkGenSelected: TCheckBox;
    chkGenSupported: TCheckBox;
    chkIgnoreCase: TCheckBox;
    chkIgnoreTexts: TCheckBox;
    chkIgnoreVersion: TCheckBox;
    chkSaaS: TCheckBox;
    chkSaveSecret: TCheckBox;
    dlgFolder: TSelectDirectoryDialog;
    dlgSave: TSaveDialog;
    dlgUnit: TSaveDialog;
    edClientId: TEdit;
    edFilter: TEdit;
    edFolder: TEdit;
    edSecret: TEdit;
    edTenant: TEdit;
    edTreeFilter: TEdit;
    edUnitFile: TEdit;
    gbConfig: TGroupBox;
    ilIcons: TImageList;
    lblBaseUrl: TLabel;
    lblBody: TLabel;
    lblClientId: TLabel;
    lblDocDesc: TLabel;
    lblDocReq: TLabel;
    lblDocResp: TLabel;
    lblDocTitle: TLabel;
    lblFilter: TLabel;
    lblFolder: TLabel;
    lblGenSummary: TLabel;
    lblGenVersion: TLabel;
    lblNew: TLabel;
    lblOld: TLabel;
    lblRespStatus: TLabel;
    lblSecret: TLabel;
    lblTenant: TLabel;
    lblTestEndpoint: TLabel;
    lblTestInfo: TLabel;
    lblUnit: TLabel;
    lvDiff: TListView;
    memBody: TSynEdit;
    memDetail: TSynEdit;
    memDocReq: TSynEdit;
    memDocResp: TSynEdit;
    memGenCode: TSynEdit;
    memResp: TSynEdit;
    mnuColorJSON: TMenuItem;
    mnuColorPascal: TMenuItem;
    pnlBottom: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pcApi: TPageControl;
    pcMain: TPageControl;
    pnlApiLeft: TPanel;
    pnlApiTop: TPanel;
    pnlBodyBar: TPanel;
    pnlDiff: TPanel;
    pnlDocReq: TPanel;
    pnlDocResp: TPanel;
    pnlDocTop: TPanel;
    pnlGenTop: TPanel;
    pnlTestEp: TPanel;
    pnlTestReq: TPanel;
    pnlTestResp: TPanel;
    pnlTop: TPanel;
    pmColors: TPopupMenu;
    sbColors: TSpeedButton;
    sbOptions: TSpeedButton;
    sbMain: TStatusBar;
    sbExit: TSpeedButton;
    sgDocParams: TStringGrid;
    sgParams: TStringGrid;
    sbAbout: TSpeedButton;
    splApi: TSplitter;
    splDetail: TSplitter;
    splDoc: TSplitter;
    splTest: TSplitter;
    synJSON: TSynJSONSyn;
    synPas: TSynPasSyn;
    tsApi: TTabSheet;
    tsDetail: TTabSheet;
    tsDiff: TTabSheet;
    tsGenerate: TTabSheet;
    tsTest: TTabSheet;
    vstEndpoints: TLazVirtualStringTree;
    PROCEDURE btnBrowseClick(Sender: TObject);
    PROCEDURE btnCompareClick(Sender: TObject);
    PROCEDURE btnExportClick(Sender: TObject);
    PROCEDURE btnGenerateClick(Sender: TObject);
    PROCEDURE cbLanguageChange(Sender: TObject);
    PROCEDURE btnHistoryClick(Sender: TObject);
    PROCEDURE btnSendClick(Sender: TObject);
    PROCEDURE btnTestConnClick(Sender: TObject);
    PROCEDURE btnUncheckAllClick(Sender: TObject);
    PROCEDURE btnUnitBrowseClick(Sender: TObject);
    PROCEDURE cbGenVersionChange(Sender: TObject);
    PROCEDURE chkOptionClick(Sender: TObject);
    PROCEDURE edFilterChange(Sender: TObject);
    PROCEDURE edFolderEditingDone(Sender: TObject);
    PROCEDURE edTreeFilterChange(Sender: TObject);
    PROCEDURE edUnitFileEditingDone(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE lvDiffCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; VAR DefaultDraw: Boolean);
    PROCEDURE lvDiffSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure mnuColorClick(Sender: TObject);
    procedure sbAboutClick(Sender: TObject);
    procedure sbColorsClick(Sender: TObject);
    procedure sbExitClick(Sender: TObject);
    procedure sbOptionsClick(Sender: TObject);
    PROCEDURE TestConfigChange(Sender: TObject);
    PROCEDURE vstEndpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    PROCEDURE vstEndpointsEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      VAR Allowed: Boolean);
    PROCEDURE vstEndpointsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    PROCEDURE vstEndpointsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    PROCEDURE vstEndpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; VAR CellText: STRING);
    PROCEDURE vstEndpointsNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      CONST NewText: STRING);
    PROCEDURE vstEndpointsPaintText(Sender: TBaseVirtualTree; CONST TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
  PRIVATE
    FComparer: TApiComparer;
    FFiles: TStringList;
    FTitle: STRING;
    FFolder: STRING;
    FVerCache: TStringList;
    FSpec: TApiSpec;
    FSel: TStringList;
    FNames: TStringList;
    FUnitFile: STRING;
    FLanguage: TGenLanguage;
    // Created at run time: not installed in the IDE (unit SynHighlighterPowerShell)
    synPowerShell: TSynPowerShellSyn;
    FUnitFiles: ARRAY[TGenLanguage] OF STRING;
    FSignature: STRING;
    FApi: TCockpitItsmBase;
    FCurrent: TEndpoint;
    FBuildingTree: Boolean;
    FGenWarnings: TStringList;
    PROCEDURE ShowGenSummary(CONST AText: STRING);
    PROCEDURE ShowUnitCode(CONST AFileName: STRING);
    FUNCTION WriteCoreFile(CONST ADir, AResName, AFileName: STRING): STRING;
    PROCEDURE ApplyLanguage;
    FUNCTION DisplayName(AEp: TEndpoint): STRING;
    FUNCTION LangName(CONST AName: STRING): STRING;
    FUNCTION ValidName(CONST AName: STRING): Boolean;
    FUNCTION FileVersion(CONST AFileName: STRING): STRING;
    FUNCTION FolderSignature(CONST AFolder: STRING): STRING;
    PROCEDURE SaveVersionCache;
    PROCEDURE AppActivate(Sender: TObject);
    PROCEDURE LoadIcons;
    FUNCTION NameOf(AEp: TEndpoint): STRING;
    PROCEDURE LoadSpec;
    PROCEDURE LoadSelection(CONST AFileName: STRING);
    PROCEDURE ExpandSelectedGroups;
    PROCEDURE SetupTree;
    PROCEDURE FillTree;
    PROCEDURE SyncSelectionFromTree;
    PROCEDURE UpdateSelStatus;
    PROCEDURE ShowEndpoint;
    PROCEDURE ShowDetail;
    FUNCTION TestEndpoint: TEndpoint;
    PROCEDURE ApplyTestConfig;
    PROCEDURE ShowTestEndpoint;
    PROCEDURE ShowResponse(CONST AStatus, AText: STRING);
    FUNCTION IniFileName: STRING;
    FUNCTION Options: TDiffOptions;
    PROCEDURE LoadSettings;
    PROCEDURE SaveSettings;
    PROCEDURE LoadFolder(CONST AFolder: STRING);
    PROCEDURE RunCompare;
    PROCEDURE FillList;
    PROCEDURE ApplyEditorOptions(AOptions: TSynEditorOptionsContainer);
  END;

VAR
  frmMain: TfrmMain;

IMPLEMENTATION

{$R *.lfm}

CONST
  LANG_NAMES: ARRAY[TGenLanguage] OF STRING = ('Pascal', 'Python', 'Java', 'Node.js', 'C#', 'PowerShell', 'VB.NET');
  // [Generator] keys of the generated file of each language
  LANG_KEYS: ARRAY[TGenLanguage] OF STRING = ('UnitFile', 'UnitFilePython', 'UnitFileJava', 'UnitFileNode',
    'UnitFileCSharp', 'UnitFilePowerShell', 'UnitFileVB');
  // Logos of the languages (devicon, MIT): project resources Images/Png/24x24/lang-*.png
  LANG_ICONS: ARRAY[TGenLanguage] OF STRING = ('LANG_DELPHI', 'LANG_PYTHON', 'LANG_JAVA', 'LANG_NODEJS',
    'LANG_CSHARP', 'LANG_POWERSHELL', 'LANG_VB');

VAR
  GSortVersions: TStringList;  // path=version, used by SortByVersion

FUNCTION SortByVersion(AList: TStringList; AIndex1, AIndex2: Integer): Integer;
// Sort JSON files by their info.version (file name as tie-breaker)
BEGIN
  Result := CompareVersionText(GSortVersions.Values[AList[AIndex1]], GSortVersions.Values[AList[AIndex2]]);
  IF Result = 0 THEN
    Result := CompareText(ExtractFileName(AList[AIndex1]), ExtractFileName(AList[AIndex2]));
END;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
VAR
  I: Integer;
BEGIN
  // SynEdits loaded from the form without streamed keystrokes have none
  // (arrows, Ctrl+C, Ctrl+Home... would do nothing)
  FOR I := 0 TO ComponentCount - 1 DO
    IF (Components[I] IS TSynEdit) AND (TSynEdit(Components[I]).Keystrokes.Count = 0) THEN
      TSynEdit(Components[I]).Keystrokes.ResetDefaults;
  FComparer := TApiComparer.Create;
  FFiles := TStringList.Create;
  FVerCache := TStringList.Create;
  FSpec := TApiSpec.Create;
  FSel := TStringList.Create;
  FSel.Sorted := True;
  FSel.Duplicates := dupIgnore;
  FNames := TStringList.Create;
  FGenWarnings := TStringList.Create;
  FApi := TCockpitItsmBase.Create;
  pcMain.ActivePage := tsDiff;
  pcApi.ActivePage := tsDetail;
  synPowerShell := TSynPowerShellSyn.Create(Self);
  SetupTree;
  LoadIcons;
  LoadSettings;
  ApplyLanguage;
  ApplyTestConfig;
  IF FileExists(edUnitFile.Text) THEN
    LoadSelection(edUnitFile.Text);
  FUnitFile := edUnitFile.Text;
  LoadFolder(edFolder.Text);
  Application.AddOnActivateHandler(AppActivate);
END;

procedure TfrmMain.FormDestroy(Sender: TObject);
BEGIN
  Application.RemoveOnActivateHandler(AppActivate);
  SaveSettings;
  FFiles.Free;
  FVerCache.Free;
  FComparer.Free;
  FSpec.Free;
  FSel.Free;
  FNames.Free;
  FGenWarnings.Free;
  FApi.Free;
END;

procedure TfrmMain.LoadIcons;
// PNG icons compiled in the executable (project resources, Images/Png/16x16)
CONST
  ICONS: ARRAY[0..15] OF STRING = ('DOCUMENTS_4_FILLED', 'FILE_COMPARE_BY_CONTENT', 'HISTORY',
    'SAVE_FILLED', 'EXECUTE', 'SELECT_NONE', 'TEST_FILLED', 'CLOUDS_HELP_FILLED',
    'CLOUDS_EXECUTE_FILLED', 'DOCUMENT_GEAR_FILLED', 'BOOK_OPEN', 'DEFINE_PROPERTIES',
    'BUTTON_INFO', 'STYLES', 'WINDOW_TEXT_TOOLS_FILLED', 'EXIT');
VAR
  Png: TPortableNetworkGraphic;
  I: Integer;
BEGIN
  ilIcons.Width := 16;
  ilIcons.Height := 16;
  FOR I := 0 TO High(ICONS) DO
  BEGIN
    Png := TPortableNetworkGraphic.Create;
    TRY
      Png.LoadFromResourceName(HInstance, ICONS[I]);
      ilIcons.Add(Png, NIL);
    FINALLY
      Png.Free;
    END;
  END;
  pcMain.Images := ilIcons;
  tsDiff.ImageIndex := 0;
  tsApi.ImageIndex := 10;
  tsDetail.ImageIndex := 11;
  pcApi.Images := ilIcons;
  tsGenerate.ImageIndex := 4;
  tsTest.ImageIndex := 6;
  btnCompare.Images := ilIcons;
  btnCompare.ImageIndex := 1;
  btnHistory.Images := ilIcons;
  btnHistory.ImageIndex := 2;
  btnExport.Images := ilIcons;
  btnExport.ImageIndex := 3;
  btnUncheckAll.Images := ilIcons;
  btnUncheckAll.ImageIndex := 5;
  btnGenerate.Images := ilIcons;
  btnGenerate.ImageIndex := 9;
  btnTestConn.Images := ilIcons;
  btnTestConn.ImageIndex := 7;
  btnSend.Images := ilIcons;
  btnSend.ImageIndex := 8;
  sbAbout.Images := ilIcons;
  sbAbout.ImageIndex := 12;
  sbColors.Images := ilIcons;
  sbColors.ImageIndex := 13;
  sbOptions.Images := ilIcons;
  sbOptions.ImageIndex := 14;
  sbExit.Images := ilIcons;
  sbExit.ImageIndex := 15;
END;

function TfrmMain.IniFileName: STRING;
BEGIN
  Result := ChangeFileExt(Application.ExeName, '.ini');
END;

function TfrmMain.Options: TDiffOptions;
BEGIN
  Result.IgnoreInfoVersion := chkIgnoreVersion.Checked;
  Result.IgnoreTexts := chkIgnoreTexts.Checked;
  Result.IgnoreRefCase := chkIgnoreCase.Checked;
END;

procedure TfrmMain.LoadSettings;
VAR
  Ini: TIniFile;
  Opt: TSynEditorOptionsContainer;
  L: TGenLanguage;
  I: Integer;
BEGIN
  Ini := TIniFile.Create(IniFileName);
  TRY
    edFolder.Text := Ini.ReadString('General', 'Folder', ExtractFilePath(Application.ExeName));
    chkIgnoreVersion.Checked := Ini.ReadBool('Options', 'IgnoreInfoVersion', True);
    chkIgnoreTexts.Checked := Ini.ReadBool('Options', 'IgnoreTexts', False);
    chkIgnoreCase.Checked := Ini.ReadBool('Options', 'IgnoreRefCase', False);
    FOR L := Low(TGenLanguage) TO High(TGenLanguage) DO
      FUnitFiles[L] := Ini.ReadString('Generator', LANG_KEYS[L], '');
    I := cbLanguage.Items.IndexOf(Ini.ReadString('Generator', 'Language', LANG_NAMES[glPascal]));
    IF I < 0 THEN
      I := 0;
    cbLanguage.ItemIndex := I;
    FLanguage := TGenLanguage(I);
    edUnitFile.Text := FUnitFiles[FLanguage];
    chkGenSupported.Checked := Ini.ReadBool('Generator', 'HideUnsupported', False);
    chkGenDeprecated.Checked := Ini.ReadBool('Generator', 'HideDeprecated', False);
    Ini.ReadSectionValues('Versions', FVerCache);
    chkSaaS.Checked := Ini.ReadBool('Test', 'SaaS', True);
    edTenant.Text := Ini.ReadString('Test', 'Tenant', '');
    edClientId.Text := Ini.ReadString('Test', 'ClientId', '');
    chkSaveSecret.Checked := Ini.ReadBool('Test', 'SaveSecret', False);
    IF chkSaveSecret.Checked THEN edSecret.Text := Ini.ReadString('Test', 'ClientSecret', '');
    LoadHighlighter(Ini, 'Highlighter JSON', synJSON);
    LoadHighlighter(Ini, 'Highlighter Pascal', synPas);
    LoadHighlighter(Ini, 'Highlighter Java', synJava);
    LoadHighlighter(Ini, 'Highlighter Python', synPython);
    LoadHighlighter(Ini, 'Highlighter JavaScript', synJScript);
    LoadHighlighter(Ini, 'Highlighter C#', synCS);
    LoadHighlighter(Ini, 'Highlighter PowerShell', synPowerShell);
    LoadHighlighter(Ini, 'Highlighter VB.NET', synVB);
    Opt := TSynEditorOptionsContainer.Create(NIL);
    TRY
      Opt.Assign(memBody);
      IF LoadEditorOptions(Ini, 'Editor', Opt) THEN ApplyEditorOptions(Opt);
    FINALLY
      Opt.Free;
    END;
  FINALLY
    Ini.Free;
  END;
END;

procedure TfrmMain.SaveSettings;
VAR
  Ini: TIniFile;
  Opt: TSynEditorOptionsContainer;
  L: TGenLanguage;
BEGIN
  Ini := TIniFile.Create(IniFileName);
  TRY
    Ini.WriteString('General', 'Folder', edFolder.Text);
    Ini.WriteBool('Options', 'IgnoreInfoVersion', chkIgnoreVersion.Checked);
    Ini.WriteBool('Options', 'IgnoreTexts', chkIgnoreTexts.Checked);
    Ini.WriteBool('Options', 'IgnoreRefCase', chkIgnoreCase.Checked);
    FUnitFiles[FLanguage] := edUnitFile.Text;
    Ini.WriteString('Generator', 'Language', LANG_NAMES[FLanguage]);
    FOR L := Low(TGenLanguage) TO High(TGenLanguage) DO
      Ini.WriteString('Generator', LANG_KEYS[L], FUnitFiles[L]);
    Ini.WriteBool('Generator', 'HideUnsupported', chkGenSupported.Checked);
    Ini.WriteBool('Generator', 'HideDeprecated', chkGenDeprecated.Checked);
    Ini.WriteBool('Test', 'SaaS', chkSaaS.Checked);
    Ini.WriteString('Test', 'Tenant', edTenant.Text);
    Ini.WriteString('Test', 'ClientId', edClientId.Text);
    Ini.WriteBool('Test', 'SaveSecret', chkSaveSecret.Checked);
    IF chkSaveSecret.Checked THEN Ini.WriteString('Test', 'ClientSecret', edSecret.Text)
                             ELSE Ini.DeleteKey('Test', 'ClientSecret');
    SaveHighlighter(Ini, 'Highlighter JSON', synJSON);
    SaveHighlighter(Ini, 'Highlighter Pascal', synPas);
    SaveHighlighter(Ini, 'Highlighter Java', synJava);
    SaveHighlighter(Ini, 'Highlighter Python', synPython);
    SaveHighlighter(Ini, 'Highlighter JavaScript', synJScript);
    SaveHighlighter(Ini, 'Highlighter C#', synCS);
    SaveHighlighter(Ini, 'Highlighter PowerShell', synPowerShell);
    SaveHighlighter(Ini, 'Highlighter VB.NET', synVB);
    Opt := TSynEditorOptionsContainer.Create(NIL);
    TRY
      Opt.Assign(memBody);
      SaveEditorOptions(Ini, 'Editor', Opt);
    FINALLY
      Opt.Free;
    END;
  FINALLY
    Ini.Free;
  END;
END;

function TfrmMain.FileVersion(const AFileName: STRING): STRING;
// info.version of a JSON file, cached in the ini ([Versions] file name=version|file age)
// The file is parsed again only if it is new or modified; file name used as fallback
VAR
  Key, Cached, Age: STRING;
  P: Integer;
  Data, Info: TJSONData;
BEGIN
  Key := ExtractFileName(AFileName);
  Age := IntToStr(FileAge(AFileName));
  Cached := FVerCache.Values[Key];
  P := Pos('|', Cached);
  IF (P > 1) AND (Copy(Cached, P + 1, MaxInt) = Age) THEN
    Exit(Copy(Cached, 1, P - 1));
  Result := '';
  TRY
    Data := LoadJsonFile(AFileName);
    TRY
      IF Data.JSONType = jtObject THEN
      BEGIN
        Info := TJSONObject(Data).Find('info');
        IF (Info <> NIL) AND (Info.JSONType = jtObject) AND (TJSONObject(Info).Find('version') <> NIL) THEN
          Result := TJSONObject(Info).Find('version').AsString;
      END;
    FINALLY
      Data.Free;
    END;
  EXCEPT
    Result := '';
  END;
  IF Result = '' THEN
    Result := VersionFromFileName(AFileName);
  FVerCache.Values[Key] := Result + '|' + Age;
END;

function TfrmMain.FolderSignature(const AFolder: STRING): STRING;
// Names, dates and sizes of the *.json files: changes when a file is added, removed or replaced
VAR
  SR: TSearchRec;
  SL: TStringList;
BEGIN
  SL := TStringList.Create;
  TRY
    IF (AFolder <> '') AND (FindFirst(IncludeTrailingPathDelimiter(AFolder) + '*.json', faAnyFile, SR) = 0) THEN
    BEGIN
      REPEAT
        IF (SR.Attr AND faDirectory) = 0 THEN
          SL.Add(SR.Name + '|' + IntToStr(SR.Time) + '|' + IntToStr(SR.Size));
      UNTIL FindNext(SR) <> 0;
      FindClose(SR);
    END;
    SL.Sort;
    Result := SL.Text;
  FINALLY
    SL.Free;
  END;
END;

procedure TfrmMain.AppActivate(Sender: TObject);
// Back to the application: rescan the folder only if its content changed
BEGIN
  IF (FFolder <> '') AND (FolderSignature(FFolder) <> FSignature) THEN
  BEGIN
    LoadFolder(FFolder);
    sbMain.SimpleText := 'Folder changed: version list updated';
  END;
END;

procedure TfrmMain.SaveVersionCache;
// [Versions] section written as soon as the folder has been scanned;
// entries of files that no longer exist in the folder are removed
VAR
  Ini: TIniFile;
  I: Integer;
BEGIN
  FOR I := FVerCache.Count - 1 DOWNTO 0 DO
    IF NOT FileExists(IncludeTrailingPathDelimiter(FFolder) + FVerCache.Names[I]) THEN
      FVerCache.Delete(I);
  Ini := TIniFile.Create(IniFileName);
  TRY
    Ini.EraseSection('Versions');
    FOR I := 0 TO FVerCache.Count - 1 DO
      Ini.WriteString('Versions', FVerCache.Names[I], FVerCache.ValueFromIndex[I]);
  FINALLY
    Ini.Free;
  END;
END;

procedure TfrmMain.LoadFolder(const AFolder: STRING);
// List *.json files of the folder, sorted by info.version; preselect the last two
VAR
  SR: TSearchRec;
  Folder, Lbl: STRING;
  I, J: Integer;
  Labels: TStringList;
  OldPath, NewPath, GenPath, PrevGen: STRING;

  FUNCTION PathOf(ACombo: TComboBox): STRING;
  BEGIN
    IF (ACombo.ItemIndex >= 0) AND (ACombo.ItemIndex < FFiles.Count) THEN
      Result := FFiles[ACombo.ItemIndex]
    ELSE
      Result := '';
  END;

BEGIN
  // Current choices, restored if the files are still there
  OldPath := PathOf(cbOld);
  NewPath := PathOf(cbNew);
  GenPath := PathOf(cbGenVersion);
  PrevGen := GenPath + '|' + IntToStr(FileAge(GenPath));
  FFolder := AFolder;
  FSignature := FolderSignature(AFolder);
  FFiles.Clear;
  cbOld.Items.Clear;
  cbNew.Items.Clear;
  cbGenVersion.Items.Clear;
  Folder := IncludeTrailingPathDelimiter(AFolder);
  IF (AFolder <> '') AND (FindFirst(Folder + '*.json', faAnyFile, SR) = 0) THEN
  BEGIN
    REPEAT
      IF (SR.Attr AND faDirectory) = 0 THEN
        FFiles.Add(Folder + SR.Name);
    UNTIL FindNext(SR) <> 0;
    FindClose(SR);
  END;
  Labels := TStringList.Create;
  GSortVersions := TStringList.Create;
  Screen.Cursor := crHourGlass;
  TRY
    FOR I := 0 TO FFiles.Count - 1 DO
      GSortVersions.Add(FFiles[I] + '=' + FileVersion(FFiles[I]));
    FFiles.CustomSort(SortByVersion);
    // Label = version; file name added when several files share a version
    FOR I := 0 TO FFiles.Count - 1 DO
    BEGIN
      Lbl := GSortVersions.Values[FFiles[I]];
      FOR J := 0 TO FFiles.Count - 1 DO
        IF (J <> I) AND (GSortVersions.Values[FFiles[J]] = GSortVersions.Values[FFiles[I]]) THEN
        BEGIN
          Lbl := Lbl + ' (' + ExtractFileName(FFiles[I]) + ')';
          Break;
        END;
      Labels.Add(Lbl);
    END;
    cbOld.Items.Assign(Labels);
    cbNew.Items.Assign(Labels);
    cbGenVersion.Items.Assign(Labels);
  FINALLY
    FreeAndNil(GSortVersions);
    Labels.Free;
    Screen.Cursor := crDefault;
  END;
  SaveVersionCache;
  IF FFiles.Count >= 2 THEN
  BEGIN
    cbOld.ItemIndex := FFiles.Count - 2;
    cbNew.ItemIndex := FFiles.Count - 1;
  END;
  cbGenVersion.ItemIndex := FFiles.Count - 1;
  IF FFiles.IndexOf(OldPath) >= 0 THEN
    cbOld.ItemIndex := FFiles.IndexOf(OldPath);
  IF FFiles.IndexOf(NewPath) >= 0 THEN
    cbNew.ItemIndex := FFiles.IndexOf(NewPath);
  IF FFiles.IndexOf(GenPath) >= 0 THEN
    cbGenVersion.ItemIndex := FFiles.IndexOf(GenPath);
  // Spec reloaded only if the generator's file changed (keeps the grid and the tree)
  IF PathOf(cbGenVersion) + '|' + IntToStr(FileAge(PathOf(cbGenVersion))) <> PrevGen THEN
    LoadSpec;
  btnCompare.Enabled := FFiles.Count >= 2;
  btnHistory.Enabled := FFiles.Count >= 2;
  UpdateSelStatus;
END;

procedure TfrmMain.btnBrowseClick(Sender: TObject);
BEGIN
  dlgFolder.InitialDir := edFolder.Text;
  IF dlgFolder.Execute THEN
  BEGIN
    edFolder.Text := dlgFolder.FileName;
    LoadFolder(edFolder.Text);
  END;
END;

procedure TfrmMain.edFolderEditingDone(Sender: TObject);
BEGIN
  IF edFolder.Text <> FFolder THEN
    LoadFolder(edFolder.Text);
END;

procedure TfrmMain.RunCompare;
BEGIN
  IF (cbOld.ItemIndex < 0) OR (cbNew.ItemIndex < 0) THEN
    Exit;
  Screen.Cursor := crHourGlass;
  TRY
    FComparer.CompareFiles(FFiles[cbOld.ItemIndex], FFiles[cbNew.ItemIndex], Options);
  FINALLY
    Screen.Cursor := crDefault;
  END;
  FTitle := cbOld.Text + ' → ' + cbNew.Text;
  btnExport.Enabled := True;
  FillList;
END;

procedure TfrmMain.btnCompareClick(Sender: TObject);
BEGIN
  IF cbOld.ItemIndex = cbNew.ItemIndex THEN
  BEGIN
    ShowMessage('Select two different versions.');
    Exit;
  END;
  RunCompare;
END;

procedure TfrmMain.chkOptionClick(Sender: TObject);
// Refresh the current comparison when an option changes
BEGIN
  IF btnExport.Enabled THEN
    RunCompare;
END;

procedure TfrmMain.FillList;
// Fill the list with the items matching the filter
VAR
  I, Shown: Integer;
  Item: TDiffItem;
  LI: TListItem;
BEGIN
  Shown := 0;
  memDetail.Clear;
  lvDiff.Items.BeginUpdate;
  TRY
    lvDiff.Items.Clear;
    FOR I := 0 TO FComparer.Count - 1 DO
    BEGIN
      Item := FComparer[I];
      IF NOT Item.MatchesFilter(edFilter.Text) THEN
        Continue;
      LI := lvDiff.Items.Add;
      LI.Caption := Item.KindText;
      LI.SubItems.Add(Item.Category);
      LI.SubItems.Add(Item.Element);
      LI.SubItems.Add(Item.Path);
      LI.SubItems.Add(OneLine(Item.OldShort, 250));
      LI.SubItems.Add(OneLine(Item.NewShort, 250));
      LI.Data := Item;
      Inc(Shown);
    END;
  FINALLY
    lvDiff.Items.EndUpdate;
  END;
  IF Shown = FComparer.Count THEN
    sbMain.SimpleText := FTitle + '  —  ' + FComparer.Summary
  ELSE
    sbMain.SimpleText := FTitle + Format('  —  %d shown of %d', [Shown, FComparer.Count]);
END;

PROCEDURE TfrmMain.ApplyEditorOptions(AOptions: TSynEditorOptionsContainer);
// Same editor options for every SynEdit of the window
VAR
  I: Integer;
BEGIN
  FOR I := 0 TO ComponentCount - 1 DO
    IF Components[I] IS TSynEdit THEN
      AOptions.AssignTo(Components[I]);
END;

procedure TfrmMain.edFilterChange(Sender: TObject);
BEGIN
  FillList;
END;

procedure TfrmMain.lvDiffCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
// Green = added, red = removed, blue = changed (selected rows keep the theme colors)
BEGIN
  DefaultDraw := True;
  IF (Item.Data = NIL) OR (cdsSelected IN State) THEN
    Exit;
  CASE TDiffItem(Item.Data).Kind OF
    dkAdded: Sender.Canvas.Font.Color := clGreen;
    dkRemoved: Sender.Canvas.Font.Color := clRed;
    dkChanged: Sender.Canvas.Font.Color := clNavy;
  END;
END;

procedure TfrmMain.lvDiffSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
// Show the full old / new values of the selected difference
VAR
  D: TDiffItem;
  Txt: STRING;
BEGIN
  IF NOT Selected OR (Item = NIL) OR (Item.Data = NIL) THEN
    Exit;
  D := TDiffItem(Item.Data);
  Txt := D.KindText + ' — ' + D.Category + ' ' + D.Element + LineEnding;
  IF D.Path <> '' THEN
    Txt := Txt + 'Path: ' + D.Path + LineEnding;
  IF D.Kind <> dkAdded THEN
    Txt := Txt + LineEnding + '--- Old value ---' + LineEnding + D.OldValue + LineEnding;
  IF D.Kind <> dkRemoved THEN
    Txt := Txt + LineEnding + '--- New value ---' + LineEnding + D.NewValue + LineEnding;
  memDetail.Text := Txt;
  memDetail.CaretXY := Point(1, 1);
  memDetail.TopLine := 1;
END;

procedure TfrmMain.mnuColorClick(Sender: TObject);
CONST
  JSON_SAMPLE =
    '{'#13#10 +
    '  "firstName": "John",'#13#10 +
    '  "lastName": "Smith",'#13#10 +
    '  "isAlive": true,'#13#10 +
    '  "age": 25,'#13#10 +
    '  "height_cm": 167.6,'#13#10 +
    '  "address": {'#13#10 +
    '    "streetAddress": "21 2nd Street",'#13#10 +
    '    "city": "New York",'#13#10 +
    '    "state": "NY",'#13#10 +
    '    "postalCode": "10021-3100"'#13#10 +
    '  },'#13#10 +
    '  "phoneNumbers": ['#13#10 +
    '    {'#13#10 +
    '      "type": "home",'#13#10 +
    '      "number": "212 555-1234"'#13#10 +
    '    },'#13#10 +
    '    {'#13#10 +
    '      "type": "office",'#13#10 +
    '      "number": "646 555-4567"'#13#10 +
    '    }'#13#10 +
    '  ],'#13#10 +
    '  "face": "\uD83D\uDE02",'#13#10 +
    '  "children": [],'#13#10 +
    '  "spouse": null'#13#10 +
    '}';

  PASCAL_SAMPLE =
    '{ Syntax highlighting }'#13#10 +
    'procedure TForm1.Button1Click(Sender: TObject);'#13#10 +
    'var'#13#10 +
    '  Number, I, X: Integer;'#13#10 +
    'begin'#13#10 +
    '  Number := 123456;'#13#10 +
    '  Caption := ''The Number is'' + #32 + IntToStr(Number);'#13#10 +
    '  for I := 0 to Number do'#13#10 +
    '  begin'#13#10 +
    '    Inc(X);'#13#10 +
    '    Dec(X);'#13#10 +
    '    X := X + 1.0;'#13#10 +
    '    X := X - $5E;'#13#10 +
    '  end;'#13#10 +
    '  {$R+}'#13#10 +
    '  asm'#13#10 +
    '    mov AX, 1234H'#13#10 +
    '    mov Number, AX'#13#10 +
    '  end;'#13#10 +
    '  {$R-}'#13#10 +
    'end;';

  JAVA_SAMPLE =
    '/* Java syntax highlighting */'#13#10 +
    'import java.util.*;'#13#10 +
    #13#10 +
    '/** Example class */'#13#10 +
    'public class Sample {'#13#10 +
    '  public static void main(String[] args) {'#13#10 +
    '    int i = 0;'#13#10 +
    '    for(i = 0; i < 10; i++)'#13#10 +
    '      System.out.println("Hello world");'#13#10 +
    '  }'#13#10 +
    '}';

  PYTHON_SAMPLE =
    '#!/usr/local/bin/python'#13#10 +
    'import string, sys'#13#10 +
    '""" If no arguments were given, print a helpful message """'#13#10 +
    'if len(sys.argv)==1:'#13#10 +
    '    print ''Usage: celsius temp1 temp2 ...'''#13#10 +
    '    sys.exit(0)';

  JSCRIPT_SAMPLE =
    '// Syntax highlighting'#13#10 +
    'function printNumber()'#13#10 +
    '{'#13#10 +
    '  var number = 1234;'#13#10 +
    '  var x;'#13#10 +
    '  document.write("The number is " + number);'#13#10 +
    '  for (var i = 0; i <= number; i++)'#13#10 +
    '  {'#13#10 +
    '    x++;'#13#10 +
    '    x--;'#13#10 +
    '    x += 1.0;'#13#10 +
    '  }'#13#10 +
    '  i += @; // illegal character'#13#10 +
    '}'#13#10 +
    'body.onLoad = printNumber;';
  CSHARP_SAMPLE =
    '/* Syntax Highlighting */'#13#10 +
    'int num = 12345;'#13#10 +
    'string str = "Hello World";'#13#10;
  POWERSHELL_SAMPLE =
    '<#'#13#10 +
    '.SYNOPSIS'#13#10 +
    '  Demo PowerShell script.'#13#10 +
    '#>'#13#10 +
    'function Get-Greeting {'#13#10 +
    '    param('#13#10 +
    '        [string]$Name = "World",'#13#10 +
    '        [int]$Count = 0x2A'#13#10 +
    '    )'#13#10 +
    '    # Build the message'#13#10 +
    '    $msg = "Hello, $Name!`n"'#13#10 +
    '    if ($Name -eq '''' -or $Count -gt 1kb) {'#13#10 +
    '        $msg = @"'#13#10 +
    'a multi-line'#13#10 +
    'here-string'#13#10 +
    '"@'#13#10 +
    '    }'#13#10 +
    '    Write-Output $msg | Out-Host'#13#10 +
    '}'#13#10 +
    ''#13#10 +
    'Get-Greeting -Name ''PowerShell'' -Count 5';
  VB_SAMPLE =
    ''' Syntax highlighting'#13#10 +
    'Function PrintNumber'#13#10 +
    '  Dim Number'#13#10 +
    '  Dim X'#13#10 +
    ''#13#10 +
    '  Number = 123456'#13#10 +
    '  Response.Write "The number is " & number'#13#10 +
    ''#13#10 +
    '  For I = 0 To Number'#13#10 +
    '    X = X + &h4c'#13#10 +
    '    X = X - &o8'#13#10 +
    '    X = X + 1.0'#13#10 +
    '  Next'#13#10 +
    ''#13#10 +
    '  I = I + @;  '' illegal character'#13#10 +
    'End Function';
VAR
  SynColorDialog: TSynColorDialog;
  Ini: TIniFile;
  Hl: TSynCustomHighlighter;
  Section, Sample: STRING;
  EditorFont: TFont;
BEGIN
  CASE (Sender AS TComponent).Tag OF
    1: BEGIN Hl := synJSON;    Section := 'Highlighter JSON';       Sample := JSON_SAMPLE;    EditorFont := memBody.Font;    END;
    2: BEGIN Hl := synPas;     Section := 'Highlighter Pascal';     Sample := PASCAL_SAMPLE;  EditorFont := memGenCode.Font; END;
    3: BEGIN Hl := synJava;    Section := 'Highlighter Java';       Sample := JAVA_SAMPLE;    EditorFont := memGenCode.Font; END;
    4: BEGIN Hl := synPython;  Section := 'Highlighter Python';     Sample := PYTHON_SAMPLE;  EditorFont := memGenCode.Font; END;
    5: BEGIN Hl := synJScript; Section := 'Highlighter JavaScript'; Sample := JSCRIPT_SAMPLE; EditorFont := memGenCode.Font; END;
    6: BEGIN Hl := synCS;      Section := 'Highlighter C#';         Sample := CSHARP_SAMPLE;  EditorFont := memGenCode.Font; END;
    7: BEGIN Hl := synPowerShell; Section := 'Highlighter PowerShell'; Sample := POWERSHELL_SAMPLE; EditorFont := memGenCode.Font; END;
    8: BEGIN Hl := synVB;      Section := 'Highlighter VB.NET';     Sample := VB_SAMPLE;      EditorFont := memGenCode.Font; END;
  ELSE
    Exit;
  END;
  SynColorDialog := TSynColorDialog.Create(Self);
  TRY
    IF SynColorDialog.Execute(Hl, Sample, EditorFont) THEN
    BEGIN
      // Colors saved as soon as they are validated
      Ini := TIniFile.Create(IniFileName);
      TRY
        SaveHighlighter(Ini, Section, Hl);
      FINALLY
        Ini.Free;
      END;
    END;
  FINALLY
    FreeAndNil(SynColorDialog);
  END;
END;

procedure TfrmMain.sbAboutClick(Sender: TObject);
begin
  ShowAbout;
end;

procedure TfrmMain.sbColorsClick(Sender: TObject);
begin
  WITH sbColors.ClientToScreen(point(0, sbColors.Height)) DO pmColors.Popup(X, Y);
end;

procedure TfrmMain.sbExitClick(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TfrmMain.sbOptionsClick(Sender: TObject);
// Editor options, read from memBody and applied to every SynEdit of the window
VAR
  Opt: TSynEditorOptionsContainer;
  Dlg: TSynEditOptionsDialog;
BEGIN
  Opt := TSynEditorOptionsContainer.Create(NIL);
  Dlg := TSynEditOptionsDialog.Create(NIL);
  TRY
    Opt.Assign(memBody);
    IF Dlg.Execute(Opt) THEN ApplyEditorOptions(Opt);
  FINALLY
    Dlg.Free;
    Opt.Free;
  END;
END;

procedure TfrmMain.btnExportClick(Sender: TObject);
// Export the current comparison as Markdown
VAR
  SL: TStringList;
BEGIN
  dlgSave.FileName := 'API diff ' + cbOld.Text + ' - ' + cbNew.Text + '.md';
  IF NOT dlgSave.Execute THEN
    Exit;
  SL := TStringList.Create;
  TRY
    SL.Text := FComparer.ToMarkdown(FTitle);
    SL.SaveToFile(dlgSave.FileName);
  FINALLY
    SL.Free;
  END;
END;

procedure TfrmMain.btnHistoryClick(Sender: TObject);
// Changelog of all consecutive versions (newest first), saved as Markdown
VAR
  SL: TStringList;
  I: Integer;
  Hist: TApiComparer;
BEGIN
  dlgSave.FileName := 'API history.md';
  IF NOT dlgSave.Execute THEN
    Exit;
  Screen.Cursor := crHourGlass;
  SL := TStringList.Create;
  Hist := TApiComparer.Create;
  TRY
    SL.Add('# API change history');
    SL.Add('');
    FOR I := FFiles.Count - 1 DOWNTO 1 DO
    BEGIN
      sbMain.SimpleText := 'Comparing ' + cbOld.Items[I - 1] + ' → ' + cbOld.Items[I] + '…';
      Application.ProcessMessages;
      Hist.CompareFiles(FFiles[I - 1], FFiles[I], Options);
      SL.Add(Hist.ToMarkdown(cbOld.Items[I - 1] + ' → ' + cbOld.Items[I]));
    END;
    SL.SaveToFile(dlgSave.FileName);
    sbMain.SimpleText := 'History saved: ' + dlgSave.FileName;
  FINALLY
    Hist.Free;
    SL.Free;
    Screen.Cursor := crDefault;
  END;
END;

{ Generator }

FUNCTION SortEndpoints(Item1, Item2: Pointer): Integer;
// Tag, then path, then method
BEGIN
  Result := CompareText(TEndpoint(Item1).Tag, TEndpoint(Item2).Tag);
  IF Result = 0 THEN
    Result := CompareText(TEndpoint(Item1).Path, TEndpoint(Item2).Path);
  IF Result = 0 THEN
    Result := CompareText(TEndpoint(Item1).Method, TEndpoint(Item2).Method);
END;

function TfrmMain.NameOf(AEp: TEndpoint): STRING;
BEGIN
  Result := FNames.Values[AEp.Key];
  IF Result = '' THEN
    Result := AEp.DefaultName;
END;

procedure TfrmMain.LoadSpec;
// Load the JSON selected in cbGenVersion and report selected endpoints missing from it
VAR
  I: Integer;
BEGIN
  // Nodes point to endpoints of the previous spec: clear them first
  FCurrent := NIL;
  vstEndpoints.Clear;
  IF cbGenVersion.ItemIndex < 0 THEN
    Exit;
  Screen.Cursor := crHourGlass;
  TRY
    FSpec.LoadFromFile(FFiles[cbGenVersion.ItemIndex]);
  FINALLY
    Screen.Cursor := crDefault;
  END;
  // Selected endpoints missing from this version (kept in the selection)
  FGenWarnings.Clear;
  FOR I := 0 TO FSel.Count - 1 DO
    IF FSpec.FindEndpoint(FSel[I]) = NIL THEN
      FGenWarnings.Add('missing from version ' + cbGenVersion.Text + ': ' + FSel[I]);
  FillTree;
END;

procedure TfrmMain.LoadSelection(const AFileName: STRING);
// Selection and method names read from the header of a generated unit
VAR
  SL: TStringList;
  I: Integer;
BEGIN
  SL := TStringList.Create;
  TRY
    ReadSelectionFromUnit(AFileName, SL);
    FSel.Clear;
    FNames.Clear;
    FOR I := 0 TO SL.Count - 1 DO
    BEGIN
      FSel.Add(SL.Names[I]);
      FNames.Add(SL[I]);
    END;
    ShowUnitCode(AFileName);
  FINALLY
    SL.Free;
  END;
END;

procedure TfrmMain.cbGenVersionChange(Sender: TObject);
BEGIN
  LoadSpec;
END;

procedure TfrmMain.edUnitFileEditingDone(Sender: TObject);
BEGIN
  IF edUnitFile.Text = FUnitFile THEN
    Exit;
  FUnitFile := edUnitFile.Text;
  IF FileExists(FUnitFile) THEN
  BEGIN
    LoadSelection(FUnitFile);
    LoadSpec;
    ExpandSelectedGroups;
  END;
END;

PROCEDURE TfrmMain.ExpandSelectedGroups;
// Groups containing selected endpoints expanded, so that the selection is visible
VAR
  Node: PVirtualNode;
BEGIN
  Node := vstEndpoints.GetFirst;
  WHILE Node <> NIL DO
  BEGIN
    IF vstEndpoints.CheckState[Node] IN [csCheckedNormal, csCheckedPressed, csMixedNormal, csMixedPressed] THEN
      vstEndpoints.Expanded[Node] := True;
    Node := vstEndpoints.GetNextSibling(Node);
  END;
END;

procedure TfrmMain.btnUnitBrowseClick(Sender: TObject);
BEGIN
  IF edUnitFile.Text <> '' THEN
  BEGIN
    dlgUnit.InitialDir := ExtractFilePath(edUnitFile.Text);
    dlgUnit.FileName := ExtractFileName(edUnitFile.Text);
  END;
  IF dlgUnit.Execute THEN
  BEGIN
    edUnitFile.Text := dlgUnit.FileName;
    // Reloaded even when it is the current unit (selection changed since)
    FUnitFile := '';
    edUnitFileEditingDone(Sender);
  END;
END;

procedure TfrmMain.btnGenerateClick(Sender: TObject);
// Generate the file of the chosen language for the selected endpoints of the chosen version
VAR
  Sel, Code: TStringList;
  I: Integer;
  Ep: TEndpoint;
  UnitName_, Summary, CoreState, CoreName: STRING;
BEGIN
  IF vstEndpoints.IsEditing THEN
    vstEndpoints.EndEditNode;
  IF edUnitFile.Text = '' THEN
    btnUnitBrowseClick(Sender);
  IF edUnitFile.Text = '' THEN
    Exit;
  UnitName_ := ChangeFileExt(ExtractFileName(edUnitFile.Text), '');
  IF (FLanguage = glJava) AND NOT IsValidJavaIdent(UnitName_) THEN
  BEGIN
    ShowMessage('Invalid Java class name (= file name): ' + UnitName_);
    Exit;
  END;
  IF (FLanguage = glPython) AND (NOT IsValidPythonIdent(UnitName_) OR (UnitName_ = PY_CORE_MODULE)) THEN
  BEGIN
    ShowMessage('Invalid Python module name (= file name): ' + UnitName_);
    Exit;
  END;
  IF (FLanguage = glNode) AND ((UnitName_ = JS_CORE_MODULE) OR NOT IsValidJsIdent(PascalCaseOf(UnitName_))) THEN
  BEGIN
    ShowMessage('Invalid Node.js module name (= file name): ' + UnitName_);
    Exit;
  END;
  IF (FLanguage = glCSharp) AND ((UnitName_ = CS_CORE_FILE) OR NOT IsValidCsIdent(UnitName_)) THEN
  BEGIN
    ShowMessage('Invalid C# class name (= file name): ' + UnitName_);
    Exit;
  END;
  IF (FLanguage = glVB) AND (SameText(UnitName_, VB_CORE_FILE) OR NOT IsValidVbIdent(UnitName_)) THEN
  BEGIN
    ShowMessage('Invalid VB.NET class name (= file name): ' + UnitName_);
    Exit;
  END;
  IF (FLanguage = glPowerShell) AND ((UnitName_ = PS_CORE_FILE) OR (UnitName_ = '')) THEN
  BEGIN
    ShowMessage('Invalid PowerShell module name (= file name): ' + UnitName_);
    Exit;
  END;
  IF (FLanguage = glPascal) AND NOT IsValidIdent(UnitName_) THEN
  BEGIN
    ShowMessage('Invalid unit name: ' + UnitName_);
    Exit;
  END;
  Sel := TStringList.Create;
  Code := TStringList.Create;
  TRY
    FOR I := 0 TO FSel.Count - 1 DO
    BEGIN
      Ep := FSpec.FindEndpoint(FSel[I]);
      IF Ep = NIL THEN
        Sel.Add(FSel[I] + '=' + FNames.Values[FSel[I]])
      ELSE
        Sel.Add(Ep.Key + '=' + NameOf(Ep));
    END;
    FGenWarnings.Clear;
    TRY
      CASE FLanguage OF
        glJava: Code.Text := FSpec.GenerateJava(Sel, UnitName_, FGenWarnings);
        glPython: Code.Text := FSpec.GeneratePython(Sel, UnitName_, FGenWarnings);
        glNode: Code.Text := FSpec.GenerateNode(Sel, UnitName_, FGenWarnings);
        glCSharp: Code.Text := FSpec.GenerateCSharp(Sel, UnitName_, FGenWarnings);
        glPowerShell: Code.Text := FSpec.GeneratePowerShell(Sel, UnitName_, FGenWarnings);
        glVB: Code.Text := FSpec.GenerateVB(Sel, UnitName_, FGenWarnings);
      ELSE
        Code.Text := FSpec.Generate(Sel, UnitName_, FGenWarnings);
      END;
    EXCEPT
      ON E: Exception DO
      BEGIN
        ShowGenSummary('ERROR: ' + E.Message);
        ShowMessage(E.Message);
        Exit;
      END;
    END;
    // Last line of the generator log = summary, the others are warnings
    Summary := '';
    IF FGenWarnings.Count > 0 THEN
    BEGIN
      Summary := FGenWarnings[FGenWarnings.Count - 1];
      FGenWarnings.Delete(FGenWarnings.Count - 1);
    END;
    TRY
      Code.SaveToFile(edUnitFile.Text);
      // Core next to the generated file
      CASE FLanguage OF
        glJava:
          BEGIN
            CoreName := 'CockpitItsmCore.java';
            CoreState := WriteCoreFile(ExtractFilePath(edUnitFile.Text), 'COCKPITITSMCORE_JAVA', CoreName);
          END;
        glPython:
          BEGIN
            CoreName := PY_CORE_MODULE + '.py';
            CoreState := WriteCoreFile(ExtractFilePath(edUnitFile.Text), 'COCKPITITSMCORE_PY', CoreName);
          END;
        glNode:
          BEGIN
            CoreName := JS_CORE_MODULE + '.mjs';
            CoreState := WriteCoreFile(ExtractFilePath(edUnitFile.Text), 'COCKPITITSMCORE_JS', CoreName);
          END;
        glCSharp:
          BEGIN
            CoreName := CS_CORE_FILE + '.cs';
            CoreState := WriteCoreFile(ExtractFilePath(edUnitFile.Text), 'COCKPITITSMCORE_CS', CoreName);
          END;
        glPowerShell:
          BEGIN
            CoreName := PS_CORE_FILE + '.ps1';
            CoreState := WriteCoreFile(ExtractFilePath(edUnitFile.Text), 'COCKPITITSMCORE_PS', CoreName);
          END;
        glVB:
          BEGIN
            CoreName := VB_CORE_FILE + '.vb';
            CoreState := WriteCoreFile(ExtractFilePath(edUnitFile.Text), 'COCKPITITSMCORE_VB', CoreName);
          END;
      ELSE
        CoreName := 'uCockpitItsmCore.pas';
        CoreState := WriteCoreFile(ExtractFilePath(edUnitFile.Text), 'UCOCKPITITSMCORE', CoreName);
      END;
    EXCEPT
      ON E: Exception DO
      BEGIN
        ShowGenSummary('ERROR: ' + E.Message);
        ShowMessage(E.Message);
        Exit;
      END;
    END;
    FUnitFile := edUnitFile.Text;
    memGenCode.Lines.Assign(Code);
    ShowGenSummary(Summary + ' — ' + CoreName + ' ' + CoreState);
    sbMain.SimpleText := 'Generated file: ' + edUnitFile.Text;
  FINALLY
    Sel.Free;
    Code.Free;
  END;
END;

procedure TfrmMain.cbLanguageChange(Sender: TObject);
// Each language has its own generated file: an existing one is read back (selection
// and names), otherwise the current selection is kept for the new language
VAR
  NewLang: TGenLanguage;
BEGIN
  IF cbLanguage.ItemIndex < 0 THEN
    Exit;
  NewLang := TGenLanguage(cbLanguage.ItemIndex);
  IF NewLang = FLanguage THEN
    Exit;
  IF vstEndpoints.IsEditing THEN
    vstEndpoints.EndEditNode;
  FUnitFiles[FLanguage] := edUnitFile.Text;
  FLanguage := NewLang;
  edUnitFile.Text := FUnitFiles[FLanguage];
  ApplyLanguage;
  IF FileExists(edUnitFile.Text) THEN
  BEGIN
    FUnitFile := '';
    edUnitFileEditingDone(Sender);
  END
  ELSE
  BEGIN
    FUnitFile := edUnitFile.Text;
    memGenCode.Clear;
  END;
END;

PROCEDURE TfrmMain.ApplyLanguage;
// Logo, name column, file dialog, highlighter and button of the chosen language
VAR
  Png: TPortableNetworkGraphic;
BEGIN
  // Logo: none (instead of an error) if the resource is missing from the project
  imgLanguage.Picture.Clear;
  IF FindResource(HInstance, PChar(LANG_ICONS[FLanguage]), PChar(10)) <> 0 THEN
  BEGIN
    Png := TPortableNetworkGraphic.Create;
    TRY
      Png.LoadFromResourceName(HInstance, LANG_ICONS[FLanguage]);
      imgLanguage.Picture.Assign(Png);
    FINALLY
      Png.Free;
    END;
  END;
  imgLanguage.Hint := LANG_NAMES[FLanguage];
  vstEndpoints.Header.Columns[1].Text := LANG_NAMES[FLanguage] + ' name';
  CASE FLanguage OF
    glPascal:
      BEGIN
        dlgUnit.Filter := 'Pascal unit (*.pas)|*.pas';
        dlgUnit.DefaultExt := '.pas';
        memGenCode.Highlighter := synPas;
        btnGenerate.Caption := 'Generate unit';
      END;
    glPython:
      BEGIN
        dlgUnit.Filter := 'Python module (*.py)|*.py';
        dlgUnit.DefaultExt := '.py';
        memGenCode.Highlighter := synPython;
        btnGenerate.Caption := 'Generate module';
      END;
    glJava:
      BEGIN
        dlgUnit.Filter := 'Java class (*.java)|*.java';
        dlgUnit.DefaultExt := '.java';
        memGenCode.Highlighter := synJava;
        btnGenerate.Caption := 'Generate class';
      END;
    glNode:
      BEGIN
        dlgUnit.Filter := 'Node.js module (*.mjs)|*.mjs';
        dlgUnit.DefaultExt := '.mjs';
        memGenCode.Highlighter := synJScript;
        btnGenerate.Caption := 'Generate module';
      END;
    glCSharp:
      BEGIN
        dlgUnit.Filter := 'C# class (*.cs)|*.cs';
        dlgUnit.DefaultExt := '.cs';
        memGenCode.Highlighter := synCS;
        btnGenerate.Caption := 'Generate class';
      END;
    glPowerShell:
      BEGIN
        dlgUnit.Filter := 'PowerShell module (*.psm1)|*.psm1';
        dlgUnit.DefaultExt := '.psm1';
        memGenCode.Highlighter := synPowerShell;
        btnGenerate.Caption := 'Generate module';
      END;
    glVB:
      BEGIN
        dlgUnit.Filter := 'VB.NET class (*.vb)|*.vb';
        dlgUnit.DefaultExt := '.vb';
        memGenCode.Highlighter := synVB;
        btnGenerate.Caption := 'Generate class';
      END;
  END;
  vstEndpoints.Invalidate;
  UpdateSelStatus;
END;

FUNCTION TfrmMain.DisplayName(AEp: TEndpoint): STRING;
// Method name as written in the generated file
BEGIN
  Result := LangName(NameOf(AEp));
END;

FUNCTION TfrmMain.LangName(CONST AName: STRING): STRING;
// Base (PascalCase) name -> name in the chosen language (Java, Node.js: camelCase, Python: snake_case,
// C#, VB.NET: NameAsync, PowerShell: Verb-CockpitNoun)
BEGIN
  CASE FLanguage OF
    glJava, glNode: Result := LowerFirst(AName);
    glPython: Result := SnakeCase(AName);
    glCSharp, glVB: Result := AName + 'Async';
    glPowerShell: Result := PowerShellName(AName);
  ELSE
    Result := AName;
  END;
END;

FUNCTION TfrmMain.ValidName(CONST AName: STRING): Boolean;
// AName = base (PascalCase) name
BEGIN
  CASE FLanguage OF
    glJava: Result := IsValidJavaIdent(LowerFirst(AName));
    glNode: Result := IsValidJsIdent(LowerFirst(AName));
    glPython: Result := IsValidPythonIdent(SnakeCase(AName));
    glCSharp: Result := IsValidCsIdent(AName + 'Async');
    glVB: Result := IsValidVbIdent(AName + 'Async');
    glPowerShell: Result := PowerShellName(AName) <> '';
  ELSE
    Result := IsValidIdent(AName);
  END;
END;

{ Test tab }

FUNCTION TypeText(CONST AT: TTypeRef): STRING;
// Short type description for the parameter grid
CONST
  NAMES: ARRAY[TTypeKind] OF STRING = ('text', 'integer', 'integer', 'decimal', 'true/false',
    'ISO date', 'yyyy-mm-dd', 'JSON', 'object', 'list');
BEGIN
  Result := NAMES[AT.Kind];
  IF AT.Kind = tkArray THEN
    Result := 'list ' + NAMES[AT.ElemKind] + ' (a,b,c)';
END;

procedure TfrmMain.ApplyTestConfig;
// Copy the configuration to the API instance (the token is dropped if it changed)
BEGIN
  FApi.SaaS := chkSaaS.Checked;
  FApi.Tenant := Trim(edTenant.Text);
  FApi.ClientId := Trim(edClientId.Text);
  FApi.ClientSecret := Trim(edSecret.Text);
  IF FApi.Tenant = '' THEN
    lblBaseUrl.Caption := 'URL:'
  ELSE
    lblBaseUrl.Caption := 'URL: ' + FApi.BaseUrl;
END;

procedure TfrmMain.TestConfigChange(Sender: TObject);
BEGIN
  ApplyTestConfig;
END;

procedure TfrmMain.ShowTestEndpoint;
// Parameters grid, body template and description of the chosen endpoint
VAR
  Ep: TEndpoint;
  I: Integer;
  Info: STRING;
BEGIN
  Ep := TestEndpoint;
  sgParams.RowCount := 1;
  memBody.Clear;
  IF Ep = NIL THEN
  BEGIN
    lblTestEndpoint.Caption := 'Select an endpoint in the tree';
    lblTestInfo.Caption := '';
    memBody.Enabled := False;
    chkAllPages.Enabled := False;
    Exit;
  END;
  lblTestEndpoint.Caption := Ep.Method + '  ' + Ep.Path + '   [' + Ep.Tag + ']';
  Info := Ep.Summary;
  IF Ep.Deprecated THEN
    Info := '[DEPRECATED] ' + Info;
  IF NOT Ep.Supported THEN
    Info := '[Generator: ' + Ep.Reason + '] ' + Info;
  lblTestInfo.Caption := Info;
  lblTestInfo.Hint := Info;
  lblTestInfo.ShowHint := True;
  sgParams.RowCount := Length(Ep.Params) + 1;
  FOR I := 0 TO High(Ep.Params) DO
  BEGIN
    sgParams.Cells[0, I + 1] := Ep.Params[I].Name;
    IF Ep.Params[I].Loc = plPath THEN
      sgParams.Cells[1, I + 1] := 'path'
    ELSE
      sgParams.Cells[1, I + 1] := 'query';
    sgParams.Cells[2, I + 1] := TypeText(Ep.Params[I].TypeRef);
    IF Ep.Params[I].Required THEN
      sgParams.Cells[3, I + 1] := 'yes'
    ELSE
      sgParams.Cells[3, I + 1] := '';
    sgParams.Cells[4, I + 1] := '';
  END;
  memBody.Enabled := Ep.BodySchema <> NIL;
  chkAllPages.Enabled := Ep.RespKind = rkPaged;
  IF NOT chkAllPages.Enabled THEN
    chkAllPages.Checked := False;
  memBody.Text := FSpec.BodyTemplate(Ep, 10);
END;

procedure TfrmMain.ShowResponse(const AStatus, AText: STRING);
// Status line + response (formatted when it is JSON)
VAR
  V: TJSONData;
BEGIN
  lblRespStatus.Caption := AStatus;
  V := NIL;
  TRY
    IF (Trim(AText) <> '') AND (Trim(AText)[1] IN ['{', '[']) THEN
      V := GetJSON(AText, True);
  EXCEPT
    V := NIL;
  END;
  TRY
    IF V <> NIL THEN
      memResp.Text := V.FormatJSON
    ELSE
      memResp.Text := AText;
  FINALLY
    V.Free;
  END;
  memResp.CaretXY := Point(1, 1);
  memResp.TopLine := 1;
END;

procedure TfrmMain.btnTestConnClick(Sender: TObject);
// Request a new token with the current configuration
VAR
  T0: QWord;
BEGIN
  ApplyTestConfig;
  FApi.ClearToken;
  Screen.Cursor := crHourGlass;
  T0 := GetTickCount64;
  TRY
    TRY
      FApi.Authenticate;
      ShowResponse(Format('Connection OK - %s - %d ms', [FApi.BaseUrl, GetTickCount64 - T0]),
        'Token received: ' + Copy(FApi.AccessToken, 1, 12) + '...');
    EXCEPT
      ON E: ECockpitItsmError DO
        ShowResponse(Format('Connection failed - HTTP %d', [E.StatusCode]), E.Message + LineEnding + LineEnding + E.Response);
      ON E: Exception DO
        ShowResponse('Connection failed', E.ClassName + ': ' + E.Message);
    END;
  FINALLY
    Screen.Cursor := crDefault;
  END;
END;

procedure TfrmMain.btnSendClick(Sender: TObject);
// Build the URL from the parameters grid and send the request
VAR
  Ep: TEndpoint;
  I: Integer;
  Path, Q, Body, Value, Item, Head, Resp: STRING;
  T0: QWord;
  BodyObj: TJSONData;
  Items: TJSONArray;
BEGIN
  Ep := TestEndpoint;
  IF Ep = NIL THEN
    Exit;
  IF sgParams.EditorMode THEN
    sgParams.EditorMode := False;
  ApplyTestConfig;
  Path := Ep.Path;
  Q := '';
  FOR I := 0 TO High(Ep.Params) DO
  BEGIN
    Value := Trim(sgParams.Cells[4, I + 1]);
    IF Value = '' THEN
    BEGIN
      IF Ep.Params[I].Required THEN
      BEGIN
        ShowMessage('Required parameter: ' + Ep.Params[I].Name);
        Exit;
      END;
      Continue;
    END;
    IF Ep.Params[I].Loc = plPath THEN
      Path := StringReplace(Path, '{' + Ep.Params[I].Name + '}', UrlEncode(Value), [])
    ELSE IF Ep.Params[I].TypeRef.Kind = tkArray THEN
    BEGIN
      FOR Item IN Value.Split([',']) DO
        IF Trim(Item) <> '' THEN
          AddQuery(Q, Ep.Params[I].Name, Trim(Item));
    END
    ELSE
      AddQuery(Q, Ep.Params[I].Name, Value);
  END;
  Body := '';
  IF Ep.BodySchema <> NIL THEN
    Body := Trim(memBody.Text);
  // JSON body checked before sending
  BodyObj := NIL;
  IF (Body <> '') AND (Ep.BodyKind <> bkText) THEN
    TRY
      BodyObj := GetJSON(Body, True);
    EXCEPT
      ON E: Exception DO
      BEGIN
        ShowMessage('Invalid JSON body: ' + E.Message);
        Exit;
      END;
    END;
  Head := Ep.Method + ' ' + FApi.BaseUrl + Path + Q;
  Screen.Cursor := crHourGlass;
  T0 := GetTickCount64;
  TRY
    TRY
      IF chkAllPages.Checked AND (BodyObj IS TJSONObject) THEN
      BEGIN
        Items := FApi.FetchAllPages(Ep.Method, Path + Q, TJSONObject(BodyObj), Ep.PagePath);
        TRY
          Resp := Items.AsJSON;
          ShowResponse(Format('%s  -  HTTP %d  -  %d ms  -  %d item(s), all pages',
            [Head, FApi.LastStatus, GetTickCount64 - T0, Items.Count]), Resp);
        FINALLY
          Items.Free;
        END;
      END
      ELSE
      BEGIN
        Resp := FApi.Call(Ep.Method, Path + Q, Body);
        ShowResponse(Format('%s  -  HTTP %d  -  %d ms  -  %d bytes',
          [Head, FApi.LastStatus, GetTickCount64 - T0, Length(Resp)]), Resp);
      END;
    EXCEPT
      ON E: ECockpitItsmError DO
        IF E.Response <> '' THEN
          ShowResponse(Format('%s  -  HTTP %d  -  %d ms', [Head, E.StatusCode, GetTickCount64 - T0]), E.Response)
        ELSE
          ShowResponse(Format('%s  -  Error', [Head]), E.Message);
      ON E: Exception DO
        ShowResponse(Format('%s  -  Error', [Head]), E.ClassName + ': ' + E.Message);
    END;
  FINALLY
    BodyObj.Free;
    Screen.Cursor := crDefault;
  END;
END;

{ Endpoint tree (API tab) }

function TfrmMain.TestEndpoint: TEndpoint;
BEGIN
  Result := FCurrent;
END;

procedure TfrmMain.SetupTree;
// Columns and options of the endpoint tree
VAR
  Col: TVirtualTreeColumn;
BEGIN
  vstEndpoints.NodeDataSize := SizeOf(TNodeData);
  vstEndpoints.DefaultText := '';
  Col := vstEndpoints.Header.Columns.Add;
  Col.Text := 'Endpoint';
  Col.Width := 290;
  Col := vstEndpoints.Header.Columns.Add;
  Col.Text := 'Pascal name';
  Col.Width := 200;
  Col := vstEndpoints.Header.Columns.Add;
  Col.Text := 'Remark';
  Col.Width := 420;
  vstEndpoints.Header.MainColumn := 0;
  vstEndpoints.Header.Options := [hoColumnResize, hoDblClickResize, hoVisible];
  vstEndpoints.TreeOptions.MiscOptions := vstEndpoints.TreeOptions.MiscOptions + [toCheckSupport, toEditable, toEditOnDblClick];
  vstEndpoints.TreeOptions.AutoOptions := vstEndpoints.TreeOptions.AutoOptions - [toAutoSort] + [toAutoTristateTracking];
  vstEndpoints.TreeOptions.SelectionOptions := vstEndpoints.TreeOptions.SelectionOptions + [toFullRowSelect, toExtendedFocus];
END;

procedure TfrmMain.FillTree;
// Tree grouped by tag (spec of cbGenVersion), filtered; checked = selected for generation
VAR
  I: Integer;
  F, OldKey: STRING;
  Ep: TEndpoint;
  Sorted: TList;
  Expanded: TStringList;
  TagNode, Node, FocusNode: PVirtualNode;
  Data, TagData: PNodeData;
  HasCheckable: Boolean;
BEGIN
  OldKey := '';
  IF FCurrent <> NIL THEN
    OldKey := FCurrent.Key;
  F := LowerCase(Trim(edTreeFilter.Text));
  FocusNode := NIL;
  Expanded := TStringList.Create;
  Sorted := TList.Create;
  FBuildingTree := True;
  vstEndpoints.BeginUpdate;
  TRY
    // Expanded groups are kept across rebuilds
    Node := vstEndpoints.GetFirst;
    WHILE Node <> NIL DO
    BEGIN
      IF vstEndpoints.Expanded[Node] THEN
        Expanded.Add(PNodeData(vstEndpoints.GetNodeData(Node))^.Tag);
      Node := vstEndpoints.GetNextSibling(Node);
    END;
    vstEndpoints.Clear;
    FCurrent := NIL;
    FOR I := 0 TO FSpec.Count - 1 DO
      Sorted.Add(FSpec[I]);
    Sorted.Sort(SortEndpoints);
    TagNode := NIL;
    TagData := NIL;
    FOR I := 0 TO Sorted.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sorted[I]);
      IF chkGenSupported.Checked AND NOT Ep.Supported THEN
        Continue;
      IF chkGenDeprecated.Checked AND Ep.Deprecated THEN
        Continue;
      IF chkGenSelected.Checked AND (FSel.IndexOf(Ep.Key) < 0) THEN
        Continue;
      IF (F <> '') AND (Pos(F, LowerCase(Ep.Tag + ' ' + Ep.Key + ' ' + NameOf(Ep) + ' ' + Ep.Summary)) = 0) THEN
        Continue;
      IF (TagNode = NIL) OR (TagData^.Tag <> Ep.Tag) THEN
      BEGIN
        TagNode := vstEndpoints.AddChild(NIL);
        TagData := vstEndpoints.GetNodeData(TagNode);
        TagData^.Ep := NIL;
        TagData^.Tag := Ep.Tag;
        TagData^.Count := 0;
        vstEndpoints.CheckType[TagNode] := ctTriStateCheckBox;
      END;
      Node := vstEndpoints.AddChild(TagNode);
      Data := vstEndpoints.GetNodeData(Node);
      Data^.Ep := Ep;
      Data^.Tag := Ep.Tag;
      Data^.Count := 0;
      Inc(TagData^.Count);
      // Endpoints the generator cannot handle have no checkbox (still testable)
      IF Ep.Supported THEN
      BEGIN
        vstEndpoints.CheckType[Node] := ctCheckBox;
        IF FSel.IndexOf(Ep.Key) >= 0 THEN
          vstEndpoints.CheckState[Node] := csCheckedNormal;
      END
      ELSE
        vstEndpoints.CheckType[Node] := ctNone;
      IF Ep.Key = OldKey THEN
        FocusNode := Node;
    END;
    // Groups: no checkbox without checkable endpoint; expanded when filtering
    TagNode := vstEndpoints.GetFirst;
    WHILE TagNode <> NIL DO
    BEGIN
      HasCheckable := False;
      Node := vstEndpoints.GetFirstChild(TagNode);
      WHILE Node <> NIL DO
      BEGIN
        IF vstEndpoints.CheckType[Node] = ctCheckBox THEN
          HasCheckable := True;
        Node := vstEndpoints.GetNextSibling(Node);
      END;
      IF NOT HasCheckable THEN
        vstEndpoints.CheckType[TagNode] := ctNone;
      TagData := vstEndpoints.GetNodeData(TagNode);
      IF (F <> '') OR chkGenSelected.Checked OR (Expanded.IndexOf(TagData^.Tag) >= 0) THEN
        vstEndpoints.Expanded[TagNode] := True;
      TagNode := vstEndpoints.GetNextSibling(TagNode);
    END;
  FINALLY
    vstEndpoints.EndUpdate;
    FBuildingTree := False;
    Sorted.Free;
    Expanded.Free;
  END;
  IF FocusNode <> NIL THEN
  BEGIN
    vstEndpoints.FocusedNode := FocusNode;
    vstEndpoints.Selected[FocusNode] := True;
    vstEndpoints.ScrollIntoView(FocusNode, True);
    FCurrent := PNodeData(vstEndpoints.GetNodeData(FocusNode))^.Ep;
  END;
  ShowEndpoint;
  UpdateSelStatus;
END;

procedure TfrmMain.SyncSelectionFromTree;
// Selection updated from the checkboxes of the displayed endpoints
// (endpoints hidden by the filters keep their state)
VAR
  Node: PVirtualNode;
  Data: PNodeData;
BEGIN
  Node := vstEndpoints.GetFirst;
  WHILE Node <> NIL DO
  BEGIN
    Data := vstEndpoints.GetNodeData(Node);
    IF (Data^.Ep <> NIL) AND (vstEndpoints.CheckType[Node] = ctCheckBox) THEN
    BEGIN
      IF vstEndpoints.CheckState[Node] IN [csCheckedNormal, csCheckedPressed] THEN
        FSel.Add(Data^.Ep.Key)
      ELSE IF FSel.IndexOf(Data^.Ep.Key) >= 0 THEN
        FSel.Delete(FSel.IndexOf(Data^.Ep.Key));
    END;
    Node := vstEndpoints.GetNext(Node);
  END;
END;

procedure TfrmMain.UpdateSelStatus;
VAR
  Shown: Cardinal;
BEGIN
  Shown := vstEndpoints.TotalCount - vstEndpoints.RootNodeCount;
  sbMain.SimpleText := Format('%d JSON file(s) — version %s: %d endpoint(s) selected for generation, %d shown',
    [FFiles.Count, cbGenVersion.Text, FSel.Count, Shown]);
  ShowGenSummary(Format('%d endpoint(s) selected — spec %s', [FSel.Count, cbGenVersion.Text]));
  // Nothing to generate without a selected endpoint
  btnGenerate.Enabled := FSel.Count > 0;
END;

procedure TfrmMain.edTreeFilterChange(Sender: TObject);
BEGIN
  FillTree;
END;

procedure TfrmMain.btnUncheckAllClick(Sender: TObject);
BEGIN
  FSel.Clear;
  FillTree;
END;

procedure TfrmMain.vstEndpointsChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
BEGIN
  IF FBuildingTree OR (Node = NIL) THEN
    Exit;
  SyncSelectionFromTree;
  UpdateSelStatus;
  Sender.Invalidate;
END;

procedure TfrmMain.vstEndpointsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: STRING);
// Endpoint | name in the chosen language | remark ; groups show their endpoint count
VAR
  Data: PNodeData;
  Ep: TEndpoint;
BEGIN
  CellText := '';
  IF TextType <> ttNormal THEN
    Exit;
  Data := Sender.GetNodeData(Node);
  IF Data^.Ep = NIL THEN
  BEGIN
    IF Column <= 0 THEN
      CellText := Format('%s (%d)', [Data^.Tag, Data^.Count]);
    Exit;
  END;
  Ep := Data^.Ep;
  CASE Column OF
    0: CellText := Ep.Method + '  ' + Ep.Path;
    1:
      IF Ep.Supported THEN
        CellText := DisplayName(Ep);
    2:
      IF NOT Ep.Supported THEN
        CellText := 'Generator: ' + Ep.Reason
      ELSE
      BEGIN
        IF Ep.Deprecated THEN
          CellText := '[DEPRECATED] ';
        IF Ep.RespKind = rkPaged THEN
          CellText := CellText + '[all pages] ';
        CellText := CellText + Ep.Summary;
      END;
  END;
END;

procedure TfrmMain.vstEndpointsPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
// Groups in bold; methods colored as in the portal; deprecated struck out;
// unsupported in grey; selected names in bold, invalid names in red
VAR
  Data: PNodeData;
  Ep: TEndpoint;
BEGIN
  IF TextType <> ttNormal THEN
    Exit;
  Data := Sender.GetNodeData(Node);
  IF Data^.Ep = NIL THEN
  BEGIN
    TargetCanvas.Font.Style := [fsBold];
    Exit;
  END;
  Ep := Data^.Ep;
  TargetCanvas.Font.Style := [];
  IF (Column = 0) AND Ep.Deprecated THEN
    TargetCanvas.Font.Style := [fsStrikeOut];
  IF (Column = 1) AND (FSel.IndexOf(Ep.Key) >= 0) THEN
    TargetCanvas.Font.Style := [fsBold];
  IF vsSelected IN Node^.States THEN
    Exit;
  IF NOT Ep.Supported THEN
    TargetCanvas.Font.Color := clGray
  ELSE IF Column = 0 THEN
  BEGIN
    IF Ep.Method = 'GET' THEN
      TargetCanvas.Font.Color := clGreen
    ELSE IF Ep.Method = 'POST' THEN
      TargetCanvas.Font.Color := clBlue
    ELSE IF Ep.Method = 'PUT' THEN
      TargetCanvas.Font.Color := $0060A0
    ELSE IF Ep.Method = 'DELETE' THEN
      TargetCanvas.Font.Color := clRed
    ELSE
      TargetCanvas.Font.Color := clPurple;
  END
  ELSE IF (Column = 1) AND NOT ValidName(NameOf(Ep)) THEN
    TargetCanvas.Font.Color := clRed
  ELSE IF (Column = 2) AND Ep.Deprecated THEN
    TargetCanvas.Font.Color := clMaroon;
END;

procedure TfrmMain.vstEndpointsEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
// Only the method name of a supported endpoint is editable
VAR
  Data: PNodeData;
BEGIN
  Data := Sender.GetNodeData(Node);
  Allowed := (Column = 1) AND (Data^.Ep <> NIL) AND Data^.Ep.Supported;
END;

procedure TfrmMain.vstEndpointsNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const NewText: STRING);
// Custom method name (kept only if different from the default one).
// Names are stored in PascalCase: listEndUsers (Java, Node.js), list_end_users (Python),
// ListEndUsersAsync (C#, VB.NET) or Find-CockpitEndUsers (PowerShell) -> ListEndUsers
VAR
  Data: PNodeData;
  Name_: STRING;
BEGIN
  Data := Sender.GetNodeData(Node);
  IF (Column <> 1) OR (Data^.Ep = NIL) THEN
    Exit;
  Name_ := Trim(NewText);
  IF Name_ = LangName(Data^.Ep.DefaultName) THEN
    Name_ := ''
  ELSE IF (Name_ <> '') AND (FLanguage IN [glJava, glNode]) THEN
    Name_ := UpperCase(Copy(Name_, 1, 1)) + Copy(Name_, 2, MaxInt)
  ELSE IF (Name_ <> '') AND (FLanguage = glPython) THEN
    Name_ := PascalCaseOf(Name_)
  ELSE IF (Name_ <> '') AND (FLanguage IN [glCSharp, glVB]) THEN
  BEGIN
    IF (Length(Name_) > 5) AND Name_.EndsWith('Async') THEN
      SetLength(Name_, Length(Name_) - 5);
    Name_ := UpperCase(Copy(Name_, 1, 1)) + Copy(Name_, 2, MaxInt);
  END
  ELSE IF (Name_ <> '') AND (FLanguage = glPowerShell) THEN
    Name_ := PowerShellBase(Name_);
  IF (Name_ = '') OR (Name_ = Data^.Ep.DefaultName) THEN
    FNames.Values[Data^.Ep.Key] := ''
  ELSE
    FNames.Values[Data^.Ep.Key] := Name_;
END;

procedure TfrmMain.vstEndpointsFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
BEGIN
  Finalize(PNodeData(Sender.GetNodeData(Node))^);
END;

procedure TfrmMain.vstEndpointsChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
// Selected node shown in the Detail and Test pages (groups clear them)
BEGIN
  IF FBuildingTree THEN
    Exit;
  IF Node = NIL THEN
    FCurrent := NIL
  ELSE
    FCurrent := PNodeData(Sender.GetNodeData(Node))^.Ep;
  ShowEndpoint;
END;

procedure TfrmMain.ShowEndpoint;
BEGIN
  ShowDetail;
  ShowTestEndpoint;
END;

procedure TfrmMain.ShowDetail;
// Documentation of the focused endpoint: description, parameters, request / response examples
VAR
  Ep: TEndpoint;
  I: Integer;
  Info: STRING;
BEGIN
  Ep := FCurrent;
  sgDocParams.RowCount := 1;
  memDocReq.Clear;
  memDocResp.Clear;
  IF Ep = NIL THEN
  BEGIN
    lblDocTitle.Caption := 'Select an endpoint in the tree';
    lblDocDesc.Caption := '';
    Exit;
  END;
  lblDocTitle.Caption := Ep.Method + '  ' + Ep.Path + '   [' + Ep.Tag + ']';
  Info := Ep.Description;
  IF Ep.Deprecated THEN
    Info := '[DEPRECATED] ' + Info;
  IF NOT Ep.Supported THEN
    Info := '[Generator: ' + Ep.Reason + '] ' + Info;
  lblDocDesc.Caption := Info;
  lblDocDesc.Hint := Info;
  sgDocParams.RowCount := Length(Ep.Params) + 1;
  FOR I := 0 TO High(Ep.Params) DO
  BEGIN
    sgDocParams.Cells[0, I + 1] := Ep.Params[I].Name;
    IF Ep.Params[I].Loc = plPath THEN
      sgDocParams.Cells[1, I + 1] := 'path'
    ELSE
      sgDocParams.Cells[1, I + 1] := 'query';
    sgDocParams.Cells[2, I + 1] := TypeText(Ep.Params[I].TypeRef);
    IF Ep.Params[I].Required THEN
      sgDocParams.Cells[3, I + 1] := 'yes'
    ELSE
      sgDocParams.Cells[3, I + 1] := '';
    sgDocParams.Cells[4, I + 1] := Ep.Params[I].Description;
  END;
  IF Ep.BodySchema = NIL THEN
    lblDocReq.Caption := 'No request body'
  ELSE IF Ep.BodyKind = bkText THEN
  BEGIN
    lblDocReq.Caption := 'Request body: plain text';
    memDocReq.Text := '"text sent as is"';
  END
  ELSE
  BEGIN
    lblDocReq.Caption := 'Request body (example)';
    memDocReq.Text := FSpec.BodyTemplate(Ep, 10);
  END;
  IF Ep.RespKind = rkNone THEN
    lblDocResp.Caption := 'Response: no content'
  ELSE
  BEGIN
    lblDocResp.Caption := Format('Response %d (example)', [Ep.RespCode]);
    memDocResp.Text := FSpec.ResponseExample(Ep);
  END;
END;

{ Generation page }

procedure TfrmMain.ShowGenSummary(const AText: STRING);
// Summary line; in red with the warnings (hint) when there are some
BEGIN
  IF FGenWarnings.Count = 0 THEN
  BEGIN
    lblGenSummary.Caption := AText;
    lblGenSummary.Font.Color := clDefault;
    lblGenSummary.Hint := '';
  END
  ELSE
  BEGIN
    lblGenSummary.Caption := Format('%s — %d warning(s): %s', [AText, FGenWarnings.Count,
      StringReplace(Trim(FGenWarnings.Text), LineEnding, ' ; ', [rfReplaceAll])]);
    lblGenSummary.Font.Color := clRed;
    lblGenSummary.Hint := FGenWarnings.Text;
  END;
  lblGenSummary.ShowHint := lblGenSummary.Hint <> '';
  IF Pos('ERROR', AText) = 1 THEN
    lblGenSummary.Font.Color := clRed;
END;

procedure TfrmMain.ShowUnitCode(const AFileName: STRING);
// Generated file shown with the highlighter of its language
BEGIN
  IF FileExists(AFileName) THEN
    memGenCode.Lines.LoadFromFile(AFileName)
  ELSE
    memGenCode.Clear;
END;

function TfrmMain.WriteCoreFile(const ADir, AResName, AFileName: STRING): STRING;
// Write the core (uCockpitItsmCore.pas or CockpitItsmCore.java, compiled in the executable)
// next to the generated file, only when missing or different: the core always matches this generator
VAR
  Res: TResourceStream;
  Embedded, Existing: STRING;
  FileName: STRING;
  F: TFileStream;
BEGIN
  FileName := IncludeTrailingPathDelimiter(ADir) + AFileName;
  Embedded := '';
  // RCDATA resource type = 10 (RT_RCDATA is declared in the Windows unit on Windows only)
  Res := TResourceStream.Create(HInstance, AResName, PChar(10));
  TRY
    SetLength(Embedded, Res.Size);
    IF Res.Size > 0 THEN
      Res.ReadBuffer(Embedded[1], Res.Size);
  FINALLY
    Res.Free;
  END;
  Existing := '';
  IF FileExists(FileName) THEN
  BEGIN
    F := TFileStream.Create(FileName, fmOpenRead OR fmShareDenyWrite);
    TRY
      SetLength(Existing, F.Size);
      IF F.Size > 0 THEN
        F.ReadBuffer(Existing[1], F.Size);
    FINALLY
      F.Free;
    END;
    IF Existing = Embedded THEN
      Exit('up to date');
    Result := 'updated';
  END
  ELSE
    Result := 'created';
  F := TFileStream.Create(FileName, fmCreate);
  TRY
    IF Length(Embedded) > 0 THEN
      F.WriteBuffer(Embedded[1], Length(Embedded));
  FINALLY
    F.Free;
  END;
END;

END.
