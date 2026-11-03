UNIT uCockpitItsmCore;

// Cockpit ITSM public API - runtime core (Delphi and Lazarus/FPC)
// Part of CIPAT4P - Cockpit ITSM Public API toolkit for Pascal
// HTTP transport, OAuth 2.0 token, paging and JSON helpers used by the
// generated unit (uCockpitItsmApi.pas). This unit is not generated.
//
// Delphi : System.Net.HttpClient + System.JSON (10.1 Berlin or later)
// FPC    : fpjson; HTTP through WinHTTP on Windows (no OpenSSL DLL needed),
//          fphttpclient + opensslsockets on Linux / macOS

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}

INTERFACE

USES
  {$IFDEF FPC}
  SysUtils, Classes, DateUtils, fpjson, jsonparser
  {$IFNDEF MSWINDOWS}, fphttpclient, opensslsockets{$ENDIF};
  {$ELSE}
  System.SysUtils, System.Classes, System.DateUtils, System.JSON,
  System.Net.HttpClient, System.Net.URLClient;
  {$ENDIF}

TYPE
  {$IFDEF FPC}
  TJSONValue = TJSONData;
  {$ENDIF}

  // Optional boolean (query parameters): cbUnset = parameter not sent
  TCockpitBool = (cbUnset, cbFalse, cbTrue);

  TCockpitStrings = ARRAY OF STRING;
  TCockpitIntegers = ARRAY OF Integer;
  TCockpitInt64s = ARRAY OF Int64;
  TCockpitDoubles = ARRAY OF Double;
  TCockpitBooleans = ARRAY OF Boolean;
  TCockpitDates = ARRAY OF TDateTime;

  ECockpitItsmError = CLASS(Exception)
  PRIVATE
    FStatusCode: Integer;
    FResponse: STRING;
  PUBLIC
    CONSTRUCTOR Create(AStatusCode: Integer; CONST AMessage, AResponse: STRING);
    PROPERTY StatusCode: Integer READ FStatusCode;
    PROPERTY Response: STRING READ FResponse;
  END;

  TCockpitItsmBase = CLASS
  PRIVATE
    FSaaS: Boolean;
    FTenant: STRING;
    FClientId: STRING;
    FClientSecret: STRING;
    FAccessToken: STRING;
    FTokenExpiry: TDateTime;
    FPageSize: Integer;
    FTimeout: Integer;
    FLastStatus: Integer;
    PROCEDURE SetSaaS(AValue: Boolean);
    PROCEDURE SetTenant(CONST AValue: STRING);
    PROCEDURE SetClientId(CONST AValue: STRING);
    PROCEDURE SetClientSecret(CONST AValue: STRING);
    FUNCTION HttpSend(CONST AMethod, AUrl, AContentType, ABody: STRING; AAuth: Boolean; OUT AStatus: Integer): STRING;
    PROCEDURE RaiseError(AStatus: Integer; CONST AResponse: STRING);
  PUBLIC
    CONSTRUCTOR Create; OVERLOAD;
    CONSTRUCTOR Create(ASaaS: Boolean; CONST ATenant, AClientId, AClientSecret: STRING); OVERLOAD;
    FUNCTION BaseUrl: STRING;
    FUNCTION TokenValid: Boolean;
    PROCEDURE Authenticate;
    PROCEDURE ClearToken;
    // Low-level access (also usable for endpoints that are not generated)
    FUNCTION Call(CONST AMethod, APathQuery: STRING; CONST ABody: STRING = ''): STRING;
    FUNCTION CallJson(CONST AMethod, APathQuery: STRING; CONST ABody: STRING = ''): TJSONValue;
    FUNCTION FetchAllPages(CONST AMethod, APathQuery: STRING; ABody: TJSONObject; CONST APagePath: STRING): TJSONArray;
    PROPERTY SaaS: Boolean READ FSaaS WRITE SetSaaS;
    PROPERTY Tenant: STRING READ FTenant WRITE SetTenant;
    PROPERTY ClientId: STRING READ FClientId WRITE SetClientId;
    PROPERTY ClientSecret: STRING READ FClientSecret WRITE SetClientSecret;
    PROPERTY AccessToken: STRING READ FAccessToken;
    PROPERTY PageSize: Integer READ FPageSize WRITE FPageSize;
    PROPERTY Timeout: Integer READ FTimeout WRITE FTimeout;
    PROPERTY LastStatus: Integer READ FLastStatus;
  END;

// URL helpers
FUNCTION UrlEncode(CONST AValue: STRING): STRING;
PROCEDURE AddQuery(VAR AQuery: STRING; CONST AName, AValue: STRING);
FUNCTION QBool(AValue: Boolean): STRING;
FUNCTION QFloat(AValue: Double): STRING;
FUNCTION TextToFloat(CONST AText: STRING): Double;

// Dates (ISO 8601, local time <-> UTC)
FUNCTION IsoToDateTime(CONST AValue: STRING): TDateTime;
FUNCTION DateTimeToIso(AValue: TDateTime): STRING;
FUNCTION DateToIsoDate(AValue: TDateTime): STRING;

// JSON: parsing / output
FUNCTION JParse(CONST AText: STRING): TJSONValue;
FUNCTION JToString(AValue: TJSONValue): STRING;
FUNCTION JToStringFree(AValue: TJSONValue): STRING;
FUNCTION JUnquote(CONST AText: STRING): STRING;
FUNCTION JAsObj(AValue: TJSONValue): TJSONObject;
FUNCTION JAsArr(AValue: TJSONValue): TJSONArray;

// JSON: reading object members (missing or null -> default value)
FUNCTION JFind(AObj: TJSONObject; CONST AName: STRING): TJSONValue;
FUNCTION JStr(AObj: TJSONObject; CONST AName: STRING): STRING;
FUNCTION JInt(AObj: TJSONObject; CONST AName: STRING): Integer;
FUNCTION JInt64(AObj: TJSONObject; CONST AName: STRING): Int64;
FUNCTION JInt64Def(AObj: TJSONObject; CONST AName: STRING; ADefault: Int64): Int64;
FUNCTION JFloat(AObj: TJSONObject; CONST AName: STRING): Double;
FUNCTION JBool(AObj: TJSONObject; CONST AName: STRING): Boolean;
FUNCTION JDate(AObj: TJSONObject; CONST AName: STRING): TDateTime;
FUNCTION JRaw(AObj: TJSONObject; CONST AName: STRING): STRING;
FUNCTION JObj(AObj: TJSONObject; CONST AName: STRING): TJSONObject;
FUNCTION JArr(AObj: TJSONObject; CONST AName: STRING): TJSONArray;

