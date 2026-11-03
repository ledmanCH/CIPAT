UNIT uApiGen;

// OpenAPI analysis and Pascal code generation for the Cockpit ITSM public API.
// The generated unit relies on uCockpitItsmCore.pas (Delphi and FPC).

{$mode delphi}{$H+}

INTERFACE

USES
  Classes, SysUtils, StrUtils, Contnrs, fpjson, jsonparser;

TYPE
  TTypeKind = (tkString, tkInteger, tkInt64, tkDouble, tkBoolean, tkDate, tkDateOnly, tkRaw, tkRecord, tkArray);

  TTypeRef = RECORD
    Kind: TTypeKind;
    ElemKind: TTypeKind;
    RecName: STRING;
  END;

  TParamLoc = (plPath, plQuery);

  TParamInfo = RECORD
    Name: STRING;
    PasName: STRING;
    Loc: TParamLoc;
    Required: Boolean;
    TypeRef: TTypeRef;
    Description: STRING;
  END;

  TBodyKind = (bkNone, bkText, bkRaw, bkTyped);
  TRespKind = (rkNone, rkText, rkRaw, rkTyped, rkPaged);

  TEndpoint = CLASS
  PUBLIC
    Method: STRING;
    Path: STRING;
    Tag: STRING;
    Summary: STRING;
    Deprecated: Boolean;
    Supported: Boolean;
    Reason: STRING;
    DefaultName: STRING;
    Params: ARRAY OF TParamInfo;
    BodyKind: TBodyKind;
    BodyType: TTypeRef;
    BodyName: STRING;
    BodySchema: TJSONObject;
    RespSchema: TJSONObject;
    RespCode: Integer;
    Description: STRING;
    RespKind: TRespKind;
    RespType: TTypeRef;
    PagePath: STRING;
    HasCriteria: Boolean;
    FUNCTION Key: STRING;
  END;

  TApiSpec = CLASS
  PRIVATE
    FRoot: TJSONData;
    FSchemas: TJSONObject;
    FCanon: TStringList;
    FEndpoints: TObjectList;
    FVersion: STRING;
    FCsShadow: TStringList;  // C#: member names of the class being generated
    FTitle: STRING;
    FArrSuffix: TStringList;
    FUNCTION GetCount: Integer;
    FUNCTION GetEndpoint(AIndex: Integer): TEndpoint;
    FUNCTION Canonical(CONST AName: STRING): STRING;
    FUNCTION SchemaObj(CONST ACanon: STRING): TJSONObject;
    FUNCTION RefName(AS_: TJSONObject): STRING;
    FUNCTION IsRecordSchema(AS_: TJSONObject): Boolean;
    FUNCTION TypeOf_(AS_: TJSONObject; ADepth: Integer = 0): TTypeRef;
    FUNCTION FindPagePath(CONST ACanon: STRING; ADepth: Integer; OUT APath: STRING): Boolean;
    FUNCTION CriteriaExists(CONST ACanon, APath: STRING): Boolean;
    FUNCTION SampleValue(AS_: TJSONObject; ADepth: Integer; AWritable: Boolean): TJSONData;
    PROCEDURE Analyze(AEp: TEndpoint; AOp: TJSONObject; APathItem: TJSONObject);
    PROCEDURE AssignDefaultNames;
    // generation helpers
    FUNCTION TyName(CONST ACanon: STRING): STRING;
    FUNCTION ArrName(CONST ACanon: STRING): STRING;
    FUNCTION BaseName(CONST ACanon: STRING): STRING;
    FUNCTION PasType(CONST AT: TTypeRef): STRING;
    PROCEDURE CollectTypes(CONST AT: TTypeRef; ASet: TStringList; AWritable: Boolean);
    PROCEDURE SortTypes(CONST ACanon: STRING; ADone, AOrder: TStringList);
    FUNCTION FieldIdent(CONST AProp: STRING; AUsed: TStringList): STRING;
    PROCEDURE GenRecord(CONST ACanon: STRING; AOut: TStrings);
    PROCEDURE GenReader(CONST ACanon: STRING; AOut: TStrings);
    PROCEDURE GenWriter(CONST ACanon: STRING; AOut: TStrings);
    FUNCTION ParamDecl(CONST AP: TParamInfo; AOptional: Boolean): STRING;
    FUNCTION BodyParamDecl(AEp: TEndpoint): STRING;
    FUNCTION RetType(AEp: TEndpoint): STRING;
    FUNCTION Signature(AEp: TEndpoint; CONST AName: STRING; AWithCriteria: Boolean; AQualified: Boolean): STRING;
    FUNCTION CallArgs(AEp: TEndpoint; AWithCriteria: Boolean): STRING;
    PROCEDURE GenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
    // Java generation
    FUNCTION JClassName(CONST ACanon: STRING): STRING;
    FUNCTION JType(CONST AT: TTypeRef; ABoxed: Boolean): STRING;
    FUNCTION JReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
    PROCEDURE JGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
    FUNCTION JSignature(AEp: TEndpoint; CONST AName: STRING; AWithCriteria: Boolean): STRING;
    PROCEDURE JGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
    // Python generation
    FUNCTION PyClassName(CONST ACanon: STRING): STRING;
    FUNCTION PyType(CONST AT: TTypeRef): STRING;
    FUNCTION PyReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
    PROCEDURE PyGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
    FUNCTION PySignature(AEp: TEndpoint; CONST AName: STRING): STRING;
    PROCEDURE PyGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
    // Node.js generation
    FUNCTION JsClassName(CONST ACanon: STRING): STRING;
    FUNCTION JsType(CONST AT: TTypeRef): STRING;
    FUNCTION JsReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
    PROCEDURE JsGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
    PROCEDURE JsGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
    // C# generation
    FUNCTION CsClassName(CONST ACanon: STRING): STRING;
    FUNCTION CsRef(CONST ACanon: STRING): STRING;
    FUNCTION CsType(CONST AT: TTypeRef): STRING;
    FUNCTION CsReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
    PROCEDURE CsGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
    PROCEDURE CsGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
    // VB.NET generation
    FUNCTION VbClassName(CONST ACanon: STRING): STRING;
    FUNCTION VbRef(CONST ACanon: STRING): STRING;
    FUNCTION VbType(CONST AT: TTypeRef): STRING;
    FUNCTION VbReqType(CONST AT: TTypeRef): STRING;
    FUNCTION VbReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
    PROCEDURE VbGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
    PROCEDURE VbGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
    // PowerShell generation
    FUNCTION PsType(CONST AT: TTypeRef): STRING;
    FUNCTION PsTypeName(CONST AT: TTypeRef): STRING;
    PROCEDURE PsGenFunction(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
  PUBLIC
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    PROCEDURE LoadFromFile(CONST AFileName: STRING);
    FUNCTION FindEndpoint(CONST AKey: STRING): TEndpoint;
    FUNCTION Generate(ASelection: TStrings; CONST AUnitName: STRING; ALog: TStrings): STRING;
    FUNCTION GenerateJava(ASelection: TStrings; CONST AClassName: STRING; ALog: TStrings): STRING;
    FUNCTION GeneratePython(ASelection: TStrings; CONST AModuleName: STRING; ALog: TStrings): STRING;
    FUNCTION GenerateNode(ASelection: TStrings; CONST AModuleName: STRING; ALog: TStrings): STRING;
    FUNCTION GenerateCSharp(ASelection: TStrings; CONST AClassName: STRING; ALog: TStrings): STRING;
    FUNCTION GeneratePowerShell(ASelection: TStrings; CONST AModuleName: STRING; ALog: TStrings): STRING;
    FUNCTION GenerateVB(ASelection: TStrings; CONST AClassName: STRING; ALog: TStrings): STRING;
    FUNCTION BodyTemplate(AEp: TEndpoint; APageSize: Integer): STRING;
    FUNCTION ResponseExample(AEp: TEndpoint): STRING;
    PROPERTY Count: Integer READ GetCount;
    PROPERTY Endpoints[AIndex: Integer]: TEndpoint READ GetEndpoint; DEFAULT;
    PROPERTY Version: STRING READ FVersion;
  END;

FUNCTION IsValidIdent(CONST AName: STRING): Boolean;
FUNCTION IsValidJavaIdent(CONST AName: STRING): Boolean;
FUNCTION LowerFirst(CONST S: STRING): STRING;
FUNCTION IsValidPythonIdent(CONST AName: STRING): Boolean;
FUNCTION SnakeCase(CONST S: STRING): STRING;
FUNCTION IsValidJsIdent(CONST AName: STRING): Boolean;
FUNCTION IsValidCsIdent(CONST AName: STRING): Boolean;
FUNCTION IsValidVbIdent(CONST AName: STRING): Boolean;
FUNCTION PowerShellName(CONST ABaseName: STRING): STRING;
FUNCTION PowerShellBase(CONST AFunctionName: STRING): STRING;
FUNCTION PascalCaseOf(CONST S: STRING): STRING;
PROCEDURE ReadSelectionFromUnit(CONST AFileName: STRING; ASelection: TStrings);

CONST
  SELECTION_TAG = '// @endpoint ';
  PY_SELECTION_TAG = '# @endpoint ';
  VB_SELECTION_TAG = ''' @endpoint ';
  // Python runtime core (module written next to the generated module)
  PY_CORE_MODULE = 'cockpit_itsm_core';
  // Node.js runtime core (cockpit-itsm-core.mjs, written next to the generated module)
  JS_CORE_MODULE = 'cockpit-itsm-core';
  // C# runtime core (CockpitItsmCore.cs, written next to the generated class)
  CS_CORE_FILE = 'CockpitItsmCore';
  // PowerShell runtime core (CockpitItsmCore.ps1, dot-sourced by the generated module)
  PS_CORE_FILE = 'CockpitItsmCore';
  // VB.NET runtime core (CockpitItsmCore.vb, written next to the generated class)
  VB_CORE_FILE = 'CockpitItsmCore';

IMPLEMENTATION

CONST
  HTTP_METHODS: ARRAY[0..4] OF STRING = ('get', 'post', 'put', 'patch', 'delete');
  RESERVED: ARRAY[0..74] OF STRING = (
    'and', 'array', 'as', 'asm', 'begin', 'case', 'class', 'const', 'constructor',
    'destructor', 'dispinterface', 'div', 'do', 'downto', 'else', 'end', 'except',
    'exports', 'file', 'finalization', 'finally', 'for', 'function', 'goto', 'if',
    'implementation', 'in', 'inherited', 'initialization', 'inline', 'interface', 'is',
    'label', 'library', 'mod', 'nil', 'not', 'object', 'of', 'or', 'out', 'packed',
    'procedure', 'program', 'property', 'raise', 'record', 'repeat', 'resourcestring',
    'set', 'shl', 'shr', 'string', 'then', 'threadvar', 'to', 'try', 'type', 'unit',
    'until', 'uses', 'var', 'while', 'with', 'xor', 'operator', 'private', 'protected',
    'public', 'published', 'strict', 'automated', 'result', 'self', 'absolute');
  PRIMITIVE_ARRAYS: ARRAY[TTypeKind] OF STRING = ('TCockpitStrings', 'TCockpitIntegers',
    'TCockpitInt64s', 'TCockpitDoubles', 'TCockpitBooleans', 'TCockpitDates', 'TCockpitDates',
    'TCockpitStrings', '', '');
  ARR_READERS: ARRAY[TTypeKind] OF STRING = ('JArrToStrs', 'JArrToIntegers', 'JArrToInt64s',
    'JArrToDoubles', 'JArrToBooleans', 'JArrToDates', 'JArrToDates', 'JArrToStrs', '', '');
  ARR_WRITERS: ARRAY[TTypeKind] OF STRING = ('StrsToJArr', 'IntegersToJArr', 'Int64sToJArr',
    'DoublesToJArr', 'BooleansToJArr', 'DatesToJArr', 'DatesToJArr', 'StrsToJArr', '', '');

{ Text helpers }

FUNCTION UpperFirst(CONST S: STRING): STRING;
BEGIN
  Result := S;
  IF Result <> '' THEN
    Result[1] := UpCase(Result[1]);
END;

FUNCTION IsReserved(CONST S: STRING): Boolean;
VAR
  R: STRING;
BEGIN
  Result := False;
  FOR R IN RESERVED DO
    IF SameText(R, S) THEN
      Exit(True);
END;

FUNCTION Ident(CONST S: STRING): STRING;
// Valid Pascal identifier from any text
VAR
  I: Integer;
BEGIN
  Result := S;
  FOR I := 1 TO Length(Result) DO
    IF NOT (Result[I] IN ['A'..'Z', 'a'..'z', '0'..'9', '_']) THEN
      Result[I] := '_';
  IF (Result = '') OR (Result[1] IN ['0'..'9']) THEN
    Result := '_' + Result;
  IF IsReserved(Result) THEN
    Result := Result + '_';
END;

FUNCTION IsValidIdent(CONST AName: STRING): Boolean;
BEGIN
  Result := (AName <> '') AND (Ident(AName) = AName);
END;

FUNCTION LowerFirst(CONST S: STRING): STRING;
BEGIN
  Result := S;
  IF Result <> '' THEN
    Result[1] := LowerCase(Result[1]);
END;

CONST
  JAVA_RESERVED: ARRAY[0..54] OF STRING = (
    'abstract', 'assert', 'boolean', 'break', 'byte', 'case', 'catch', 'char', 'class',
    'const', 'continue', 'default', 'do', 'double', 'else', 'enum', 'extends', 'final',
    'finally', 'float', 'for', 'goto', 'if', 'implements', 'import', 'instanceof', 'int',
    'interface', 'long', 'native', 'new', 'package', 'private', 'protected', 'public',
    'return', 'short', 'static', 'strictfp', 'super', 'switch', 'synchronized', 'this',
    'throw', 'throws', 'transient', 'try', 'void', 'volatile', 'while', 'true', 'false',
    'null', 'var', 'record');
  // Simple type names used by the generated code: never used for a generated class
  JAVA_TYPE_NAMES: ARRAY[0..38] OF STRING = (
    'String', 'Object', 'Integer', 'Long', 'Double', 'Boolean', 'Number', 'Character',
    'Byte', 'Short', 'Float', 'Void', 'Class', 'Math', 'System', 'Thread', 'Override',
    'Deprecated', 'Exception', 'RuntimeException', 'Error', 'Enum', 'Record',
    'JSONObject', 'JSONArray', 'CockpitItsmCore', 'CockpitItsmException', 'Iterable',
    'StringBuilder', 'List', 'Map', 'Set', 'Collection', 'Iterator', 'Optional', 'Function',
    'Date', 'Instant', 'LocalDate');
  // Methods of CockpitItsmCore (and Object): a generated method must not hide them
  JAVA_CORE_METHODS: ARRAY[0..56] OF STRING = (
    'isSaas', 'setSaas', 'getTenant', 'setTenant', 'getClientId', 'setClientId',
    'getClientSecret', 'setClientSecret', 'getPageSize', 'setPageSize', 'getTimeout',
    'setTimeout', 'getLastStatus', 'getAccessToken', 'getTokenExpiry', 'setHttpClient',
    'baseUrl', 'getBaseUrl', 'isTokenValid', 'clearToken', 'setToken', 'authenticate',
    'call', 'callJson', 'fetchAllPages', 'urlEncode', 'addQuery', 'qDouble',
    'parseDateTime', 'parseDate', 'formatDateTime', 'formatDate', 'parse', 'asObj',
    'asArr', 'unquote', 'toStr', 'toInt', 'toLong', 'toDouble', 'toBool', 'toDateTime',
    'toDate', 'toRaw', 'list', 'array', 'put', 'putRaw', 'fromDateTime', 'fromDate',
    'getClass', 'hashCode', 'equals', 'toString', 'notify', 'notifyAll', 'wait');

FUNCTION InArr(CONST S: STRING; CONST AList: ARRAY OF STRING): Boolean;
VAR
  R: STRING;
BEGIN
  Result := False;
  FOR R IN AList DO
    IF R = S THEN
      Exit(True);
END;

FUNCTION JIdent(CONST S: STRING): STRING;
// Valid Java identifier from any text (reserved words get a trailing "_")
VAR
  I: Integer;
BEGIN
  Result := S;
  FOR I := 1 TO Length(Result) DO
    IF NOT (Result[I] IN ['A'..'Z', 'a'..'z', '0'..'9', '_']) THEN
      Result[I] := '_';
  IF (Result = '') OR (Result[1] IN ['0'..'9']) THEN
    Result := '_' + Result;
  IF InArr(Result, JAVA_RESERVED) OR (Result = '_') THEN
    Result := Result + '_';
END;

FUNCTION IsValidJavaIdent(CONST AName: STRING): Boolean;
BEGIN
  Result := (AName <> '') AND (JIdent(AName) = AName);
END;

FUNCTION JQuote(CONST S: STRING): STRING;
// Java string literal
BEGIN
  Result := '"' + StringReplace(StringReplace(S, '\', '\\', [rfReplaceAll]), '"', '\"', [rfReplaceAll]) + '"';
END;

FUNCTION JDoc(CONST S: STRING): STRING;
// Comment text: no end of comment, no backslash (unicode escapes are read in comments too)
BEGIN
  Result := StringReplace(StringReplace(S, '*/', '* /', [rfReplaceAll]), '\', '/', [rfReplaceAll]);
END;

CONST
  PY_KEYWORDS: ARRAY[0..34] OF STRING = (
    'False', 'None', 'True', 'and', 'as', 'assert', 'async', 'await', 'break', 'class',
    'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global',
    'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise',
    'return', 'try', 'while', 'with', 'yield');
  // Names used by the generated module: never used for a generated class
  PY_TYPE_NAMES: ARRAY[0..10] OF STRING = (
    'Any', 'Dict', 'List', 'Optional', 'Tuple', 'CockpitItsmCore', 'CockpitItsmError',
    'Exception', 'NotImplemented', 'Ellipsis', 'BaseException');
  // Members of the generated dataclasses: a field must not hide them
  PY_CLASS_MEMBERS: ARRAY[0..3] OF STRING = ('from_json', 'list_from_json', 'to_json', 'list_to_json');
  // Members of CockpitItsmCore: a generated method must not hide them
  // Helpers of cockpit_itsm_core and typing names imported when used
  PY_HELPERS: ARRAY[0..16] OF STRING = (
    'add_query', 'array_of', 'from_date', 'from_date_time', 'list_of', 'put', 'put_raw',
    'query_string', 'to_bool', 'to_date', 'to_date_time', 'to_float', 'to_int', 'to_raw',
    'to_str', 'unquote', 'url_encode');
  PY_TYPING: ARRAY[0..4] OF STRING = ('Any', 'Dict', 'List', 'Optional', 'Tuple');
  PY_CORE_METHODS: ARRAY[0..19] OF STRING = (
    'saas', 'tenant', 'client_id', 'client_secret', 'page_size', 'timeout', 'ssl_context',
    'last_status', 'make_base_url', 'base_url', 'access_token', 'token_expiry',
    'is_token_valid', 'clear_token', 'set_token', 'authenticate', 'call', 'call_json',
    'fetch_all_pages', 'mro');

FUNCTION PyIdent(CONST S: STRING): STRING;
// Valid Python identifier from any text (keywords get a trailing "_")
VAR
  I: Integer;
BEGIN
  Result := S;
  FOR I := 1 TO Length(Result) DO
    IF NOT (Result[I] IN ['A'..'Z', 'a'..'z', '0'..'9', '_']) THEN
      Result[I] := '_';
  IF (Result = '') OR (Result[1] IN ['0'..'9']) THEN
    Result := '_' + Result;
  IF InArr(Result, PY_KEYWORDS) OR (Result = '_') THEN
    Result := Result + '_';
END;

FUNCTION IsValidPythonIdent(CONST AName: STRING): Boolean;
BEGIN
  Result := (AName <> '') AND (PyIdent(AName) = AName);
END;

FUNCTION SnakeCase(CONST S: STRING): STRING;
// "ListEndUsers" -> "list_end_users", "APIList" -> "api_list", "end-users" -> "end_users"
VAR
  I: Integer;
  C: Char;
BEGIN
  Result := '';
  FOR I := 1 TO Length(S) DO
  BEGIN
    C := S[I];
    IF NOT (C IN ['A'..'Z', 'a'..'z', '0'..'9']) THEN
    BEGIN
      IF (Result <> '') AND (Result[Length(Result)] <> '_') THEN
        Result := Result + '_';
      Continue;
    END;
    IF C IN ['A'..'Z'] THEN
    BEGIN
      IF (I > 1) AND (Result <> '') AND (Result[Length(Result)] <> '_')
        AND ((S[I - 1] IN ['a'..'z', '0'..'9'])
          OR ((S[I - 1] IN ['A'..'Z']) AND (I < Length(S)) AND (S[I + 1] IN ['a'..'z']))) THEN
        Result := Result + '_';
      Result := Result + LowerCase(C);
    END
    ELSE
      Result := Result + C;
  END;
  WHILE (Result <> '') AND (Result[Length(Result)] = '_') DO
    Delete(Result, Length(Result), 1);
END;

FUNCTION PyDoc(CONST S: STRING): STRING;
// Docstring / comment text: no double quote, no backslash
BEGIN
  Result := StringReplace(StringReplace(S, '\', '/', [rfReplaceAll]), '"', '''', [rfReplaceAll]);
END;

CONST
  JS_RESERVED: ARRAY[0..45] OF STRING = (
    'await', 'break', 'case', 'catch', 'class', 'const', 'continue', 'debugger', 'default',
    'delete', 'do', 'else', 'enum', 'export', 'extends', 'false', 'finally', 'for',
    'function', 'if', 'implements', 'import', 'in', 'instanceof', 'interface', 'let', 'new',
    'null', 'package', 'private', 'protected', 'public', 'return', 'static', 'super',
    'switch', 'this', 'throw', 'true', 'try', 'typeof', 'var', 'void', 'while', 'with',
    'yield');
  // Global objects and names of the core: never used for a generated type
  JS_TYPE_NAMES: ARRAY[0..22] OF STRING = (
    'Object', 'Array', 'String', 'Number', 'Boolean', 'Date', 'Error', 'Map', 'Set',
    'Promise', 'JSON', 'Math', 'Symbol', 'RegExp', 'Function', 'BigInt', 'URL', 'FormData',
    'Record', 'Infinity', 'NaN', 'CockpitItsmCore', 'CockpitItsmError');
  // Members of CockpitItsmCore: a generated method must not hide them
  JS_CORE_METHODS: ARRAY[0..19] OF STRING = (
    'constructor', 'saas', 'tenant', 'clientId', 'clientSecret', 'pageSize', 'timeout',
    'lastStatus', 'setFetch', 'makeBaseUrl', 'baseUrl', 'accessToken', 'tokenExpiry',
    'isTokenValid', 'clearToken', 'setToken', 'authenticate', 'call', 'callJson',
    'fetchAllPages');
  // Helpers of cockpit-itsm-core.mjs imported when used
  JS_HELPERS: ARRAY[0..15] OF STRING = (
    'urlEncode', 'addQuery', 'queryString', 'asObj', 'listOf', 'arrayOf', 'put', 'putRaw',
    'toStr', 'toNum', 'toBool', 'toDateTime', 'toDate', 'toRaw', 'unquote', 'fromDateTime');

FUNCTION JsIdent(CONST S: STRING): STRING;
// Valid JavaScript identifier from any text (reserved words get a trailing "_")
VAR
  I: Integer;
BEGIN
  Result := S;
  FOR I := 1 TO Length(Result) DO
    IF NOT (Result[I] IN ['A'..'Z', 'a'..'z', '0'..'9', '_', '$']) THEN
      Result[I] := '_';
  IF (Result = '') OR (Result[1] IN ['0'..'9']) THEN
    Result := '_' + Result;
  IF InArr(Result, JS_RESERVED) OR (Result = 'undefined') OR (Result = 'arguments') OR (Result = 'eval') THEN
    Result := Result + '_';
END;

FUNCTION IsValidJsIdent(CONST AName: STRING): Boolean;
BEGIN
  Result := (AName <> '') AND (JsIdent(AName) = AName);
END;

CONST
  CS_RESERVED: ARRAY[0..77] OF STRING = (
    'abstract', 'as', 'base', 'bool', 'break', 'byte', 'case', 'catch', 'char', 'checked',
    'class', 'const', 'continue', 'decimal', 'default', 'delegate', 'do', 'double', 'else',
    'enum', 'event', 'explicit', 'extern', 'false', 'finally', 'fixed', 'float', 'for',
    'foreach', 'goto', 'if', 'implicit', 'in', 'int', 'interface', 'internal', 'is', 'lock',
    'long', 'namespace', 'new', 'null', 'object', 'operator', 'out', 'override', 'params',
    'private', 'protected', 'public', 'readonly', 'ref', 'return', 'sbyte', 'sealed', 'short',
    'sizeof', 'stackalloc', 'static', 'string', 'struct', 'switch', 'this', 'throw', 'true',
    'try', 'typeof', 'uint', 'ulong', 'unchecked', 'unsafe', 'ushort', 'using', 'virtual',
    'void', 'volatile', 'while', 'var');
  // Types used by the generated code: never used for a generated class
  CS_TYPE_NAMES: ARRAY[0..34] OF STRING = (
    'String', 'Object', 'Exception', 'List', 'IEnumerable', 'Dictionary', 'KeyValuePair',
    'Task', 'JsonNode', 'JsonObject', 'JsonArray', 'JsonValue', 'DateTimeOffset', 'DateOnly',
    'DateTime', 'TimeSpan', 'Math', 'Convert', 'Uri', 'HttpClient', 'CancellationToken',
    'Func', 'Action', 'Type', 'Attribute', 'Console', 'Environment', 'Guid', 'Version', 'Enum',
    'Array', 'Nullable', 'Obsolete', 'CockpitItsmCore', 'CockpitItsmException');
  // Members of the generated classes (and of object): a property must not hide them
  CS_CLASS_MEMBERS: ARRAY[0..7] OF STRING = (
    'FromJson', 'ListFromJson', 'ToJson', 'ListToJson', 'Equals', 'GetHashCode', 'GetType',
    'ToString');
  // Members of CockpitItsmCore (properties, methods)
  CS_CORE_MEMBERS: ARRAY[0..23] OF STRING = (
    'SaaS', 'Tenant', 'ClientId', 'ClientSecret', 'PageSize', 'LastStatus', 'BaseUrl',
    'AccessToken', 'TokenExpiry', 'IsTokenValid', 'ClearToken', 'SetToken', 'MakeBaseUrl',
    'Dispose', 'UrlEncode', 'AddQuery', 'QueryString', 'Parse', 'Unquote', 'ListOf',
    'ListOfValues', 'ArrayOf', 'Put', 'PutRaw');
  // Methods of CockpitItsmCore: a generated method must not hide them
  CS_CORE_METHODS: ARRAY[0..3] OF STRING = (
    'AuthenticateAsync', 'CallAsync', 'CallJsonAsync', 'FetchAllPagesAsync');

  // Approved verbs of PowerShell (Get-Verb) kept as the verb of a function name
  PS_VERBS: ARRAY[0..99] OF STRING = (
    'Add', 'Approve', 'Assert', 'Backup', 'Block', 'Build', 'Checkpoint', 'Clear', 'Close',
    'Compare', 'Complete', 'Compress', 'Confirm', 'Connect', 'Convert', 'ConvertFrom',
    'ConvertTo', 'Copy', 'Debug', 'Deny', 'Deploy', 'Disable', 'Disconnect', 'Dismount', 'Edit',
    'Enable', 'Enter', 'Exit', 'Expand', 'Export', 'Find', 'Format', 'Get', 'Grant', 'Group',
    'Hide', 'Import', 'Initialize', 'Install', 'Invoke', 'Join', 'Limit', 'Lock', 'Measure',
    'Merge', 'Mount', 'Move', 'New', 'Open', 'Optimize', 'Out', 'Ping', 'Pop', 'Protect',
    'Publish', 'Push', 'Read', 'Receive', 'Redo', 'Register', 'Remove', 'Rename', 'Repair',
    'Request', 'Reset', 'Resize', 'Resolve', 'Restart', 'Restore', 'Resume', 'Revoke', 'Save',
    'Search', 'Select', 'Send', 'Set', 'Show', 'Skip', 'Split', 'Start', 'Step', 'Stop',
    'Submit', 'Suspend', 'Switch', 'Sync', 'Test', 'Trace', 'Unblock', 'Undo', 'Uninstall',
    'Unlock', 'Unprotect', 'Unpublish', 'Unregister', 'Update', 'Use', 'Wait', 'Watch', 'Write');
  // Automatic variables, common parameters and variables of the generated functions
  PS_RESERVED: ARRAY[0..48] OF STRING = (
    'Args', 'Input', 'Error', 'Host', 'Home', 'Matches', 'PID', 'PWD', 'Profile', 'ShellId',
    'StackTrace', 'This', 'True', 'False', 'Null', 'Event', 'EventArgs', 'EventSubscriber',
    'Sender', 'ForEach', 'PSItem', 'OFS', 'MyInvocation', 'PSBoundParameters', 'PSCmdlet',
    'ExecutionContext', 'LastExitCode', 'Verbose', 'Debug', 'ErrorAction', 'WarningAction',
    'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable',
    'OutVariable', 'OutBuffer', 'PipelineVariable', 'ProgressAction', 'WhatIf', 'Confirm',
    'IsWindows', 'IsLinux', 'IsMacOS', 'CpQuery', 'CpPath', 'CpResult', 'CpText', 'Switch');
  // Functions of CockpitItsmCore.ps1: a generated function must not hide them
  PS_CORE_FUNCTIONS: ARRAY[0..20] OF STRING = (
    'Connect-CockpitItsm', 'Disconnect-CockpitItsm', 'Get-CockpitItsmConnection',
    'Invoke-CockpitItsmRequest', 'Get-CockpitItsmAllPages', 'Get-CockpitItsmState',
    'New-CockpitItsmError', 'Update-CockpitItsmToken', 'ConvertTo-CockpitItsmUrl',
    'ConvertTo-CockpitItsmText', 'Add-CockpitItsmQuery', 'Get-CockpitItsmQueryString',
    'ConvertTo-CockpitItsmPlain', 'ConvertTo-CockpitItsmJson', 'ConvertFrom-CockpitItsmDates',
    'ConvertFrom-CockpitItsmJson', 'ConvertFrom-CockpitItsmQuoted', 'Add-CockpitItsmTypeName',
    'Send-CockpitItsmHttp', 'Set-StrictMode', 'Add-Type');

FUNCTION CsIdent(CONST S: STRING): STRING;
// Valid C# identifier from any text (keywords get a trailing "_")
VAR
  I: Integer;
BEGIN
  Result := S;
  FOR I := 1 TO Length(Result) DO
    IF NOT (Result[I] IN ['A'..'Z', 'a'..'z', '0'..'9', '_']) THEN
      Result[I] := '_';
  IF (Result = '') OR (Result[1] IN ['0'..'9']) THEN
    Result := '_' + Result;
  IF InArr(Result, CS_RESERVED) OR (Result = '_') THEN
    Result := Result + '_';
END;

FUNCTION IsValidCsIdent(CONST AName: STRING): Boolean;
BEGIN
  Result := (AName <> '') AND (CsIdent(AName) = AName);
END;

FUNCTION InArrCI(CONST S: STRING; CONST AList: ARRAY OF STRING): Boolean;
// InArr, case insensitive (VB.NET)
VAR
  R: STRING;
BEGIN
  Result := False;
  FOR R IN AList DO
    IF SameText(R, S) THEN
      Exit(True);
END;

CONST
  VB_RESERVED: ARRAY[0..157] OF STRING = (
    'AddHandler', 'AddressOf', 'Alias', 'And', 'AndAlso', 'As', 'Boolean', 'ByRef', 'Byte',
    'ByVal', 'Call', 'Case', 'Catch', 'CBool', 'CByte', 'CChar', 'CDate', 'CDbl', 'CDec', 'Char',
    'CInt', 'Class', 'CLng', 'CObj', 'Const', 'Continue', 'CSByte', 'CShort', 'CSng', 'CStr',
    'CType', 'CUInt', 'CULng', 'CUShort', 'Date', 'Decimal', 'Declare', 'Default', 'Delegate',
    'Dim', 'DirectCast', 'Do', 'Double', 'Each', 'Else', 'ElseIf', 'End', 'EndIf', 'Enum',
    'Erase', 'Error', 'Event', 'Exit', 'False', 'Finally', 'For', 'Friend', 'Function', 'Get',
    'GetType', 'GetXMLNamespace', 'Global', 'GoSub', 'GoTo', 'Handles', 'If', 'Implements',
    'Imports', 'In', 'Inherits', 'Integer', 'Interface', 'Is', 'IsNot', 'Let', 'Lib', 'Like',
    'Long', 'Loop', 'Me', 'Mod', 'Module', 'MustInherit', 'MustOverride', 'MyBase', 'MyClass',
    'NameOf', 'Namespace', 'Narrowing', 'New', 'Next', 'Not', 'Nothing', 'NotInheritable',
    'NotOverridable', 'Object', 'Of', 'On', 'Operator', 'Option', 'Optional', 'Or', 'OrElse',
    'Out', 'Overloads', 'Overridable', 'Overrides', 'ParamArray', 'Partial', 'Private',
    'Property', 'Protected', 'Public', 'RaiseEvent', 'ReadOnly', 'ReDim', 'REM',
    'RemoveHandler', 'Resume', 'Return', 'SByte', 'Select', 'Set', 'Shadows', 'Shared', 'Short',
    'Single', 'Static', 'Step', 'Stop', 'String', 'Structure', 'Sub', 'SyncLock', 'Then',
    'Throw', 'To', 'True', 'Try', 'TryCast', 'TypeOf', 'UInteger', 'ULong', 'UShort', 'Using',
    'Variant', 'Wend', 'When', 'While', 'Widening', 'With', 'WithEvents', 'WriteOnly', 'Xor',
    'Await', 'Async', 'Yield', 'Iterator');
  // Types and namespaces used by the generated code: never used for a generated class
  VB_TYPE_NAMES: ARRAY[0..41] OF STRING = (
    'String', 'Object', 'Exception', 'List', 'IEnumerable', 'Dictionary', 'KeyValuePair',
    'Task', 'JsonNode', 'JsonObject', 'JsonArray', 'JsonValue', 'DateTimeOffset', 'DateOnly',
    'DateTime', 'TimeSpan', 'Math', 'Convert', 'Uri', 'HttpClient', 'CancellationToken',
    'Func', 'Action', 'Type', 'Attribute', 'Console', 'Environment', 'Guid', 'Version', 'Enum',
    'Array', 'Nullable', 'Obsolete', 'CockpitItsmCore', 'CockpitItsmException', 'CockpitItsm',
    'System', 'Microsoft', 'Collection', 'Strings', 'Conversion', 'Interaction');
  // Shared helpers of CockpitItsmCore used by the generated code
  VB_CORE_HELPERS: ARRAY[0..19] OF STRING = (
    'ToStr', 'ToDouble', 'ToLong', 'ToInt', 'ToBool', 'ToDateTime', 'ToDate', 'ToRaw',
    'FromValue', 'AsObj', 'AsArr', 'ParseDateTime', 'ParseDate', 'FormatDateTime', 'FormatDate',
    'CallAsync', 'CallJsonAsync', 'FetchAllPagesAsync', 'AuthenticateAsync', 'Content');

FUNCTION VbIdent(CONST S: STRING): STRING;
// Valid VB.NET identifier from any text (keywords, case insensitive, get a trailing "_")
VAR
  I: Integer;
BEGIN
  Result := S;
  FOR I := 1 TO Length(Result) DO
    IF NOT (Result[I] IN ['A'..'Z', 'a'..'z', '0'..'9', '_']) THEN
      Result[I] := '_';
  IF (Result = '') OR (Result[1] IN ['0'..'9']) THEN
    Result := '_' + Result;
  IF InArrCI(Result, VB_RESERVED) OR (Result = '_') THEN
    Result := Result + '_';
END;

FUNCTION IsValidVbIdent(CONST AName: STRING): Boolean;
BEGIN
  Result := (AName <> '') AND (VbIdent(AName) = AName);
END;

FUNCTION PowerShellName(CONST ABaseName: STRING): STRING;
// Base (PascalCase) name -> Verb-CockpitNoun: Get -> Get, List -> Find, Post -> Invoke,
// Put -> Set, Delete -> Remove, Patch -> Update, approved verb kept, otherwise Invoke
// (ListEndUsers -> Find-CockpitEndUsers, GetEndUsers -> Get-CockpitEndUsers)
VAR
  I: Integer;
  Verb, Rest, V: STRING;
BEGIN
  Result := '';
  IF NOT IsValidIdent(ABaseName) THEN
    Exit;
  I := 2;
  WHILE (I <= Length(ABaseName)) AND NOT (ABaseName[I] IN ['A'..'Z', '_']) DO
    Inc(I);
  Verb := Copy(ABaseName, 1, I - 1);
  Rest := Copy(ABaseName, I, MaxInt);
  V := '';
  IF Verb = 'List' THEN
    V := 'Find'
  ELSE IF Verb = 'Post' THEN
    V := 'Invoke'
  ELSE IF Verb = 'Put' THEN
    V := 'Set'
  ELSE IF Verb = 'Delete' THEN
    V := 'Remove'
  ELSE IF Verb = 'Patch' THEN
    V := 'Update'
  ELSE IF InArr(Verb, PS_VERBS) THEN
    V := Verb;
  IF V = '' THEN
  BEGIN
    V := 'Invoke';
    Rest := ABaseName;
  END;
  Result := V + '-Cockpit' + UpperFirst(Rest);
END;

FUNCTION PowerShellBase(CONST AFunctionName: STRING): STRING;
// Verb-CockpitNoun (or Verb-Noun) -> base name VerbNoun ('' if not Verb-Noun)
VAR
  P: Integer;
  Verb, Noun: STRING;
BEGIN
  Result := '';
  P := Pos('-', AFunctionName);
  IF P < 2 THEN
    Exit;
  Verb := UpperFirst(Copy(AFunctionName, 1, P - 1));
  Noun := Copy(AFunctionName, P + 1, MaxInt);
  IF Copy(Noun, 1, 7) = 'Cockpit' THEN
    Delete(Noun, 1, 7);
  Result := Verb + UpperFirst(Noun);
  IF NOT IsValidIdent(Result) THEN
    Result := '';
END;

FUNCTION PascalWords(CONST S: STRING): STRING;
// "end-users" -> "EndUsers", "objects.xlsx" -> "ObjectsXlsx"
VAR
  I: Integer;
  Up: Boolean;
BEGIN
  Result := '';
  Up := True;
  FOR I := 1 TO Length(S) DO
  BEGIN
    IF S[I] IN ['A'..'Z', 'a'..'z', '0'..'9'] THEN
    BEGIN
      IF Up THEN
        Result := Result + UpCase(S[I])
      ELSE
        Result := Result + S[I];
      Up := False;
    END
    ELSE
      Up := True;
  END;
END;

FUNCTION CleanDoc(CONST S: STRING; AMax: Integer): STRING;
// Single-line ASCII comment text: tags removed, whitespace collapsed, truncated
VAR
  I: Integer;
  InTag: Boolean;
  C: Char;
BEGIN
  Result := '';
  InTag := False;
  FOR I := 1 TO Length(S) DO
  BEGIN
    C := S[I];
    IF C = '<' THEN
    BEGIN
      InTag := True;
      Result := Result + ' ';
    END
    ELSE IF C = '>' THEN
      InTag := False
    ELSE IF NOT InTag THEN
    BEGIN
      IF C IN [#0..#31] THEN
        C := ' ';
      IF Ord(C) > 126 THEN
        Continue;
      IF (C = ' ') AND (Result <> '') AND (Result[Length(Result)] = ' ') THEN
        Continue;
      Result := Result + C;
    END;
  END;
  Result := Trim(Result);
  IF Length(Result) > AMax THEN
    Result := Copy(Result, 1, AMax - 3) + '...';
END;

FUNCTION Quote(CONST S: STRING): STRING;
BEGIN
  Result := '''' + StringReplace(S, '''', '''''', [rfReplaceAll]) + '''';
END;

FUNCTION ObjStr(AObj: TJSONObject; CONST AName: STRING): STRING;
VAR
  D: TJSONData;
BEGIN
  Result := '';
  IF AObj = NIL THEN
    Exit;
  D := AObj.Find(AName);
  IF (D <> NIL) AND (D.JSONType = jtString) THEN
    Result := D.AsString;
END;

FUNCTION ObjObj(AObj: TJSONObject; CONST AName: STRING): TJSONObject;
VAR
  D: TJSONData;
BEGIN
  Result := NIL;
  IF AObj = NIL THEN
    Exit;
  D := AObj.Find(AName);
  IF (D <> NIL) AND (D.JSONType = jtObject) THEN
    Result := TJSONObject(D);
END;

FUNCTION ObjBool(AObj: TJSONObject; CONST AName: STRING): Boolean;
VAR
  D: TJSONData;
BEGIN
  Result := False;
  IF AObj = NIL THEN
    Exit;
  D := AObj.Find(AName);
  Result := (D <> NIL) AND (D.JSONType = jtBoolean) AND D.AsBoolean;
END;

FUNCTION InList(AList: TJSONData; CONST AValue: STRING): Boolean;
VAR
  I: Integer;
BEGIN
  Result := False;
  IF (AList = NIL) OR (AList.JSONType <> jtArray) THEN
    Exit;
  FOR I := 0 TO AList.Count - 1 DO
    IF (AList.Items[I].JSONType = jtString) AND (AList.Items[I].AsString = AValue) THEN
      Exit(True);
END;

FUNCTION IsIdLike(CONST AName: STRING): Boolean;
// Optional ids are omitted when 0 (0 never designates an object)
BEGIN
  Result := (AName = 'id') OR ((Length(AName) > 2) AND AName.EndsWith('Id'));
END;

FUNCTION IsPrimitive(AKind: TTypeKind): Boolean;
BEGIN
  Result := AKind IN [tkString, tkInteger, tkInt64, tkDouble, tkBoolean, tkDate, tkDateOnly];
END;

PROCEDURE ReadSelectionFromUnit(CONST AFileName: STRING; ASelection: TStrings);
// Read "// @endpoint METHOD /path Name" lines of a generated file (Python, PowerShell: "# @endpoint",
// VB.NET: "' @endpoint") (Key=Name)
VAR
  SL: TStringList;
  I: Integer;
  Line: STRING;
  Parts: TStringArray;
BEGIN
  ASelection.Clear;
  SL := TStringList.Create;
  TRY
    SL.LoadFromFile(AFileName);
    FOR I := 0 TO SL.Count - 1 DO
    BEGIN
      Line := Trim(SL[I]);
      IF Line.StartsWith(SELECTION_TAG) THEN
        Line := Copy(Line, Length(SELECTION_TAG) + 1, MaxInt)
      ELSE IF Line.StartsWith(PY_SELECTION_TAG) THEN
        Line := Copy(Line, Length(PY_SELECTION_TAG) + 1, MaxInt)
      ELSE IF Line.StartsWith(VB_SELECTION_TAG) THEN
        Line := Copy(Line, Length(VB_SELECTION_TAG) + 1, MaxInt)
      ELSE
        Continue;
      Parts := Trim(Line).Split([' '], TStringSplitOptions.ExcludeEmpty);
      IF Length(Parts) = 3 THEN
        ASelection.Add(UpperCase(Parts[0]) + ' ' + Parts[1] + '=' + Parts[2]);
    END;
  FINALLY
    SL.Free;
  END;
END;

FUNCTION PascalCaseOf(CONST S: STRING): STRING;
// "list_end_users" -> "ListEndUsers"
BEGIN
  Result := PascalWords(S);
END;

{ TEndpoint }

FUNCTION TEndpoint.Key: STRING;
BEGIN
  Result := Method + ' ' + Path;
END;

{ TApiSpec }

CONSTRUCTOR TApiSpec.Create;
BEGIN
  INHERITED Create;
  FEndpoints := TObjectList.Create(True);
  FCanon := TStringList.Create;
  FArrSuffix := TStringList.Create;
END;

DESTRUCTOR TApiSpec.Destroy;
BEGIN
  FEndpoints.Free;
  FCanon.Free;
  FArrSuffix.Free;
  FRoot.Free;
  INHERITED Destroy;
END;

FUNCTION TApiSpec.GetCount: Integer;
BEGIN
  Result := FEndpoints.Count;
END;

FUNCTION TApiSpec.GetEndpoint(AIndex: Integer): TEndpoint;
BEGIN
  Result := TEndpoint(FEndpoints[AIndex]);
END;

FUNCTION TApiSpec.FindEndpoint(CONST AKey: STRING): TEndpoint;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  FOR I := 0 TO Count - 1 DO
    IF Endpoints[I].Key = AKey THEN
      Exit(Endpoints[I]);
END;

FUNCTION TApiSpec.Canonical(CONST AName: STRING): STRING;
// Schemas differing only by case are identical: use one of them (PascalCase preferred)
BEGIN
  Result := FCanon.Values[LowerCase(AName)];
  IF Result = '' THEN
    Result := AName;
END;

FUNCTION TApiSpec.SchemaObj(CONST ACanon: STRING): TJSONObject;
BEGIN
  Result := ObjObj(FSchemas, ACanon);
END;

FUNCTION TApiSpec.RefName(AS_: TJSONObject): STRING;
VAR
  R: STRING;
BEGIN
  Result := '';
  R := ObjStr(AS_, '$ref');
  IF R <> '' THEN
    Result := Canonical(Copy(R, LastDelimiter('/', R) + 1, MaxInt));
END;

FUNCTION TApiSpec.IsRecordSchema(AS_: TJSONObject): Boolean;
VAR
  Props: TJSONObject;
BEGIN
  Props := ObjObj(AS_, 'properties');
  Result := (Props <> NIL) AND (Props.Count > 0);
END;

FUNCTION TApiSpec.TypeOf_(AS_: TJSONObject; ADepth: Integer): TTypeRef;
// Pascal type of a schema
VAR
  R, Typ, Fmt: STRING;
  T: TJSONObject;
  D: TJSONData;
  I: Integer;
  Item: TTypeRef;
BEGIN
  Result.Kind := tkRaw;
  Result.ElemKind := tkRaw;
  Result.RecName := '';
  IF (AS_ = NIL) OR (ADepth > 5) THEN
    Exit;
  R := RefName(AS_);
  IF R <> '' THEN
  BEGIN
    T := SchemaObj(R);
    IF T = NIL THEN
      Exit;
    IF IsRecordSchema(T) THEN
    BEGIN
      Result.Kind := tkRecord;
      Result.RecName := R;
    END
    ELSE
      Result := TypeOf_(T, ADepth + 1);
    Exit;
  END;
  Typ := '';
  D := AS_.Find('type');
  IF D <> NIL THEN
  BEGIN
    IF D.JSONType = jtString THEN
      Typ := D.AsString
    ELSE IF D.JSONType = jtArray THEN
      FOR I := 0 TO D.Count - 1 DO
        IF (D.Items[I].JSONType = jtString) AND (D.Items[I].AsString <> 'null') THEN
        BEGIN
          Typ := D.Items[I].AsString;
          Break;
        END;
  END;
  Fmt := ObjStr(AS_, 'format');
  IF Typ = 'array' THEN
  BEGIN
    Item := TypeOf_(ObjObj(AS_, 'items'), ADepth + 1);
    IF Item.Kind = tkRecord THEN
    BEGIN
      Result.Kind := tkArray;
      Result.ElemKind := tkRecord;
      Result.RecName := Item.RecName;
    END
    ELSE IF IsPrimitive(Item.Kind) THEN
    BEGIN
      Result.Kind := tkArray;
      Result.ElemKind := Item.Kind;
    END;
  END
  ELSE IF Typ = 'string' THEN
  BEGIN
    IF Fmt = 'date-time' THEN
      Result.Kind := tkDate
    ELSE IF Fmt = 'date' THEN
      Result.Kind := tkDateOnly
    ELSE
      Result.Kind := tkString;
  END
  ELSE IF Typ = 'integer' THEN
  BEGIN
    IF Fmt = 'int32' THEN
      Result.Kind := tkInteger
    ELSE
      Result.Kind := tkInt64;
  END
  ELSE IF Typ = 'number' THEN
    Result.Kind := tkDouble
  ELSE IF Typ = 'boolean' THEN
    Result.Kind := tkBoolean;
END;

FUNCTION TApiSpec.FindPagePath(CONST ACanon: STRING; ADepth: Integer; OUT APath: STRING): Boolean;
// Dotted path from schema ACanon to the object holding "page" and "pageSize"
VAR
  Props, PS: TJSONObject;
  I: Integer;
  R, Sub: STRING;
BEGIN
  Result := False;
  APath := '';
  Props := ObjObj(SchemaObj(ACanon), 'properties');
  IF Props = NIL THEN
    Exit;
  IF (Props.Find('page') <> NIL) AND (Props.Find('pageSize') <> NIL) THEN
    Exit(True);
  IF ADepth >= 3 THEN
    Exit;
  FOR I := 0 TO Props.Count - 1 DO
  BEGIN
    IF Props.Items[I].JSONType <> jtObject THEN
      Continue;
    PS := TJSONObject(Props.Items[I]);
    R := RefName(PS);
    IF (R <> '') AND IsRecordSchema(SchemaObj(R)) AND FindPagePath(R, ADepth + 1, Sub) THEN
    BEGIN
      APath := Props.Names[I];
      IF Sub <> '' THEN
        APath := APath + '.' + Sub;
      Exit(True);
    END;
  END;
END;

FUNCTION TApiSpec.CriteriaExists(CONST ACanon, APath: STRING): Boolean;
// True if the paged request schema has members other than the paging ones
VAR
  Props: TJSONObject;
  I, P: Integer;
  First, Rest, N: STRING;
BEGIN
  Result := False;
  Props := ObjObj(SchemaObj(ACanon), 'properties');
  IF Props = NIL THEN
    Exit;
  P := Pos('.', APath);
  IF P = 0 THEN
  BEGIN
    First := APath;
    Rest := '';
  END
  ELSE
  BEGIN
    First := Copy(APath, 1, P - 1);
    Rest := Copy(APath, P + 1, MaxInt);
  END;
  FOR I := 0 TO Props.Count - 1 DO
  BEGIN
    N := Props.Names[I];
    IF (APath = '') AND ((N = 'page') OR (N = 'pageSize') OR (N = 'sort')) THEN
      Continue;
    IF (APath <> '') AND (N = First) THEN
      Continue;
    IF (Props.Items[I].JSONType = jtObject) AND ObjBool(TJSONObject(Props.Items[I]), 'readOnly') THEN
      Continue;
    Exit(True);
  END;
  IF APath <> '' THEN
    Result := CriteriaExists(RefName(ObjObj(Props, First)), Rest);
END;

PROCEDURE TApiSpec.Analyze(AEp: TEndpoint; AOp: TJSONObject; APathItem: TJSONObject);
// Determine parameters, body, response and whether the endpoint can be generated
VAR
  Lists: ARRAY[0..1] OF TJSONData;
  L, I, Code, BestCode: Integer;
  P, Content, Media, Responses, Best: TJSONObject;
  Loc: STRING;
  Prm: TParamInfo;
  T: TTypeRef;

  PROCEDURE Unsupported(CONST AReason: STRING);
  BEGIN
    IF AEp.Supported THEN
    BEGIN
      AEp.Supported := False;
      AEp.Reason := AReason;
    END;
  END;

BEGIN
  AEp.Supported := True;
  AEp.Deprecated := ObjBool(AOp, 'deprecated');
  IF (AOp.Find('tags') <> NIL) AND (AOp.Find('tags').Count > 0) THEN
    AEp.Tag := AOp.Find('tags').Items[0].AsString;
  AEp.Summary := CleanDoc(ObjStr(AOp, 'description'), 200);
  IF AEp.Summary = '' THEN
    AEp.Summary := CleanDoc(ObjStr(AOp, 'summary'), 200);
  AEp.Description := CleanDoc(ObjStr(AOp, 'description'), 4000);
  IF AEp.Description = '' THEN
    AEp.Description := CleanDoc(ObjStr(AOp, 'summary'), 4000);
  IF AEp.Path = '/oauth2/token' THEN
    Unsupported('Handled by Authenticate');

  // Parameters (path item level + operation level)
  Lists[0] := APathItem.Find('parameters');
  Lists[1] := AOp.Find('parameters');
  FOR L := 0 TO 1 DO
  BEGIN
    IF (Lists[L] = NIL) OR (Lists[L].JSONType <> jtArray) THEN
      Continue;
    FOR I := 0 TO Lists[L].Count - 1 DO
    BEGIN
      IF Lists[L].Items[I].JSONType <> jtObject THEN
        Continue;
      P := TJSONObject(Lists[L].Items[I]);
      Loc := ObjStr(P, 'in');
      IF (Loc <> 'path') AND (Loc <> 'query') THEN
        Continue;
      Prm.Name := ObjStr(P, 'name');
      Prm.PasName := 'A' + PascalWords(Prm.Name);
      FOR Code := 0 TO High(AEp.Params) DO
        IF SameText(AEp.Params[Code].PasName, Prm.PasName) THEN
          Prm.PasName := Prm.PasName + '2';
      IF Loc = 'path' THEN
        Prm.Loc := plPath
      ELSE
        Prm.Loc := plQuery;
      Prm.Required := (Loc = 'path') OR ObjBool(P, 'required');
      Prm.TypeRef := TypeOf_(ObjObj(P, 'schema'));
      Prm.Description := CleanDoc(ObjStr(P, 'description'), 300);
      IF NOT (IsPrimitive(Prm.TypeRef.Kind) OR ((Prm.TypeRef.Kind = tkArray) AND IsPrimitive(Prm.TypeRef.ElemKind))) THEN
        Unsupported('Parameter "' + Prm.Name + '" has an unsupported type');
      IF (Prm.Loc = plPath) AND NOT (Prm.TypeRef.Kind IN [tkString, tkInteger, tkInt64]) THEN
        Unsupported('Path parameter "' + Prm.Name + '" has an unsupported type');
      SetLength(AEp.Params, Length(AEp.Params) + 1);
      AEp.Params[High(AEp.Params)] := Prm;
    END;
  END;

  // Request body
  AEp.BodyKind := bkNone;
  P := ObjObj(AOp, 'requestBody');
  IF P <> NIL THEN
  BEGIN
    Content := ObjObj(P, 'content');
    Media := ObjObj(Content, 'application/json');
    IF Media = NIL THEN
      Unsupported('Non-JSON request body')
    ELSE
    BEGIN
      // Body still analysed when unsupported by the generator (used by the Test tab)
      IF (AEp.Method = 'GET') OR (AEp.Method = 'DELETE') THEN
        Unsupported(AEp.Method + ' with a body (use the POST variant)');
      AEp.BodySchema := ObjObj(Media, 'schema');
      T := TypeOf_(AEp.BodySchema);
      AEp.BodyType := T;
      IF Pos('"binary"', Media.AsJSON) > 0 THEN
        Unsupported('Binary file upload not supported');
      CASE T.Kind OF
        tkString: AEp.BodyKind := bkText;
        tkRaw: AEp.BodyKind := bkRaw;
        tkRecord, tkArray: AEp.BodyKind := bkTyped;
      ELSE
        Unsupported('Request body of an unsupported type');
      END;
    END;
  END;

  // Response: lowest 2xx code with a content
  AEp.RespKind := rkNone;
  Responses := ObjObj(AOp, 'responses');
  Best := NIL;
  BestCode := 999;
  IF Responses <> NIL THEN
    FOR I := 0 TO Responses.Count - 1 DO
    BEGIN
      Code := StrToIntDef(Responses.Names[I], 0);
      IF (Code >= 200) AND (Code <= 299) AND (Code < BestCode) AND (Responses.Items[I].JSONType = jtObject)
        AND (ObjObj(TJSONObject(Responses.Items[I]), 'content') <> NIL)
        AND (ObjObj(TJSONObject(Responses.Items[I]), 'content').Count > 0) THEN
      BEGIN
        Best := TJSONObject(Responses.Items[I]);
        BestCode := Code;
      END;
    END;
  IF Best <> NIL THEN
  BEGIN
    Content := ObjObj(Best, 'content');
    Media := ObjObj(Content, 'application/json');
    AEp.RespCode := BestCode;
    IF Media <> NIL THEN
      AEp.RespSchema := ObjObj(Media, 'schema');
    IF Media = NIL THEN
    BEGIN
      AEp.RespKind := rkText;
      AEp.RespType.Kind := tkString;
    END
    ELSE
    BEGIN
      T := TypeOf_(ObjObj(Media, 'schema'));
      AEp.RespType := T;
      IF T.Kind = tkString THEN
        AEp.RespKind := rkText
      ELSE IF T.Kind = tkRaw THEN
        AEp.RespKind := rkRaw
      ELSE
        AEp.RespKind := rkTyped;
      // Paged list: response with content[] + totalNumberOfPages and a body holding page/pageSize
      IF (T.Kind = tkRecord) AND (AEp.BodyKind = bkTyped) AND (AEp.BodyType.Kind = tkRecord) THEN
      BEGIN
        P := ObjObj(SchemaObj(T.RecName), 'properties');
        IF (P <> NIL) AND (P.Find('totalNumberOfPages') <> NIL) AND (ObjObj(P, 'content') <> NIL)
          AND (TypeOf_(ObjObj(P, 'content')).Kind = tkArray)
          AND (TypeOf_(ObjObj(P, 'content')).ElemKind = tkRecord)
          AND FindPagePath(AEp.BodyType.RecName, 0, AEp.PagePath) THEN
        BEGIN
          AEp.RespKind := rkPaged;
          AEp.RespType := TypeOf_(ObjObj(P, 'content'));
          AEp.HasCriteria := CriteriaExists(AEp.BodyType.RecName, AEp.PagePath);
        END;
      END;
    END;
  END;
END;

PROCEDURE TApiSpec.AssignDefaultNames;
// METHOD /api/a-b/{id}/c -> GetABC ; paths containing "list" -> ListXxx ; collisions resolved
VAR
  I, J, K: Integer;
  Ep: TEndpoint;
  Segs: TStringArray;
  Lit, Prm, Verb: STRING;
  HasList: Boolean;
BEGIN
  FOR I := 0 TO Count - 1 DO
  BEGIN
    Ep := Endpoints[I];
    Segs := Ep.Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
    Lit := '';
    HasList := False;
    FOR J := 0 TO High(Segs) DO
    BEGIN
      IF (J = 0) AND (Segs[J] = 'api') THEN
        Continue;
      IF Segs[J].StartsWith('{') THEN
        Continue;
      IF Segs[J] = 'list' THEN
        HasList := True
      ELSE
        Lit := Lit + PascalWords(Segs[J]);
    END;
    IF HasList THEN
      Ep.DefaultName := 'List' + Lit
    ELSE
    BEGIN
      Verb := LowerCase(Ep.Method);
      Ep.DefaultName := UpperFirst(Verb) + Lit;
    END;
  END;
  // Collisions among supported endpoints: add path parameters, then verb, then index
  FOR K := 1 TO 3 DO
    FOR I := 0 TO Count - 1 DO
    BEGIN
      IF NOT Endpoints[I].Supported THEN
        Continue;
      FOR J := 0 TO Count - 1 DO
      BEGIN
        IF (I = J) OR NOT Endpoints[J].Supported OR NOT SameText(Endpoints[I].DefaultName, Endpoints[J].DefaultName) THEN
          Continue;
        Ep := Endpoints[I];
        CASE K OF
          1: BEGIN
               Prm := '';
               FOR Lit IN Ep.Path.Split(['/'], TStringSplitOptions.ExcludeEmpty) DO
                 IF Lit.StartsWith('{') THEN
                 BEGIN
                   IF Prm <> '' THEN
                     Prm := Prm + 'And';
                   Prm := Prm + PascalWords(Lit);
                 END;
               IF Prm <> '' THEN
                 Ep.DefaultName := Ep.DefaultName + 'By' + Prm;
             END;
          2: IF NOT Ep.DefaultName.StartsWith(UpperFirst(LowerCase(Ep.Method))) THEN
               Ep.DefaultName := UpperFirst(LowerCase(Ep.Method)) + Ep.DefaultName;
          3: Ep.DefaultName := Ep.DefaultName + IntToStr(I);
        END;
        Break;
      END;
    END;
END;

PROCEDURE TApiSpec.LoadFromFile(CONST AFileName: STRING);
VAR
  Stream: TFileStream;
  Paths, Item, Op: TJSONObject;
  I, J: Integer;
  M: STRING;
  Ep: TEndpoint;
BEGIN
  FEndpoints.Clear;
  FCanon.Clear;
  FreeAndNil(FRoot);
  Stream := TFileStream.Create(AFileName, fmOpenRead OR fmShareDenyWrite);
  TRY
    FRoot := GetJSON(Stream, True);
  FINALLY
    Stream.Free;
  END;
  IF FRoot.JSONType <> jtObject THEN
    RAISE Exception.Create('Invalid OpenAPI file');
  FVersion := ObjStr(ObjObj(TJSONObject(FRoot), 'info'), 'version');
  FTitle := ObjStr(ObjObj(TJSONObject(FRoot), 'info'), 'title');
  FSchemas := ObjObj(ObjObj(TJSONObject(FRoot), 'components'), 'schemas');
  IF FSchemas = NIL THEN
  BEGIN
    FSchemas := TJSONObject.Create;
    TJSONObject(FRoot).Add('__noschemas', FSchemas);
  END;
  // Canonical names: first PascalCase variant of each case-insensitive name
  FOR I := 0 TO FSchemas.Count - 1 DO
  BEGIN
    M := FSchemas.Names[I];
    J := FCanon.IndexOfName(LowerCase(M));
    IF J < 0 THEN
      FCanon.Add(LowerCase(M) + '=' + M)
    ELSE IF (M[1] IN ['A'..'Z']) AND NOT (FCanon.ValueFromIndex[J][1] IN ['A'..'Z']) THEN
      FCanon.ValueFromIndex[J] := M;
  END;
  Paths := ObjObj(TJSONObject(FRoot), 'paths');
  IF Paths = NIL THEN
    Exit;
  FOR I := 0 TO Paths.Count - 1 DO
  BEGIN
    IF Paths.Items[I].JSONType <> jtObject THEN
      Continue;
    Item := TJSONObject(Paths.Items[I]);
    FOR M IN HTTP_METHODS DO
    BEGIN
      Op := ObjObj(Item, M);
      IF Op = NIL THEN
        Continue;
      Ep := TEndpoint.Create;
      Ep.Method := UpperCase(M);
      Ep.Path := Paths.Names[I];
      FEndpoints.Add(Ep);
      Analyze(Ep, Op, Item);
    END;
  END;
  AssignDefaultNames;
END;

{ Generation }

FUNCTION TApiSpec.BaseName(CONST ACanon: STRING): STRING;
BEGIN
  Result := UpperFirst(Ident(ACanon));
  IF Result.EndsWith('_') THEN
    Delete(Result, Length(Result), 1);
END;

FUNCTION TApiSpec.TyName(CONST ACanon: STRING): STRING;
BEGIN
  Result := 'ty' + BaseName(ACanon);
END;

FUNCTION TApiSpec.ArrName(CONST ACanon: STRING): STRING;
// tyXxxs, or tyXxxArray if tyXxxs is already a record type
BEGIN
  Result := TyName(ACanon) + FArrSuffix.Values[LowerCase(ACanon)];
  IF FArrSuffix.Values[LowerCase(ACanon)] = '' THEN
    Result := Result + 's';
END;

FUNCTION TApiSpec.PasType(CONST AT: TTypeRef): STRING;
BEGIN
  Result := '';
  CASE AT.Kind OF
    tkString, tkRaw: Result := 'STRING';
    tkInteger: Result := 'Integer';
    tkInt64: Result := 'Int64';
    tkDouble: Result := 'Double';
    tkBoolean: Result := 'Boolean';
    tkDate, tkDateOnly: Result := 'TDateTime';
    tkRecord: Result := TyName(AT.RecName);
    tkArray:
      IF AT.ElemKind = tkRecord THEN
        Result := ArrName(AT.RecName)
      ELSE
        Result := PRIMITIVE_ARRAYS[AT.ElemKind];
  END;
END;

PROCEDURE TApiSpec.CollectTypes(CONST AT: TTypeRef; ASet: TStringList; AWritable: Boolean);
// Add the record type of AT and its nested record types (writable members only if AWritable)
VAR
  Props, PS: TJSONObject;
  I: Integer;
BEGIN
  IF NOT ((AT.Kind = tkRecord) OR ((AT.Kind = tkArray) AND (AT.ElemKind = tkRecord))) THEN
    Exit;
  IF ASet.IndexOf(AT.RecName) >= 0 THEN
    Exit;
  ASet.Add(AT.RecName);
  Props := ObjObj(SchemaObj(AT.RecName), 'properties');
  IF Props = NIL THEN
    Exit;
  FOR I := 0 TO Props.Count - 1 DO
  BEGIN
    IF Props.Items[I].JSONType <> jtObject THEN
      Continue;
    PS := TJSONObject(Props.Items[I]);
    IF AWritable AND ObjBool(PS, 'readOnly') THEN
      Continue;
    CollectTypes(TypeOf_(PS), ASet, AWritable);
  END;
END;

PROCEDURE TApiSpec.SortTypes(CONST ACanon: STRING; ADone, AOrder: TStringList);
// Depth-first: dependencies are declared before the record using them
VAR
  Props: TJSONObject;
  I: Integer;
  T: TTypeRef;
BEGIN
  IF ADone.IndexOf(ACanon) >= 0 THEN
    Exit;
  ADone.Add(ACanon);
  Props := ObjObj(SchemaObj(ACanon), 'properties');
  IF Props <> NIL THEN
    FOR I := 0 TO Props.Count - 1 DO
      IF Props.Items[I].JSONType = jtObject THEN
      BEGIN
        T := TypeOf_(TJSONObject(Props.Items[I]));
        IF (T.Kind = tkRecord) OR ((T.Kind = tkArray) AND (T.ElemKind = tkRecord)) THEN
          SortTypes(T.RecName, ADone, AOrder);
      END;
  AOrder.Add(ACanon);
END;

FUNCTION TApiSpec.FieldIdent(CONST AProp: STRING; AUsed: TStringList): STRING;
VAR
  N: Integer;
BEGIN
  Result := Ident(AProp);
  N := 2;
  WHILE AUsed.IndexOf(LowerCase(Result)) >= 0 DO
  BEGIN
    Result := Ident(AProp) + '_' + IntToStr(N);
    Inc(N);
  END;
  AUsed.Add(LowerCase(Result));
END;

PROCEDURE TApiSpec.GenRecord(CONST ACanon: STRING; AOut: TStrings);
VAR
  T, Props, PS: TJSONObject;
  I: Integer;
  Used: TStringList;
  Doc, Line: STRING;
BEGIN
  T := SchemaObj(ACanon);
  Props := ObjObj(T, 'properties');
  Used := TStringList.Create;
  TRY
    Doc := CleanDoc(ObjStr(T, 'description'), 100);
    IF Doc <> '' THEN
      AOut.Add('  // ' + Doc);
    AOut.Add('  ' + TyName(ACanon) + ' = RECORD');
    FOR I := 0 TO Props.Count - 1 DO
    BEGIN
      IF Props.Items[I].JSONType <> jtObject THEN
        Continue;
      PS := TJSONObject(Props.Items[I]);
      Line := '    ' + FieldIdent(Props.Names[I], Used) + ': ' + PasType(TypeOf_(PS)) + ';';
      Doc := CleanDoc(ObjStr(PS, 'description'), 90);
      IF ObjBool(PS, 'readOnly') THEN
        Doc := Trim('[read-only] ' + Doc);
      IF Doc <> '' THEN
        Line := Line + ' // ' + Doc;
      AOut.Add(Line);
    END;
    AOut.Add('  END;');
    AOut.Add('  ' + ArrName(ACanon) + ' = ARRAY OF ' + TyName(ACanon) + ';');
    AOut.Add('');
  FINALLY
    Used.Free;
  END;
END;

PROCEDURE TApiSpec.GenReader(CONST ACanon: STRING; AOut: TStrings);
VAR
  Props: TJSONObject;
  I: Integer;
  Used: TStringList;
  F, N, Conv: STRING;
  T: TTypeRef;
BEGIN
  Props := ObjObj(SchemaObj(ACanon), 'properties');
  Used := TStringList.Create;
  TRY
    AOut.Add('FUNCTION JsonTo' + BaseName(ACanon) + '(AObj: TJSONObject): ' + TyName(ACanon) + ';');
    AOut.Add('BEGIN');
    AOut.Add('  Result := Default(' + TyName(ACanon) + ');');
    AOut.Add('  IF AObj = NIL THEN');
    AOut.Add('    Exit;');
    FOR I := 0 TO Props.Count - 1 DO
    BEGIN
      IF Props.Items[I].JSONType <> jtObject THEN
        Continue;
      N := Props.Names[I];
      F := FieldIdent(N, Used);
      T := TypeOf_(TJSONObject(Props.Items[I]));
      CASE T.Kind OF
        tkString: Conv := 'JStr(AObj, ' + Quote(N) + ')';
        tkInteger: Conv := 'JInt(AObj, ' + Quote(N) + ')';
        tkInt64: Conv := 'JInt64(AObj, ' + Quote(N) + ')';
        tkDouble: Conv := 'JFloat(AObj, ' + Quote(N) + ')';
        tkBoolean: Conv := 'JBool(AObj, ' + Quote(N) + ')';
        tkDate, tkDateOnly: Conv := 'JDate(AObj, ' + Quote(N) + ')';
        tkRaw: Conv := 'JRaw(AObj, ' + Quote(N) + ')';
        tkRecord: Conv := 'JsonTo' + BaseName(T.RecName) + '(JObj(AObj, ' + Quote(N) + '))';
        tkArray:
          IF T.ElemKind = tkRecord THEN
            Conv := 'JsonTo' + Copy(ArrName(T.RecName), 3, MaxInt) + '(JArr(AObj, ' + Quote(N) + '))'
          ELSE
            Conv := ARR_READERS[T.ElemKind] + '(JArr(AObj, ' + Quote(N) + '))';
      END;
      AOut.Add('  Result.' + F + ' := ' + Conv + ';');
    END;
    AOut.Add('END;');
    AOut.Add('');
    AOut.Add('FUNCTION JsonTo' + Copy(ArrName(ACanon), 3, MaxInt) + '(AArr: TJSONArray): ' + ArrName(ACanon) + ';');
    AOut.Add('VAR');
    AOut.Add('  I: Integer;');
    AOut.Add('BEGIN');
    AOut.Add('  Result := NIL;');
    AOut.Add('  SetLength(Result, JCount(AArr));');
    AOut.Add('  FOR I := 0 TO High(Result) DO');
    AOut.Add('    Result[I] := JsonTo' + BaseName(ACanon) + '(JItemObj(AArr, I));');
    AOut.Add('END;');
    AOut.Add('');
  FINALLY
    Used.Free;
  END;
END;

PROCEDURE TApiSpec.GenWriter(CONST ACanon: STRING; AOut: TStrings);
// Read-only members are not sent; optional empty strings, 0 ids, 0 dates,
// empty arrays and references with id 0 are omitted
VAR
  T, Props, PS, Sub: TJSONObject;
  I: Integer;
  Used: TStringList;
  F, N, V, Cond, Stmt: STRING;
  TR: TTypeRef;
  Req: Boolean;
BEGIN
  T := SchemaObj(ACanon);
  Props := ObjObj(T, 'properties');
  Used := TStringList.Create;
  TRY
    AOut.Add('FUNCTION ' + BaseName(ACanon) + 'ToJson(CONST ARec: ' + TyName(ACanon) + '): TJSONObject;');
    AOut.Add('BEGIN');
    AOut.Add('  Result := JNewObj;');
    FOR I := 0 TO Props.Count - 1 DO
    BEGIN
      IF Props.Items[I].JSONType <> jtObject THEN
        Continue;
      N := Props.Names[I];
      F := FieldIdent(N, Used);
      PS := TJSONObject(Props.Items[I]);
      IF ObjBool(PS, 'readOnly') THEN
        Continue;
      Req := InList(T.Find('required'), N);
      TR := TypeOf_(PS);
      V := 'ARec.' + F;
      Cond := '';
      CASE TR.Kind OF
        tkString:
          BEGIN
            Stmt := 'JAddStr(Result, ' + Quote(N) + ', ' + V + ')';
            IF NOT Req THEN Cond := V + ' <> ''''';
          END;
        tkInteger, tkInt64:
          BEGIN
            Stmt := 'JAddInt(Result, ' + Quote(N) + ', ' + V + ')';
            IF NOT Req AND IsIdLike(N) THEN Cond := V + ' <> 0';
          END;
        tkDouble: Stmt := 'JAddFloat(Result, ' + Quote(N) + ', ' + V + ')';
        tkBoolean: Stmt := 'JAddBool(Result, ' + Quote(N) + ', ' + V + ')';
        tkDate, tkDateOnly:
          BEGIN
            IF TR.Kind = tkDate THEN
              Stmt := 'JAddDate(Result, ' + Quote(N) + ', ' + V + ')'
            ELSE
              Stmt := 'JAddDateOnly(Result, ' + Quote(N) + ', ' + V + ')';
            IF NOT Req THEN Cond := V + ' <> 0';
          END;
        tkRaw:
          BEGIN
            Stmt := 'JAddRaw(Result, ' + Quote(N) + ', ' + V + ')';
            IF NOT Req THEN Cond := V + ' <> ''''';
          END;
        tkRecord:
          BEGIN
            Stmt := 'JAddValue(Result, ' + Quote(N) + ', ' + BaseName(TR.RecName) + 'ToJson(' + V + '))';
            Sub := ObjObj(ObjObj(SchemaObj(TR.RecName), 'properties'), 'id');
            IF NOT Req AND (Sub <> NIL) AND (TypeOf_(Sub).Kind IN [tkInteger, tkInt64]) THEN
              Cond := V + '.id <> 0';
          END;
        tkArray:
          BEGIN
            IF TR.ElemKind = tkRecord THEN
              Stmt := 'JAddValue(Result, ' + Quote(N) + ', ' + Copy(ArrName(TR.RecName), 3, MaxInt) + 'ToJson(' + V + '))'
            ELSE
              Stmt := 'JAddValue(Result, ' + Quote(N) + ', ' + ARR_WRITERS[TR.ElemKind] + '(' + V + '))';
            IF NOT Req THEN Cond := 'Length(' + V + ') > 0';
          END;
      END;
      IF Cond = '' THEN
        AOut.Add('  ' + Stmt + ';')
      ELSE
      BEGIN
        AOut.Add('  IF ' + Cond + ' THEN');
        AOut.Add('    ' + Stmt + ';');
      END;
    END;
    AOut.Add('END;');
    AOut.Add('');
    AOut.Add('FUNCTION ' + Copy(ArrName(ACanon), 3, MaxInt) + 'ToJson(CONST AArr: ' + ArrName(ACanon) + '): TJSONArray;');
    AOut.Add('VAR');
    AOut.Add('  I: Integer;');
    AOut.Add('BEGIN');
    AOut.Add('  Result := JNewArr;');
    AOut.Add('  FOR I := 0 TO High(AArr) DO');
    AOut.Add('    JArrAddValue(Result, ' + BaseName(ACanon) + 'ToJson(AArr[I]));');
    AOut.Add('END;');
    AOut.Add('');
  FINALLY
    Used.Free;
  END;
END;

FUNCTION TApiSpec.ParamDecl(CONST AP: TParamInfo; AOptional: Boolean): STRING;
VAR
  Typ, Def: STRING;
BEGIN
  Typ := PasType(AP.TypeRef);
  Def := '';
  IF AOptional THEN
    CASE AP.TypeRef.Kind OF
      tkString, tkRaw: Def := '''''';
      tkInteger, tkInt64, tkDouble, tkDate, tkDateOnly: Def := '0';
      tkBoolean:
        BEGIN
          Typ := 'TCockpitBool';
          Def := 'cbUnset';
        END;
      tkArray: Def := 'NIL';
    END;
  Result := AP.PasName + ': ' + Typ;
  IF AP.TypeRef.Kind IN [tkString, tkRaw, tkArray, tkRecord] THEN
    Result := 'CONST ' + Result;
  IF Def <> '' THEN
    Result := Result + ' = ' + Def;
END;

FUNCTION TApiSpec.BodyParamDecl(AEp: TEndpoint): STRING;
BEGIN
  CASE AEp.BodyKind OF
    bkText, bkRaw: Result := 'CONST ' + AEp.BodyName + ': STRING';
    bkTyped: Result := 'CONST ' + AEp.BodyName + ': ' + PasType(AEp.BodyType);
  ELSE
    Result := '';
  END;
END;

FUNCTION TApiSpec.RetType(AEp: TEndpoint): STRING;
BEGIN
  CASE AEp.RespKind OF
    rkText:
      IF AEp.RespType.Kind = tkString THEN
        Result := 'STRING'
      ELSE
        Result := PasType(AEp.RespType);
    rkRaw: Result := 'STRING';
    rkTyped, rkPaged: Result := PasType(AEp.RespType);
  ELSE
    Result := '';
  END;
END;

FUNCTION TApiSpec.Signature(AEp: TEndpoint; CONST AName: STRING; AWithCriteria: Boolean; AQualified: Boolean): STRING;
// Order: path params, required query params, body, optional query params
VAR
  Parts: TStringList;
  I: Integer;
  S: STRING;
BEGIN
  Parts := TStringList.Create;
  TRY
    FOR I := 0 TO High(AEp.Params) DO
      IF AEp.Params[I].Loc = plPath THEN
        Parts.Add(ParamDecl(AEp.Params[I], False));
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND AEp.Params[I].Required THEN
        Parts.Add(ParamDecl(AEp.Params[I], False));
    IF (AEp.RespKind <> rkPaged) OR (AWithCriteria AND AEp.HasCriteria) THEN
    BEGIN
      S := BodyParamDecl(AEp);
      IF S <> '' THEN
        Parts.Add(S);
    END;
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND NOT AEp.Params[I].Required THEN
        Parts.Add(ParamDecl(AEp.Params[I], True));
    S := '';
    FOR I := 0 TO Parts.Count - 1 DO
    BEGIN
      IF S <> '' THEN
        S := S + '; ';
      S := S + Parts[I];
    END;
  FINALLY
    Parts.Free;
  END;
  IF AQualified THEN
    Result := 'TCockpitItsmInstance.' + AName
  ELSE
    Result := AName;
  IF S <> '' THEN
    Result := Result + '(' + S + ')';
  IF RetType(AEp) = '' THEN
    Result := 'PROCEDURE ' + Result + ';'
  ELSE
    Result := 'FUNCTION ' + Result + ': ' + RetType(AEp) + ';';
END;

FUNCTION TApiSpec.CallArgs(AEp: TEndpoint; AWithCriteria: Boolean): STRING;
// Arguments forwarding the overload without criteria to the full method
VAR
  I: Integer;
  PROCEDURE Add(CONST S: STRING);
  BEGIN
    IF Result <> '' THEN
      Result := Result + ', ';
    Result := Result + S;
  END;
BEGIN
  Result := '';
  FOR I := 0 TO High(AEp.Params) DO
    IF AEp.Params[I].Loc = plPath THEN
      Add(AEp.Params[I].PasName);
  FOR I := 0 TO High(AEp.Params) DO
    IF (AEp.Params[I].Loc = plQuery) AND AEp.Params[I].Required THEN
      Add(AEp.Params[I].PasName);
  IF AWithCriteria THEN
    Add('Default(' + PasType(AEp.BodyType) + ')');
  FOR I := 0 TO High(AEp.Params) DO
    IF (AEp.Params[I].Loc = plQuery) AND NOT AEp.Params[I].Required THEN
      Add(AEp.Params[I].PasName);
END;

PROCEDURE TApiSpec.GenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
VAR
  I: Integer;
  P: TParamInfo;
  Url, Seg, Q, Body, Conv, Item: STRING;
  NeedI, Overloaded: Boolean;
  Segs: TStringArray;
BEGIN
  Overloaded := (AEp.RespKind = rkPaged) AND AEp.HasCriteria;
  // Overload without criteria
  IF Overloaded THEN
  BEGIN
    AOut.Add(Signature(AEp, AName, False, True));
    AOut.Add('// ' + AEp.Method + ' ' + AEp.Path + ' - all pages, no criteria');
    AOut.Add('BEGIN');
    AOut.Add('  Result := ' + AName + '(' + CallArgs(AEp, True) + ');');
    AOut.Add('END;');
    AOut.Add('');
  END;
  AOut.Add(Signature(AEp, AName, True, True));
  AOut.Add('// ' + AEp.Method + ' ' + AEp.Path + IfThen(AEp.Summary <> '', ' - ' + CleanDoc(AEp.Summary, 120), ''));
  // URL with encoded path parameters
  Url := '';
  Segs := AEp.Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  FOR Seg IN Segs DO
  BEGIN
    IF Seg.StartsWith('{') THEN
    BEGIN
      Item := Copy(Seg, 2, Length(Seg) - 2);
      FOR I := 0 TO High(AEp.Params) DO
        IF (AEp.Params[I].Loc = plPath) AND (AEp.Params[I].Name = Item) THEN
        BEGIN
          P := AEp.Params[I];
          IF P.TypeRef.Kind = tkString THEN
            Url := Url + ' + ''/'' + UrlEncode(' + P.PasName + ')'
          ELSE
            Url := Url + ' + ''/'' + IntToStr(' + P.PasName + ')';
        END;
    END
    ELSE
      Url := Url + ' + ''/' + StringReplace(Seg, '''', '''''', [rfReplaceAll]) + '''';
  END;
  Url := Copy(Url, 4, MaxInt);
  Url := StringReplace(Url, ''' + ''', '', [rfReplaceAll]);
  // Query
  Q := '';
  NeedI := False;
  FOR I := 0 TO High(AEp.Params) DO
    IF AEp.Params[I].Loc = plQuery THEN
    BEGIN
      P := AEp.Params[I];
      IF P.TypeRef.Kind = tkArray THEN
      BEGIN
        NeedI := True;
        Item := '';
        CASE P.TypeRef.ElemKind OF
          tkString: Item := P.PasName + '[I]';
          tkInteger, tkInt64: Item := 'IntToStr(' + P.PasName + '[I])';
          tkDouble: Item := 'QFloat(' + P.PasName + '[I])';
          tkBoolean: Item := 'QBool(' + P.PasName + '[I])';
          tkDate: Item := 'DateTimeToIso(' + P.PasName + '[I])';
          tkDateOnly: Item := 'DateToIsoDate(' + P.PasName + '[I])';
        END;
        Q := Q + '  FOR I := 0 TO High(' + P.PasName + ') DO' + LineEnding +
          '    AddQuery(Q, ' + Quote(P.Name) + ', ' + Item + ');' + LineEnding;
        Continue;
      END;
      Item := '';
      CASE P.TypeRef.Kind OF
        tkString: Item := P.PasName;
        tkInteger, tkInt64: Item := 'IntToStr(' + P.PasName + ')';
        tkDouble: Item := 'QFloat(' + P.PasName + ')';
        tkBoolean:
          IF P.Required THEN
            Item := 'QBool(' + P.PasName + ')'
          ELSE
            Item := 'QBool(' + P.PasName + ' = cbTrue)';
        tkDate: Item := 'DateTimeToIso(' + P.PasName + ')';
        tkDateOnly: Item := 'DateToIsoDate(' + P.PasName + ')';
      END;
      IF NOT P.Required THEN
      BEGIN
        CASE P.TypeRef.Kind OF
          tkString: Q := Q + '  IF ' + P.PasName + ' <> '''' THEN' + LineEnding;
          tkBoolean: Q := Q + '  IF ' + P.PasName + ' <> cbUnset THEN' + LineEnding;
        ELSE
          Q := Q + '  IF ' + P.PasName + ' <> 0 THEN' + LineEnding;
        END;
        Q := Q + '  ';
      END;
      Q := Q + '  AddQuery(Q, ' + Quote(P.Name) + ', ' + Item + ');' + LineEnding;
    END;
  // Body expression
  Body := '';
  IF AEp.RespKind <> rkPaged THEN
    CASE AEp.BodyKind OF
      bkText, bkRaw: Body := AEp.BodyName;
      bkTyped:
        IF AEp.BodyType.Kind = tkRecord THEN
          Body := 'JToStringFree(' + BaseName(AEp.BodyType.RecName) + 'ToJson(' + AEp.BodyName + '))'
        ELSE IF AEp.BodyType.ElemKind = tkRecord THEN
          Body := 'JToStringFree(' + Copy(ArrName(AEp.BodyType.RecName), 3, MaxInt) + 'ToJson(' + AEp.BodyName + '))'
        ELSE
          Body := 'JToStringFree(' + ARR_WRITERS[AEp.BodyType.ElemKind] + '(' + AEp.BodyName + '))';
    END;
  // Response conversion
  Conv := '';
  CASE AEp.RespType.Kind OF
    tkRecord: Conv := 'JsonTo' + BaseName(AEp.RespType.RecName) + '(JAsObj(Resp))';
    tkArray:
      IF AEp.RespType.ElemKind = tkRecord THEN
        Conv := 'JsonTo' + Copy(ArrName(AEp.RespType.RecName), 3, MaxInt) + '(JAsArr(Resp))'
      ELSE
        Conv := ARR_READERS[AEp.RespType.ElemKind] + '(JAsArr(Resp))';
  END;
  // VAR section
  IF (Q <> '') OR (AEp.RespKind IN [rkTyped, rkPaged]) THEN
  BEGIN
    AOut.Add('VAR');
    IF Q <> '' THEN
      AOut.Add('  Q: STRING;');
    IF NeedI THEN
      AOut.Add('  I: Integer;');
    IF (AEp.RespKind = rkTyped) AND (Conv <> '') THEN
      AOut.Add('  Resp: TJSONValue;')
    ELSE IF AEp.RespKind = rkTyped THEN
      AOut.Add('  Txt: STRING;');
    IF AEp.RespKind = rkPaged THEN
    BEGIN
      AOut.Add('  Body: TJSONObject;');
      AOut.Add('  Items: TJSONArray;');
    END;
  END;
  AOut.Add('BEGIN');
  IF Q <> '' THEN
  BEGIN
    AOut.Add('  Q := '''';');
    AOut.Add(TrimRight(Q));
    Url := Url + ' + Q';
  END;
  IF Body <> '' THEN
    Body := ', ' + Body;
  CASE AEp.RespKind OF
    rkNone: AOut.Add('  Call(' + Quote(AEp.Method) + ', ' + Url + Body + ');');
    rkRaw: AOut.Add('  Result := Call(' + Quote(AEp.Method) + ', ' + Url + Body + ');');
    rkText: AOut.Add('  Result := JUnquote(Call(' + Quote(AEp.Method) + ', ' + Url + Body + '));');
    rkTyped:
      IF Conv <> '' THEN
      BEGIN
        AOut.Add('  Resp := CallJson(' + Quote(AEp.Method) + ', ' + Url + Body + ');');
        AOut.Add('  TRY');
        AOut.Add('    Result := ' + Conv + ';');
        AOut.Add('  FINALLY');
        AOut.Add('    Resp.Free;');
        AOut.Add('  END;');
      END
      ELSE
      BEGIN
        // primitive JSON response
        AOut.Add('  Txt := Trim(JUnquote(Call(' + Quote(AEp.Method) + ', ' + Url + Body + ')));');
        CASE AEp.RespType.Kind OF
          tkInteger: AOut.Add('  Result := StrToIntDef(Txt, 0);');
          tkInt64: AOut.Add('  Result := StrToInt64Def(Txt, 0);');
          tkDouble: AOut.Add('  Result := TextToFloat(Txt);');
          tkBoolean: AOut.Add('  Result := SameText(Txt, ''true'');');
          tkDate, tkDateOnly: AOut.Add('  Result := IsoToDateTime(Txt);');
        END;
      END;
    rkPaged:
      BEGIN
        IF AEp.HasCriteria THEN
          AOut.Add('  Body := ' + BaseName(AEp.BodyType.RecName) + 'ToJson(' + AEp.BodyName + ');')
        ELSE
          AOut.Add('  Body := JNewObj;');
        AOut.Add('  TRY');
        AOut.Add('    Items := FetchAllPages(' + Quote(AEp.Method) + ', ' + Url + ', Body, ' + Quote(AEp.PagePath) + ');');
        AOut.Add('  FINALLY');
        AOut.Add('    Body.Free;');
        AOut.Add('  END;');
        AOut.Add('  TRY');
        AOut.Add('    Result := JsonTo' + Copy(ArrName(AEp.RespType.RecName), 3, MaxInt) + '(Items);');
        AOut.Add('  FINALLY');
        AOut.Add('    Items.Free;');
        AOut.Add('  END;');
      END;
  END;
  AOut.Add('END;');
  AOut.Add('');
END;

FUNCTION TApiSpec.Generate(ASelection: TStrings; CONST AUnitName: STRING; ALog: TStrings): STRING;
// ASelection: "METHOD /path=PascalName" lines
VAR
  Sel: TObjectList;
  Names: TStringList;
  ReadSet, WriteSet, AllSet, Done, Order: TStringList;
  Code, Decl, Impl: TStringList;
  I, J: Integer;
  Ep: TEndpoint;
  Key, Nm, S: STRING;
  Used: TStringList;
BEGIN
  Sel := TObjectList.Create(False);
  Names := TStringList.Create;
  ReadSet := TStringList.Create;
  WriteSet := TStringList.Create;
  AllSet := TStringList.Create;
  Done := TStringList.Create;
  Order := TStringList.Create;
  Code := TStringList.Create;
  Decl := TStringList.Create;
  Impl := TStringList.Create;
  Used := TStringList.Create;
  TRY
    // Selected endpoints
    FOR I := 0 TO ASelection.Count - 1 DO
    BEGIN
      Key := ASelection.Names[I];
      Nm := ASelection.ValueFromIndex[I];
      Ep := FindEndpoint(Key);
      IF Ep = NIL THEN
      BEGIN
        ALog.Add('MISSING from version ' + FVersion + ': ' + Key + ' (' + Nm + ') - skipped');
        Continue;
      END;
      IF NOT Ep.Supported THEN
      BEGIN
        ALog.Add('Unsupported: ' + Key + ' - ' + Ep.Reason);
        Continue;
      END;
      IF NOT IsValidIdent(Nm) OR (Names.IndexOf(LowerCase(Nm)) >= 0) THEN
        RAISE Exception.Create('Invalid or duplicate method name: ' + Nm + ' (' + Key + ')');
      Names.Add(LowerCase(Nm));
      Sel.Add(Ep);
      // Body parameter name (unique among the parameters)
      Used.Clear;
      FOR J := 0 TO High(Ep.Params) DO
        Used.Add(LowerCase(Ep.Params[J].PasName));
      CASE Ep.BodyKind OF
        bkText: Ep.BodyName := 'AText';
        bkRaw: Ep.BodyName := 'AJson';
        bkTyped:
          IF Ep.RespKind = rkPaged THEN
            Ep.BodyName := 'ACriteria'
          ELSE IF Ep.BodyType.Kind = tkRecord THEN
            Ep.BodyName := 'A' + BaseName(Ep.BodyType.RecName)
          ELSE
            Ep.BodyName := 'AItems';
      END;
      WHILE (Ep.BodyName <> '') AND (Used.IndexOf(LowerCase(Ep.BodyName)) >= 0) DO
        Ep.BodyName := Ep.BodyName + '_';
      // Types
      IF (Ep.BodyKind = bkTyped) AND ((Ep.RespKind <> rkPaged) OR Ep.HasCriteria) THEN
        CollectTypes(Ep.BodyType, WriteSet, True);
      IF Ep.RespKind IN [rkTyped, rkPaged] THEN
        CollectTypes(Ep.RespType, ReadSet, False);
    END;
    IF Sel.Count = 0 THEN
      RAISE Exception.Create('No endpoint selected');

    // Declared types: closure over every member, dependencies first
    AllSet.AddStrings(ReadSet);
    AllSet.AddStrings(WriteSet);
    FOR I := 0 TO AllSet.Count - 1 DO
      SortTypes(AllSet[I], Done, Order);
    // Array type names must not collide with record type names
    FArrSuffix.Clear;
    FOR I := 0 TO Order.Count - 1 DO
      IF Order.IndexOf(Order[I] + 's') >= 0 THEN
        FArrSuffix.Add(LowerCase(Order[I]) + '=Array');
    FOR I := 0 TO Order.Count - 1 DO
      FOR J := 0 TO Order.Count - 1 DO
        IF (I <> J) AND SameText(TyName(Order[I]) + 's', TyName(Order[J])) THEN
          FArrSuffix.Values[LowerCase(Order[I])] := 'Array';

    // Header
    Code.Add('UNIT ' + AUnitName + ';');
    Code.Add('');
    Code.Add('// Cockpit ITSM public API - GENERATED UNIT, do not edit (regenerate with CIPAT)');
    Code.Add('// Source: ' + CleanDoc(FTitle, 80) + ' ' + FVersion + ' - generated ' + FormatDateTime('yyyy-mm-dd hh:nn', Now));
    Code.Add('// Requires uCockpitItsmCore.pas (Delphi and Lazarus/FPC)');
    Code.Add('//');
    Code.Add('// Selected endpoints (read back by CIPAT when regenerating):');
    FOR I := 0 TO Sel.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sel[I]);
      Code.Add(SELECTION_TAG + Ep.Method + ' ' + Ep.Path + ' ' + ASelection.Values[Ep.Key]);
    END;
    Code.Add('');
    Code.Add('{$IFDEF FPC}');
    Code.Add('  {$mode delphi}{$H+}');
    Code.Add('{$ENDIF}');
    Code.Add('');
    Code.Add('INTERFACE');
    Code.Add('');
    Code.Add('USES');
    Code.Add('  {$IFDEF FPC}');
    Code.Add('  SysUtils, fpjson,');
    Code.Add('  {$ELSE}');
    Code.Add('  System.SysUtils, System.JSON,');
    Code.Add('  {$ENDIF}');
    Code.Add('  uCockpitItsmCore;');
    Code.Add('');
    Code.Add('TYPE');
    FOR I := 0 TO Order.Count - 1 DO
      GenRecord(Order[I], Code);

    // Class
    Code.Add('  TCockpitItsmInstance = CLASS(TCockpitItsmBase)');
    Code.Add('  PUBLIC');
    FOR I := 0 TO Sel.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sel[I]);
      Nm := ASelection.Values[Ep.Key];
      IF (Ep.RespKind = rkPaged) AND Ep.HasCriteria THEN
      BEGIN
        S := Signature(Ep, Nm, False, False);
        Code.Add('    ' + Copy(S, 1, Length(S) - 1) + '; OVERLOAD;');
        S := Signature(Ep, Nm, True, False);
        Code.Add('    ' + Copy(S, 1, Length(S) - 1) + '; OVERLOAD;');
      END
      ELSE
        Code.Add('    ' + Signature(Ep, Nm, True, False));
      S := '    // ' + Ep.Method + ' ' + Ep.Path;
      IF Ep.RespKind = rkPaged THEN
        S := S + ' (all pages)';
      IF Ep.Deprecated THEN
        S := S + ' [DEPRECATED]';
      Code.Add(S);
    END;
    Code.Add('  END;');
    Code.Add('');

    // Converters
    FOR I := 0 TO Order.Count - 1 DO
    BEGIN
      IF ReadSet.IndexOf(Order[I]) >= 0 THEN
      BEGIN
        Decl.Add('FUNCTION JsonTo' + BaseName(Order[I]) + '(AObj: TJSONObject): ' + TyName(Order[I]) + ';');
        Decl.Add('FUNCTION JsonTo' + Copy(ArrName(Order[I]), 3, MaxInt) + '(AArr: TJSONArray): ' + ArrName(Order[I]) + ';');
        GenReader(Order[I], Impl);
      END;
      IF WriteSet.IndexOf(Order[I]) >= 0 THEN
      BEGIN
        Decl.Add('FUNCTION ' + BaseName(Order[I]) + 'ToJson(CONST ARec: ' + TyName(Order[I]) + '): TJSONObject;');
        Decl.Add('FUNCTION ' + Copy(ArrName(Order[I]), 3, MaxInt) + 'ToJson(CONST AArr: ' + ArrName(Order[I]) + '): TJSONArray;');
        GenWriter(Order[I], Impl);
      END;
    END;
    Code.Add('// JSON <-> record conversions');
    Code.AddStrings(Decl);
    Code.Add('');
    Code.Add('IMPLEMENTATION');
    Code.Add('');
    Code.AddStrings(Impl);
    Code.Add('{ TCockpitItsmInstance }');
    Code.Add('');
    FOR I := 0 TO Sel.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sel[I]);
      GenMethod(Ep, ASelection.Values[Ep.Key], Code);
    END;
    Code.Add('END.');
    Result := Code.Text;
    ALog.Add(Format('%d method(s), %d record type(s) generated (spec %s)', [Sel.Count, Order.Count, FVersion]));
  FINALLY
    Sel.Free;
    Names.Free;
    ReadSet.Free;
    WriteSet.Free;
    AllSet.Free;
    Done.Free;
    Order.Free;
    Code.Free;
    Decl.Free;
    Impl.Free;
    Used.Free;
  END;
END;

{ Java generation }

FUNCTION TApiSpec.JClassName(CONST ACanon: STRING): STRING;
// Nested class name: never a type name used by the generated code
BEGIN
  Result := BaseName(ACanon);
  IF InArr(Result, JAVA_TYPE_NAMES) OR InArr(LowerCase(Result), JAVA_RESERVED) THEN
    Result := Result + '_';
END;

FUNCTION TApiSpec.JType(CONST AT: TTypeRef; ABoxed: Boolean): STRING;
// Java type; ABoxed = False: primitive type for the numbers and booleans (required parameters)
VAR
  E: TTypeRef;
BEGIN
  Result := '';
  CASE AT.Kind OF
    tkString, tkRaw: Result := 'String';
    tkInteger: IF ABoxed THEN Result := 'Integer' ELSE Result := 'int';
    tkInt64: IF ABoxed THEN Result := 'Long' ELSE Result := 'long';
    tkDouble: IF ABoxed THEN Result := 'Double' ELSE Result := 'double';
    tkBoolean: IF ABoxed THEN Result := 'Boolean' ELSE Result := 'boolean';
    tkDate: Result := 'java.time.Instant';
    tkDateOnly: Result := 'java.time.LocalDate';
    tkRecord: Result := JClassName(AT.RecName);
    tkArray:
      BEGIN
        E := AT;
        E.Kind := AT.ElemKind;
        Result := 'java.util.List<' + JType(E, True) + '>';
      END;
  END;