// JSON: arrays
FUNCTION JCount(AArr: TJSONArray): Integer;
FUNCTION JItem(AArr: TJSONArray; AIndex: Integer): TJSONValue;
FUNCTION JItemObj(AArr: TJSONArray; AIndex: Integer): TJSONObject;
FUNCTION JArrToStrs(AArr: TJSONArray): TCockpitStrings;
FUNCTION JArrToIntegers(AArr: TJSONArray): TCockpitIntegers;
FUNCTION JArrToInt64s(AArr: TJSONArray): TCockpitInt64s;
FUNCTION JArrToDoubles(AArr: TJSONArray): TCockpitDoubles;
FUNCTION JArrToBooleans(AArr: TJSONArray): TCockpitBooleans;
FUNCTION JArrToDates(AArr: TJSONArray): TCockpitDates;

// JSON: building
FUNCTION JNewObj: TJSONObject;
FUNCTION JNewArr: TJSONArray;
PROCEDURE JAddStr(AObj: TJSONObject; CONST AName, AValue: STRING);
PROCEDURE JAddInt(AObj: TJSONObject; CONST AName: STRING; AValue: Int64);
PROCEDURE JAddFloat(AObj: TJSONObject; CONST AName: STRING; AValue: Double);
PROCEDURE JAddBool(AObj: TJSONObject; CONST AName: STRING; AValue: Boolean);
PROCEDURE JAddDate(AObj: TJSONObject; CONST AName: STRING; AValue: TDateTime);
PROCEDURE JAddDateOnly(AObj: TJSONObject; CONST AName: STRING; AValue: TDateTime);
PROCEDURE JAddRaw(AObj: TJSONObject; CONST AName, AJson: STRING);
PROCEDURE JAddNull(AObj: TJSONObject; CONST AName: STRING);
PROCEDURE JAddValue(AObj: TJSONObject; CONST AName: STRING; AValue: TJSONValue);
PROCEDURE JSetInt(AObj: TJSONObject; CONST AName: STRING; AValue: Int64);
PROCEDURE JArrAddValue(AArr: TJSONArray; AValue: TJSONValue);
FUNCTION StrsToJArr(CONST AValues: TCockpitStrings): TJSONArray;
FUNCTION IntegersToJArr(CONST AValues: TCockpitIntegers): TJSONArray;
FUNCTION Int64sToJArr(CONST AValues: TCockpitInt64s): TJSONArray;
FUNCTION DoublesToJArr(CONST AValues: TCockpitDoubles): TJSONArray;
FUNCTION BooleansToJArr(CONST AValues: TCockpitBooleans): TJSONArray;
FUNCTION DatesToJArr(CONST AValues: TCockpitDates): TJSONArray;

IMPLEMENTATION

{$IF DEFINED(FPC) AND DEFINED(MSWINDOWS)}
USES
  Windows;

// WinHTTP API (winhttp.dll, native Windows TLS: no OpenSSL DLL)
TYPE
  HINTERNET = Pointer;

CONST
  WINHTTP_ACCESS_TYPE_DEFAULT_PROXY = 0;
  WINHTTP_ACCESS_TYPE_AUTOMATIC_PROXY = 4;
  WINHTTP_FLAG_SECURE = $00800000;
  WINHTTP_QUERY_STATUS_CODE = 19;
  WINHTTP_QUERY_FLAG_NUMBER = $20000000;

FUNCTION WinHttpOpen(pszAgentW: PWideChar; dwAccessType: DWORD; pszProxyW, pszProxyBypassW: PWideChar;
  dwFlags: DWORD): HINTERNET; STDCALL; EXTERNAL 'winhttp.dll';
FUNCTION WinHttpConnect(hSession: HINTERNET; pswzServerName: PWideChar; nServerPort: WORD;
  dwReserved: DWORD): HINTERNET; STDCALL; EXTERNAL 'winhttp.dll';
FUNCTION WinHttpOpenRequest(hConnect: HINTERNET; pwszVerb, pwszObjectName, pwszVersion, pwszReferrer: PWideChar;
  ppwszAcceptTypes: Pointer; dwFlags: DWORD): HINTERNET; STDCALL; EXTERNAL 'winhttp.dll';
FUNCTION WinHttpSetTimeouts(hInternet: HINTERNET; nResolveTimeout, nConnectTimeout, nSendTimeout,
  nReceiveTimeout: Integer): BOOL; STDCALL; EXTERNAL 'winhttp.dll';
FUNCTION WinHttpSendRequest(hRequest: HINTERNET; lpszHeaders: PWideChar; dwHeadersLength: DWORD;
  lpOptional: Pointer; dwOptionalLength, dwTotalLength: DWORD; dwContext: PtrUInt): BOOL; STDCALL; EXTERNAL 'winhttp.dll';
FUNCTION WinHttpReceiveResponse(hRequest: HINTERNET; lpReserved: Pointer): BOOL; STDCALL; EXTERNAL 'winhttp.dll';
FUNCTION WinHttpQueryHeaders(hRequest: HINTERNET; dwInfoLevel: DWORD; pwszName: PWideChar; lpBuffer: Pointer;
  VAR lpdwBufferLength: DWORD; lpdwIndex: PDWORD): BOOL; STDCALL; EXTERNAL 'winhttp.dll';
FUNCTION WinHttpQueryDataAvailable(hRequest: HINTERNET; VAR lpdwNumberOfBytesAvailable: DWORD): BOOL; STDCALL; EXTERNAL 'winhttp.dll';
FUNCTION WinHttpReadData(hRequest: HINTERNET; lpBuffer: Pointer; dwNumberOfBytesToRead: DWORD;
  VAR lpdwNumberOfBytesRead: DWORD): BOOL; STDCALL; EXTERNAL 'winhttp.dll';
FUNCTION WinHttpCloseHandle(hInternet: HINTERNET): BOOL; STDCALL; EXTERNAL 'winhttp.dll';
{$ENDIF}

RESOURCESTRING
  {$IF DEFINED(FPC) AND DEFINED(MSWINDOWS)}
  SWinHttpError = 'WinHTTP: %s (code %d)';
  {$ENDIF}
  SInvalidJson = 'Invalid JSON response: %s';
  {$IFNDEF FPC}
  SUnsupportedMethod = 'Unsupported HTTP method: %s';
  {$ENDIF}
  SHttpError = 'Cockpit ITSM: HTTP error %d - %s';
  SMissingCredentials = 'Cockpit ITSM: tenant, ClientId and ClientSecret are required';
  SNoToken = 'Cockpit ITSM: no token in the response';
  SInvalidPage = 'Cockpit ITSM: invalid paged response';