END;

FUNCTION JConv(AKind: TTypeKind): STRING;
// Core conversion of a JSON value (method reference)
BEGIN
  CASE AKind OF
    tkInteger: Result := 'CockpitItsmCore::toInt';
    tkInt64: Result := 'CockpitItsmCore::toLong';
    tkDouble: Result := 'CockpitItsmCore::toDouble';
    tkBoolean: Result := 'CockpitItsmCore::toBool';
    tkDate: Result := 'CockpitItsmCore::toDateTime';
    tkDateOnly: Result := 'CockpitItsmCore::toDate';
    tkRaw: Result := 'CockpitItsmCore::toRaw';
  ELSE
    Result := 'CockpitItsmCore::toStr';
  END;
END;

FUNCTION JWriteConv(AKind: TTypeKind): STRING;
// Conversion of a list item to a JSON value (method reference or lambda)
BEGIN
  CASE AKind OF
    tkDate: Result := 'CockpitItsmCore::fromDateTime';
    tkDateOnly: Result := 'CockpitItsmCore::fromDate';
  ELSE
    Result := 'x -> x';
  END;
END;

FUNCTION TApiSpec.JReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
// Expression converting the JSON value AValue (Object) to the Java type of AT
BEGIN
  CASE AT.Kind OF
    tkRecord: Result := JClassName(AT.RecName) + '.fromJson(asObj(' + AValue + '))';
    tkArray:
      IF AT.ElemKind = tkRecord THEN
        Result := JClassName(AT.RecName) + '.listFromJson(asArr(' + AValue + '))'
      ELSE
        Result := 'list(asArr(' + AValue + '), ' + JConv(AT.ElemKind) + ')';
  ELSE
    Result := Copy(JConv(AT.Kind), Length('CockpitItsmCore::') + 1, MaxInt) + '(' + AValue + ')';
  END;