CONST
  DEFAULT_PAGE_SIZE = 500;
  DEFAULT_TIMEOUT = 60000;
  TOKEN_MARGIN_SEC = 60;

VAR
  InvFS: TFormatSettings;

{ ECockpitItsmError }

CONSTRUCTOR ECockpitItsmError.Create(AStatusCode: Integer; CONST AMessage, AResponse: STRING);
BEGIN
  INHERITED Create(AMessage);
  FStatusCode := AStatusCode;
  FResponse := AResponse;
END;

{ URL helpers }

FUNCTION UrlEncode(CONST AValue: STRING): STRING;
// Percent-encode the UTF-8 bytes of AValue (RFC 3986 unreserved kept)
// FPC: strings are UTF-8 already (Lazarus), bytes are used as is
VAR
  U: RawByteString;
  I: Integer;
  C: AnsiChar;
BEGIN
  Result := '';
  {$IFDEF FPC}
  SetString(U, PAnsiChar(Pointer(AValue)), Length(AValue));
  {$ELSE}
  U := UTF8Encode(AValue);
  {$ENDIF}
  FOR I := 1 TO Length(U) DO
  BEGIN
    C := U[I];
    IF C IN ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.', '~'] THEN
      Result := Result + Char(C)
    ELSE
      Result := Result + '%' + IntToHex(Ord(C), 2);
  END;
END;

PROCEDURE AddQuery(VAR AQuery: STRING; CONST AName, AValue: STRING);
BEGIN
  IF AQuery = '' THEN
    AQuery := '?'
  ELSE
    AQuery := AQuery + '&';
  AQuery := AQuery + UrlEncode(AName) + '=' + UrlEncode(AValue);
END;

FUNCTION QBool(AValue: Boolean): STRING;
BEGIN
  IF AValue THEN
    Result := 'true'
  ELSE
    Result := 'false';
END;

FUNCTION QFloat(AValue: Double): STRING;
BEGIN
  Result := FloatToStr(AValue, InvFS);
END;

FUNCTION TextToFloat(CONST AText: STRING): Double;
BEGIN
  Result := StrToFloatDef(Trim(AText), 0, InvFS);
END;

{ Dates }

FUNCTION LocalToUtc(AValue: TDateTime): TDateTime;
BEGIN
  {$IFDEF FPC}
  Result := LocalTimeToUniversal(AValue);
  {$ELSE}
  Result := TTimeZone.Local.ToUniversalTime(AValue);
  {$ENDIF}
END;

FUNCTION UtcToLocal(AValue: TDateTime): TDateTime;
BEGIN
  {$IFDEF FPC}
  Result := UniversalTimeToLocal(AValue);
  {$ELSE}
  Result := TTimeZone.Local.ToLocalTime(AValue);
  {$ENDIF}
END;

FUNCTION IsoToDateTime(CONST AValue: STRING): TDateTime;
// yyyy-mm-dd[Thh:nn[:ss[.fff]]][Z|+hh[:]mm|-hh[:]mm] -> local TDateTime (0 if invalid)
VAR
  S, Frac: STRING;
  Y, M, D, H, N, Sec, Ms, P, OffSign, OffMin: Integer;
  T: TDateTime;
  HasTZ: Boolean;
BEGIN
  Result := 0;
  S := Trim(AValue);
  IF Length(S) < 10 THEN
    Exit;
  Y := StrToIntDef(Copy(S, 1, 4), 0);
  M := StrToIntDef(Copy(S, 6, 2), 0);
  D := StrToIntDef(Copy(S, 9, 2), 0);
  IF NOT TryEncodeDate(Y, M, D, Result) THEN
    Exit(0);
  IF Length(S) < 16 THEN
    Exit;
  H := StrToIntDef(Copy(S, 12, 2), 0);
  N := StrToIntDef(Copy(S, 15, 2), 0);
  Sec := 0;
  Ms := 0;
  P := 17;
  IF (P <= Length(S)) AND (S[P] = ':') THEN
  BEGIN
    Sec := StrToIntDef(Copy(S, P + 1, 2), 0);
    P := P + 3;
  END;
  IF (P <= Length(S)) AND (S[P] = '.') THEN
  BEGIN
    Inc(P);
    Frac := '';
    WHILE (P <= Length(S)) AND CharInSet(S[P], ['0'..'9']) DO
    BEGIN
      Frac := Frac + S[P];
      Inc(P);
    END;
    Frac := Copy(Frac + '000', 1, 3);
    Ms := StrToIntDef(Frac, 0);
  END;
  IF NOT TryEncodeTime(H, N, Sec, Ms, T) THEN
    T := 0;
  Result := Result + T;
  HasTZ := False;
  OffMin := 0;
  IF (P <= Length(S)) AND CharInSet(S[P], ['Z', 'z']) THEN
    HasTZ := True
  ELSE IF (P <= Length(S)) AND CharInSet(S[P], ['+', '-']) THEN
  BEGIN
    HasTZ := True;
    IF S[P] = '-' THEN
      OffSign := -1
    ELSE
      OffSign := 1;
    Frac := StringReplace(Copy(S, P + 1, 5), ':', '', [rfReplaceAll]);
    OffMin := OffSign * (StrToIntDef(Copy(Frac, 1, 2), 0) * 60 + StrToIntDef(Copy(Frac, 3, 2), 0));
  END;
  IF HasTZ THEN
    Result := UtcToLocal(Result - OffMin / MinsPerDay);
END;

FUNCTION DateTimeToIso(AValue: TDateTime): STRING;
// Local TDateTime -> UTC ISO 8601 with milliseconds
BEGIN
  Result := FormatDateTime('yyyy-mm-dd"T"hh":"nn":"ss"."zzz"Z"', LocalToUtc(AValue), InvFS);
END;

FUNCTION DateToIsoDate(AValue: TDateTime): STRING;
BEGIN
  Result := FormatDateTime('yyyy-mm-dd', AValue, InvFS);
END;

{ JSON value access (library specific) }

FUNCTION VStr(AValue: TJSONValue): STRING;
BEGIN
  {$IFDEF FPC}
  IF AValue.JSONType IN [jtObject, jtArray] THEN
    Result := AValue.AsJSON
  ELSE
    Result := AValue.AsString;
  {$ELSE}
  IF (AValue IS TJSONObject) OR (AValue IS TJSONArray) THEN
    Result := AValue.ToJSON
  ELSE
    Result := AValue.Value;
  {$ENDIF}
END;

FUNCTION VInt64(AValue: TJSONValue): Int64;
BEGIN
  {$IFDEF FPC}
  IF AValue.JSONType = jtNumber THEN
    Result := AValue.AsInt64
  ELSE
    Result := StrToInt64Def(VStr(AValue), 0);
  {$ELSE}
  IF AValue IS TJSONNumber THEN
    Result := TJSONNumber(AValue).AsInt64
  ELSE
    Result := StrToInt64Def(AValue.Value, 0);
  {$ENDIF}
END;

FUNCTION VFloat(AValue: TJSONValue): Double;
BEGIN
  {$IFDEF FPC}
  IF AValue.JSONType = jtNumber THEN
    Result := AValue.AsFloat
  ELSE
    Result := StrToFloatDef(VStr(AValue), 0, InvFS);
  {$ELSE}
  IF AValue IS TJSONNumber THEN
    Result := TJSONNumber(AValue).AsDouble
  ELSE
    Result := StrToFloatDef(AValue.Value, 0, InvFS);
  {$ENDIF}
END;

FUNCTION VBool(AValue: TJSONValue): Boolean;
BEGIN
  {$IFDEF FPC}
  IF AValue.JSONType = jtBoolean THEN
    Result := AValue.AsBoolean
  ELSE
    Result := SameText(VStr(AValue), 'true');
  {$ELSE}
  Result := (AValue IS TJSONTrue) OR SameText(AValue.Value, 'true');
  {$ENDIF}
END;

FUNCTION JParse(CONST AText: STRING): TJSONValue;
// Parse JSON text; nil for empty text; raises ECockpitItsmError if invalid
BEGIN
  Result := NIL;
  IF Trim(AText) = '' THEN
    Exit;
  {$IFDEF FPC}
  TRY
    Result := GetJSON(AText, True);
  EXCEPT
    ON E: Exception DO
      RAISE ECockpitItsmError.Create(0, Format(SInvalidJson, [E.Message]), AText);
  END;
  {$ELSE}
  Result := TJSONObject.ParseJSONValue(AText);
  IF Result = NIL THEN
    RAISE ECockpitItsmError.Create(0, Format(SInvalidJson, ['']), AText);
  {$ENDIF}
END;

FUNCTION JToString(AValue: TJSONValue): STRING;
BEGIN
  IF AValue = NIL THEN
    Result := ''
  ELSE
    {$IFDEF FPC}
    Result := AValue.AsJSON;
    {$ELSE}
    Result := AValue.ToJSON;
    {$ENDIF}
END;

FUNCTION JToStringFree(AValue: TJSONValue): STRING;
// Serialize then free AValue
BEGIN
  TRY
    Result := JToString(AValue);
  FINALLY
    AValue.Free;
  END;
END;

FUNCTION JUnquote(CONST AText: STRING): STRING;
// Plain-text response: decode it if the server sent a JSON string literal
VAR
  V: TJSONValue;
BEGIN
  Result := AText;
  IF (Length(AText) >= 2) AND (AText[1] = '"') AND (AText[Length(AText)] = '"') THEN
  BEGIN
    V := JParse(AText);
    TRY
      IF V <> NIL THEN
        Result := VStr(V);
    FINALLY
      V.Free;
    END;
  END;
END;

FUNCTION JAsObj(AValue: TJSONValue): TJSONObject;
BEGIN
  IF AValue IS TJSONObject THEN
    Result := TJSONObject(AValue)
  ELSE
    Result := NIL;
END;

FUNCTION JAsArr(AValue: TJSONValue): TJSONArray;
BEGIN
  IF AValue IS TJSONArray THEN
    Result := TJSONArray(AValue)
  ELSE
    Result := NIL;
END;

FUNCTION JFind(AObj: TJSONObject; CONST AName: STRING): TJSONValue;
// Member value, nil if missing or null
BEGIN
  Result := NIL;
  IF AObj = NIL THEN
    Exit;
  {$IFDEF FPC}
  Result := AObj.Find(AName);
  IF (Result <> NIL) AND (Result.JSONType = jtNull) THEN
    Result := NIL;
  {$ELSE}
  Result := AObj.GetValue(AName);
  IF Result IS TJSONNull THEN
    Result := NIL;
  {$ENDIF}
END;

FUNCTION JStr(AObj: TJSONObject; CONST AName: STRING): STRING;
VAR
  V: TJSONValue;
BEGIN
  V := JFind(AObj, AName);
  IF V = NIL THEN
    Result := ''
  ELSE
    Result := VStr(V);
END;

FUNCTION JInt(AObj: TJSONObject; CONST AName: STRING): Integer;
BEGIN
  Result := Integer(JInt64Def(AObj, AName, 0));
END;

FUNCTION JInt64(AObj: TJSONObject; CONST AName: STRING): Int64;
BEGIN
  Result := JInt64Def(AObj, AName, 0);
END;

FUNCTION JInt64Def(AObj: TJSONObject; CONST AName: STRING; ADefault: Int64): Int64;
VAR
  V: TJSONValue;
BEGIN
  V := JFind(AObj, AName);
  IF V = NIL THEN
    Result := ADefault
  ELSE
    Result := VInt64(V);
END;

FUNCTION JFloat(AObj: TJSONObject; CONST AName: STRING): Double;
VAR
  V: TJSONValue;
BEGIN
  V := JFind(AObj, AName);
  IF V = NIL THEN
    Result := 0
  ELSE
    Result := VFloat(V);
END;

FUNCTION JBool(AObj: TJSONObject; CONST AName: STRING): Boolean;
VAR
  V: TJSONValue;
BEGIN
  V := JFind(AObj, AName);
  Result := (V <> NIL) AND VBool(V);
END;

FUNCTION JDate(AObj: TJSONObject; CONST AName: STRING): TDateTime;
BEGIN
  Result := IsoToDateTime(JStr(AObj, AName));
END;

FUNCTION JRaw(AObj: TJSONObject; CONST AName: STRING): STRING;
// Raw JSON text of a member ('' if missing or null)
BEGIN
  Result := JToString(JFind(AObj, AName));
END;

FUNCTION JObj(AObj: TJSONObject; CONST AName: STRING): TJSONObject;
BEGIN
  Result := JAsObj(JFind(AObj, AName));
END;

FUNCTION JArr(AObj: TJSONObject; CONST AName: STRING): TJSONArray;
BEGIN
  Result := JAsArr(JFind(AObj, AName));
END;

{ Arrays }