END;

PROCEDURE TApiSpec.JGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
// Nested class: public fields (null = missing), fromJson / listFromJson (ARead),
// toJson / listToJson (AWrite, read-only members and null values not sent)
VAR
  T, Props, PS: TJSONObject;
  I: Integer;
  Used, Fields, Names: TStringList;
  Cls, Doc, F, N: STRING;
  TR: TTypeRef;
BEGIN
  T := SchemaObj(ACanon);
  Props := ObjObj(T, 'properties');
  Cls := JClassName(ACanon);
  Used := TStringList.Create;
  Fields := TStringList.Create;
  Names := TStringList.Create;
  TRY
    Doc := JDoc(CleanDoc(ObjStr(T, 'description'), 100));
    IF Doc <> '' THEN
      AOut.Add('    /** ' + Doc + ' */');
    AOut.Add('    public static class ' + Cls + ' {');
    IF Props <> NIL THEN
      FOR I := 0 TO Props.Count - 1 DO
      BEGIN
        IF Props.Items[I].JSONType <> jtObject THEN
          Continue;
        PS := TJSONObject(Props.Items[I]);
        N := Props.Names[I];
        F := JIdent(N);
        WHILE Used.IndexOf(F) >= 0 DO
          F := F + '_';
        Used.Add(F);
        Fields.AddObject(F, PS);
        Names.Add(N);
        Doc := JDoc(CleanDoc(ObjStr(PS, 'description'), 100));
        IF ObjBool(PS, 'readOnly') THEN
          Doc := Trim('[read-only] ' + Doc);
        IF Doc <> '' THEN
          AOut.Add('        /** ' + Doc + ' */');
        AOut.Add('        public ' + JType(TypeOf_(PS), True) + ' ' + F + ';');
      END;
    IF ARead THEN
    BEGIN
      AOut.Add('');
      AOut.Add('        public static ' + Cls + ' fromJson(JSONObject src) {');
      AOut.Add('            if (src == null) {');
      AOut.Add('                return null;');
      AOut.Add('            }');
      AOut.Add('            ' + Cls + ' res = new ' + Cls + '();');
      FOR I := 0 TO Fields.Count - 1 DO
        AOut.Add('            res.' + Fields[I] + ' = ' +
          JReadExpr(TypeOf_(TJSONObject(Fields.Objects[I])), 'src.opt(' + JQuote(Names[I]) + ')') + ';');
      AOut.Add('            return res;');
      AOut.Add('        }');
      AOut.Add('');
      AOut.Add('        public static java.util.List<' + Cls + '> listFromJson(JSONArray src) {');
      AOut.Add('            return list(src, v -> fromJson(asObj(v)));');
      AOut.Add('        }');
    END;
    IF AWrite THEN
    BEGIN
      AOut.Add('');
      AOut.Add('        public JSONObject toJson() {');
      AOut.Add('            JSONObject res = new JSONObject();');
      FOR I := 0 TO Fields.Count - 1 DO
      BEGIN
        PS := TJSONObject(Fields.Objects[I]);
        IF ObjBool(PS, 'readOnly') THEN
          Continue;
        TR := TypeOf_(PS);
        F := 'this.' + Fields[I];
        CASE TR.Kind OF
          tkRaw:
            AOut.Add('            putRaw(res, ' + JQuote(Names[I]) + ', ' + F + ');');
          tkRecord:
            AOut.Add('            put(res, ' + JQuote(Names[I]) + ', ' + F + ' == null ? null : ' + F + '.toJson());');
          tkArray:
            IF TR.ElemKind = tkRecord THEN
              AOut.Add('            put(res, ' + JQuote(Names[I]) + ', ' + F + ' == null ? null : ' +
                JClassName(TR.RecName) + '.listToJson(' + F + '));')
            ELSE
              AOut.Add('            put(res, ' + JQuote(Names[I]) + ', ' + F + ' == null ? null : array(' +
                F + ', ' + JWriteConv(TR.ElemKind) + '));');
        ELSE
          AOut.Add('            put(res, ' + JQuote(Names[I]) + ', ' + F + ');');
        END;
      END;
      AOut.Add('            return res;');
      AOut.Add('        }');
      AOut.Add('');
      AOut.Add('        public static JSONArray listToJson(java.util.List<' + Cls + '> items) {');
      AOut.Add('            return array(items, ' + Cls + '::toJson);');
      AOut.Add('        }');
    END;
    AOut.Add('    }');
    AOut.Add('');
  FINALLY
    Used.Free;
    Fields.Free;
    Names.Free;
  END;
END;

FUNCTION JParamName(CONST AP: TParamInfo): STRING;
// "organizationId" -> organizationId, "end-user" -> endUser
BEGIN
  Result := JIdent(LowerFirst(PascalWords(AP.Name)));
END;

FUNCTION TApiSpec.JSignature(AEp: TEndpoint; CONST AName: STRING; AWithCriteria: Boolean): STRING;
// Order: path params, required query params, body, optional query params (null = not sent)
VAR
  Parts: TStringList;
  I: Integer;
  Ret: STRING;
BEGIN
  Parts := TStringList.Create;
  TRY
    FOR I := 0 TO High(AEp.Params) DO
      IF AEp.Params[I].Loc = plPath THEN
        Parts.Add(JType(AEp.Params[I].TypeRef, False) + ' ' + AEp.Params[I].PasName);
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND AEp.Params[I].Required THEN
        Parts.Add(JType(AEp.Params[I].TypeRef, False) + ' ' + AEp.Params[I].PasName);
    IF (AEp.RespKind <> rkPaged) OR (AWithCriteria AND AEp.HasCriteria) THEN
      CASE AEp.BodyKind OF
        bkText, bkRaw: Parts.Add('String ' + AEp.BodyName);
        bkTyped: Parts.Add(JType(AEp.BodyType, True) + ' ' + AEp.BodyName);
      END;
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND NOT AEp.Params[I].Required THEN
        Parts.Add(JType(AEp.Params[I].TypeRef, True) + ' ' + AEp.Params[I].PasName);
    Result := '';
    FOR I := 0 TO Parts.Count - 1 DO
    BEGIN
      IF I > 0 THEN
        Result := Result + ', ';
      Result := Result + Parts[I];
    END;
  FINALLY
    Parts.Free;
  END;
  Ret := '';
  CASE AEp.RespKind OF
    rkNone: Ret := 'void';
    rkText, rkRaw: Ret := 'String';
    rkTyped, rkPaged: Ret := JType(AEp.RespType, True);
  END;
  Result := 'public ' + Ret + ' ' + AName + '(' + Result + ')';
END;

PROCEDURE TApiSpec.JGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
VAR
  I: Integer;
  P: TParamInfo;
  Url, Seg, Item, Body, Args, Doc, Ind: STRING;
  Segs: TStringArray;
  HasQ: Boolean;
  E: TTypeRef;

  FUNCTION QText(AKind: TTypeKind; CONST AValue: STRING): STRING;
  // Query value text
  BEGIN
    CASE AKind OF
      tkString, tkRaw: Result := AValue;
      tkDouble: Result := 'qDouble(' + AValue + ')';
      tkDate: Result := 'formatDateTime(' + AValue + ')';
      tkDateOnly: Result := 'formatDate(' + AValue + ')';
    ELSE
      Result := 'String.valueOf(' + AValue + ')';
    END;
  END;

BEGIN
  Doc := AEp.Method + ' ' + AEp.Path;
  IF AEp.Summary <> '' THEN
    Doc := Doc + ' - ' + CleanDoc(AEp.Summary, 120);
  IF AEp.RespKind = rkPaged THEN
    Doc := Doc + ' (all pages)';
  Doc := JDoc(Doc);
  // Overload without criteria
  IF (AEp.RespKind = rkPaged) AND AEp.HasCriteria THEN
  BEGIN
    Args := '';
    FOR I := 0 TO High(AEp.Params) DO
      IF AEp.Params[I].Loc = plPath THEN
        Args := Args + ', ' + AEp.Params[I].PasName;
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND AEp.Params[I].Required THEN
        Args := Args + ', ' + AEp.Params[I].PasName;
    Args := Args + ', (' + JType(AEp.BodyType, True) + ') null';
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND NOT AEp.Params[I].Required THEN
        Args := Args + ', ' + AEp.Params[I].PasName;
    AOut.Add('    /** ' + Doc + ', no criteria */');
    IF AEp.Deprecated THEN
      AOut.Add('    @Deprecated');
    AOut.Add('    ' + JSignature(AEp, AName, False) + ' {');
    AOut.Add('        return ' + AName + '(' + Copy(Args, 3, MaxInt) + ');');
    AOut.Add('    }');
    AOut.Add('');
  END;
  AOut.Add('    /** ' + Doc + IfThen(AEp.Deprecated, ' [DEPRECATED]', '') + ' */');
  IF AEp.Deprecated THEN
    AOut.Add('    @Deprecated');
  AOut.Add('    ' + JSignature(AEp, AName, True) + ' {');
  // URL with encoded path parameters
  Url := '';
  Segs := AEp.Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  FOR Seg IN Segs DO
  BEGIN
    IF Seg.StartsWith('{') THEN
    BEGIN
      Item := Copy(Seg, 2, Length(Seg) - 2);
      FOR I := 0 TO High(AEp.Params) DO
        IF (AEp.Params[I].Loc = plPath) AND (AEp.Params[I].Name = Item) THEN
        BEGIN
          P := AEp.Params[I];
          IF P.TypeRef.Kind = tkString THEN
            Url := Url + ' + "/" + urlEncode(' + P.PasName + ')'
          ELSE
            Url := Url + ' + "/" + ' + P.PasName;
        END;
    END
    ELSE
      Url := Url + ' + ' + JQuote('/' + Seg);
  END;
  Url := Copy(Url, 4, MaxInt);
  Url := StringReplace(Url, '" + "', '', [rfReplaceAll]);
  // Query
  HasQ := False;
  FOR I := 0 TO High(AEp.Params) DO
    IF AEp.Params[I].Loc = plQuery THEN
    BEGIN
      IF NOT HasQ THEN
        AOut.Add('        StringBuilder q = new StringBuilder();');
      HasQ := True;
      P := AEp.Params[I];
      IF P.TypeRef.Kind = tkArray THEN
      BEGIN
        E := P.TypeRef;
        E.Kind := P.TypeRef.ElemKind;
        AOut.Add('        if (' + P.PasName + ' != null) {');
        AOut.Add('            for (' + JType(E, True) + ' item : ' + P.PasName + ') {');
        AOut.Add('                if (item != null) {');
        AOut.Add('                    addQuery(q, ' + JQuote(P.Name) + ', ' + QText(E.Kind, 'item') + ');');
        AOut.Add('                }');
        AOut.Add('            }');
        AOut.Add('        }');
        Continue;
      END;
      Ind := '        ';
      IF NOT P.Required OR (P.TypeRef.Kind IN [tkString, tkRaw, tkDate, tkDateOnly]) THEN
      BEGIN
        AOut.Add('        if (' + P.PasName + ' != null) {');
        Ind := '            ';
      END;
      AOut.Add(Ind + 'addQuery(q, ' + JQuote(P.Name) + ', ' + QText(P.TypeRef.Kind, P.PasName) + ');');
      IF Ind <> '        ' THEN
        AOut.Add('        }');
    END;
  IF HasQ THEN
    Url := Url + ' + q';
  // Body
  Body := '';
  IF AEp.RespKind <> rkPaged THEN
    CASE AEp.BodyKind OF
      bkText, bkRaw: Body := AEp.BodyName;
      bkTyped:
        IF AEp.BodyType.Kind = tkRecord THEN
          Body := AEp.BodyName + '.toJson().toString()'
        ELSE IF AEp.BodyType.ElemKind = tkRecord THEN
          Body := JClassName(AEp.BodyType.RecName) + '.listToJson(' + AEp.BodyName + ').toString()'
        ELSE
          Body := 'array(' + AEp.BodyName + ', ' + JWriteConv(AEp.BodyType.ElemKind) + ').toString()';
    END;
  IF Body = '' THEN
    Body := 'null';
  CASE AEp.RespKind OF
    rkNone: AOut.Add('        call(' + JQuote(AEp.Method) + ', ' + Url + ', ' + Body + ');');
    rkRaw: AOut.Add('        return call(' + JQuote(AEp.Method) + ', ' + Url + ', ' + Body + ');');
    rkText: AOut.Add('        return unquote(call(' + JQuote(AEp.Method) + ', ' + Url + ', ' + Body + '));');
    rkTyped:
      IF AEp.RespType.Kind IN [tkRecord, tkArray] THEN
        AOut.Add('        return ' + JReadExpr(AEp.RespType, 'callJson(' + JQuote(AEp.Method) + ', ' + Url + ', ' + Body + ')') + ';')
      ELSE
        AOut.Add('        return ' + JReadExpr(AEp.RespType, 'unquote(call(' + JQuote(AEp.Method) + ', ' + Url + ', ' + Body + '))') + ';');
    rkPaged:
      BEGIN
        IF AEp.HasCriteria THEN
          AOut.Add('        JSONObject body = ' + AEp.BodyName + ' == null ? new JSONObject() : ' + AEp.BodyName + '.toJson();')
        ELSE
          AOut.Add('        JSONObject body = new JSONObject();');
        AOut.Add('        return ' + JClassName(AEp.RespType.RecName) + '.listFromJson(fetchAllPages(' + JQuote(AEp.Method) + ', ' +
          Url + ', body, ' + JQuote(AEp.PagePath) + '));');
      END;
  END;
  AOut.Add('    }');
  AOut.Add('');
END;

FUNCTION TApiSpec.GenerateJava(ASelection: TStrings; CONST AClassName: STRING; ALog: TStrings): STRING;
// ASelection: "METHOD /path=BaseName" lines (Java method name = baseName)
VAR
  Sel: TObjectList;
  Names, MethodNames, Used: TStringList;
  ReadSet, WriteSet, AllSet, Done, Order: TStringList;
  Code: TStringList;
  I, J, K: Integer;
  Ep: TEndpoint;
  Key, Nm, JN: STRING;
  SavedNames: ARRAY OF STRING;
  SavedBody: ARRAY OF STRING;
BEGIN
  IF NOT IsValidJavaIdent(AClassName) THEN
    RAISE Exception.Create('Invalid Java class name: ' + AClassName);
  Sel := TObjectList.Create(False);
  Names := TStringList.Create;
  MethodNames := TStringList.Create;
  Used := TStringList.Create;
  ReadSet := TStringList.Create;
  WriteSet := TStringList.Create;
  AllSet := TStringList.Create;
  Done := TStringList.Create;
  Order := TStringList.Create;
  Code := TStringList.Create;
  TRY
    FOR I := 0 TO ASelection.Count - 1 DO
    BEGIN
      Key := ASelection.Names[I];
      Nm := ASelection.ValueFromIndex[I];
      Ep := FindEndpoint(Key);
      IF Ep = NIL THEN
      BEGIN
        ALog.Add('MISSING from version ' + FVersion + ': ' + Key + ' (' + Nm + ') - skipped');
        Continue;
      END;
      IF NOT Ep.Supported THEN
      BEGIN
        ALog.Add('Unsupported: ' + Key + ' - ' + Ep.Reason);
        Continue;
      END;
      JN := LowerFirst(Nm);
      IF NOT IsValidJavaIdent(JN) OR (Names.IndexOf(JN) >= 0) THEN
        RAISE Exception.Create('Invalid or duplicate method name: ' + JN + ' (' + Key + ')');
      IF InArr(JN, JAVA_CORE_METHODS) THEN
        RAISE Exception.Create('Method name ' + JN + ' is used by CockpitItsmCore: rename ' + Key);
      Names.Add(JN);
      Sel.Add(Ep);
      MethodNames.Add(JN);
      IF (Ep.BodyKind = bkTyped) AND ((Ep.RespKind <> rkPaged) OR Ep.HasCriteria) THEN
        CollectTypes(Ep.BodyType, WriteSet, True);
      IF Ep.RespKind IN [rkTyped, rkPaged] THEN
        CollectTypes(Ep.RespType, ReadSet, False);
    END;
    IF Sel.Count = 0 THEN
      RAISE Exception.Create('No endpoint selected');

    // Java parameter names (PasName / BodyName are restored at the end:
    // the endpoints are shared with the Pascal generator)
    SetLength(SavedBody, Sel.Count);
    SetLength(SavedNames, 0);
    FOR I := 0 TO Sel.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sel[I]);
      SavedBody[I] := Ep.BodyName;
      FOR J := 0 TO High(Ep.Params) DO
      BEGIN
        SetLength(SavedNames, Length(SavedNames) + 1);
        SavedNames[High(SavedNames)] := Ep.Params[J].PasName;
      END;
    END;
    TRY
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Used.Clear;
        // local variables of the generated methods
        Used.Add('q');
        Used.Add('body');
        Used.Add('item');
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := JParamName(Ep.Params[J]);
          WHILE Used.IndexOf(Ep.Params[J].PasName) >= 0 DO
            Ep.Params[J].PasName := Ep.Params[J].PasName + '_';
          Used.Add(Ep.Params[J].PasName);
        END;
        CASE Ep.BodyKind OF
          bkText: Ep.BodyName := 'text';
          bkRaw: Ep.BodyName := 'json';
          bkTyped:
            IF Ep.RespKind = rkPaged THEN
              Ep.BodyName := 'criteria'
            ELSE IF Ep.BodyType.Kind = tkRecord THEN
              Ep.BodyName := JIdent(LowerFirst(BaseName(Ep.BodyType.RecName)))
            ELSE
              Ep.BodyName := 'items';
        ELSE
          Ep.BodyName := '';
        END;
        WHILE (Ep.BodyName <> '') AND (Used.IndexOf(Ep.BodyName) >= 0) DO
          Ep.BodyName := Ep.BodyName + '_';
      END;

      AllSet.AddStrings(ReadSet);
      AllSet.AddStrings(WriteSet);
      FOR I := 0 TO AllSet.Count - 1 DO
        SortTypes(AllSet[I], Done, Order);

      Code.Add('// Cockpit ITSM public API - GENERATED CLASS, do not edit (regenerate with CIPAT)');
      Code.Add('// Source: ' + JDoc(CleanDoc(FTitle, 80)) + ' ' + FVersion + ' - generated ' + FormatDateTime('yyyy-mm-dd hh:nn', Now));
      Code.Add('// Requires CockpitItsmCore.java (same folder) and org.json (JSONObject / JSONArray)');
      Code.Add('//');
      Code.Add('// Selected endpoints (read back by CIPAT when regenerating):');
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Code.Add(SELECTION_TAG + Ep.Method + ' ' + Ep.Path + ' ' + ASelection.Values[Ep.Key]);
      END;
      Code.Add('');
      Code.Add('import org.json.JSONArray;');
      Code.Add('import org.json.JSONObject;');
      Code.Add('');
      Code.Add('/**');
      Code.Add(' * Typed access to the selected endpoints of the Cockpit ITSM public API.');
      Code.Add(' * <pre>');
      Code.Add(' * ' + AClassName + ' api = new ' + AClassName + '(true, "tenant", "clientId", "clientSecret");');
      Code.Add(' * </pre>');
      Code.Add(' * Members and optional parameters: null = missing / not sent. Paged lists: all pages.');
      Code.Add(' * Errors: CockpitItsmCore.CockpitItsmException (HTTP status and response).');
      Code.Add(' */');
      Code.Add('public class ' + AClassName + ' extends CockpitItsmCore {');
      Code.Add('');
      Code.Add('    public ' + AClassName + '() {');
      Code.Add('    }');
      Code.Add('');
      Code.Add('    public ' + AClassName + '(boolean saas, String tenant, String clientId, String clientSecret) {');
      Code.Add('        super(saas, tenant, clientId, clientSecret);');
      Code.Add('    }');
      Code.Add('');
      Code.Add('    // ---------------------------------------------------------------- types');
      Code.Add('');
      FOR I := 0 TO Order.Count - 1 DO
        JGenClass(Order[I], ReadSet.IndexOf(Order[I]) >= 0, WriteSet.IndexOf(Order[I]) >= 0, Code);
      Code.Add('    // ---------------------------------------------------------------- endpoints');
      Code.Add('');
      FOR I := 0 TO Sel.Count - 1 DO
        JGenMethod(TEndpoint(Sel[I]), MethodNames[I], Code);
      // last empty line removed
      IF (Code.Count > 0) AND (Code[Code.Count - 1] = '') THEN
        Code.Delete(Code.Count - 1);
      Code.Add('}');
      Result := Code.Text;
      ALog.Add(Format('%d method(s), %d class(es) generated (spec %s)', [Sel.Count, Order.Count, FVersion]));
    FINALLY
      // Pascal names restored
      K := 0;
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Ep.BodyName := SavedBody[I];
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := SavedNames[K];
          Inc(K);
        END;
      END;
    END;
  FINALLY
    Sel.Free;
    Names.Free;
    MethodNames.Free;
    Used.Free;
    ReadSet.Free;
    WriteSet.Free;
    AllSet.Free;
    Done.Free;
    Order.Free;
    Code.Free;
  END;