FUNCTION JCount(AArr: TJSONArray): Integer;
BEGIN
  IF AArr = NIL THEN
    Result := 0
  ELSE
    Result := AArr.Count;
END;

FUNCTION JItem(AArr: TJSONArray; AIndex: Integer): TJSONValue;
BEGIN
  Result := AArr.Items[AIndex];
  {$IFDEF FPC}
  IF Result.JSONType = jtNull THEN
    Result := NIL;
  {$ELSE}
  IF Result IS TJSONNull THEN
    Result := NIL;
  {$ENDIF}
END;

FUNCTION JItemObj(AArr: TJSONArray; AIndex: Integer): TJSONObject;
BEGIN
  Result := JAsObj(JItem(AArr, AIndex));
END;

FUNCTION JArrToStrs(AArr: TJSONArray): TCockpitStrings;
VAR
  I: Integer;
  V: TJSONValue;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
  BEGIN
    V := JItem(AArr, I);
    IF V = NIL THEN
      Result[I] := ''
    ELSE
      Result[I] := VStr(V);
  END;
END;

FUNCTION JArrToIntegers(AArr: TJSONArray): TCockpitIntegers;
VAR
  I: Integer;
  V: TJSONValue;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
  BEGIN
    V := JItem(AArr, I);
    IF V = NIL THEN
      Result[I] := 0
    ELSE
      Result[I] := Integer(VInt64(V));
  END;
END;

FUNCTION JArrToInt64s(AArr: TJSONArray): TCockpitInt64s;
VAR
  I: Integer;
  V: TJSONValue;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
  BEGIN
    V := JItem(AArr, I);
    IF V = NIL THEN
      Result[I] := 0
    ELSE
      Result[I] := VInt64(V);
  END;
END;

FUNCTION JArrToDoubles(AArr: TJSONArray): TCockpitDoubles;
VAR
  I: Integer;
  V: TJSONValue;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
  BEGIN
    V := JItem(AArr, I);
    IF V = NIL THEN
      Result[I] := 0
    ELSE
      Result[I] := VFloat(V);
  END;
END;

FUNCTION JArrToBooleans(AArr: TJSONArray): TCockpitBooleans;
VAR
  I: Integer;
  V: TJSONValue;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
  BEGIN
    V := JItem(AArr, I);
    Result[I] := (V <> NIL) AND VBool(V);
  END;
END;

FUNCTION JArrToDates(AArr: TJSONArray): TCockpitDates;
VAR
  I: Integer;
  V: TJSONValue;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
  BEGIN
    V := JItem(AArr, I);
    IF V = NIL THEN
      Result[I] := 0
    ELSE
      Result[I] := IsoToDateTime(VStr(V));
  END;
END;

{ Building }

FUNCTION JNewObj: TJSONObject;
BEGIN
  Result := TJSONObject.Create;
END;

FUNCTION JNewArr: TJSONArray;
BEGIN
  Result := TJSONArray.Create;
END;

FUNCTION NewStr(CONST AValue: STRING): TJSONValue;
BEGIN
  Result := TJSONString.Create(AValue);
END;

FUNCTION NewInt(AValue: Int64): TJSONValue;
BEGIN
  {$IFDEF FPC}
  Result := TJSONInt64Number.Create(AValue);
  {$ELSE}
  Result := TJSONNumber.Create(AValue);
  {$ENDIF}
END;

FUNCTION NewFloat(AValue: Double): TJSONValue;
BEGIN
  {$IFDEF FPC}
  Result := TJSONFloatNumber.Create(AValue);
  {$ELSE}
  Result := TJSONNumber.Create(AValue);
  {$ENDIF}
END;

FUNCTION NewBool(AValue: Boolean): TJSONValue;
BEGIN
  {$IFDEF FPC}
  Result := TJSONBoolean.Create(AValue);
  {$ELSE}
  IF AValue THEN
    Result := TJSONTrue.Create
  ELSE
    Result := TJSONFalse.Create;
  {$ENDIF}
END;

FUNCTION NewNull: TJSONValue;
BEGIN
  Result := TJSONNull.Create;
END;

PROCEDURE JAddValue(AObj: TJSONObject; CONST AName: STRING; AValue: TJSONValue);
// Add (or replace) a member; AObj takes ownership of AValue
BEGIN
  {$IFDEF FPC}
  IF AObj.IndexOfName(AName) >= 0 THEN
    AObj.Delete(AName);
  AObj.Add(AName, AValue);
  {$ELSE}
  AObj.RemovePair(AName).Free;
  AObj.AddPair(AName, AValue);
  {$ENDIF}
END;

PROCEDURE JArrAddValue(AArr: TJSONArray; AValue: TJSONValue);
BEGIN
  {$IFDEF FPC}
  AArr.Add(AValue);
  {$ELSE}
  AArr.AddElement(AValue);
  {$ENDIF}
END;

PROCEDURE JAddStr(AObj: TJSONObject; CONST AName, AValue: STRING);
BEGIN
  JAddValue(AObj, AName, NewStr(AValue));
END;

PROCEDURE JAddInt(AObj: TJSONObject; CONST AName: STRING; AValue: Int64);
BEGIN
  JAddValue(AObj, AName, NewInt(AValue));
END;

PROCEDURE JAddFloat(AObj: TJSONObject; CONST AName: STRING; AValue: Double);
BEGIN
  JAddValue(AObj, AName, NewFloat(AValue));
END;

PROCEDURE JAddBool(AObj: TJSONObject; CONST AName: STRING; AValue: Boolean);
BEGIN
  JAddValue(AObj, AName, NewBool(AValue));
END;

PROCEDURE JAddDate(AObj: TJSONObject; CONST AName: STRING; AValue: TDateTime);
// 0 -> null
BEGIN
  IF AValue = 0 THEN
    JAddValue(AObj, AName, NewNull)
  ELSE
    JAddValue(AObj, AName, NewStr(DateTimeToIso(AValue)));
END;

PROCEDURE JAddDateOnly(AObj: TJSONObject; CONST AName: STRING; AValue: TDateTime);
BEGIN
  IF AValue = 0 THEN
    JAddValue(AObj, AName, NewNull)
  ELSE
    JAddValue(AObj, AName, NewStr(DateToIsoDate(AValue)));
END;

PROCEDURE JAddRaw(AObj: TJSONObject; CONST AName, AJson: STRING);
// Raw JSON text ('' -> null)
VAR
  V: TJSONValue;
BEGIN
  V := JParse(AJson);
  IF V = NIL THEN
    V := NewNull;
  JAddValue(AObj, AName, V);
END;

PROCEDURE JAddNull(AObj: TJSONObject; CONST AName: STRING);
BEGIN
  JAddValue(AObj, AName, NewNull);
END;

PROCEDURE JSetInt(AObj: TJSONObject; CONST AName: STRING; AValue: Int64);
BEGIN
  JAddValue(AObj, AName, NewInt(AValue));
END;

FUNCTION StrsToJArr(CONST AValues: TCockpitStrings): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AValues) DO
    JArrAddValue(Result, NewStr(AValues[I]));
END;

FUNCTION IntegersToJArr(CONST AValues: TCockpitIntegers): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AValues) DO
    JArrAddValue(Result, NewInt(AValues[I]));
END;

FUNCTION Int64sToJArr(CONST AValues: TCockpitInt64s): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AValues) DO
    JArrAddValue(Result, NewInt(AValues[I]));
END;

FUNCTION DoublesToJArr(CONST AValues: TCockpitDoubles): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AValues) DO
    JArrAddValue(Result, NewFloat(AValues[I]));
END;

FUNCTION BooleansToJArr(CONST AValues: TCockpitBooleans): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AValues) DO
    JArrAddValue(Result, NewBool(AValues[I]));
END;

FUNCTION DatesToJArr(CONST AValues: TCockpitDates): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AValues) DO
    JArrAddValue(Result, NewStr(DateTimeToIso(AValues[I])));
END;

PROCEDURE JMoveItems(ASource, ADest: TJSONArray);
// Move all items of ASource to ADest (ownership transferred)
BEGIN
  WHILE ASource.Count > 0 DO
    {$IFDEF FPC}
    ADest.Add(ASource.Extract(0));
    {$ELSE}
    ADest.AddElement(ASource.Remove(0));
    {$ENDIF}
END;

PROCEDURE JTruncate(AArr: TJSONArray; ACount: Integer);
BEGIN
  WHILE AArr.Count > ACount DO
    {$IFDEF FPC}
    AArr.Delete(AArr.Count - 1);
    {$ELSE}
    AArr.Remove(AArr.Count - 1).Free;
    {$ENDIF}
END;

{ TCockpitItsmBase }

CONSTRUCTOR TCockpitItsmBase.Create;
BEGIN
  INHERITED Create;
  FSaaS := True;
  FPageSize := DEFAULT_PAGE_SIZE;
  FTimeout := DEFAULT_TIMEOUT;
END;

CONSTRUCTOR TCockpitItsmBase.Create(ASaaS: Boolean; CONST ATenant, AClientId, AClientSecret: STRING);
BEGIN
  Create;
  FSaaS := ASaaS;
  FTenant := ATenant;
  FClientId := AClientId;
  FClientSecret := AClientSecret;
END;

PROCEDURE TCockpitItsmBase.SetSaaS(AValue: Boolean);
BEGIN
  IF FSaaS <> AValue THEN
    ClearToken;
  FSaaS := AValue;
END;

PROCEDURE TCockpitItsmBase.SetTenant(CONST AValue: STRING);
BEGIN
  IF FTenant <> AValue THEN
    ClearToken;
  FTenant := AValue;
END;

PROCEDURE TCockpitItsmBase.SetClientId(CONST AValue: STRING);
BEGIN
  IF FClientId <> AValue THEN
    ClearToken;
  FClientId := AValue;
END;

PROCEDURE TCockpitItsmBase.SetClientSecret(CONST AValue: STRING);
BEGIN
  IF FClientSecret <> AValue THEN
    ClearToken;
  FClientSecret := AValue;
END;

FUNCTION TCockpitItsmBase.BaseUrl: STRING;
// SaaS: https://{tenant}.cockpit-itsm.com - on premise: https://{tenant}
// (an on-premise tenant given with its scheme, e.g. http://host:8080, is used as is)
BEGIN
  Result := Trim(FTenant);
  WHILE (Result <> '') AND (Result[Length(Result)] = '/') DO
    Delete(Result, Length(Result), 1);
  IF FSaaS THEN
    Result := 'https://' + Result + '.cockpit-itsm.com'
  ELSE IF Pos('://', Result) = 0 THEN
    Result := 'https://' + Result;
END;

FUNCTION TCockpitItsmBase.TokenValid: Boolean;
BEGIN
  Result := (FAccessToken <> '') AND (Now < FTokenExpiry);
END;

PROCEDURE TCockpitItsmBase.ClearToken;
BEGIN
  FAccessToken := '';
  FTokenExpiry := 0;
END;

FUNCTION TCockpitItsmBase.HttpSend(CONST AMethod, AUrl, AContentType, ABody: STRING; AAuth: Boolean; OUT AStatus: Integer): STRING;
// Single HTTP request; returns the response body (UTF-8 decoded) whatever the status
{$IF DEFINED(FPC) AND DEFINED(MSWINDOWS)}
VAR
  Session, Connect, Request: HINTERNET;
  Scheme, Host, PathQuery, Headers: STRING;
  Port, P, I: Integer;
  Status, Len, Avail, ReadCount: DWORD;
  Dst: TMemoryStream;
  Buf: ARRAY[0..16383] OF Byte;

  PROCEDURE Fail(CONST AStep: STRING);
  // Raise with the WinHTTP error code (12002 timeout, 12007 name not resolved,
  // 12029 cannot connect, 12175 TLS failure...)
  VAR
    Code: DWORD;
  BEGIN
    Code := GetLastError;
    RAISE ECockpitItsmError.Create(0, Format(SWinHttpError, [AStep, Code]), '');
  END;