END;


{ Python generation }

FUNCTION TApiSpec.PyClassName(CONST ACanon: STRING): STRING;
// Class name of a schema: never a name used by the generated code
BEGIN
  Result := PyIdent(BaseName(ACanon));
  IF InArr(Result, PY_TYPE_NAMES) THEN
    Result := Result + '_';
END;

FUNCTION TApiSpec.PyType(CONST AT: TTypeRef): STRING;
// Type annotation (not evaluated: "from __future__ import annotations")
VAR
  E: TTypeRef;
BEGIN
  Result := '';
  CASE AT.Kind OF
    tkString, tkRaw: Result := 'str';
    tkInteger, tkInt64: Result := 'int';
    tkDouble: Result := 'float';
    tkBoolean: Result := 'bool';
    tkDate: Result := 'datetime.datetime';
    tkDateOnly: Result := 'datetime.date';
    tkRecord: Result := PyClassName(AT.RecName);
    tkArray:
      BEGIN
        E := AT;
        E.Kind := AT.ElemKind;
        Result := 'List[' + PyType(E) + ']';
      END;
  END;
END;

FUNCTION PyConv(AKind: TTypeKind): STRING;
// Core function converting a JSON value
BEGIN
  CASE AKind OF
    tkInteger, tkInt64: Result := 'to_int';
    tkDouble: Result := 'to_float';
    tkBoolean: Result := 'to_bool';
    tkDate: Result := 'to_date_time';
    tkDateOnly: Result := 'to_date';
    tkRaw: Result := 'to_raw';
  ELSE
    Result := 'to_str';
  END;
END;

FUNCTION PyWriteConv(AKind: TTypeKind): STRING;
// Conversion of a list item to a JSON value ('' = none)
BEGIN
  CASE AKind OF
    tkDate: Result := ', from_date_time';
    tkDateOnly: Result := ', from_date';
  ELSE
    Result := '';
  END;
END;

FUNCTION TApiSpec.PyReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
// Expression converting the JSON value AValue to the Python type of AT
BEGIN
  CASE AT.Kind OF
    tkRecord: Result := PyClassName(AT.RecName) + '.from_json(' + AValue + ')';
    tkArray:
      IF AT.ElemKind = tkRecord THEN
        Result := PyClassName(AT.RecName) + '.list_from_json(' + AValue + ')'
      ELSE
        Result := 'list_of(' + AValue + ', ' + PyConv(AT.ElemKind) + ')';
  ELSE
    Result := PyConv(AT.Kind) + '(' + AValue + ')';
  END;
END;

PROCEDURE TApiSpec.PyGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
// Dataclass: fields default None (= missing / not sent), from_json / list_from_json (ARead),
// to_json / list_to_json (AWrite, read-only members and None values not sent)
VAR
  T, Props, PS: TJSONObject;
  I: Integer;
  Used, Fields, Names: TStringList;
  Cls, Doc, F, N: STRING;
  TR: TTypeRef;
BEGIN
  T := SchemaObj(ACanon);
  Props := ObjObj(T, 'properties');
  Cls := PyClassName(ACanon);
  Used := TStringList.Create;
  Fields := TStringList.Create;
  Names := TStringList.Create;
  TRY
    AOut.Add('@dataclass');
    AOut.Add('class ' + Cls + ':');
    Doc := PyDoc(CleanDoc(ObjStr(T, 'description'), 100));
    IF Doc <> '' THEN
      AOut.Add('    """' + Doc + '"""');
    IF Props <> NIL THEN
      FOR I := 0 TO Props.Count - 1 DO
      BEGIN
        IF Props.Items[I].JSONType <> jtObject THEN
          Continue;
        PS := TJSONObject(Props.Items[I]);
        N := Props.Names[I];
        F := PyIdent(N);
        IF InArr(F, PY_CLASS_MEMBERS) THEN
          F := F + '_';
        WHILE Used.IndexOf(F) >= 0 DO
          F := F + '_';
        Used.Add(F);
        Fields.AddObject(F, PS);
        Names.Add(N);
        Doc := CleanDoc(ObjStr(PS, 'description'), 100);
        IF ObjBool(PS, 'readOnly') THEN
          Doc := Trim('[read-only] ' + Doc);
        IF Doc <> '' THEN
          Doc := '  # ' + PyDoc(Doc);
        AOut.Add('    ' + F + ': Optional[' + PyType(TypeOf_(PS)) + '] = None' + Doc);
      END;
    IF ARead THEN
    BEGIN
      AOut.Add('');
      AOut.Add('    @classmethod');
      AOut.Add('    def from_json(cls, src: Any) -> Optional[' + Cls + ']:');
      AOut.Add('        if not isinstance(src, dict):');
      AOut.Add('            return None');
      IF Fields.Count = 0 THEN
        AOut.Add('        return cls()')
      ELSE
      BEGIN
        AOut.Add('        return cls(');
        FOR I := 0 TO Fields.Count - 1 DO
          AOut.Add('            ' + Fields[I] + '=' +
            PyReadExpr(TypeOf_(TJSONObject(Fields.Objects[I])), 'src.get(' + JQuote(Names[I]) + ')') + ',');
        AOut.Add('        )');
      END;
      AOut.Add('');
      AOut.Add('    @classmethod');
      AOut.Add('    def list_from_json(cls, src: Any) -> Optional[List[' + Cls + ']]:');
      AOut.Add('        return list_of(src, cls.from_json)');
    END;
    IF AWrite THEN
    BEGIN
      AOut.Add('');
      AOut.Add('    def to_json(self) -> Dict[str, Any]:');
      AOut.Add('        res: Dict[str, Any] = {}');
      FOR I := 0 TO Fields.Count - 1 DO
      BEGIN
        PS := TJSONObject(Fields.Objects[I]);
        IF ObjBool(PS, 'readOnly') THEN
          Continue;
        TR := TypeOf_(PS);
        F := 'self.' + Fields[I];
        CASE TR.Kind OF
          tkRaw:
            AOut.Add('        put_raw(res, ' + JQuote(Names[I]) + ', ' + F + ')');
          tkRecord:
            AOut.Add('        put(res, ' + JQuote(Names[I]) + ', None if ' + F + ' is None else ' + F + '.to_json())');
          tkArray:
            IF TR.ElemKind = tkRecord THEN
              AOut.Add('        put(res, ' + JQuote(Names[I]) + ', None if ' + F + ' is None else ' +
                PyClassName(TR.RecName) + '.list_to_json(' + F + '))')
            ELSE
              AOut.Add('        put(res, ' + JQuote(Names[I]) + ', None if ' + F + ' is None else array_of(' +
                F + PyWriteConv(TR.ElemKind) + '))');
        ELSE
          AOut.Add('        put(res, ' + JQuote(Names[I]) + ', ' + F + ')');
        END;
      END;
      AOut.Add('        return res');
      AOut.Add('');
      AOut.Add('    @staticmethod');
      AOut.Add('    def list_to_json(items: Optional[List[' + Cls + ']]) -> List[Any]:');
      AOut.Add('        return array_of(items, lambda x: x.to_json())');
    END;
    AOut.Add('');
    AOut.Add('');
  FINALLY
    Used.Free;
    Fields.Free;
    Names.Free;
  END;
END;

FUNCTION TApiSpec.PySignature(AEp: TEndpoint; CONST AName: STRING): STRING;
// def name(self, path params, required query params, body, *, optional query params = None)
// The criteria of a paged list are optional (None = no criteria).
// Long signatures: one parameter per line (the result then contains line breaks)
VAR
  Parts: TStringList;
  I: Integer;
  Ret, Line: STRING;
  Star: Boolean;
BEGIN
  Parts := TStringList.Create;
  TRY
    Parts.Add('self');
    FOR I := 0 TO High(AEp.Params) DO
      IF AEp.Params[I].Loc = plPath THEN
        Parts.Add(AEp.Params[I].PasName + ': ' + PyType(AEp.Params[I].TypeRef));
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND AEp.Params[I].Required THEN
        Parts.Add(AEp.Params[I].PasName + ': ' + PyType(AEp.Params[I].TypeRef));
    IF AEp.RespKind = rkPaged THEN
    BEGIN
      IF AEp.HasCriteria THEN
        Parts.Add(AEp.BodyName + ': Optional[' + PyType(AEp.BodyType) + '] = None');
    END
    ELSE
      CASE AEp.BodyKind OF
        bkText, bkRaw: Parts.Add(AEp.BodyName + ': str');
        bkTyped: Parts.Add(AEp.BodyName + ': ' + PyType(AEp.BodyType));
      END;
    Star := False;
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND NOT AEp.Params[I].Required THEN
      BEGIN
        IF NOT Star THEN
          Parts.Add('*');
        Star := True;
        Parts.Add(AEp.Params[I].PasName + ': Optional[' + PyType(AEp.Params[I].TypeRef) + '] = None');
      END;
    Ret := '';
    CASE AEp.RespKind OF
      rkNone: Ret := 'None';
      rkRaw: Ret := 'str';
      rkText: Ret := 'Optional[str]';
      rkTyped, rkPaged: Ret := 'Optional[' + PyType(AEp.RespType) + ']';
    END;
    Line := '';
    FOR I := 0 TO Parts.Count - 1 DO
    BEGIN
      IF I > 0 THEN
        Line := Line + ', ';
      Line := Line + Parts[I];
    END;
    Result := 'def ' + AName + '(' + Line + ') -> ' + Ret + ':';
    IF Length(Result) + 4 > 100 THEN
    BEGIN
      Result := 'def ' + AName + '(' + LineEnding;
      FOR I := 0 TO Parts.Count - 1 DO
        Result := Result + '        ' + Parts[I] + ',' + LineEnding;
      Result := Result + '    ) -> ' + Ret + ':';
    END;
  FINALLY
    Parts.Free;
  END;
END;

PROCEDURE TApiSpec.PyGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
VAR
  I: Integer;
  P: TParamInfo;
  Url, Seg, Item, Body, Doc, Call_: STRING;
  Segs: TStringArray;
  HasQ: Boolean;
BEGIN
  Doc := AEp.Method + ' ' + AEp.Path;
  IF AEp.Summary <> '' THEN
    Doc := Doc + ' - ' + CleanDoc(AEp.Summary, 120);
  IF AEp.RespKind = rkPaged THEN
    Doc := Doc + ' (all pages)';
  IF AEp.Deprecated THEN
    Doc := Doc + ' [DEPRECATED]';
  AOut.AddText('    ' + PySignature(AEp, AName));
  AOut.Add('        """' + PyDoc(Doc) + '"""');
  // URL with encoded path parameters
  Url := '';
  Segs := AEp.Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  FOR Seg IN Segs DO
  BEGIN
    IF Seg.StartsWith('{') THEN
    BEGIN
      Item := Copy(Seg, 2, Length(Seg) - 2);
      FOR I := 0 TO High(AEp.Params) DO
        IF (AEp.Params[I].Loc = plPath) AND (AEp.Params[I].Name = Item) THEN
          Url := Url + ' + "/" + url_encode(' + AEp.Params[I].PasName + ')';
    END
    ELSE
      Url := Url + ' + ' + JQuote('/' + Seg);
  END;
  Url := Copy(Url, 4, MaxInt);
  Url := StringReplace(Url, '" + "', '', [rfReplaceAll]);
  // Query (None values not sent, lists as repeated keys)
  HasQ := False;
  FOR I := 0 TO High(AEp.Params) DO
    IF AEp.Params[I].Loc = plQuery THEN
    BEGIN
      IF NOT HasQ THEN
        AOut.Add('        q: List[Tuple[str, str]] = []');
      HasQ := True;
      P := AEp.Params[I];
      AOut.Add('        add_query(q, ' + JQuote(P.Name) + ', ' + P.PasName + ')');
    END;
  IF HasQ THEN
    Url := Url + ' + query_string(q)';
  // Body
  Body := '';
  IF AEp.RespKind <> rkPaged THEN
    CASE AEp.BodyKind OF
      bkText, bkRaw: Body := AEp.BodyName;
      bkTyped:
        IF AEp.BodyType.Kind = tkRecord THEN
          Body := AEp.BodyName + '.to_json()'
        ELSE IF AEp.BodyType.ElemKind = tkRecord THEN
          Body := PyClassName(AEp.BodyType.RecName) + '.list_to_json(' + AEp.BodyName + ')'
        ELSE
          Body := 'array_of(' + AEp.BodyName + PyWriteConv(AEp.BodyType.ElemKind) + ')';
    END;
  IF Body = '' THEN
    Body := 'None';
  Call_ := '(' + JQuote(AEp.Method) + ', ' + Url + ', ' + Body + ')';
  CASE AEp.RespKind OF
    rkNone: AOut.Add('        self.call' + Call_);
    rkRaw: AOut.Add('        return self.call' + Call_);
    rkText: AOut.Add('        return unquote(self.call' + Call_ + ')');
    rkTyped:
      IF AEp.RespType.Kind IN [tkRecord, tkArray] THEN
        AOut.Add('        return ' + PyReadExpr(AEp.RespType, 'self.call_json' + Call_))
      ELSE
        AOut.Add('        return ' + PyReadExpr(AEp.RespType, 'unquote(self.call' + Call_ + ')'));
    rkPaged:
      BEGIN
        IF AEp.HasCriteria THEN
          AOut.Add('        body: Dict[str, Any] = {} if ' + AEp.BodyName + ' is None else ' + AEp.BodyName + '.to_json()')
        ELSE
          AOut.Add('        body: Dict[str, Any] = {}');
        AOut.Add('        return ' + PyClassName(AEp.RespType.RecName) + '.list_from_json(self.fetch_all_pages(' +
          JQuote(AEp.Method) + ', ' + Url + ', body, ' + JQuote(AEp.PagePath) + '))');
      END;
  END;
  AOut.Add('');
END;

FUNCTION TApiSpec.GeneratePython(ASelection: TStrings; CONST AModuleName: STRING; ALog: TStrings): STRING;
// ASelection: "METHOD /path=BaseName" lines (Python method name = snake_case of BaseName)
// Class name = PascalCase of the module name (cockpit_itsm_api -> CockpitItsmApi)
VAR
  Sel: TObjectList;
  Names, MethodNames, Used: TStringList;
  ReadSet, WriteSet, AllSet, Done, Order: TStringList;
  Code, Body, Imports: TStringList;
  Typing: STRING;
  I, J, K: Integer;
  Ep: TEndpoint;
  Key, Nm, PN, Cls: STRING;
  SavedNames: ARRAY OF STRING;
  SavedBody: ARRAY OF STRING;
BEGIN
  IF NOT IsValidPythonIdent(AModuleName) OR (AModuleName = PY_CORE_MODULE) THEN
    RAISE Exception.Create('Invalid Python module name: ' + AModuleName);
  Cls := PascalWords(AModuleName);
  IF NOT IsValidPythonIdent(Cls) OR InArr(Cls, PY_TYPE_NAMES) THEN
    RAISE Exception.Create('Invalid Python class name: ' + Cls + ' (from the module name)');
  Sel := TObjectList.Create(False);
  Names := TStringList.Create;
  MethodNames := TStringList.Create;
  Used := TStringList.Create;
  ReadSet := TStringList.Create;
  WriteSet := TStringList.Create;
  AllSet := TStringList.Create;
  Done := TStringList.Create;
  Order := TStringList.Create;
  Code := TStringList.Create;
  Body := TStringList.Create;
  Imports := TStringList.Create;
  TRY
    FOR I := 0 TO ASelection.Count - 1 DO
    BEGIN
      Key := ASelection.Names[I];
      Nm := ASelection.ValueFromIndex[I];
      Ep := FindEndpoint(Key);
      IF Ep = NIL THEN
      BEGIN
        ALog.Add('MISSING from version ' + FVersion + ': ' + Key + ' (' + Nm + ') - skipped');
        Continue;
      END;
      IF NOT Ep.Supported THEN
      BEGIN
        ALog.Add('Unsupported: ' + Key + ' - ' + Ep.Reason);
        Continue;
      END;
      PN := SnakeCase(Nm);
      IF NOT IsValidPythonIdent(PN) OR (Names.IndexOf(PN) >= 0) THEN
        RAISE Exception.Create('Invalid or duplicate method name: ' + PN + ' (' + Key + ')');
      IF InArr(PN, PY_CORE_METHODS) THEN
        RAISE Exception.Create('Method name ' + PN + ' is used by CockpitItsmCore: rename ' + Key);
      Names.Add(PN);
      Sel.Add(Ep);
      MethodNames.Add(PN);
      IF (Ep.BodyKind = bkTyped) AND ((Ep.RespKind <> rkPaged) OR Ep.HasCriteria) THEN
        CollectTypes(Ep.BodyType, WriteSet, True);
      IF Ep.RespKind IN [rkTyped, rkPaged] THEN
        CollectTypes(Ep.RespType, ReadSet, False);
    END;
    IF Sel.Count = 0 THEN
      RAISE Exception.Create('No endpoint selected');

    // Python parameter names (PasName / BodyName restored at the end:
    // the endpoints are shared with the other generators)
    SetLength(SavedBody, Sel.Count);
    SetLength(SavedNames, 0);
    FOR I := 0 TO Sel.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sel[I]);
      SavedBody[I] := Ep.BodyName;
      FOR J := 0 TO High(Ep.Params) DO
      BEGIN
        SetLength(SavedNames, Length(SavedNames) + 1);
        SavedNames[High(SavedNames)] := Ep.Params[J].PasName;
      END;
    END;
    TRY
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Used.Clear;
        // names used inside the generated methods
        Used.Add('self');
        Used.Add('q');
        Used.Add('body');
        Used.Add('str');
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := PyIdent(SnakeCase(Ep.Params[J].Name));
          WHILE Used.IndexOf(Ep.Params[J].PasName) >= 0 DO
            Ep.Params[J].PasName := Ep.Params[J].PasName + '_';
          Used.Add(Ep.Params[J].PasName);
        END;
        CASE Ep.BodyKind OF
          bkText: Ep.BodyName := 'text';
          bkRaw: Ep.BodyName := 'json_text';
          bkTyped:
            IF Ep.RespKind = rkPaged THEN
              Ep.BodyName := 'criteria'
            ELSE IF Ep.BodyType.Kind = tkRecord THEN
              Ep.BodyName := PyIdent(SnakeCase(BaseName(Ep.BodyType.RecName)))
            ELSE
              Ep.BodyName := 'items';
        ELSE
          Ep.BodyName := '';
        END;
        WHILE (Ep.BodyName <> '') AND (Used.IndexOf(Ep.BodyName) >= 0) DO
          Ep.BodyName := Ep.BodyName + '_';
      END;

      AllSet.AddStrings(ReadSet);
      AllSet.AddStrings(WriteSet);
      FOR I := 0 TO AllSet.Count - 1 DO
        SortTypes(AllSet[I], Done, Order);
      FOR I := 0 TO Order.Count - 1 DO
        IF PyClassName(Order[I]) = Cls THEN
          RAISE Exception.Create('Class name ' + Cls + ' is used by a schema: choose another module name');

      Body.Add('# ------------------------------------------------------------------ types');
      Body.Add('');
      FOR I := 0 TO Order.Count - 1 DO
        PyGenClass(Order[I], ReadSet.IndexOf(Order[I]) >= 0, WriteSet.IndexOf(Order[I]) >= 0, Body);
      Body.Add('# ------------------------------------------------------------------ endpoints');
      Body.Add('');
      Body.Add('');
      Body.Add('class ' + Cls + '(CockpitItsmCore):');
      Body.Add('    """Cockpit ITSM API: one method per selected endpoint."""');
      Body.Add('');
      FOR I := 0 TO Sel.Count - 1 DO
        PyGenMethod(TEndpoint(Sel[I]), MethodNames[I], Body);
      IF (Body.Count > 0) AND (Body[Body.Count - 1] = '') THEN
        Body.Delete(Body.Count - 1);
      Code.Add('# Cockpit ITSM public API - GENERATED MODULE, do not edit (regenerate with CIPAT)');
      Code.Add('# Source: ' + PyDoc(CleanDoc(FTitle, 80)) + ' ' + FVersion + ' - generated ' + FormatDateTime('yyyy-mm-dd hh:nn', Now));
      Code.Add('# Requires ' + PY_CORE_MODULE + '.py (same folder), Python 3.8+, standard library only');
      Code.Add('#');
      Code.Add('# Selected endpoints (read back by CIPAT when regenerating):');
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Code.Add('# ' + Copy(SELECTION_TAG, 4, MaxInt) + Ep.Method + ' ' + Ep.Path + ' ' + ASelection.Values[Ep.Key]);
      END;
      Code.Add('');
      Code.Add('"""Typed access to the selected endpoints of the Cockpit ITSM public API.');
      Code.Add('');
      Code.Add('    api = ' + Cls + '(True, "tenant", "client_id", "client_secret")');
      Code.Add('');
      Code.Add('Fields and optional parameters: None = missing / not sent. Paged lists: all pages.');
      Code.Add('Errors: CockpitItsmError (status_code, response).');
      Code.Add('"""');
      Code.Add('');
      Code.Add('from __future__ import annotations');
      Code.Add('');
      IF Pos('datetime.', Body.Text) > 0 THEN
        Code.Add('import datetime');
      Code.Add('from dataclasses import dataclass');
      Typing := '';
      FOR I := 0 TO High(PY_TYPING) DO
        IF (Pos(PY_TYPING[I] + '[', Body.Text) > 0) OR (Pos(PY_TYPING[I] + ']', Body.Text) > 0)
          OR (Pos(PY_TYPING[I] + ',', Body.Text) > 0) OR (Pos(': ' + PY_TYPING[I] + ')', Body.Text) > 0) THEN
          Typing := Typing + ', ' + PY_TYPING[I];
      IF Typing <> '' THEN
        Code.Add('from typing import ' + Copy(Typing, 3, MaxInt));
      Code.Add('');
      // Only the helpers used by the generated code are imported
      Imports.Add('from ' + PY_CORE_MODULE + ' import (');
      Imports.Add('    CockpitItsmCore,');
      Imports.Add('    CockpitItsmError,');
      FOR I := 0 TO High(PY_HELPERS) DO
        IF (Pos(PY_HELPERS[I] + '(', Body.Text) > 0) OR (Pos(' ' + PY_HELPERS[I] + ')', Body.Text) > 0) THEN
          Imports.Add('    ' + PY_HELPERS[I] + ',');
      Imports.Add(')');
      Code.AddStrings(Imports);
      Code.Add('');
      Code.Add('__all__ = ["' + Cls + '", "CockpitItsmError"]');
      Code.Add('');
      Code.Add('');
      Code.AddStrings(Body);
      IF (Code.Count > 0) AND (Code[Code.Count - 1] = '') THEN
        Code.Delete(Code.Count - 1);
      Result := Code.Text;
      ALog.Add(Format('%d method(s), %d class(es) generated (spec %s)', [Sel.Count, Order.Count, FVersion]));
    FINALLY
      // Pascal names restored
      K := 0;
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Ep.BodyName := SavedBody[I];
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := SavedNames[K];
          Inc(K);
        END;
      END;
    END;
  FINALLY
    Sel.Free;
    Names.Free;
    MethodNames.Free;
    Used.Free;
    ReadSet.Free;
    WriteSet.Free;
    AllSet.Free;
    Done.Free;
    Order.Free;
    Code.Free;
    Body.Free;
    Imports.Free;
  END;
END;


{ Node.js generation }

FUNCTION TApiSpec.JsClassName(CONST ACanon: STRING): STRING;
// Name of a schema (JSDoc type and converter object): never a name used by the module
BEGIN
  Result := JsIdent(BaseName(ACanon));
  IF InArr(Result, JS_TYPE_NAMES) THEN
    Result := Result + '_';
END;

FUNCTION TApiSpec.JsType(CONST AT: TTypeRef): STRING;
// JSDoc type
VAR
  E: TTypeRef;
BEGIN
  Result := '';
  CASE AT.Kind OF
    tkString, tkRaw, tkDateOnly: Result := 'string';
    tkInteger, tkInt64, tkDouble: Result := 'number';
    tkBoolean: Result := 'boolean';
    tkDate: Result := 'Date';
    tkRecord: Result := JsClassName(AT.RecName);
    tkArray:
      BEGIN
        E := AT;
        E.Kind := AT.ElemKind;
        Result := JsType(E) + '[]';
      END;
  END;
END;

FUNCTION JsConv(AKind: TTypeKind): STRING;
// Core function converting a JSON value
BEGIN
  CASE AKind OF
    tkInteger, tkInt64, tkDouble: Result := 'toNum';
    tkBoolean: Result := 'toBool';
    tkDate: Result := 'toDateTime';
    tkDateOnly: Result := 'toDate';
    tkRaw: Result := 'toRaw';
  ELSE
    Result := 'toStr';
  END;
END;

FUNCTION JsWriteConv(AKind: TTypeKind): STRING;
// Conversion of a list item to a JSON value ('' = none)
BEGIN
  IF AKind = tkDate THEN
    Result := ', fromDateTime'
  ELSE
    Result := '';
END;

FUNCTION TApiSpec.JsReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
// Expression converting the JSON value AValue to the JavaScript type of AT
BEGIN
  CASE AT.Kind OF
    tkRecord: Result := JsClassName(AT.RecName) + '.fromJson(' + AValue + ')';
    tkArray:
      IF AT.ElemKind = tkRecord THEN
        Result := JsClassName(AT.RecName) + '.listFromJson(' + AValue + ')'
      ELSE
        Result := 'listOf(' + AValue + ', ' + JsConv(AT.ElemKind) + ')';
  ELSE
    Result := JsConv(AT.Kind) + '(' + AValue + ')';
  END;
END;

PROCEDURE TApiSpec.JsGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
// JSDoc type (plain object, members undefined = missing / not sent) and converter object:
// fromJson / listFromJson (ARead), toJson / listToJson (AWrite, read-only members and
// undefined / null values not sent)
VAR
  T, Props, PS: TJSONObject;
  I: Integer;
  Used, Fields, Names: TStringList;
  Cls, Doc, F, N, V: STRING;
  TR: TTypeRef;