BEGIN
  // URL split: scheme://host[:port]/path?query
  P := Pos('://', AUrl);
  Scheme := LowerCase(Copy(AUrl, 1, P - 1));
  Host := Copy(AUrl, P + 3, MaxInt);
  I := Pos('/', Host);
  IF I > 0 THEN
  BEGIN
    PathQuery := Copy(Host, I, MaxInt);
    Host := Copy(Host, 1, I - 1);
  END
  ELSE
    PathQuery := '/';
  IF Scheme = 'http' THEN
    Port := 80
  ELSE
    Port := 443;
  I := Pos(':', Host);
  IF I > 0 THEN
  BEGIN
    Port := StrToIntDef(Copy(Host, I + 1, MaxInt), Port);
    Host := Copy(Host, 1, I - 1);
  END;
  Headers := 'Accept: application/json'#13#10;
  IF (ABody <> '') OR (AMethod = 'POST') OR (AMethod = 'PUT') OR (AMethod = 'PATCH') THEN
    Headers := Headers + 'Content-Type: ' + AContentType + #13#10;
  IF AAuth THEN
    Headers := Headers + 'Authorization: Bearer ' + FAccessToken + #13#10;

  Session := WinHttpOpen('CIPAT4P', WINHTTP_ACCESS_TYPE_AUTOMATIC_PROXY, NIL, NIL, 0);
  IF Session = NIL THEN
    Session := WinHttpOpen('CIPAT4P', WINHTTP_ACCESS_TYPE_DEFAULT_PROXY, NIL, NIL, 0);
  IF Session = NIL THEN
    Fail('WinHttpOpen');
  Connect := NIL;
  Request := NIL;
  Dst := TMemoryStream.Create;
  TRY
    WinHttpSetTimeouts(Session, FTimeout, FTimeout, FTimeout, FTimeout);
    Connect := WinHttpConnect(Session, PWideChar(UTF8Decode(Host)), Port, 0);
    IF Connect = NIL THEN
      Fail('connecting to ' + Host);
    IF Scheme = 'https' THEN
      Request := WinHttpOpenRequest(Connect, PWideChar(UnicodeString(AMethod)), PWideChar(UTF8Decode(PathQuery)),
        NIL, NIL, NIL, WINHTTP_FLAG_SECURE)
    ELSE
      Request := WinHttpOpenRequest(Connect, PWideChar(UnicodeString(AMethod)), PWideChar(UTF8Decode(PathQuery)),
        NIL, NIL, NIL, 0);
    IF Request = NIL THEN
      Fail('request');
    // Body: UTF-8 bytes sent as is
    IF NOT WinHttpSendRequest(Request, PWideChar(UTF8Decode(Headers)), DWORD(-1), Pointer(ABody),
      Length(ABody), Length(ABody), 0) THEN
      Fail('sending to ' + Host);
    IF NOT WinHttpReceiveResponse(Request, NIL) THEN
      Fail('response from ' + Host);
    Status := 0;
    Len := SizeOf(Status);
    IF NOT WinHttpQueryHeaders(Request, WINHTTP_QUERY_STATUS_CODE OR WINHTTP_QUERY_FLAG_NUMBER, NIL, @Status, Len, NIL) THEN
      Fail('HTTP status');
    AStatus := Integer(Status);
    REPEAT
      Avail := 0;
      IF NOT WinHttpQueryDataAvailable(Request, Avail) THEN
        Fail('read');
      WHILE Avail > 0 DO
      BEGIN
        ReadCount := 0;
        IF Avail > SizeOf(Buf) THEN
          Len := SizeOf(Buf)
        ELSE
          Len := Avail;
        IF NOT WinHttpReadData(Request, @Buf[0], Len, ReadCount) THEN
          Fail('read');
        IF ReadCount = 0 THEN
          Break;
        Dst.WriteBuffer(Buf[0], ReadCount);
        Dec(Avail, ReadCount);
      END;
      // Loop until WinHttpQueryDataAvailable reports the end of the response
      IF NOT WinHttpQueryDataAvailable(Request, Avail) THEN
        Fail('read');
    UNTIL Avail = 0;
    SetString(Result, PAnsiChar(Dst.Memory), Dst.Size);
  FINALLY
    Dst.Free;
    IF Request <> NIL THEN
      WinHttpCloseHandle(Request);
    IF Connect <> NIL THEN
      WinHttpCloseHandle(Connect);
    WinHttpCloseHandle(Session);
  END;
END;
{$ELSEIF DEFINED(FPC)}
VAR
  Client: TFPHTTPClient;
  Src, Dst: TMemoryStream;
BEGIN
  Client := TFPHTTPClient.Create(NIL);
  Src := NIL;
  Dst := TMemoryStream.Create;
  TRY
    Client.ConnectTimeout := FTimeout;
    Client.IOTimeout := FTimeout;
    Client.AllowRedirect := True;
    Client.AddHeader('Accept', 'application/json');
    IF AAuth THEN
      Client.AddHeader('Authorization', 'Bearer ' + FAccessToken);
    IF (ABody <> '') OR (AMethod = 'POST') OR (AMethod = 'PUT') OR (AMethod = 'PATCH') THEN
    BEGIN
      // UTF-8 bytes sent as is (no code page conversion)
      Src := TMemoryStream.Create;
      IF Length(ABody) > 0 THEN
        Src.WriteBuffer(Pointer(ABody)^, Length(ABody));
      Src.Position := 0;
      Client.RequestBody := Src;
      Client.AddHeader('Content-Type', AContentType);
    END;
    Client.HTTPMethod(AMethod, AUrl, Dst, []);
    AStatus := Client.ResponseStatusCode;
    SetString(Result, PAnsiChar(Dst.Memory), Dst.Size);
  FINALLY
    Client.RequestBody := NIL;
    Src.Free;
    Dst.Free;
    Client.Free;
  END;
END;
{$ELSE}
VAR
  Client: THTTPClient;
  Resp: IHTTPResponse;
  Src: TStringStream;
  Headers: TNetHeaders;
BEGIN
  Client := THTTPClient.Create;
  Src := TStringStream.Create(ABody, TEncoding.UTF8);
  TRY
    Client.ConnectionTimeout := FTimeout;
    Client.ResponseTimeout := FTimeout;
    Client.Accept := 'application/json';
    Client.ContentType := AContentType;
    IF AAuth THEN
    BEGIN
      SetLength(Headers, 1);
      Headers[0] := TNetHeader.Create('Authorization', 'Bearer ' + FAccessToken);
    END;
    IF AMethod = 'GET' THEN
      Resp := Client.Get(AUrl, NIL, Headers)
    ELSE IF AMethod = 'POST' THEN
      Resp := Client.Post(AUrl, Src, NIL, Headers)
    ELSE IF AMethod = 'PUT' THEN
      Resp := Client.Put(AUrl, Src, NIL, Headers)
    ELSE IF AMethod = 'PATCH' THEN
      Resp := Client.Patch(AUrl, Src, NIL, Headers)
    ELSE IF AMethod = 'DELETE' THEN
      Resp := Client.Delete(AUrl, NIL, Headers)
    ELSE
      RAISE ECockpitItsmError.Create(0, Format(SUnsupportedMethod, [AMethod]), '');
    AStatus := Resp.StatusCode;
    Result := Resp.ContentAsString(TEncoding.UTF8);
  FINALLY
    Src.Free;
    Client.Free;
  END;
END;
{$ENDIF}

PROCEDURE TCockpitItsmBase.RaiseError(AStatus: Integer; CONST AResponse: STRING);
// Raise ECockpitItsmError with the message found in the error body
VAR
  V: TJSONValue;
  Msg: STRING;