BEGIN
  T := SchemaObj(ACanon);
  Props := ObjObj(T, 'properties');
  Cls := JsClassName(ACanon);
  Used := TStringList.Create;
  Fields := TStringList.Create;
  Names := TStringList.Create;
  TRY
    AOut.Add('/**');
    Doc := JDoc(CleanDoc(ObjStr(T, 'description'), 100));
    IF Doc <> '' THEN
      AOut.Add(' * ' + Doc);
    AOut.Add(' * @typedef {Object} ' + Cls);
    IF Props <> NIL THEN
      FOR I := 0 TO Props.Count - 1 DO
      BEGIN
        IF Props.Items[I].JSONType <> jtObject THEN
          Continue;
        PS := TJSONObject(Props.Items[I]);
        N := Props.Names[I];
        // JSON name kept when it is an identifier (reserved words are valid member names)
        F := JsIdent(N);
        IF (F <> N) AND (F = N + '_') THEN
          F := N;
        WHILE Used.IndexOf(F) >= 0 DO
          F := F + '_';
        Used.Add(F);
        Fields.AddObject(F, PS);
        Names.Add(N);
        Doc := JDoc(CleanDoc(ObjStr(PS, 'description'), 100));
        IF ObjBool(PS, 'readOnly') THEN
          Doc := Trim('[read-only] ' + Doc);
        AOut.Add(TrimRight(' * @property {' + JsType(TypeOf_(PS)) + '} [' + F + '] ' + Doc));
      END;
    AOut.Add(' */');
    AOut.Add('');
    IF NOT ARead AND NOT AWrite THEN
      Exit;
    AOut.Add('/** JSON conversion of ' + Cls + ' */');
    AOut.Add('export const ' + Cls + ' = {');
    IF ARead THEN
    BEGIN
      AOut.Add('  /**');
      AOut.Add('   * @param {unknown} src');
      AOut.Add('   * @returns {' + Cls + ' | undefined}');
      AOut.Add('   */');
      AOut.Add('  fromJson(src) {');
      AOut.Add('    const o = asObj(src);');
      AOut.Add('    if (!o) return undefined;');
      IF Fields.Count = 0 THEN
        AOut.Add('    return {};')
      ELSE
      BEGIN
        AOut.Add('    return {');
        FOR I := 0 TO Fields.Count - 1 DO
          AOut.Add('      ' + Fields[I] + ': ' +
            JsReadExpr(TypeOf_(TJSONObject(Fields.Objects[I])), 'o[' + JQuote(Names[I]) + ']') + ',');
        AOut.Add('    };');
      END;
      AOut.Add('  },');
      AOut.Add('  /**');
      AOut.Add('   * @param {unknown} src');
      AOut.Add('   * @returns {' + Cls + '[] | undefined}');
      AOut.Add('   */');
      AOut.Add('  listFromJson(src) {');
      AOut.Add('    return listOf(src, ' + Cls + '.fromJson);');
      AOut.Add('  },');
    END;
    IF AWrite THEN
    BEGIN
      AOut.Add('  /**');
      AOut.Add('   * @param {' + Cls + '} v');
      AOut.Add('   * @returns {Record<string, any>}');
      AOut.Add('   */');
      AOut.Add('  toJson(v) {');
      AOut.Add('    /** @type {Record<string, any>} */');
      AOut.Add('    const res = {};');
      FOR I := 0 TO Fields.Count - 1 DO
      BEGIN
        PS := TJSONObject(Fields.Objects[I]);
        IF ObjBool(PS, 'readOnly') THEN
          Continue;
        TR := TypeOf_(PS);
        V := 'v.' + Fields[I];
        CASE TR.Kind OF
          tkRaw:
            AOut.Add('    putRaw(res, ' + JQuote(Names[I]) + ', ' + V + ');');
          tkRecord:
            AOut.Add('    put(res, ' + JQuote(Names[I]) + ', ' + V + ' == null ? undefined : ' +
              JsClassName(TR.RecName) + '.toJson(' + V + '));');
          tkArray:
            IF TR.ElemKind = tkRecord THEN
              AOut.Add('    put(res, ' + JQuote(Names[I]) + ', ' + V + ' == null ? undefined : ' +
                JsClassName(TR.RecName) + '.listToJson(' + V + '));')
            ELSE
              AOut.Add('    put(res, ' + JQuote(Names[I]) + ', ' + V + ' == null ? undefined : arrayOf(' +
                V + JsWriteConv(TR.ElemKind) + '));');
        ELSE
          AOut.Add('    put(res, ' + JQuote(Names[I]) + ', ' + V + ');');
        END;
      END;
      AOut.Add('    return res;');
      AOut.Add('  },');
      AOut.Add('  /**');
      AOut.Add('   * @param {' + Cls + '[] | undefined} items');
      AOut.Add('   * @returns {any[]}');
      AOut.Add('   */');
      AOut.Add('  listToJson(items) {');
      AOut.Add('    return arrayOf(items, ' + Cls + '.toJson);');
      AOut.Add('  },');
    END;
    AOut.Add('};');
    AOut.Add('');
  FINALLY
    Used.Free;
    Fields.Free;
    Names.Free;
  END;
END;

PROCEDURE TApiSpec.JsGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
// async name(path params, required query params, body, options = {})
// options: optional query parameters (undefined = not sent); the criteria of a paged
// list are optional (undefined = no criteria)
VAR
  I: Integer;
  P: TParamInfo;
  Url, Seg, Item, Body, Args, Ret, Opt, Call_: STRING;
  Segs: TStringArray;
  HasQ, HasOpt: Boolean;
BEGIN
  AOut.Add('  /**');
  Item := AEp.Method + ' ' + AEp.Path;
  IF AEp.Summary <> '' THEN
    Item := Item + ' - ' + CleanDoc(AEp.Summary, 120);
  IF AEp.RespKind = rkPaged THEN
    Item := Item + ' (all pages)';
  AOut.Add('   * ' + JDoc(Item));
  IF AEp.Deprecated THEN
    AOut.Add('   * @deprecated');
  Args := '';
  FOR I := 0 TO High(AEp.Params) DO
    IF AEp.Params[I].Loc = plPath THEN
    BEGIN
      AOut.Add('   * @param {' + JsType(AEp.Params[I].TypeRef) + '} ' + AEp.Params[I].PasName);
      Args := Args + ', ' + AEp.Params[I].PasName;
    END;
  FOR I := 0 TO High(AEp.Params) DO
    IF (AEp.Params[I].Loc = plQuery) AND AEp.Params[I].Required THEN
    BEGIN
      AOut.Add('   * @param {' + JsType(AEp.Params[I].TypeRef) + '} ' + AEp.Params[I].PasName);
      Args := Args + ', ' + AEp.Params[I].PasName;
    END;
  IF AEp.RespKind = rkPaged THEN
  BEGIN
    IF AEp.HasCriteria THEN
    BEGIN
      AOut.Add('   * @param {' + JsType(AEp.BodyType) + '} [' + AEp.BodyName + '] criteria (undefined = none)');
      Args := Args + ', ' + AEp.BodyName;
    END;
  END
  ELSE IF AEp.BodyKind <> bkNone THEN
  BEGIN
    CASE AEp.BodyKind OF
      bkText: AOut.Add('   * @param {string} ' + AEp.BodyName + ' text sent as is');
      bkRaw: AOut.Add('   * @param {string} ' + AEp.BodyName + ' JSON text');
      bkTyped: AOut.Add('   * @param {' + JsType(AEp.BodyType) + '} ' + AEp.BodyName);
    END;
    Args := Args + ', ' + AEp.BodyName;
  END;
  Opt := '';
  HasOpt := False;
  FOR I := 0 TO High(AEp.Params) DO
    IF (AEp.Params[I].Loc = plQuery) AND NOT AEp.Params[I].Required THEN
    BEGIN
      IF HasOpt THEN
        Opt := Opt + ', ';
      HasOpt := True;
      Opt := Opt + AEp.Params[I].PasName + '?: ' + JsType(AEp.Params[I].TypeRef);
    END;
  IF HasOpt THEN
  BEGIN
    AOut.Add('   * @param {{' + Opt + '}} [options] optional query parameters (undefined = not sent)');
    Args := Args + ', options = {}';
  END;
  Ret := '';
  CASE AEp.RespKind OF
    rkNone: Ret := 'void';
    rkRaw: Ret := 'string';
    rkText: Ret := 'string | undefined';
    rkTyped, rkPaged: Ret := JsType(AEp.RespType) + ' | undefined';
  END;
  AOut.Add('   * @returns {Promise<' + Ret + '>}');
  AOut.Add('   */');
  AOut.Add('  async ' + AName + '(' + Copy(Args, 3, MaxInt) + ') {');
  // URL with encoded path parameters
  Url := '';
  Segs := AEp.Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  FOR Seg IN Segs DO
  BEGIN
    IF Seg.StartsWith('{') THEN
    BEGIN
      Item := Copy(Seg, 2, Length(Seg) - 2);
      FOR I := 0 TO High(AEp.Params) DO
        IF (AEp.Params[I].Loc = plPath) AND (AEp.Params[I].Name = Item) THEN
          Url := Url + ' + "/" + urlEncode(' + AEp.Params[I].PasName + ')';
    END
    ELSE
      Url := Url + ' + ' + JQuote('/' + Seg);
  END;
  Url := Copy(Url, 4, MaxInt);
  Url := StringReplace(Url, '" + "', '', [rfReplaceAll]);
  // Query
  HasQ := False;
  FOR I := 0 TO High(AEp.Params) DO
    IF AEp.Params[I].Loc = plQuery THEN
    BEGIN
      IF NOT HasQ THEN
      BEGIN
        AOut.Add('    /** @type {Array<[string, string]>} */');
        AOut.Add('    const q = [];');
      END;
      HasQ := True;
      P := AEp.Params[I];
      IF P.Required THEN
        AOut.Add('    addQuery(q, ' + JQuote(P.Name) + ', ' + P.PasName + ');')
      ELSE
        AOut.Add('    addQuery(q, ' + JQuote(P.Name) + ', options.' + P.PasName + ');');
    END;
  IF HasQ THEN
    Url := Url + ' + queryString(q)';
  // Body
  Body := '';
  IF AEp.RespKind <> rkPaged THEN
    CASE AEp.BodyKind OF
      bkText, bkRaw: Body := AEp.BodyName;
      bkTyped:
        IF AEp.BodyType.Kind = tkRecord THEN
          Body := JsClassName(AEp.BodyType.RecName) + '.toJson(' + AEp.BodyName + ')'
        ELSE IF AEp.BodyType.ElemKind = tkRecord THEN
          Body := JsClassName(AEp.BodyType.RecName) + '.listToJson(' + AEp.BodyName + ')'
        ELSE
          Body := 'arrayOf(' + AEp.BodyName + JsWriteConv(AEp.BodyType.ElemKind) + ')';
    END;
  IF Body = '' THEN
    Call_ := '(' + JQuote(AEp.Method) + ', ' + Url + ')'
  ELSE
    Call_ := '(' + JQuote(AEp.Method) + ', ' + Url + ', ' + Body + ')';
  CASE AEp.RespKind OF
    rkNone: AOut.Add('    await this.call' + Call_ + ';');
    rkRaw: AOut.Add('    return this.call' + Call_ + ';');
    rkText: AOut.Add('    return unquote(await this.call' + Call_ + ');');
    rkTyped:
      IF AEp.RespType.Kind IN [tkRecord, tkArray] THEN
        AOut.Add('    return ' + JsReadExpr(AEp.RespType, 'await this.callJson' + Call_) + ';')
      ELSE
        AOut.Add('    return ' + JsReadExpr(AEp.RespType, 'unquote(await this.call' + Call_ + ')') + ';');
    rkPaged:
      BEGIN
        IF AEp.HasCriteria THEN
          AOut.Add('    const body = ' + AEp.BodyName + ' == null ? {} : ' + JsClassName(AEp.BodyType.RecName) +
            '.toJson(' + AEp.BodyName + ');')
        ELSE
          AOut.Add('    const body = {};');
        AOut.Add('    return ' + JsClassName(AEp.RespType.RecName) + '.listFromJson(await this.fetchAllPages(' +
          JQuote(AEp.Method) + ', ' + Url + ', body, ' + JQuote(AEp.PagePath) + '));');
      END;
  END;
  AOut.Add('  }');
  AOut.Add('');
END;

FUNCTION TApiSpec.GenerateNode(ASelection: TStrings; CONST AModuleName: STRING; ALog: TStrings): STRING;
// ASelection: "METHOD /path=BaseName" lines (method name = baseName)
// AModuleName: file name without extension (cockpit-itsm-api); class name = its
// PascalCase form (CockpitItsmApi)
VAR
  Sel: TObjectList;
  Names, MethodNames, Used: TStringList;
  ReadSet, WriteSet, AllSet, Done, Order: TStringList;
  Code, Body: TStringList;
  I, J, K: Integer;
  Ep: TEndpoint;
  Key, Nm, JN, Cls: STRING;
  SavedNames: ARRAY OF STRING;
  SavedBody: ARRAY OF STRING;
BEGIN
  Cls := PascalWords(AModuleName);
  IF (AModuleName = '') OR (AModuleName = JS_CORE_MODULE) OR NOT IsValidJsIdent(Cls) OR InArr(Cls, JS_TYPE_NAMES) THEN
    RAISE Exception.Create('Invalid Node.js module name: ' + AModuleName);
  Sel := TObjectList.Create(False);
  Names := TStringList.Create;
  MethodNames := TStringList.Create;
  Used := TStringList.Create;
  ReadSet := TStringList.Create;
  WriteSet := TStringList.Create;
  AllSet := TStringList.Create;
  Done := TStringList.Create;
  Order := TStringList.Create;
  Code := TStringList.Create;
  Body := TStringList.Create;
  TRY
    FOR I := 0 TO ASelection.Count - 1 DO
    BEGIN
      Key := ASelection.Names[I];
      Nm := ASelection.ValueFromIndex[I];
      Ep := FindEndpoint(Key);
      IF Ep = NIL THEN
      BEGIN
        ALog.Add('MISSING from version ' + FVersion + ': ' + Key + ' (' + Nm + ') - skipped');
        Continue;
      END;
      IF NOT Ep.Supported THEN
      BEGIN
        ALog.Add('Unsupported: ' + Key + ' - ' + Ep.Reason);
        Continue;
      END;
      JN := LowerFirst(Nm);
      IF NOT IsValidJsIdent(JN) OR (Names.IndexOf(JN) >= 0) THEN
        RAISE Exception.Create('Invalid or duplicate method name: ' + JN + ' (' + Key + ')');
      IF InArr(JN, JS_CORE_METHODS) THEN
        RAISE Exception.Create('Method name ' + JN + ' is used by CockpitItsmCore: rename ' + Key);
      Names.Add(JN);
      Sel.Add(Ep);
      MethodNames.Add(JN);
      IF (Ep.BodyKind = bkTyped) AND ((Ep.RespKind <> rkPaged) OR Ep.HasCriteria) THEN
        CollectTypes(Ep.BodyType, WriteSet, True);
      IF Ep.RespKind IN [rkTyped, rkPaged] THEN
        CollectTypes(Ep.RespType, ReadSet, False);
    END;
    IF Sel.Count = 0 THEN
      RAISE Exception.Create('No endpoint selected');

    // JavaScript parameter names (PasName / BodyName restored at the end:
    // the endpoints are shared with the other generators)
    SetLength(SavedBody, Sel.Count);
    SetLength(SavedNames, 0);
    FOR I := 0 TO Sel.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sel[I]);
      SavedBody[I] := Ep.BodyName;
      FOR J := 0 TO High(Ep.Params) DO
      BEGIN
        SetLength(SavedNames, Length(SavedNames) + 1);
        SavedNames[High(SavedNames)] := Ep.Params[J].PasName;
      END;
    END;
    TRY
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Used.Clear;
        // names used inside the generated methods
        Used.Add('q');
        Used.Add('body');
        Used.Add('options');
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := JsIdent(LowerFirst(PascalWords(Ep.Params[J].Name)));
          WHILE Used.IndexOf(Ep.Params[J].PasName) >= 0 DO
            Ep.Params[J].PasName := Ep.Params[J].PasName + '_';
          Used.Add(Ep.Params[J].PasName);
        END;
        CASE Ep.BodyKind OF
          bkText: Ep.BodyName := 'text';
          bkRaw: Ep.BodyName := 'json';
          bkTyped:
            IF Ep.RespKind = rkPaged THEN
              Ep.BodyName := 'criteria'
            ELSE IF Ep.BodyType.Kind = tkRecord THEN
              Ep.BodyName := JsIdent(LowerFirst(BaseName(Ep.BodyType.RecName)))
            ELSE
              Ep.BodyName := 'items';
        ELSE
          Ep.BodyName := '';
        END;
        WHILE (Ep.BodyName <> '') AND (Used.IndexOf(Ep.BodyName) >= 0) DO
          Ep.BodyName := Ep.BodyName + '_';
      END;

      AllSet.AddStrings(ReadSet);
      AllSet.AddStrings(WriteSet);
      FOR I := 0 TO AllSet.Count - 1 DO
        SortTypes(AllSet[I], Done, Order);
      FOR I := 0 TO Order.Count - 1 DO
        IF JsClassName(Order[I]) = Cls THEN
          RAISE Exception.Create('Class name ' + Cls + ' is used by a schema: choose another module name');

      Body.Add('// ------------------------------------------------------------------ types');
      Body.Add('');
      FOR I := 0 TO Order.Count - 1 DO
        JsGenClass(Order[I], ReadSet.IndexOf(Order[I]) >= 0, WriteSet.IndexOf(Order[I]) >= 0, Body);
      Body.Add('// ------------------------------------------------------------------ endpoints');
      Body.Add('');
      Body.Add('/**');
      Body.Add(' * Typed access to the selected endpoints of the Cockpit ITSM public API.');
      Body.Add(' * Members and optional parameters: undefined = missing / not sent. Paged lists: all pages.');
      Body.Add(' * Errors: CockpitItsmError (statusCode, response).');
      Body.Add(' *');
      Body.Add(' *     const api = new ' + Cls + '(true, ''tenant'', ''clientId'', ''clientSecret'');');
      Body.Add(' */');
      Body.Add('export class ' + Cls + ' extends CockpitItsmCore {');
      FOR I := 0 TO Sel.Count - 1 DO
        JsGenMethod(TEndpoint(Sel[I]), MethodNames[I], Body);
      IF (Body.Count > 0) AND (Body[Body.Count - 1] = '') THEN
        Body.Delete(Body.Count - 1);
      Body.Add('}');

      Code.Add('// Cockpit ITSM public API - GENERATED MODULE, do not edit (regenerate with CIPAT)');
      Code.Add('// Source: ' + JDoc(CleanDoc(FTitle, 80)) + ' ' + FVersion + ' - generated ' + FormatDateTime('yyyy-mm-dd hh:nn', Now));
      Code.Add('// Requires ' + JS_CORE_MODULE + '.mjs (same folder), Node.js 18+, no dependency');
      Code.Add('//');
      Code.Add('// Selected endpoints (read back by CIPAT when regenerating):');
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Code.Add(SELECTION_TAG + Ep.Method + ' ' + Ep.Path + ' ' + ASelection.Values[Ep.Key]);
      END;
      Code.Add('');
      // Only the helpers used by the generated code are imported
      Code.Add('import {');
      Code.Add('  CockpitItsmCore,');
      Code.Add('  CockpitItsmError,');
      FOR I := 0 TO High(JS_HELPERS) DO
        IF (Pos(JS_HELPERS[I] + '(', Body.Text) > 0) OR (Pos(' ' + JS_HELPERS[I] + ')', Body.Text) > 0) THEN
          Code.Add('  ' + JS_HELPERS[I] + ',');
      Code.Add('} from ''./' + JS_CORE_MODULE + '.mjs'';');
      Code.Add('');
      Code.Add('export { CockpitItsmError };');
      Code.Add('');
      Code.AddStrings(Body);
      Result := Code.Text;
      ALog.Add(Format('%d method(s), %d type(s) generated (spec %s)', [Sel.Count, Order.Count, FVersion]));
    FINALLY
      // Pascal names restored
      K := 0;
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Ep.BodyName := SavedBody[I];
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := SavedNames[K];
          Inc(K);
        END;
      END;
    END;
  FINALLY
    Sel.Free;
    Names.Free;
    MethodNames.Free;
    Used.Free;
    ReadSet.Free;
    WriteSet.Free;
    AllSet.Free;
    Done.Free;
    Order.Free;
    Code.Free;
    Body.Free;
  END;
END;


{ C# generation }

FUNCTION CsDoc(CONST S: STRING): STRING;
// XML documentation text
BEGIN
  Result := StringReplace(S, '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
END;

FUNCTION TApiSpec.CsClassName(CONST ACanon: STRING): STRING;
// Class of a schema: never a type name used by the generated code
BEGIN
  Result := CsIdent(BaseName(ACanon));
  IF InArr(Result, CS_TYPE_NAMES) THEN
    Result := Result + '_';
END;

FUNCTION TApiSpec.CsRef(CONST ACanon: STRING): STRING;
// Class of a schema in an expression: qualified when a member of the class being
// generated has the same name (public List<Sort>? Sort -> global::CockpitItsm.Sort)
BEGIN
  Result := CsClassName(ACanon);
  IF (FCsShadow <> NIL) AND (FCsShadow.IndexOf(Result) >= 0) THEN
    Result := 'global::CockpitItsm.' + Result;
END;

FUNCTION CsIsValueKind(AKind: TTypeKind): Boolean;
BEGIN
  Result := AKind IN [tkInteger, tkInt64, tkDouble, tkBoolean, tkDate, tkDateOnly];
END;

FUNCTION TApiSpec.CsType(CONST AT: TTypeRef): STRING;
// C# type, without the nullable mark
VAR
  E: TTypeRef;
BEGIN
  Result := '';
  CASE AT.Kind OF
    tkString, tkRaw: Result := 'string';
    tkInteger: Result := 'int';
    tkInt64: Result := 'long';
    tkDouble: Result := 'double';
    tkBoolean: Result := 'bool';
    tkDate: Result := 'DateTimeOffset';
    tkDateOnly: Result := 'DateOnly';
    tkRecord: Result := CsClassName(AT.RecName);
    tkArray:
      BEGIN
        E := AT;
        E.Kind := AT.ElemKind;
        Result := 'List<' + CsType(E) + '>';
      END;
  END;
END;

FUNCTION CsConv(AKind: TTypeKind): STRING;
// Core function converting a JSON node
BEGIN
  CASE AKind OF
    tkInteger: Result := 'ToInt';
    tkInt64: Result := 'ToLong';
    tkDouble: Result := 'ToDouble';
    tkBoolean: Result := 'ToBool';
    tkDate: Result := 'ToDateTime';
    tkDateOnly: Result := 'ToDate';
    tkRaw: Result := 'ToRaw';
  ELSE
    Result := 'ToStr';
  END;
END;

FUNCTION TApiSpec.CsReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
// Expression converting the JSON node AValue to the C# type of AT
BEGIN
  CASE AT.Kind OF
    tkRecord: Result := CsRef(AT.RecName) + '.FromJson(' + AValue + ')';
    tkArray:
      IF AT.ElemKind = tkRecord THEN
        Result := CsRef(AT.RecName) + '.ListFromJson(' + AValue + ')'
      ELSE IF CsIsValueKind(AT.ElemKind) THEN
        Result := 'ListOfValues(' + AValue + ', ' + CsConv(AT.ElemKind) + ')'
      ELSE
        Result := 'ListOf(' + AValue + ', ' + CsConv(AT.ElemKind) + ')';
  ELSE
    Result := CsConv(AT.Kind) + '(' + AValue + ')';
  END;
END;

PROCEDURE TApiSpec.CsGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
// Class with nullable properties (null = missing / not sent), FromJson / ListFromJson
// (ARead), ToJson / ListToJson (AWrite, read-only members and null values not sent)
VAR
  T, Props, PS: TJSONObject;
  I: Integer;
  Used, Fields, Names: TStringList;
  Cls, Doc, F, N, V: STRING;
  TR: TTypeRef;
BEGIN
  T := SchemaObj(ACanon);
  Props := ObjObj(T, 'properties');
  Cls := CsClassName(ACanon);
  Used := TStringList.Create;
  Fields := TStringList.Create;
  Names := TStringList.Create;
  TRY
    Doc := CsDoc(CleanDoc(ObjStr(T, 'description'), 100));
    IF Doc <> '' THEN
      AOut.Add('    /// <summary>' + Doc + '</summary>');
    AOut.Add('    public sealed class ' + Cls);
    AOut.Add('    {');
    IF Props <> NIL THEN
      FOR I := 0 TO Props.Count - 1 DO
      BEGIN
        IF Props.Items[I].JSONType <> jtObject THEN
          Continue;
        PS := TJSONObject(Props.Items[I]);
        N := Props.Names[I];
        F := CsIdent(UpperFirst(PascalWords(N)));
        IF (F = Cls) OR InArr(F, CS_CLASS_MEMBERS) THEN
          F := F + '_';
        WHILE Used.IndexOf(F) >= 0 DO
          F := F + '_';
        Used.Add(F);
        Fields.AddObject(F, PS);
        Names.Add(N);
        Doc := CsDoc(CleanDoc(ObjStr(PS, 'description'), 100));
        IF ObjBool(PS, 'readOnly') THEN
          Doc := Trim('[read-only] ' + Doc);
        IF Doc <> '' THEN
          AOut.Add('        /// <summary>' + Doc + '</summary>');
        AOut.Add('        public ' + CsType(TypeOf_(PS)) + '? ' + F + ' { get; set; }');
        AOut.Add('');
      END;
    FCsShadow.Assign(Used);
    IF ARead THEN
    BEGIN
      AOut.Add('        public static ' + Cls + '? FromJson(JsonNode? src)');
      AOut.Add('        {');
      AOut.Add('            if (src is not JsonObject o) return null;');
      IF Fields.Count = 0 THEN
        AOut.Add('            return new ' + Cls + '();')
      ELSE
      BEGIN
        AOut.Add('            return new ' + Cls);
        AOut.Add('            {');
        FOR I := 0 TO Fields.Count - 1 DO
          AOut.Add('                ' + Fields[I] + ' = ' +
            CsReadExpr(TypeOf_(TJSONObject(Fields.Objects[I])), 'o[' + JQuote(Names[I]) + ']') + ',');
        AOut.Add('            };');
      END;
      AOut.Add('        }');
      AOut.Add('');
      AOut.Add('        public static List<' + Cls + '>? ListFromJson(JsonNode? src) => ListOf(src, FromJson);');
      AOut.Add('');
    END;
    IF AWrite THEN
    BEGIN
      AOut.Add('        public JsonObject ToJson()');
      AOut.Add('        {');
      AOut.Add('            var res = new JsonObject();');
      FOR I := 0 TO Fields.Count - 1 DO
      BEGIN
        PS := TJSONObject(Fields.Objects[I]);
        IF ObjBool(PS, 'readOnly') THEN
          Continue;
        TR := TypeOf_(PS);
        V := Fields[I];
        CASE TR.Kind OF
          tkRaw:
            AOut.Add('            PutRaw(res, ' + JQuote(Names[I]) + ', ' + V + ');');
          tkRecord:
            AOut.Add('            Put(res, ' + JQuote(Names[I]) + ', ' + V + '?.ToJson());');
          tkArray:
            IF TR.ElemKind = tkRecord THEN
              AOut.Add('            if (' + V + ' != null) Put(res, ' + JQuote(Names[I]) + ', ' +
                CsRef(TR.RecName) + '.ListToJson(' + V + '));')
            ELSE
              AOut.Add('            if (' + V + ' != null) Put(res, ' + JQuote(Names[I]) + ', ArrayOf(' + V +
                ', x => FromValue(x)));');
        ELSE
          AOut.Add('            Put(res, ' + JQuote(Names[I]) + ', FromValue(' + V + '));');
        END;
      END;
      AOut.Add('            return res;');
      AOut.Add('        }');
      AOut.Add('');
      AOut.Add('        public static JsonArray ListToJson(IEnumerable<' + Cls + '>? items) => ArrayOf(items, x => x.ToJson());');
      AOut.Add('');
    END;
    IF AOut[AOut.Count - 1] = '' THEN
      AOut.Delete(AOut.Count - 1);
    AOut.Add('    }');
    AOut.Add('');
  FINALLY
    FCsShadow.Clear;
    Used.Free;
    Fields.Free;
    Names.Free;
  END;
END;

PROCEDURE TApiSpec.CsGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
// Task<T> NameAsync(path params, required query params, body, optional query params = null,
// cancellationToken); the criteria of a paged list are optional (null = no criteria)
VAR
  I: Integer;
  P: TParamInfo;
  Url, Seg, Item, Body, Args, Ret, Call_, BodyArg: STRING;
  Segs: TStringArray;
  HasQ: Boolean;
BEGIN
  Item := AEp.Method + ' ' + AEp.Path;
  IF AEp.Summary <> '' THEN
    Item := Item + ' - ' + CleanDoc(AEp.Summary, 120);
  IF AEp.RespKind = rkPaged THEN
    Item := Item + ' (all pages)';
  AOut.Add('        /// <summary>' + CsDoc(Item) + '</summary>');
  IF AEp.Deprecated THEN
    AOut.Add('        [Obsolete("Deprecated endpoint of the Cockpit ITSM API")]');
  Args := '';
  FOR I := 0 TO High(AEp.Params) DO
    IF AEp.Params[I].Loc = plPath THEN
      Args := Args + ', ' + CsType(AEp.Params[I].TypeRef) + ' ' + AEp.Params[I].PasName;
  FOR I := 0 TO High(AEp.Params) DO
    IF (AEp.Params[I].Loc = plQuery) AND AEp.Params[I].Required THEN
      Args := Args + ', ' + CsType(AEp.Params[I].TypeRef) + ' ' + AEp.Params[I].PasName;
  IF AEp.RespKind = rkPaged THEN
  BEGIN
    IF AEp.HasCriteria THEN
      Args := Args + ', ' + CsType(AEp.BodyType) + '? ' + AEp.BodyName + ' = null';
  END
  ELSE
    CASE AEp.BodyKind OF
      bkText, bkRaw: Args := Args + ', string ' + AEp.BodyName;
      bkTyped: Args := Args + ', ' + CsType(AEp.BodyType) + ' ' + AEp.BodyName;
    END;
  FOR I := 0 TO High(AEp.Params) DO
    IF (AEp.Params[I].Loc = plQuery) AND NOT AEp.Params[I].Required THEN
      Args := Args + ', ' + CsType(AEp.Params[I].TypeRef) + '? ' + AEp.Params[I].PasName + ' = null';
  Args := Args + ', CancellationToken cancellationToken = default';
  Ret := '';
  CASE AEp.RespKind OF
    rkNone: Ret := 'Task';
    rkRaw: Ret := 'Task<string>';
    rkText: Ret := 'Task<string?>';
    rkTyped, rkPaged: Ret := 'Task<' + CsType(AEp.RespType) + '?>';
  END;
  AOut.Add('        public async ' + Ret + ' ' + AName + '(' + Copy(Args, 3, MaxInt) + ')');
  AOut.Add('        {');
  // URL with encoded path parameters
  Url := '';
  Segs := AEp.Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  FOR Seg IN Segs DO
  BEGIN
    IF Seg.StartsWith('{') THEN
    BEGIN
      Item := Copy(Seg, 2, Length(Seg) - 2);
      FOR I := 0 TO High(AEp.Params) DO
        IF (AEp.Params[I].Loc = plPath) AND (AEp.Params[I].Name = Item) THEN
          Url := Url + ' + "/" + UrlEncode(' + AEp.Params[I].PasName + ')';
    END
    ELSE
      Url := Url + ' + ' + JQuote('/' + Seg);
  END;
  Url := Copy(Url, 4, MaxInt);
  Url := StringReplace(Url, '" + "', '', [rfReplaceAll]);
  // Query (null not sent, lists as repeated keys)
  HasQ := False;
  FOR I := 0 TO High(AEp.Params) DO
    IF AEp.Params[I].Loc = plQuery THEN
    BEGIN
      IF NOT HasQ THEN
        AOut.Add('            var q = new List<KeyValuePair<string, string>>();');
      HasQ := True;
      P := AEp.Params[I];
      AOut.Add('            AddQuery(q, ' + JQuote(P.Name) + ', ' + P.PasName + ');');
    END;
  IF HasQ THEN
    Url := Url + ' + QueryString(q)';
  // Body
  Body := 'null';
  IF AEp.RespKind <> rkPaged THEN
    CASE AEp.BodyKind OF
      bkText, bkRaw: Body := AEp.BodyName;
      bkTyped:
        IF AEp.BodyType.Kind = tkRecord THEN
          Body := AEp.BodyName + '.ToJson().ToJsonString()'
        ELSE IF AEp.BodyType.ElemKind = tkRecord THEN
          Body := CsRef(AEp.BodyType.RecName) + '.ListToJson(' + AEp.BodyName + ').ToJsonString()'
        ELSE
          Body := 'ArrayOf(' + AEp.BodyName + ', x => FromValue(x)).ToJsonString()';
    END;
  BodyArg := ', ' + Body + ', cancellationToken).ConfigureAwait(false)';
  Call_ := '(' + JQuote(AEp.Method) + ', ' + Url + BodyArg;
  CASE AEp.RespKind OF
    rkNone: AOut.Add('            await CallAsync' + Call_ + ';');
    rkRaw: AOut.Add('            return await CallAsync' + Call_ + ';');
    rkText: AOut.Add('            return Unquote(await CallAsync' + Call_ + ');');
    rkTyped:
      IF AEp.RespType.Kind IN [tkRecord, tkArray] THEN
        AOut.Add('            return ' + CsReadExpr(AEp.RespType, 'await CallJsonAsync' + Call_) + ';')
      ELSE
        AOut.Add('            return ' + CsReadExpr(AEp.RespType, 'FromValue(Unquote(await CallAsync' + Call_ + '))') + ';');
    rkPaged:
      BEGIN
        IF AEp.HasCriteria THEN
          AOut.Add('            var body = ' + AEp.BodyName + '?.ToJson() ?? new JsonObject();')
        ELSE
          AOut.Add('            var body = new JsonObject();');
        AOut.Add('            return ' + CsRef(AEp.RespType.RecName) + '.ListFromJson(await FetchAllPagesAsync(' +
          JQuote(AEp.Method) + ', ' + Url + ', body, ' + JQuote(AEp.PagePath) + ', cancellationToken).ConfigureAwait(false));');
      END;
  END;
  AOut.Add('        }');
  AOut.Add('');
END;

FUNCTION TApiSpec.GenerateCSharp(ASelection: TStrings; CONST AClassName: STRING; ALog: TStrings): STRING;
// ASelection: "METHOD /path=BaseName" lines (C# method name = BaseNameAsync)
VAR
  Sel: TObjectList;
  Names, MethodNames, Used: TStringList;
  ReadSet, WriteSet, AllSet, Done, Order: TStringList;
  Code: TStringList;
  I, J, K: Integer;
  Ep: TEndpoint;
  Key, Nm, CN: STRING;
  SavedNames: ARRAY OF STRING;
  SavedBody: ARRAY OF STRING;
BEGIN
  IF NOT IsValidCsIdent(AClassName) OR InArr(AClassName, CS_TYPE_NAMES) THEN
    RAISE Exception.Create('Invalid C# class name: ' + AClassName);
  Sel := TObjectList.Create(False);
  Names := TStringList.Create;
  MethodNames := TStringList.Create;
  Used := TStringList.Create;
  ReadSet := TStringList.Create;
  WriteSet := TStringList.Create;
  AllSet := TStringList.Create;
  Done := TStringList.Create;
  Order := TStringList.Create;
  Code := TStringList.Create;
  FCsShadow := TStringList.Create;
  TRY
    FOR I := 0 TO ASelection.Count - 1 DO
    BEGIN
      Key := ASelection.Names[I];
      Nm := ASelection.ValueFromIndex[I];
      Ep := FindEndpoint(Key);
      IF Ep = NIL THEN
      BEGIN
        ALog.Add('MISSING from version ' + FVersion + ': ' + Key + ' (' + Nm + ') - skipped');
        Continue;
      END;
      IF NOT Ep.Supported THEN
      BEGIN
        ALog.Add('Unsupported: ' + Key + ' - ' + Ep.Reason);
        Continue;
      END;
      CN := Nm + 'Async';
      IF NOT IsValidCsIdent(CN) OR (Names.IndexOf(CN) >= 0) OR (CN = AClassName) THEN
        RAISE Exception.Create('Invalid or duplicate method name: ' + CN + ' (' + Key + ')');
      IF InArr(CN, CS_CORE_METHODS) THEN
        RAISE Exception.Create('Method name ' + CN + ' is used by CockpitItsmCore: rename ' + Key);
      Names.Add(CN);
      Sel.Add(Ep);
      MethodNames.Add(CN);
      IF (Ep.BodyKind = bkTyped) AND ((Ep.RespKind <> rkPaged) OR Ep.HasCriteria) THEN
        CollectTypes(Ep.BodyType, WriteSet, True);
      IF Ep.RespKind IN [rkTyped, rkPaged] THEN
        CollectTypes(Ep.RespType, ReadSet, False);
    END;
    IF Sel.Count = 0 THEN
      RAISE Exception.Create('No endpoint selected');

    // C# parameter names (PasName / BodyName restored at the end:
    // the endpoints are shared with the other generators)
    SetLength(SavedBody, Sel.Count);
    SetLength(SavedNames, 0);
    FOR I := 0 TO Sel.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sel[I]);
      SavedBody[I] := Ep.BodyName;
      FOR J := 0 TO High(Ep.Params) DO
      BEGIN
        SetLength(SavedNames, Length(SavedNames) + 1);
        SavedNames[High(SavedNames)] := Ep.Params[J].PasName;
      END;
    END;
    TRY
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Used.Clear;
        // names used inside the generated methods
        Used.Add('q');
        Used.Add('body');
        Used.Add('cancellationToken');
        Used.Add('x');
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := CsIdent(LowerFirst(PascalWords(Ep.Params[J].Name)));
          WHILE Used.IndexOf(Ep.Params[J].PasName) >= 0 DO
            Ep.Params[J].PasName := Ep.Params[J].PasName + '_';
          Used.Add(Ep.Params[J].PasName);
        END;
        CASE Ep.BodyKind OF
          bkText: Ep.BodyName := 'text';
          bkRaw: Ep.BodyName := 'json';
          bkTyped:
            IF Ep.RespKind = rkPaged THEN
              Ep.BodyName := 'criteria'
            ELSE IF Ep.BodyType.Kind = tkRecord THEN
              Ep.BodyName := CsIdent(LowerFirst(BaseName(Ep.BodyType.RecName)))
            ELSE
              Ep.BodyName := 'items';
        ELSE
          Ep.BodyName := '';
        END;
        WHILE (Ep.BodyName <> '') AND (Used.IndexOf(Ep.BodyName) >= 0) DO
          Ep.BodyName := Ep.BodyName + '_';
      END;

      AllSet.AddStrings(ReadSet);
      AllSet.AddStrings(WriteSet);
      FOR I := 0 TO AllSet.Count - 1 DO
        SortTypes(AllSet[I], Done, Order);
      FOR I := 0 TO Order.Count - 1 DO
        IF CsClassName(Order[I]) = AClassName THEN
          RAISE Exception.Create('Class name ' + AClassName + ' is used by a schema: choose another file name');

      Code.Add('// Cockpit ITSM public API - GENERATED CLASS, do not edit (regenerate with CIPAT)');
      Code.Add('// Source: ' + CleanDoc(FTitle, 80) + ' ' + FVersion + ' - generated ' + FormatDateTime('yyyy-mm-dd hh:nn', Now));
      Code.Add('// Requires CockpitItsmCore.cs (same project), .NET 6+, no dependency');
      Code.Add('//');
      Code.Add('// Selected endpoints (read back by CIPAT when regenerating):');
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Code.Add(SELECTION_TAG + Ep.Method + ' ' + Ep.Path + ' ' + ASelection.Values[Ep.Key]);
      END;
      Code.Add('');
      Code.Add('#nullable enable');
      Code.Add('');
      Code.Add('using System;');
      Code.Add('using System.Collections.Generic;');
      Code.Add('using System.Net.Http;');
      Code.Add('using System.Text.Json.Nodes;');
      Code.Add('using System.Threading;');
      Code.Add('using System.Threading.Tasks;');
      Code.Add('using static CockpitItsm.CockpitItsmCore;');
      Code.Add('');
      Code.Add('namespace CockpitItsm');
      Code.Add('{');
      Code.Add('    // ---------------------------------------------------------------- types');
      Code.Add('');
      FOR I := 0 TO Order.Count - 1 DO
        CsGenClass(Order[I], ReadSet.IndexOf(Order[I]) >= 0, WriteSet.IndexOf(Order[I]) >= 0, Code);
      Code.Add('    // ---------------------------------------------------------------- endpoints');
      Code.Add('');
      Code.Add('    /// <summary>');
      Code.Add('    /// Typed access to the selected endpoints of the Cockpit ITSM public API.');
      Code.Add('    /// Members and optional parameters: null = missing / not sent. Paged lists: all pages.');
      Code.Add('    /// Errors: CockpitItsmException (StatusCode, Response).');
      Code.Add('    /// </summary>');
      Code.Add('    public class ' + AClassName + ' : CockpitItsmCore');
      Code.Add('    {');
      Code.Add('        /// <param name="saas">true: https://{tenant}.cockpit-itsm.com - false: https://{tenant}</param>');
      Code.Add('        /// <param name="tenant">Tenant name (SaaS) or host name (on premise)</param>');
      Code.Add('        /// <param name="clientId">OAuth 2.0 client id</param>');
      Code.Add('        /// <param name="clientSecret">OAuth 2.0 client secret</param>');
      Code.Add('        /// <param name="httpClient">HttpClient used for every request; created if null</param>');
      Code.Add('        public ' + AClassName + '(bool saas, string tenant, string clientId, string clientSecret, HttpClient? httpClient = null)');
      Code.Add('            : base(saas, tenant, clientId, clientSecret, httpClient)');
      Code.Add('        {');
      Code.Add('        }');
      Code.Add('');
      // Members of CockpitItsmCore: shadow the classes of the same name in the methods
      FOR I := 0 TO High(CS_CORE_MEMBERS) DO
        FCsShadow.Add(CS_CORE_MEMBERS[I]);
      FOR I := 0 TO Sel.Count - 1 DO
        CsGenMethod(TEndpoint(Sel[I]), MethodNames[I], Code);
      FCsShadow.Clear;
      IF (Code.Count > 0) AND (Code[Code.Count - 1] = '') THEN
        Code.Delete(Code.Count - 1);
      Code.Add('    }');
      Code.Add('}');
      Result := Code.Text;
      ALog.Add(Format('%d method(s), %d class(es) generated (spec %s)', [Sel.Count, Order.Count, FVersion]));
    FINALLY
      // Pascal names restored
      K := 0;
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Ep.BodyName := SavedBody[I];
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := SavedNames[K];
          Inc(K);
        END;
      END;
    END;
  FINALLY
    Sel.Free;
    Names.Free;
    MethodNames.Free;
    Used.Free;
    ReadSet.Free;
    WriteSet.Free;
    AllSet.Free;
    Done.Free;
    Order.Free;
    Code.Free;
    FreeAndNil(FCsShadow);
  END;
END;


{ VB.NET generation }

FUNCTION VbQuote(CONST S: STRING): STRING;
// VB string literal (no escape character: quotes doubled)
BEGIN
  Result := '"' + StringReplace(S, '"', '""', [rfReplaceAll]) + '"';
END;

FUNCTION TApiSpec.VbClassName(CONST ACanon: STRING): STRING;
// Class of a schema: never a type name used by the generated code (VB: case insensitive)
BEGIN
  Result := VbIdent(BaseName(ACanon));
  IF InArrCI(Result, VB_TYPE_NAMES) THEN
    Result := Result + '_';
END;

FUNCTION TApiSpec.VbRef(CONST ACanon: STRING): STRING;
// Class of a schema in an expression: qualified when a member, a parameter or a local
// variable has the same name (case insensitive: parameter endUser hides class EndUser)
BEGIN
  Result := VbClassName(ACanon);
  IF (FCsShadow <> NIL) AND (FCsShadow.IndexOf(Result) >= 0) THEN
    Result := 'Global.CockpitItsm.' + Result;
END;

FUNCTION TApiSpec.VbType(CONST AT: TTypeRef): STRING;
// VB type (value types: nullable with "?")
VAR
  E: TTypeRef;
BEGIN
  Result := '';
  CASE AT.Kind OF
    tkString, tkRaw: Result := 'String';
    tkInteger: Result := 'Integer?';
    tkInt64: Result := 'Long?';
    tkDouble: Result := 'Double?';
    tkBoolean: Result := 'Boolean?';
    tkDate: Result := 'DateTimeOffset?';
    tkDateOnly: Result := 'DateOnly?';
    tkRecord: Result := VbRef(AT.RecName);
    tkArray:
      BEGIN
        E := AT;
        E.Kind := AT.ElemKind;
        Result := VbType(E);
        IF Result.EndsWith('?') THEN
          SetLength(Result, Length(Result) - 1);
        Result := 'List(Of ' + Result + ')';
      END;
  END;
END;

FUNCTION TApiSpec.VbReqType(CONST AT: TTypeRef): STRING;
// Type of a required parameter or body: value types not nullable
BEGIN
  Result := VbType(AT);
  IF Result.EndsWith('?') THEN
    SetLength(Result, Length(Result) - 1);
END;

FUNCTION VbValueType(AKind: TTypeKind): STRING;
// Item type of a list of values
BEGIN
  CASE AKind OF
    tkInteger: Result := 'Integer';
    tkInt64: Result := 'Long';
    tkDouble: Result := 'Double';
    tkBoolean: Result := 'Boolean';
    tkDate: Result := 'DateTimeOffset';
    tkDateOnly: Result := 'DateOnly';
  ELSE
    Result := 'String';
  END;
END;

FUNCTION TApiSpec.VbReadExpr(CONST AT: TTypeRef; CONST AValue: STRING): STRING;
// Expression converting the JSON node AValue to the VB type of AT
BEGIN
  CASE AT.Kind OF
    tkRecord: Result := VbRef(AT.RecName) + '.FromJson(' + AValue + ')';
    tkArray:
      IF AT.ElemKind = tkRecord THEN
        Result := VbRef(AT.RecName) + '.ListFromJson(' + AValue + ')'
      ELSE IF CsIsValueKind(AT.ElemKind) THEN
        Result := 'ListOfValues(Of ' + VbValueType(AT.ElemKind) + ')(' + AValue + ', AddressOf ' + CsConv(AT.ElemKind) + ')'
      ELSE
        Result := 'ListOf(Of String)(' + AValue + ', AddressOf ' + CsConv(AT.ElemKind) + ')';
  ELSE
    Result := CsConv(AT.Kind) + '(' + AValue + ')';
  END;
END;

PROCEDURE TApiSpec.VbGenClass(CONST ACanon: STRING; ARead, AWrite: Boolean; AOut: TStrings);
// Class with properties (Nothing = missing / not sent), FromJson / ListFromJson (ARead),
// ToJson / ListToJson (AWrite, read-only members and Nothing values not sent)
VAR
  T, Props, PS: TJSONObject;
  I: Integer;
  Used, Fields, Names: TStringList;
  Cls, Doc, F, N, V: STRING;
  TR: TTypeRef;
BEGIN
  T := SchemaObj(ACanon);
  Props := ObjObj(T, 'properties');
  Cls := VbClassName(ACanon);
  Used := TStringList.Create;  // case insensitive, like VB
  Fields := TStringList.Create;
  Names := TStringList.Create;
  TRY
    Doc := CsDoc(CleanDoc(ObjStr(T, 'description'), 100));
    IF Doc <> '' THEN
      AOut.Add('    '''''' <summary>' + Doc + '</summary>');
    AOut.Add('    Public NotInheritable Class ' + Cls);
    IF Props <> NIL THEN
      FOR I := 0 TO Props.Count - 1 DO
      BEGIN
        IF Props.Items[I].JSONType <> jtObject THEN
          Continue;
        PS := TJSONObject(Props.Items[I]);
        N := Props.Names[I];
        F := VbIdent(UpperFirst(PascalWords(N)));
        IF SameText(F, Cls) OR InArrCI(F, CS_CLASS_MEMBERS) THEN
          F := F + '_';
        WHILE Used.IndexOf(F) >= 0 DO
          F := F + '_';
        Used.Add(F);
        Fields.AddObject(F, PS);
        Names.Add(N);
      END;
    // Property types and expressions: classes hidden by a property qualified
    FCsShadow.Assign(Used);
    FCsShadow.Add('cpObj');
    FCsShadow.Add('cpRes');
    FCsShadow.Add('src');
    FCsShadow.Add('items');
    FCsShadow.Add('x');
    FOR I := 0 TO Fields.Count - 1 DO
    BEGIN
      PS := TJSONObject(Fields.Objects[I]);
      AOut.Add('');
      Doc := CsDoc(CleanDoc(ObjStr(PS, 'description'), 100));
      IF ObjBool(PS, 'readOnly') THEN
        Doc := Trim('[read-only] ' + Doc);
      IF Doc <> '' THEN
        AOut.Add('        '''''' <summary>' + Doc + '</summary>');
      AOut.Add('        Public Property ' + Fields[I] + ' As ' + VbType(TypeOf_(PS)));
    END;
    IF ARead THEN
    BEGIN
      AOut.Add('');
      AOut.Add('        Public Shared Function FromJson(src As JsonNode) As ' + Cls);
      AOut.Add('            Dim cpObj = TryCast(src, JsonObject)');
      AOut.Add('            If cpObj Is Nothing Then Return Nothing');
      IF Fields.Count = 0 THEN
        AOut.Add('            Return New ' + Cls + '()')
      ELSE
      BEGIN
        AOut.Add('            Return New ' + Cls + ' With {');
        FOR I := 0 TO Fields.Count - 1 DO
        BEGIN
          V := '                .' + Fields[I] + ' = ' +
            VbReadExpr(TypeOf_(TJSONObject(Fields.Objects[I])), 'cpObj(' + VbQuote(Names[I]) + ')');
          IF I < Fields.Count - 1 THEN
            V := V + ',';
          AOut.Add(V);
        END;
        AOut.Add('            }');
      END;
      AOut.Add('        End Function');
      AOut.Add('');
      AOut.Add('        Public Shared Function ListFromJson(src As JsonNode) As List(Of ' + Cls + ')');
      AOut.Add('            Return ListOf(Of ' + Cls + ')(src, AddressOf FromJson)');
      AOut.Add('        End Function');
    END;
    IF AWrite THEN
    BEGIN
      AOut.Add('');
      AOut.Add('        Public Function ToJson() As JsonObject');
      AOut.Add('            Dim cpRes As New JsonObject()');
      FOR I := 0 TO Fields.Count - 1 DO
      BEGIN
        PS := TJSONObject(Fields.Objects[I]);
        IF ObjBool(PS, 'readOnly') THEN
          Continue;
        TR := TypeOf_(PS);
        V := 'Me.' + Fields[I];
        CASE TR.Kind OF
          tkRaw:
            AOut.Add('            PutRaw(cpRes, ' + VbQuote(Names[I]) + ', ' + V + ')');
          tkRecord:
            AOut.Add('            Put(cpRes, ' + VbQuote(Names[I]) + ', ' + V + '?.ToJson())');
          tkArray:
            IF TR.ElemKind = tkRecord THEN
              AOut.Add('            If ' + V + ' IsNot Nothing Then Put(cpRes, ' + VbQuote(Names[I]) + ', ' +
                VbRef(TR.RecName) + '.ListToJson(' + V + '))')
            ELSE
              AOut.Add('            If ' + V + ' IsNot Nothing Then Put(cpRes, ' + VbQuote(Names[I]) + ', ArrayOf(' + V +
                ', Function(x) FromValue(x)))');
        ELSE
          AOut.Add('            Put(cpRes, ' + VbQuote(Names[I]) + ', FromValue(' + V + '))');
        END;
      END;
      AOut.Add('            Return cpRes');
      AOut.Add('        End Function');
      AOut.Add('');
      AOut.Add('        Public Shared Function ListToJson(items As IEnumerable(Of ' + Cls + ')) As JsonArray');
      AOut.Add('            Return ArrayOf(items, Function(x) x.ToJson())');
      AOut.Add('        End Function');
    END;
    AOut.Add('    End Class');
    AOut.Add('');
  FINALLY
    FCsShadow.Clear;
    Used.Free;
    Fields.Free;
    Names.Free;
  END;
END;

PROCEDURE TApiSpec.VbGenMethod(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
// Task(Of T) NameAsync(path params, required query params, body, Optional query params = Nothing,
// Optional cancellationToken); the criteria of a paged list are optional (Nothing = no criteria)
VAR
  I: Integer;
  P: TParamInfo;
  Url, Seg, Item, Body, Args, Ret, Call_, BodyArg: STRING;
  Segs: TStringArray;
  HasQ: Boolean;
  ShadowCount: Integer;
BEGIN
  // parameters hide the classes of the same name (case insensitive)
  ShadowCount := FCsShadow.Count;
  FOR I := 0 TO High(AEp.Params) DO
    FCsShadow.Add(AEp.Params[I].PasName);
  IF AEp.BodyName <> '' THEN
    FCsShadow.Add(AEp.BodyName);
  TRY
    Item := AEp.Method + ' ' + AEp.Path;
    IF AEp.Summary <> '' THEN
      Item := Item + ' - ' + CleanDoc(AEp.Summary, 120);
    IF AEp.RespKind = rkPaged THEN
      Item := Item + ' (all pages)';
    AOut.Add('        '''''' <summary>' + CsDoc(Item) + '</summary>');
    IF AEp.Deprecated THEN
      AOut.Add('        <Obsolete("Deprecated endpoint of the Cockpit ITSM API")>');
    Args := '';
    FOR I := 0 TO High(AEp.Params) DO
      IF AEp.Params[I].Loc = plPath THEN
        Args := Args + ', ' + AEp.Params[I].PasName + ' As ' + VbReqType(AEp.Params[I].TypeRef);
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND AEp.Params[I].Required THEN
        Args := Args + ', ' + AEp.Params[I].PasName + ' As ' + VbReqType(AEp.Params[I].TypeRef);
    IF AEp.RespKind = rkPaged THEN
    BEGIN
      IF AEp.HasCriteria THEN
        Args := Args + ', Optional ' + AEp.BodyName + ' As ' + VbReqType(AEp.BodyType) + ' = Nothing';
    END
    ELSE
      CASE AEp.BodyKind OF
        bkText, bkRaw: Args := Args + ', ' + AEp.BodyName + ' As String';
        bkTyped: Args := Args + ', ' + AEp.BodyName + ' As ' + VbReqType(AEp.BodyType);
      END;
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND NOT AEp.Params[I].Required THEN
        Args := Args + ', Optional ' + AEp.Params[I].PasName + ' As ' + VbType(AEp.Params[I].TypeRef) + ' = Nothing';
    Args := Args + ', Optional cancellationToken As CancellationToken = Nothing';
    Ret := '';
    CASE AEp.RespKind OF
      rkNone: Ret := 'Task';
      rkRaw, rkText: Ret := 'Task(Of String)';
      rkTyped, rkPaged: Ret := 'Task(Of ' + VbType(AEp.RespType) + ')';
    END;
    AOut.Add('        Public Async Function ' + AName + '(' + Copy(Args, 3, MaxInt) + ') As ' + Ret);
    // URL with encoded path parameters
    Url := '';
    Segs := AEp.Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
    FOR Seg IN Segs DO
    BEGIN
      IF Seg.StartsWith('{') THEN
      BEGIN
        Item := Copy(Seg, 2, Length(Seg) - 2);
        FOR I := 0 TO High(AEp.Params) DO
          IF (AEp.Params[I].Loc = plPath) AND (AEp.Params[I].Name = Item) THEN
            Url := Url + ' & "/" & UrlEncode(' + AEp.Params[I].PasName + ')';
      END
      ELSE
        Url := Url + ' & ' + VbQuote('/' + Seg);
    END;
    Url := Copy(Url, 4, MaxInt);
    Url := StringReplace(Url, '" & "', '', [rfReplaceAll]);
    // Query (Nothing not sent, lists as repeated keys)
    HasQ := False;
    FOR I := 0 TO High(AEp.Params) DO
      IF AEp.Params[I].Loc = plQuery THEN
      BEGIN
        IF NOT HasQ THEN
          AOut.Add('            Dim cpQuery As New List(Of KeyValuePair(Of String, String))()');
        HasQ := True;
        P := AEp.Params[I];
        AOut.Add('            AddQuery(cpQuery, ' + VbQuote(P.Name) + ', ' + P.PasName + ')');
      END;
    IF HasQ THEN
      Url := Url + ' & QueryString(cpQuery)';
    // Body
    Body := 'Nothing';
    IF AEp.RespKind <> rkPaged THEN
      CASE AEp.BodyKind OF
        bkText, bkRaw: Body := AEp.BodyName;
        bkTyped:
          IF AEp.BodyType.Kind = tkRecord THEN
            Body := AEp.BodyName + '.ToJson().ToJsonString()'
          ELSE IF AEp.BodyType.ElemKind = tkRecord THEN
            Body := VbRef(AEp.BodyType.RecName) + '.ListToJson(' + AEp.BodyName + ').ToJsonString()'
          ELSE
            Body := 'ArrayOf(' + AEp.BodyName + ', Function(x) FromValue(x)).ToJsonString()';
      END;
    BodyArg := ', ' + Body + ', cancellationToken).ConfigureAwait(False)';
    Call_ := '(' + VbQuote(AEp.Method) + ', ' + Url + BodyArg;
    CASE AEp.RespKind OF
      rkNone: AOut.Add('            Await CallAsync' + Call_);
      rkRaw: AOut.Add('            Return Await CallAsync' + Call_);
      rkText: AOut.Add('            Return Unquote(Await CallAsync' + Call_ + ')');
      rkTyped:
        IF AEp.RespType.Kind IN [tkRecord, tkArray] THEN
          AOut.Add('            Return ' + VbReadExpr(AEp.RespType, 'Await CallJsonAsync' + Call_))
        ELSE
          AOut.Add('            Return ' + VbReadExpr(AEp.RespType, 'FromValue(Unquote(Await CallAsync' + Call_ + '))'));
      rkPaged:
        BEGIN
          IF AEp.HasCriteria THEN
            AOut.Add('            Dim cpBody As JsonObject = If(' + AEp.BodyName + '?.ToJson(), New JsonObject())')
          ELSE
            AOut.Add('            Dim cpBody As New JsonObject()');
          AOut.Add('            Return ' + VbRef(AEp.RespType.RecName) + '.ListFromJson(Await FetchAllPagesAsync(' +
            VbQuote(AEp.Method) + ', ' + Url + ', cpBody, ' + VbQuote(AEp.PagePath) + ', cancellationToken).ConfigureAwait(False))');
        END;
    END;
    AOut.Add('        End Function');
    AOut.Add('');
  FINALLY
    WHILE FCsShadow.Count > ShadowCount DO
      FCsShadow.Delete(FCsShadow.Count - 1);
  END;
END;

FUNCTION TApiSpec.GenerateVB(ASelection: TStrings; CONST AClassName: STRING; ALog: TStrings): STRING;
// ASelection: "METHOD /path=BaseName" lines (VB method name = BaseNameAsync)
VAR
  Sel: TObjectList;
  Names, MethodNames, Used: TStringList;
  ReadSet, WriteSet, AllSet, Done, Order: TStringList;
  Code: TStringList;
  I, J, K: Integer;
  Ep: TEndpoint;
  Key, Nm, CN: STRING;
  SavedNames: ARRAY OF STRING;
  SavedBody: ARRAY OF STRING;
BEGIN
  IF NOT IsValidVbIdent(AClassName) OR InArrCI(AClassName, VB_TYPE_NAMES) THEN
    RAISE Exception.Create('Invalid VB.NET class name: ' + AClassName);
  Sel := TObjectList.Create(False);
  Names := TStringList.Create;  // case insensitive, like VB
  MethodNames := TStringList.Create;
  Used := TStringList.Create;
  ReadSet := TStringList.Create;
  WriteSet := TStringList.Create;
  AllSet := TStringList.Create;
  Done := TStringList.Create;
  Order := TStringList.Create;
  Code := TStringList.Create;
  FCsShadow := TStringList.Create;
  TRY
    FOR I := 0 TO ASelection.Count - 1 DO
    BEGIN
      Key := ASelection.Names[I];
      Nm := ASelection.ValueFromIndex[I];
      Ep := FindEndpoint(Key);
      IF Ep = NIL THEN
      BEGIN
        ALog.Add('MISSING from version ' + FVersion + ': ' + Key + ' (' + Nm + ') - skipped');
        Continue;
      END;
      IF NOT Ep.Supported THEN
      BEGIN
        ALog.Add('Unsupported: ' + Key + ' - ' + Ep.Reason);
        Continue;
      END;
      CN := Nm + 'Async';
      IF NOT IsValidVbIdent(CN) OR (Names.IndexOf(CN) >= 0) OR SameText(CN, AClassName) THEN
        RAISE Exception.Create('Invalid or duplicate method name: ' + CN + ' (' + Key + ')');
      IF InArrCI(CN, CS_CORE_METHODS) OR InArrCI(CN, CS_CORE_MEMBERS) THEN
        RAISE Exception.Create('Method name ' + CN + ' is used by CockpitItsmCore: rename ' + Key);
      Names.Add(CN);
      Sel.Add(Ep);
      MethodNames.Add(CN);
      IF (Ep.BodyKind = bkTyped) AND ((Ep.RespKind <> rkPaged) OR Ep.HasCriteria) THEN
        CollectTypes(Ep.BodyType, WriteSet, True);
      IF Ep.RespKind IN [rkTyped, rkPaged] THEN
        CollectTypes(Ep.RespType, ReadSet, False);
    END;
    IF Sel.Count = 0 THEN
      RAISE Exception.Create('No endpoint selected');

    // VB parameter names (PasName / BodyName restored at the end:
    // the endpoints are shared with the other generators)
    SetLength(SavedBody, Sel.Count);
    SetLength(SavedNames, 0);
    FOR I := 0 TO Sel.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sel[I]);
      SavedBody[I] := Ep.BodyName;
      FOR J := 0 TO High(Ep.Params) DO
      BEGIN
        SetLength(SavedNames, Length(SavedNames) + 1);
        SavedNames[High(SavedNames)] := Ep.Params[J].PasName;
      END;
    END;
    TRY
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Used.Clear;
        // names used inside the generated methods (case insensitive)
        Used.Add('cpQuery');
        Used.Add('cpBody');
        Used.Add('cancellationToken');
        Used.Add('x');
        Used.Add(MethodNames[I]);
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := VbIdent(LowerFirst(PascalWords(Ep.Params[J].Name)));
          WHILE Used.IndexOf(Ep.Params[J].PasName) >= 0 DO
            Ep.Params[J].PasName := Ep.Params[J].PasName + '_';
          Used.Add(Ep.Params[J].PasName);
        END;
        CASE Ep.BodyKind OF
          bkText: Ep.BodyName := 'text';
          bkRaw: Ep.BodyName := 'json';
          bkTyped:
            IF Ep.RespKind = rkPaged THEN
              Ep.BodyName := 'criteria'
            ELSE IF Ep.BodyType.Kind = tkRecord THEN
              Ep.BodyName := VbIdent(LowerFirst(BaseName(Ep.BodyType.RecName)))
            ELSE
              Ep.BodyName := 'items';
        ELSE
          Ep.BodyName := '';
        END;
        WHILE (Ep.BodyName <> '') AND (Used.IndexOf(Ep.BodyName) >= 0) DO
          Ep.BodyName := Ep.BodyName + '_';
      END;

      AllSet.AddStrings(ReadSet);
      AllSet.AddStrings(WriteSet);
      FOR I := 0 TO AllSet.Count - 1 DO
        SortTypes(AllSet[I], Done, Order);
      FOR I := 0 TO Order.Count - 1 DO
        IF SameText(VbClassName(Order[I]), AClassName) THEN
          RAISE Exception.Create('Class name ' + AClassName + ' is used by a schema: choose another file name');

      Code.Add('''  Cockpit ITSM public API - GENERATED CLASS, do not edit (regenerate with CIPAT)');
      Code.Add('''  Source: ' + CleanDoc(FTitle, 80) + ' ' + FVersion + ' - generated ' + FormatDateTime('yyyy-mm-dd hh:nn', Now));
      Code.Add('''  Requires CockpitItsmCore.vb (same project), .NET 6+, no dependency');
      Code.Add('''');
      Code.Add('''  Selected endpoints (read back by CIPAT when regenerating):');
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Code.Add(VB_SELECTION_TAG + Ep.Method + ' ' + Ep.Path + ' ' + ASelection.Values[Ep.Key]);
      END;
      Code.Add('');
      Code.Add('Option Strict On');
      Code.Add('Option Explicit On');
      Code.Add('Option Infer On');
      Code.Add('');
      Code.Add('Imports System.Collections.Generic');
      Code.Add('Imports System.Net.Http');
      Code.Add('Imports System.Text.Json.Nodes');
      Code.Add('Imports System.Threading');
      Code.Add('Imports System.Threading.Tasks');
      Code.Add('Imports CockpitItsm.CockpitItsmCore');
      Code.Add('');
      Code.Add('Namespace Global.CockpitItsm');
      Code.Add('');
      Code.Add('    '' ---------------------------------------------------------------- types');
      Code.Add('');
      FOR I := 0 TO Order.Count - 1 DO
        VbGenClass(Order[I], ReadSet.IndexOf(Order[I]) >= 0, WriteSet.IndexOf(Order[I]) >= 0, Code);
      Code.Add('    '' ---------------------------------------------------------------- endpoints');
      Code.Add('');
      Code.Add('    '''''' <summary>');
      Code.Add('    '''''' Typed access to the selected endpoints of the Cockpit ITSM public API.');
      Code.Add('    '''''' Members and optional parameters: Nothing = missing / not sent. Paged lists: all pages.');
      Code.Add('    '''''' Errors: CockpitItsmException (StatusCode, Response).');
      Code.Add('    '''''' </summary>');
      Code.Add('    Public Class ' + AClassName);
      Code.Add('        Inherits CockpitItsmCore');
      Code.Add('');
      Code.Add('        '''''' <param name="saas">True: https://{tenant}.cockpit-itsm.com - False: https://{tenant}</param>');
      Code.Add('        '''''' <param name="tenant">Tenant name (SaaS) or host name (on premise)</param>');
      Code.Add('        '''''' <param name="clientId">OAuth 2.0 client id</param>');
      Code.Add('        '''''' <param name="clientSecret">OAuth 2.0 client secret</param>');
      Code.Add('        '''''' <param name="httpClient">HttpClient used for every request; created if Nothing</param>');
      Code.Add('        Public Sub New(saas As Boolean, tenant As String, clientId As String, clientSecret As String, Optional httpClient As HttpClient = Nothing)');
      Code.Add('            MyBase.New(saas, tenant, clientId, clientSecret, httpClient)');
      Code.Add('        End Sub');
      Code.Add('');
      // Members of CockpitItsmCore and generated methods: shadow the classes of the same name
      FOR I := 0 TO High(CS_CORE_MEMBERS) DO
        FCsShadow.Add(CS_CORE_MEMBERS[I]);
      FOR I := 0 TO High(VB_CORE_HELPERS) DO
        FCsShadow.Add(VB_CORE_HELPERS[I]);
      FCsShadow.AddStrings(MethodNames);
      FOR I := 0 TO Sel.Count - 1 DO
        VbGenMethod(TEndpoint(Sel[I]), MethodNames[I], Code);
      FCsShadow.Clear;
      IF (Code.Count > 0) AND (Code[Code.Count - 1] = '') THEN
        Code.Delete(Code.Count - 1);
      Code.Add('    End Class');
      Code.Add('');
      Code.Add('End Namespace');
      Result := Code.Text;
      ALog.Add(Format('%d method(s), %d class(es) generated (spec %s)', [Sel.Count, Order.Count, FVersion]));
    FINALLY
      // Pascal names restored
      K := 0;
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Ep.BodyName := SavedBody[I];
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := SavedNames[K];
          Inc(K);
        END;
      END;
    END;
  FINALLY
    Sel.Free;
    Names.Free;
    MethodNames.Free;
    Used.Free;
    ReadSet.Free;
    WriteSet.Free;
    AllSet.Free;
    Done.Free;
    Order.Free;
    Code.Free;
    FreeAndNil(FCsShadow);
  END;
END;


{ PowerShell generation }

FUNCTION PsHelp(CONST S: STRING): STRING;
// Comment-based help text: no end of block comment
BEGIN
  Result := StringReplace(S, '#>', '# >', [rfReplaceAll]);
END;

FUNCTION PsQuote(CONST S: STRING): STRING;
// PowerShell single-quoted string
BEGIN
  Result := '''' + StringReplace(S, '''', '''''', [rfReplaceAll]) + '''';
END;

FUNCTION TApiSpec.PsType(CONST AT: TTypeRef): STRING;
// Type of a parameter (records: hashtable or PSCustomObject)
BEGIN
  Result := '';
  CASE AT.Kind OF
    tkString, tkRaw: Result := '[string]';
    tkInteger: Result := '[int]';
    tkInt64: Result := '[long]';
    tkDouble: Result := '[double]';
    tkBoolean: Result := '[bool]';
    tkDate, tkDateOnly: Result := '[datetime]';
    tkRecord: Result := '[object]';
    tkArray:
      CASE AT.ElemKind OF
        tkString, tkRaw: Result := '[string[]]';
        tkInteger: Result := '[int[]]';
        tkInt64: Result := '[long[]]';
        tkDouble: Result := '[double[]]';
        tkBoolean: Result := '[bool[]]';
        tkDate, tkDateOnly: Result := '[datetime[]]';
      ELSE
        Result := '[object[]]';
      END;
  END;
END;

FUNCTION TApiSpec.PsTypeName(CONST AT: TTypeRef): STRING;
// Type name given to the returned objects ('' for other values)
BEGIN
  Result := '';
  IF (AT.Kind = tkRecord) OR ((AT.Kind = tkArray) AND (AT.ElemKind = tkRecord)) THEN
    Result := 'CockpitItsm.' + PascalWords(BaseName(AT.RecName));
END;

PROCEDURE TApiSpec.PsGenFunction(AEp: TEndpoint; CONST AName: STRING; AOut: TStrings);
// Verb-CockpitNoun with comment-based help: mandatory path / required query parameters
// and body, optional query parameters (not sent when not given); objects of the
// responses sent to the pipeline
VAR
  I: Integer;
  P: TParamInfo;
  Item, Path, QVal, Call_, TN, Desc: STRING;
  Segs: TStringArray;
  Seg: STRING;
  HasQ: Boolean;
  Params: TStringList;

  PROCEDURE AddParam(CONST AName_, AType, ADesc: STRING; AMandatory: Boolean);
  BEGIN
    AOut.Add('    .PARAMETER ' + AName_);
    AOut.Add('    ' + PsHelp(ADesc));
    IF AMandatory THEN
      Params.Add('        [Parameter(Mandatory = $true)] ' + AType + ' $' + AName_)
    ELSE
      Params.Add('        ' + AType + ' $' + AName_);
  END;

  FUNCTION ParamDesc(CONST AP: TParamInfo): STRING;
  BEGIN
    IF AP.Loc = plPath THEN
      Result := 'Path parameter ' + AP.Name
    ELSE
      Result := 'Query parameter ' + AP.Name;
    IF AP.Description <> '' THEN
      Result := Result + ': ' + CleanDoc(AP.Description, 100);
    IF (AP.Loc = plQuery) AND NOT AP.Required THEN
      Result := Result + ' (not sent when not given)';
  END;

BEGIN
  Params := TStringList.Create;
  TRY
    AOut.Add('function ' + AName + ' {');
    AOut.Add('    <#');
    AOut.Add('    .SYNOPSIS');
    Item := AEp.Method + ' ' + AEp.Path;
    IF AEp.Summary <> '' THEN
      Item := Item + ' - ' + CleanDoc(AEp.Summary, 120);
    IF AEp.RespKind = rkPaged THEN
      Item := Item + ' (all pages)';
    AOut.Add('    ' + PsHelp(Item));
    IF AEp.Deprecated THEN
    BEGIN
      AOut.Add('    .DESCRIPTION');
      AOut.Add('    [DEPRECATED] endpoint of the Cockpit ITSM API');
    END;
    FOR I := 0 TO High(AEp.Params) DO
      IF AEp.Params[I].Loc = plPath THEN
        AddParam(AEp.Params[I].PasName, PsType(AEp.Params[I].TypeRef), ParamDesc(AEp.Params[I]), True);
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND AEp.Params[I].Required THEN
        AddParam(AEp.Params[I].PasName, PsType(AEp.Params[I].TypeRef), ParamDesc(AEp.Params[I]), True);
    IF AEp.RespKind = rkPaged THEN
    BEGIN
      IF AEp.HasCriteria THEN
        AddParam(AEp.BodyName, '[object]', 'Criteria (' + BaseName(AEp.BodyType.RecName) +
          ', hashtable or PSCustomObject); page and pageSize are set by the module', False);
    END
    ELSE
      CASE AEp.BodyKind OF
        bkText: AddParam(AEp.BodyName, '[string]', 'Text sent as is', True);
        bkRaw: AddParam(AEp.BodyName, '[string]', 'JSON text', True);
        bkTyped:
          IF AEp.BodyType.Kind = tkRecord THEN
            AddParam(AEp.BodyName, '[object]', BaseName(AEp.BodyType.RecName) +
              ' (hashtable or PSCustomObject; $null members are not sent)', True)
          ELSE IF AEp.BodyType.ElemKind = tkRecord THEN
            AddParam(AEp.BodyName, '[object[]]', 'List of ' + BaseName(AEp.BodyType.RecName) +
              ' (hashtables or PSCustomObjects)', True)
          ELSE
            AddParam(AEp.BodyName, PsType(AEp.BodyType), 'List of values', True);
      END;
    FOR I := 0 TO High(AEp.Params) DO
      IF (AEp.Params[I].Loc = plQuery) AND NOT AEp.Params[I].Required THEN
        AddParam(AEp.Params[I].PasName, PsType(AEp.Params[I].TypeRef), ParamDesc(AEp.Params[I]), False);
    TN := '';
    IF AEp.RespKind IN [rkTyped, rkPaged] THEN
      TN := PsTypeName(AEp.RespType);
    IF TN <> '' THEN
    BEGIN
      AOut.Add('    .OUTPUTS');
      AOut.Add('    ' + TN);
    END;
    AOut.Add('    #>');
    AOut.Add('    [CmdletBinding()]');
    IF TN <> '' THEN
      AOut.Add('    [OutputType(' + PsQuote(TN) + ')]');
    IF Params.Count = 0 THEN
      AOut.Add('    param()')
    ELSE
    BEGIN
      AOut.Add('    param(');
      FOR I := 0 TO Params.Count - 1 DO
        IF I < Params.Count - 1 THEN
          AOut.Add(Params[I] + ',')
        ELSE
          AOut.Add(Params[I]);
      AOut.Add('    )');
    END;
    // URL with encoded path parameters
    Path := '';
    Segs := AEp.Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
    FOR Seg IN Segs DO
    BEGIN
      IF Seg.StartsWith('{') THEN
      BEGIN
        Item := Copy(Seg, 2, Length(Seg) - 2);
        FOR I := 0 TO High(AEp.Params) DO
          IF (AEp.Params[I].Loc = plPath) AND (AEp.Params[I].Name = Item) THEN
            Path := Path + ' + ''/'' + (ConvertTo-CockpitItsmUrl $' + AEp.Params[I].PasName + ')';
      END
      ELSE
        Path := Path + ' + ' + PsQuote('/' + Seg);
    END;
    Path := Copy(Path, 4, MaxInt);
    Path := StringReplace(Path, ''' + ''', '', [rfReplaceAll]);
    // Query ($null / not given not sent, arrays as repeated keys)
    HasQ := False;
    FOR I := 0 TO High(AEp.Params) DO
      IF AEp.Params[I].Loc = plQuery THEN
      BEGIN
        IF NOT HasQ THEN
          AOut.Add('    $cpQuery = New-Object System.Collections.Generic.List[string]');
        HasQ := True;
        P := AEp.Params[I];
        QVal := '$' + P.PasName;
        IF P.TypeRef.Kind = tkDateOnly THEN
          QVal := '$' + P.PasName + '.ToString(''yyyy-MM-dd'')'
        ELSE IF (P.TypeRef.Kind = tkArray) AND (P.TypeRef.ElemKind = tkDateOnly) THEN
          QVal := '@($' + P.PasName + ' | ForEach-Object { $_.ToString(''yyyy-MM-dd'') })';
        IF P.Required THEN
          AOut.Add('    Add-CockpitItsmQuery $cpQuery ' + PsQuote(P.Name) + ' ' + QVal)
        ELSE
          AOut.Add('    if ($PSBoundParameters.ContainsKey(' + PsQuote(P.PasName) + ')) { Add-CockpitItsmQuery $cpQuery ' +
            PsQuote(P.Name) + ' ' + QVal + ' }');
      END;
    IF HasQ THEN
      Path := Path + ' + (Get-CockpitItsmQueryString $cpQuery)';
    AOut.Add('    $cpPath = ' + Path);
    Call_ := 'Invoke-CockpitItsmRequest -Method ' + PsQuote(AEp.Method) + ' -PathQuery $cpPath';
    IF (AEp.RespKind <> rkPaged) AND (AEp.BodyKind <> bkNone) THEN
    BEGIN
      Call_ := Call_ + ' -Body $' + AEp.BodyName;
    END;
    CASE AEp.RespKind OF
      rkNone: AOut.Add('    $null = ' + Call_ + ' -Raw');
      rkRaw: AOut.Add('    ' + Call_ + ' -Raw');
      rkText: AOut.Add('    ConvertFrom-CockpitItsmQuoted (' + Call_ + ' -Raw)');
      rkTyped:
        IF TN <> '' THEN
          AOut.Add('    Add-CockpitItsmTypeName (' + Call_ + ') ' + PsQuote(TN))
        ELSE IF AEp.RespType.Kind = tkArray THEN
        BEGIN
          AOut.Add('    $cpResult = ' + Call_);
          AOut.Add('    $cpResult');
        END
        ELSE
        BEGIN
          AOut.Add('    $cpText = ConvertFrom-CockpitItsmQuoted (' + Call_ + ' -Raw)');
          CASE AEp.RespType.Kind OF
            tkInteger: AOut.Add('    [int]$cpText');
            tkInt64: AOut.Add('    [long]$cpText');
            tkDouble: AOut.Add('    [double]::Parse($cpText, [Globalization.CultureInfo]::InvariantCulture)');
            tkBoolean: AOut.Add('    $cpText.Trim() -eq ''true''');
            tkDate, tkDateOnly: AOut.Add('    ConvertFrom-CockpitItsmDates $cpText.Trim()');
          ELSE
            AOut.Add('    $cpText');
          END;
        END;
      rkPaged:
        BEGIN
          Desc := 'Get-CockpitItsmAllPages -Method ' + PsQuote(AEp.Method) + ' -PathQuery $cpPath';
          IF AEp.HasCriteria THEN
            Desc := Desc + ' -Body $' + AEp.BodyName;
          Desc := Desc + ' -PagePath ' + PsQuote(AEp.PagePath);
          AOut.Add('    Add-CockpitItsmTypeName (' + Desc + ') ' + PsQuote(TN));
        END;
    END;
    AOut.Add('}');
    AOut.Add('');
  FINALLY
    Params.Free;
  END;
END;

FUNCTION TApiSpec.GeneratePowerShell(ASelection: TStrings; CONST AModuleName: STRING; ALog: TStrings): STRING;
// ASelection: "METHOD /path=BaseName" lines (function name = PowerShellName(BaseName))
VAR
  Sel: TObjectList;
  Names, FuncNames, Used: TStringList;
  Code: TStringList;
  I, J, K: Integer;
  Ep: TEndpoint;
  Key, Nm, FN, Exported: STRING;
  SavedNames: ARRAY OF STRING;
  SavedBody: ARRAY OF STRING;
BEGIN
  IF (AModuleName = '') OR SameText(AModuleName, PS_CORE_FILE) THEN
    RAISE Exception.Create('Invalid PowerShell module name: ' + AModuleName);
  Sel := TObjectList.Create(False);
  Names := TStringList.Create;
  Names.CaseSensitive := False;
  FuncNames := TStringList.Create;
  Used := TStringList.Create;
  Used.CaseSensitive := False;
  Code := TStringList.Create;
  TRY
    FOR I := 0 TO ASelection.Count - 1 DO
    BEGIN
      Key := ASelection.Names[I];
      Nm := ASelection.ValueFromIndex[I];
      Ep := FindEndpoint(Key);
      IF Ep = NIL THEN
      BEGIN
        ALog.Add('MISSING from version ' + FVersion + ': ' + Key + ' (' + Nm + ') - skipped');
        Continue;
      END;
      IF NOT Ep.Supported THEN
      BEGIN
        ALog.Add('Unsupported: ' + Key + ' - ' + Ep.Reason);
        Continue;
      END;
      FN := PowerShellName(Nm);
      IF (FN = '') OR (Names.IndexOf(FN) >= 0) THEN
        RAISE Exception.Create('Invalid or duplicate function name: ' + FN + ' (' + Key + ')');
      FOR J := 0 TO High(PS_CORE_FUNCTIONS) DO
        IF SameText(FN, PS_CORE_FUNCTIONS[J]) THEN
          RAISE Exception.Create('Function name ' + FN + ' is used by the core: rename ' + Key);
      Names.Add(FN);
      Sel.Add(Ep);
      FuncNames.Add(FN);
    END;
    IF Sel.Count = 0 THEN
      RAISE Exception.Create('No endpoint selected');

    // PowerShell parameter names (PasName / BodyName restored at the end:
    // the endpoints are shared with the other generators)
    SetLength(SavedBody, Sel.Count);
    SetLength(SavedNames, 0);
    FOR I := 0 TO Sel.Count - 1 DO
    BEGIN
      Ep := TEndpoint(Sel[I]);
      SavedBody[I] := Ep.BodyName;
      FOR J := 0 TO High(Ep.Params) DO
      BEGIN
        SetLength(SavedNames, Length(SavedNames) + 1);
        SavedNames[High(SavedNames)] := Ep.Params[J].PasName;
      END;
    END;
    TRY
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Used.Clear;
        // variables of the generated functions, automatic variables and common parameters
        FOR J := 0 TO High(PS_RESERVED) DO
          Used.Add(PS_RESERVED[J]);
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := PascalWords(Ep.Params[J].Name);
          IF (Ep.Params[J].PasName = '') OR (Ep.Params[J].PasName[1] IN ['0'..'9']) THEN
            Ep.Params[J].PasName := 'P' + Ep.Params[J].PasName;
          WHILE Used.IndexOf(Ep.Params[J].PasName) >= 0 DO
            Ep.Params[J].PasName := Ep.Params[J].PasName + 'Value';
          Used.Add(Ep.Params[J].PasName);
        END;
        CASE Ep.BodyKind OF
          bkText: Ep.BodyName := 'Text';
          bkRaw: Ep.BodyName := 'Json';
          bkTyped:
            IF Ep.RespKind = rkPaged THEN
              Ep.BodyName := 'Criteria'
            ELSE IF Ep.BodyType.Kind = tkRecord THEN
              Ep.BodyName := PascalWords(BaseName(Ep.BodyType.RecName))
            ELSE
              Ep.BodyName := 'Items';
        ELSE
          Ep.BodyName := '';
        END;
        WHILE (Ep.BodyName <> '') AND (Used.IndexOf(Ep.BodyName) >= 0) DO
          Ep.BodyName := Ep.BodyName + 'Value';
      END;

      Code.Add('# Cockpit ITSM public API - GENERATED MODULE, do not edit (regenerate with CIPAT)');
      Code.Add('# Source: ' + CleanDoc(FTitle, 80) + ' ' + FVersion + ' - generated ' + FormatDateTime('yyyy-mm-dd hh:nn', Now));
      Code.Add('# Requires ' + PS_CORE_FILE + '.ps1 (same folder), Windows PowerShell 5.1 or PowerShell 7+, no dependency');
      Code.Add('#');
      Code.Add('# Selected endpoints (read back by CIPAT when regenerating):');
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Code.Add(PY_SELECTION_TAG + Ep.Method + ' ' + Ep.Path + ' ' + ASelection.Values[Ep.Key]);
      END;
      Code.Add('#');
      Code.Add('# Use:');
      Code.Add('#   Import-Module .\' + AModuleName + '.psm1');
      Code.Add('#   Connect-CockpitItsm -SaaS -Tenant mytenant -ClientId myClientId -ClientSecret $secret');
      Code.Add('#   ' + FuncNames[0] + ' ...');
      Code.Add('#   Get-Help ' + FuncNames[0] + ' -Full');
      Code.Add('# Objects returned: PSCustomObject (JSON members, dates as [datetime]), type name');
      Code.Add('# CockpitItsm.<schema>. Errors: CockpitItsm.CockpitItsmException (StatusCode, Response).');
      Code.Add('');
      Code.Add('. (Join-Path $PSScriptRoot ' + PsQuote(PS_CORE_FILE + '.ps1') + ')');
      Code.Add('');
      FOR I := 0 TO Sel.Count - 1 DO
        PsGenFunction(TEndpoint(Sel[I]), FuncNames[I], Code);
      Exported := '';
      FOR I := 0 TO FuncNames.Count - 1 DO
      BEGIN
        IF I > 0 THEN
          Exported := Exported + ',' + LineEnding + '    ';
        Exported := Exported + PsQuote(FuncNames[I]);
      END;
      Code.Add('Export-ModuleMember -Function ($script:CockpitItsmCoreFunctions + @(');
      Code.Add('    ' + Exported);
      Code.Add('))');
      Result := Code.Text;
      ALog.Add(Format('%d function(s) generated (spec %s)', [Sel.Count, FVersion]));
    FINALLY
      // Pascal names restored
      K := 0;
      FOR I := 0 TO Sel.Count - 1 DO
      BEGIN
        Ep := TEndpoint(Sel[I]);
        Ep.BodyName := SavedBody[I];
        FOR J := 0 TO High(Ep.Params) DO
        BEGIN
          Ep.Params[J].PasName := SavedNames[K];
          Inc(K);
        END;
      END;
    END;
  FINALLY
    Sel.Free;
    Names.Free;
    FuncNames.Free;
    Used.Free;
    Code.Free;
  END;
END;


{ Test templates }

FUNCTION TApiSpec.SampleValue(AS_: TJSONObject; ADepth: Integer; AWritable: Boolean): TJSONData;
// Example JSON value for a schema. AWritable (request): writable members only, references
// reduced to {"id": 0}, empty arrays. Otherwise (response): every member, one array item
VAR
  R, Typ: STRING;
  T, Props, PS: TJSONObject;
  Obj: TJSONObject;
  Ex, D: TJSONData;
  I: Integer;
BEGIN
  IF AS_ = NIL THEN
    Exit(TJSONNull.Create);
  R := RefName(AS_);
  IF R <> '' THEN
  BEGIN
    T := SchemaObj(R);
    IF T = NIL THEN
      Exit(TJSONObject.Create);
    Props := ObjObj(T, 'properties');
    // Nested reference: only the id is evaluated by the API
    IF AWritable AND (ADepth > 0) AND (Props <> NIL) AND (Props.Find('id') <> NIL) THEN
      Exit(TJSONObject.Create(['id', 0]));
    Exit(SampleValue(T, ADepth, AWritable));
  END;
  Ex := AS_.Find('example');
  IF (Ex <> NIL) AND NOT (Ex.JSONType IN [jtObject, jtArray, jtNull]) THEN
    Exit(Ex.Clone);
  Typ := ObjStr(AS_, 'type');
  D := AS_.Find('type');
  IF (D <> NIL) AND (D.JSONType = jtArray) AND (D.Count > 0) THEN
    Typ := D.Items[0].AsString;
  Props := ObjObj(AS_, 'properties');
  IF Props <> NIL THEN
  BEGIN
    Obj := TJSONObject.Create;
    IF ADepth < 4 THEN
      FOR I := 0 TO Props.Count - 1 DO
      BEGIN
        IF Props.Items[I].JSONType <> jtObject THEN
          Continue;
        PS := TJSONObject(Props.Items[I]);
        IF AWritable AND ObjBool(PS, 'readOnly') THEN
          Continue;
        Obj.Add(Props.Names[I], SampleValue(PS, ADepth + 1, AWritable));
      END;
    Exit(Obj);
  END;
  IF Typ = 'array' THEN
  BEGIN
    Result := TJSONArray.Create;
    IF NOT AWritable AND (ADepth < 4) AND (ObjObj(AS_, 'items') <> NIL) THEN
      TJSONArray(Result).Add(SampleValue(ObjObj(AS_, 'items'), ADepth + 1, AWritable));
  END
  ELSE IF Typ = 'object' THEN
    Result := TJSONObject.Create
  ELSE IF Typ = 'string' THEN
  BEGIN
    IF (ObjStr(AS_, 'format') = 'date-time') AND NOT AWritable THEN
      Result := TJSONString.Create('2026-01-31T08:00:00.000+0000')
    ELSE IF (ObjStr(AS_, 'format') = 'date') AND NOT AWritable THEN
      Result := TJSONString.Create('2026-01-31')
    ELSE IF (ObjStr(AS_, 'format') = 'date-time') OR (ObjStr(AS_, 'format') = 'date') THEN
      Result := TJSONNull.Create
    ELSE IF (AS_.Find('enum') <> NIL) AND (AS_.Find('enum').Count > 0) THEN
      Result := AS_.Find('enum').Items[0].Clone
    ELSE
      Result := TJSONString.Create('');
  END
  ELSE IF (Typ = 'integer') OR (Typ = 'number') THEN
    Result := TJSONIntegerNumber.Create(0)
  ELSE IF Typ = 'boolean' THEN
    Result := TJSONBoolean.Create(False)
  ELSE
    Result := TJSONNull.Create;
END;

FUNCTION TApiSpec.BodyTemplate(AEp: TEndpoint; APageSize: Integer): STRING;
// Request body template for the Test tab ('' if the endpoint has no body)
VAR
  V: TJSONData;
  PageObj, Child: TJSONObject;
  Member: STRING;
BEGIN
  Result := '';
  IF AEp.BodySchema = NIL THEN
    Exit;
  IF AEp.BodyKind = bkText THEN
    Exit;
  V := SampleValue(AEp.BodySchema, 0, True);
  TRY
    IF (AEp.RespKind = rkPaged) AND (V.JSONType = jtObject) THEN
    BEGIN
      PageObj := TJSONObject(V);
      FOR Member IN AEp.PagePath.Split(['.'], TStringSplitOptions.ExcludeEmpty) DO
      BEGIN
        Child := ObjObj(PageObj, Member);
        IF Child = NIL THEN
        BEGIN
          Child := TJSONObject.Create;
          PageObj.Add(Member, Child);
        END;
        PageObj := Child;
      END;
      IF PageObj.IndexOfName('page') >= 0 THEN
        PageObj.Delete('page');
      IF PageObj.IndexOfName('pageSize') >= 0 THEN
        PageObj.Delete('pageSize');
      PageObj.Add('page', 0);
      PageObj.Add('pageSize', APageSize);
    END;
    Result := V.FormatJSON;
  FINALLY
    V.Free;
  END;
END;

FUNCTION TApiSpec.ResponseExample(AEp: TEndpoint): STRING;
// Response example for the Detail page (every member, read-only ones included)
VAR
  V: TJSONData;
BEGIN
  IF AEp.RespSchema = NIL THEN
  BEGIN
    IF AEp.RespKind = rkNone THEN
      Result := ''
    ELSE
      Result := '"text"';
    Exit;
  END;
  V := SampleValue(AEp.RespSchema, 0, False);
  TRY
    Result := V.FormatJSON;
  FINALLY
    V.Free;
  END;
END;

END.