BEGIN
  Msg := '';
  V := NIL;
  TRY
    TRY
      V := JParse(AResponse);
    EXCEPT
      V := NIL;
    END;
    IF V IS TJSONObject THEN
    BEGIN
      Msg := JStr(TJSONObject(V), 'errorMessage');
      IF Msg = '' THEN
        Msg := JStr(TJSONObject(V), 'error_description');
      IF Msg = '' THEN
        Msg := JStr(TJSONObject(V), 'error');
    END;
  FINALLY
    V.Free;
  END;
  IF Msg = '' THEN
    Msg := Copy(Trim(AResponse), 1, 300);
  RAISE ECockpitItsmError.Create(AStatus, Format(SHttpError, [AStatus, Msg]), AResponse);
END;

PROCEDURE TCockpitItsmBase.Authenticate;
// OAuth 2.0 client_credentials (multipart/form-data, scope public-api)
VAR
  Boundary, Body, Resp: STRING;
  Status: Integer;
  V: TJSONValue;
  Expires: Int64;

  FUNCTION Part(CONST AName, AValue: STRING): STRING;
  BEGIN
    Result := '--' + Boundary + #13#10 + 'Content-Disposition: form-data; name="' + AName + '"' + #13#10#13#10 + AValue + #13#10;
  END;

BEGIN
  ClearToken;
  IF (FTenant = '') OR (FClientId = '') OR (FClientSecret = '') THEN
    RAISE ECockpitItsmError.Create(0, SMissingCredentials, '');
  Boundary := '----CockpitItsm' + FormatDateTime('yyyymmddhhnnsszzz', Now);
  Body := Part('grant_type', 'client_credentials') + Part('client_id', FClientId) +
    Part('client_secret', FClientSecret) + Part('scope', 'public-api') + '--' + Boundary + '--' + #13#10;
  Resp := HttpSend('POST', BaseUrl + '/oauth2/token', 'multipart/form-data; boundary=' + Boundary, Body, False, Status);
  FLastStatus := Status;
  IF Status <> 200 THEN
    RaiseError(Status, Resp);
  V := JParse(Resp);
  TRY
    FAccessToken := JStr(JAsObj(V), 'access_token');
    Expires := JInt64Def(JAsObj(V), 'expires_in', 3600);
  FINALLY
    V.Free;
  END;
  IF FAccessToken = '' THEN
    RAISE ECockpitItsmError.Create(Status, SNoToken, Resp);
  IF Expires > 2 * TOKEN_MARGIN_SEC THEN
    Expires := Expires - TOKEN_MARGIN_SEC;
  FTokenExpiry := Now + Expires / SecsPerDay;
END;

FUNCTION TCockpitItsmBase.Call(CONST AMethod, APathQuery: STRING; CONST ABody: STRING): STRING;
// Authenticated call; re-authenticates once on 401; raises on non-2xx status
VAR
  Status: Integer;
BEGIN
  IF NOT TokenValid THEN
    Authenticate;
  Result := HttpSend(AMethod, BaseUrl + APathQuery, 'application/json', ABody, True, Status);
  IF Status = 401 THEN
  BEGIN
    Authenticate;
    Result := HttpSend(AMethod, BaseUrl + APathQuery, 'application/json', ABody, True, Status);
  END;
  FLastStatus := Status;
  IF (Status < 200) OR (Status > 299) THEN
    RaiseError(Status, Result);
END;

FUNCTION TCockpitItsmBase.CallJson(CONST AMethod, APathQuery: STRING; CONST ABody: STRING): TJSONValue;
// Caller frees the result (nil for an empty response)
BEGIN
  Result := JParse(Call(AMethod, APathQuery, ABody));
END;

FUNCTION TCockpitItsmBase.FetchAllPages(CONST AMethod, APathQuery: STRING; ABody: TJSONObject; CONST APagePath: STRING): TJSONArray;
// Read every page of a paged list. APagePath = dot-separated members leading from
// ABody to the object holding "page" / "pageSize" ('' = ABody itself, created if
// missing). Pages are 0-based.
// Returns the merged "content" items (caller frees), truncated to totalNumberOfElements.
VAR
  PageObj, Child, RespObj: TJSONObject;
  Resp: TJSONValue;
  Content: TJSONArray;
  Page, TotalPages, P: Integer;
  Total: Int64;
  Rest, Member: STRING;
BEGIN
  PageObj := ABody;
  Rest := APagePath;
  WHILE Rest <> '' DO
  BEGIN
    P := Pos('.', Rest);
    IF P = 0 THEN
      P := Length(Rest) + 1;
    Member := Copy(Rest, 1, P - 1);
    Delete(Rest, 1, P);
    Child := JObj(PageObj, Member);
    IF Child = NIL THEN
    BEGIN
      Child := JNewObj;
      JAddValue(PageObj, Member, Child);
    END;
    PageObj := Child;
  END;
  Result := JNewArr;
  TRY
    Page := 0;
    TotalPages := 1;
    Total := -1;
    REPEAT
      JSetInt(PageObj, 'page', Page);
      JSetInt(PageObj, 'pageSize', FPageSize);
      Resp := CallJson(AMethod, APathQuery, JToString(ABody));
      TRY
        RespObj := JAsObj(Resp);
        IF RespObj = NIL THEN
          RAISE ECockpitItsmError.Create(0, SInvalidPage, JToString(Resp));
        IF Page = 0 THEN
        BEGIN
          TotalPages := Integer(JInt64Def(RespObj, 'totalNumberOfPages', 1));
          Total := JInt64Def(RespObj, 'totalNumberOfElements', -1);
        END;
        Content := JArr(RespObj, 'content');
        IF JCount(Content) = 0 THEN
          Break;
        JMoveItems(Content, Result);
      FINALLY
        Resp.Free;
      END;
      Inc(Page);
    UNTIL Page >= TotalPages;
    IF (Total >= 0) AND (Result.Count > Total) THEN
      JTruncate(Result, Integer(Total));
  EXCEPT
    Result.Free;
    RAISE;
  END;
END;

INITIALIZATION
  {$IFDEF FPC}
  // UTF-8 strings everywhere, as LazUTF8 does in every LCL application
  // (needed for console programs: fpjson returns UTF8String values)
  DefaultSystemCodePage := CP_UTF8;
  {$ENDIF}
  InvFS := FormatSettings;
  InvFS.DecimalSeparator := '.';
  InvFS.ThousandSeparator := #0;
  InvFS.DateSeparator := '-';
  InvFS.TimeSeparator := ':';

END.
