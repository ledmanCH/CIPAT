<p align="center"><img src="Images/Logo/CIPAT.png" alt="CIPAT logo" width="40" height="40"></p>

# CIPAT — Cockpit ITSM Public API Toolkit

*After working with French colleagues for so long, I've started coming up with acronyms that don't make any sense either. So here's CIPAT. Say it out loud: CIPAT sounds like "six pattes" (six legs) in French, hence the insect.*

CIPAT (**C**ockpit **I**TSM **P**ublic **A**PI **T**oolkit) is a Lazarus (Free Pascal / LCL) desktop application built around the OpenAPI JSON files of the **Cockpit ITSM Portal Public API**. It has two main tabs:

1. **Differences**: show the *real* changes between two versions of the API specification, with the noise filtered out.
2. **API**: browse the endpoints of one spec version in a tree, and for the selected endpoint:
   - **Detail**: read its documentation (parameters, request and response examples);
   - **Test**: call it on a real portal;
   - **Generation**: produce typed access code for the ticked endpoints:
     - **Pascal**: a unit that compiles with both **Delphi** and **Lazarus/FPC**;
     - **Java**: a class for Java 11+ (`java.net.http.HttpClient`), using **org.json**;
     - **Python**: a module for Python 3.8+, standard library only;
     - **Node.js**: an ES module for Node.js 18+, no dependency, typed with JSDoc;
     - **C#**: a class for .NET 6+ (`HttpClient`, `System.Text.Json`), no package;
     - **VB.NET**: the same class in Visual Basic, .NET 6+, no package;
     - **PowerShell**: a script module for Windows PowerShell 5.1 and PowerShell 7+, no module dependency.

---

## Contents

- [Project files](#project-files)
- [Building](#building)
- [Getting started](#getting-started)
- [Differences tab](#differences-tab)
  - [What is ignored](#what-is-ignored)
  - [How arrays are compared](#how-arrays-are-compared)
  - [Options](#options)
  - [Result list](#result-list)
  - [Export and full history](#export-and-full-history)
- [API tab](#api-tab)
  - [Endpoint tree](#endpoint-tree)
  - [Detail page](#detail-page)
- [Generation page](#generation-page)
  - [Workflow](#workflow)
  - [Endpoint grid](#endpoint-grid)
  - [Default method names](#default-method-names)
  - [Selection persistence](#selection-persistence)
  - [Unsupported endpoints](#unsupported-endpoints)
- [Generated Java code](#generated-java-code)
- [Generated Python code](#generated-python-code)
- [Generated Node.js code](#generated-nodejs-code)
- [Generated C# code](#generated-c-code)
- [Generated VB.NET code](#generated-vbnet-code)
- [Generated PowerShell code](#generated-powershell-code)
- [Test page](#test-page)
  - [Configuration](#configuration)
  - [Sending a request](#sending-a-request)
- [Generated code](#generated-code)
  - [Unit layout](#unit-layout)
  - [Type mapping](#type-mapping)
  - [Records](#records)
  - [Method signatures](#method-signatures)
  - [Paged lists](#paged-lists)
  - [Serialization rules (records → JSON)](#serialization-rules-records--json)
  - [Deserialization rules (JSON → records)](#deserialization-rules-json--records)
- [Runtime core: uCockpitItsmCore.pas](#runtime-core-ucockpititsmcorepas)
  - [TCockpitItsmInstance / TCockpitItsmBase](#tcockpititsminstance--tcockpititsmbase)
  - [Authentication](#authentication)
  - [HTTP transport](#http-transport)
  - [Error handling](#error-handling)
  - [Dates](#dates)
  - [Strings and encoding](#strings-and-encoding)
  - [Low-level access](#low-level-access)
- [Usage examples](#usage-examples)
- [Settings file](#settings-file)
- [Known limitations and assumptions](#known-limitations-and-assumptions)

---

## Project files

| File | Role |
|---|---|
| `CIPAT.lpi` / `CIPAT.lpr` | Lazarus project and program |
| `uMain.pas` / `uMain.lfm` | Main form (both tabs) |
| `uApiDiff.pas` | Comparison engine (JSON tree diff, Markdown report) |
| `uApiGen.pas` | OpenAPI analysis and Pascal code generator |
| `uCockpitItsmCore.pas` | Runtime core used by the generated unit (Delphi + FPC). Maintained by hand, compiled into CIPAT as a resource and copied next to each generated unit |
| `cockpit_itsm_core.py` | Runtime core used by the generated Python module (Python 3.8+, standard library only). Maintained by hand, compiled into CIPAT as a resource (`COCKPITITSMCORE_PY`) and copied next to each generated module |
| `cockpit-itsm-core.mjs` | Runtime core used by the generated Node.js module (Node.js 18+, ES module, no dependency). Maintained by hand, compiled into CIPAT as a resource (`COCKPITITSMCORE_JS`) and copied next to each generated module |
| `CockpitItsmCore.cs` | Runtime core used by the generated C# class (.NET 6+, no package). Maintained by hand, compiled into CIPAT as a resource (`COCKPITITSMCORE_CS`) and copied next to each generated class |
| `CockpitItsmCore.vb` | Runtime core used by the generated VB.NET class (.NET 6+, no package). Maintained by hand, compiled into CIPAT as a resource (`COCKPITITSMCORE_VB`) and copied next to each generated class |
| `CockpitItsmCore.ps1` | Runtime core dot-sourced by the generated PowerShell module (Windows PowerShell 5.1, PowerShell 7+). Maintained by hand, compiled into CIPAT as a resource (`COCKPITITSMCORE_PS`) and copied next to each generated module |
| `SynHighlighterPowerShell.pas` | PowerShell highlighter (`TSynPowerShellSyn`): Lazarus port of `SynHighlighterPowerShell.pas` of [TurboPack SynEdit](https://github.com/TurboPack/SynEdit) (MPL 1.1 / GPL 2+), Lazarus having none. Created at run time by the main form, so it does not need to be installed in the IDE |
| `CockpitItsmCore.java` | Runtime core used by the generated Java class (Java 11+, org.json). Maintained by hand, compiled into CIPAT as a resource (`COCKPITITSMCORE_JAVA`) and copied next to each generated class |
| `Example/uCockpitItsmApi.pas` | Example generated unit (10 endpoints) |
| `CIPAT.ico` | Application icon (16 to 256 px), declared in the `.lpi` and compiled into the executable |
| `Images/Logo/CIPAT.png`, `CIPAT.svg` | Logo (512×512 transparent PNG) and its vector source |
| `Images/Png/16x16/*.png` | Tab and button icons, compiled into the executable as project resources (`RCDATA`, declared in the `.lpi`) and loaded into a `TImageList` at startup |
| `Images/Png/24x24/lang-*.png` | Logos of the languages shown next to the language list (Delphi for Pascal, Python, Java, Node.js, C#, PowerShell, Visual Basic), from [devicon](https://github.com/devicons/devicon) (MIT, Copyright (c) 2015 konpa), compiled into the executable as project resources (`LANG_DELPHI`, `LANG_PYTHON`, `LANG_JAVA`, `LANG_NODEJS`, `LANG_CSHARP`, `LANG_POWERSHELL`, `LANG_VB`) |

CIPAT depends on:

- the LCL, **SynEdit** and **laz.virtualtreeview_package** (`TLazVirtualStringTree`), all shipped with Lazarus;
- FPC's `fpjson`;
- the **ExtraSyn** package (`ExtraHighlighters`), which provides `TSynJSONSyn` (unit `SynHighlighterJSON`) for JSON and `TSynCSSyn` (unit `SynHighlighterCS`) for C# syntax highlighting.

## Building

1. Install **ExtraSyn** with the Online Package Manager (*Package → Online Package Manager → ExtraSyn*). Alternatively, compile `extrahighlighters.lpk` from Lazarus-CCR.
2. Open `CIPAT.lpi` in Lazarus and build it, or run:

```
lazbuild CIPAT.lpi
```

## Getting started

1. Download the API JSON files from the Cockpit ITSM portal into one folder. Any file name works, including the portal's default `document.json`.
2. Start CIPAT and pick that folder in **JSON folder** (top of the window).
3. Files are listed and sorted **numerically by version** (`2025.6.7` < `2025.11.2`).
   - The version is read **inside each file** (`info.version`).
   - The file name is used only as a fallback, when the file cannot be parsed or has no version: in that case the text after the last ` - ` is taken.
   - When several files contain the same version, the file name is added to the label: `2026.8.4 (document.json)`.
   - Versions are cached in the settings file (`[Versions]`, `file name=version|file date`). A file is parsed again only when it is new or has been modified. The section is written as soon as the folder has been scanned, and entries of files that no longer exist are removed.
4. The folder is **rescanned automatically** when the window gets the focus back, if its content changed: a file was added, removed or replaced (for example a new `document.json` downloaded over the old one).
   - The versions chosen in the lists are kept when their files still exist.
   - The generator grid and the Test tree are rebuilt only if the generator's spec file changed.

The folder applies to both tabs.

---

## Differences tab

Pick an **Old** and a **New** version, then click **Compare**. The two most recent versions are preselected when the folder loads.

The comparison walks both JSON documents recursively and reports three kinds of differences:

| Type | Meaning |
|---|---|
| **Added** (green) | Key or array element present only in the new version |
| **Removed** (red) | Key or array element present only in the old version |
| **Changed** (blue) | Same location, different value or different JSON type |

When a whole subtree is added or removed (a new endpoint, a new schema, a new property), it is reported **once** at its root, with its full JSON value. It is not reported again for every leaf.

### What is ignored

These are never reported:

- every `operationId` key, at any depth (the values are regenerated by the portal and change all the time);
- `servers[*].url` (it depends on the portal the file was downloaded from).

### How arrays are compared

Array order is not significant. Each array is compared using the first rule that applies:

1. **All elements are scalars** (`enum`, `required`, `tags`, …): compared as **sets**. Values that appear or disappear are reported as additions or removals on `path[]`.
2. **All elements are identifiable objects**: elements are matched by key, then compared recursively.
   - parameters: `in` + `name` (shown as `parameters[query:startDate]`);
   - other objects that have a `name`: `name`;
   - objects that have a `$ref`: the reference.
3. **Otherwise**: compared by index (`[0]`, `[1]`, …), and extra elements are reported as additions or removals.

Without these rules, simply reordering parameters would show up as dozens of changes.

### Options

| Option | Default | Effect |
|---|---|---|
| **Ignore info.version** | on | Ignores `info.version`, which always differs |
| **Ignore texts (description, summary)** | off | Ignores the **string** values of `description` and `summary`. A schema property *named* `description` is an object, so it is still compared |
| **Ignore schema / $ref case** | off | Compares `$ref` values case-insensitively, and pairs schemas whose names differ only by case (e.g. `EndUser` → `endUser` in 2026.07.1) |

Changing an option recomputes the current comparison immediately. Options are saved in the settings file.

### Result list

Each difference is split into columns:

| Column | Content |
|---|---|
| Type | Added / Removed / Changed |
| Category | `Endpoint`, `Schema`, `Component`, `Info`, `Tag` or `Other` |
| Element | `GET /api/ticket/{ticketId}/logs`, schema name, … |
| Chemin | Path inside the element, e.g. `properties.dateFormat.description` |
| Old / New value | Compact single-line value |

- Rows are sorted by category, element, path, then type.
- Selecting a row shows the full, formatted old and new values in the bottom pane (SynEdit with JSON highlighting).
- **Filter** searches every column, case-insensitively.
- The status bar summarises the comparison: totals by type, plus endpoints and schemas added and removed.

### Export and full history

- **Export...** saves the current comparison as Markdown, grouped by `### <Category> <Element>`.
- **Full history...** compares every pair of consecutive versions in the folder and writes a single Markdown changelog, newest first, using the current options. Versions without changes are marked *No difference*.

---

## API tab

The left side holds the spec **Version** (the latest one by default), the filters and the endpoint tree. The right side is a page control (**Detail**, **Test**, **Generation**) showing the endpoint selected in the tree.

### Endpoint tree

The tree is a `TLazVirtualStringTree` (package `laz.virtualtreeview_package`, shipped with Lazarus). Endpoints are grouped by tag, like in the portal, and each group shows its count.

| Column | Content |
|---|---|
| Endpoint | `METHOD /path`, colored by method (GET green, POST blue, PUT orange, DELETE red) |
| *Language* name | Method name in the generated file, for the language chosen on the Generation page (`ListEndUsers` in Pascal, `listEndUsers` in Java and Node.js, `list_end_users` in Python, `ListEndUsersAsync` in C# and VB.NET, `Find-CockpitEndUsers` in PowerShell). Edit it with a double click or **F2** |
| Remark | Description, `[DEPRECATED]`, `[all pages]` for paged lists, or the reason the generator does not support the endpoint |

**Checkboxes = selection for the generated unit.**

- Ticking a **tag** ticks all its endpoints. The tag box shows a partial state when only some of them are ticked.
- Endpoints the generator does not support have no checkbox, but they can still be read and tested.

Display conventions:

- **bold** name: the endpoint is selected;
- struck out: deprecated;
- grey: not supported by the generator;
- red name: not a valid identifier in the chosen language.

Filters:

- **Filter**: text search on tag, method, path, name and description; matching groups are expanded;
- **Selection only**: shows only ticked endpoints;
- **Hide unsupported**: hides unsupported endpoints;
- **Hide DEPRECATED**: hides deprecated endpoints;
- **Uncheck all**: clears the whole selection.

Endpoints hidden by a filter keep their selection state. Expanded groups stay expanded when the tree is rebuilt.

### Detail page

The documentation of the selected endpoint, available offline and for any spec version:

- title (method, path, tag) and full description;
- parameters grid: name, location (path/query), type, required, description;
- **request body example**: the same template as the Test page (writable members only);
- **response example**: every member of the response, read-only ones included, with one item in each array and sample dates.

## Generation page

1. Choose the **Language**: Pascal, Python, Java, Node.js, C#, PowerShell or VB.NET. The logo of the language is shown next to the list.
2. Choose the target file in **Generated file** (`.pas`, `.py`, `.java`, `.mjs`, `.cs`, `.psm1` or `.vb`). Each language has its own file, stored in the settings file; switching language switches the file.
   - Pascal: the unit name is taken from the file name and must be a valid identifier.
   - Java: the class name is taken from the file name and must be a valid Java identifier (the class is generated in the default package).
   - Python: the module name is taken from the file name and must be a valid Python identifier; the class name is its PascalCase form (`cockpit_itsm_api.py` → `CockpitItsmApi`).
   - Node.js: the class name is the PascalCase form of the file name (`cockpit-itsm-api.mjs` → `CockpitItsmApi`).
   - C#: the class name is taken from the file name and must be a valid C# identifier (`CockpitItsmApi.cs` → `CockpitItsmApi`, namespace `CockpitItsm`).
   - PowerShell: the module name is the file name (`CockpitItsmApi.psm1`).
   - VB.NET: the class name is taken from the file name and must be a valid VB identifier (`CockpitItsmApi.vb` → `CockpitItsmApi`, namespace `CockpitItsm`).
   - If the file already exists, its endpoint selection is read back (see [Selection persistence](#selection-persistence)). If it does not exist yet, the current selection is kept, so the same endpoints can be generated in another language.
3. Tick the endpoints in the tree and rename methods if you want.
4. Click **Generate unit** (Pascal), **Generate module** (Python, Node.js, PowerShell) or **Generate class** (Java, C#, VB.NET).

The page shows the generated file in a SynEdit with the highlighter of its language (`TSynPasSyn`, `TSynPythonSyn`, `TSynJavaSyn`, `TSynJScriptSyn`, `TSynCSSyn`, `TSynVBSyn`, `TSynPowerShellSyn`), switched with the language; the colors of each highlighter are set with the **Colors** button (JSON, Pascal, Java, Python, JavaScript, C#, PowerShell, VB.NET) and saved as soon as the dialog is validated; an existing file is displayed as soon as it is chosen. The summary line gives the number of methods and types. It turns red, with the details as a hint, when there are warnings: selected endpoints absent from the chosen version, or not supported.

The runtime core is compiled into CIPAT and **written next to the generated file at each generation**: `uCockpitItsmCore.pas` (resource `UCOCKPITITSMCORE`), `cockpit_itsm_core.py` (resource `COCKPITITSMCORE_PY`), `CockpitItsmCore.java` (resource `COCKPITITSMCORE_JAVA`) `cockpit-itsm-core.mjs` (resource `COCKPITITSMCORE_JS`), `CockpitItsmCore.cs` (resource `COCKPITITSMCORE_CS`), `CockpitItsmCore.vb` (resource `COCKPITITSMCORE_VB`) or `CockpitItsmCore.ps1` (resource `COCKPITITSMCORE_PS`). The file is rewritten only when it is missing or different, and the summary tells which case applied: *created*, *updated* or *up to date*. The core used by your projects therefore always matches the generator that produced the code.

### Default method names

Names are derived from the path; `operationId` values are random and cannot be used.

- `/api` and `{parameters}` are dropped, and each segment is converted to PascalCase (`end-users` → `EndUsers`).
- If the path contains a `list` segment, the name is `List` + the other segments: `POST /api/end-users/list` → `ListEndUsers`.
- Otherwise the HTTP method is used as a prefix: `GET /api/end-users/{userId}` → `GetEndUsers`, `PUT /api/ticket/{ticketId}/update-title` → `PutTicketUpdateTitle`.
- When two supported endpoints end up with the same name, the generator first adds `By<PathParams>` (`GetTeams` / `GetTeamsById`), then the method prefix, then an index.

A custom name is stored only if it differs from the default name. Names are stored in PascalCase whatever the language: the Java method name is the same name with a lower-case first letter (`ListEndUsers` → `listEndUsers`), the Python one its snake_case form (`list_end_users`); Node.js uses the Java name; C# and VB.NET add `Async` (`ListEndUsersAsync`); PowerShell builds a `Verb-CockpitNoun` name with an approved verb (see [Generated PowerShell code](#generated-powershell-code)).

### Selection persistence

The generated file is the single source of truth. Its header lists the selected endpoints with their method names (same lines in every language, starting with `#` in Python):

```pascal
// @endpoint POST /api/end-users/list ListEndUsers
// @endpoint GET /api/end-users/{userId} GetEndUsers
```

When you choose an existing unit, or when CIPAT starts with the last used unit (stored in the settings file), these lines are parsed to restore the checkboxes and names.

If a selected endpoint does not exist in the chosen spec version:

- the log reports it as `MISSING`;
- it is skipped during generation;
- it stays in the selection, so switching back to an older version restores it.

To upgrade to a new API version: run the **Differences** tab first to see what changed, then select the new version in the API tab and regenerate.

### Unsupported endpoints

| Reason | Endpoints |
|---|---|
| `GET`/`DELETE` with a request body | `GET .../list` variants and `DELETE /api/secured-data/{id}/remove-element`. Every GET-with-body has an equivalent **POST** endpoint; use that one |
| Binary file upload | `POST /api/report/custom/add` |
| Authentication | `/oauth2/token`, handled by `Authenticate` |
| Parameter types | Path parameters other than string/integer; query parameters that are objects |

With spec 2026.8.4, 266 of the 282 endpoints are supported.

## Generated Java code

One file, `<ClassName>.java`, in the default package, next to `CockpitItsmCore.java`. Requirements: **Java 11** or later and **org.json** (`JSONObject`, `JSONArray`, `JSONTokener`) on the class path.

```java
// header: source spec version, generation date, @endpoint selection
import org.json.JSONArray;
import org.json.JSONObject;

public class CockpitItsmApi extends CockpitItsmCore {
    public CockpitItsmApi() { }
    public CockpitItsmApi(boolean saas, String tenant, String clientId, String clientSecret) { ... }

    public static class EndUser {          // one nested class per schema actually used
        public Long id;                    // public fields, boxed types: null = missing / not sent
        public String firstName;
        public Department department;
        public java.util.List<Tag> tags;
        public static EndUser fromJson(JSONObject src) { ... }
        public static java.util.List<EndUser> listFromJson(JSONArray src) { ... }
        public JSONObject toJson() { ... }  // only for types that are sent
        public static JSONArray listToJson(java.util.List<EndUser> items) { ... }
    }

    public EndUser getEndUsers(long userId) { ... }   // one method per selected endpoint
}
```

| OpenAPI | Java |
|---|---|
| `string`, enum, raw JSON | `String` |
| `string` + `date-time` | `java.time.Instant` (UTC) |
| `string` + `date` | `java.time.LocalDate` |
| `integer` + `int32` / int64 | `Integer` / `Long` |
| `number` / `boolean` | `Double` / `Boolean` |
| object schema | nested class |
| array | `java.util.List<…>` |

- **Fields**: `null` means missing in the response, and is not sent in a request. Read-only fields are never sent. Field names are the JSON names; Java reserved words get a trailing underscore.
- **Class names**: schema names; names that would hide a type used by the generated code (`List`, `String`, `Map`…) get a trailing underscore (`List_`).
- **Method parameters**, in the same order as in Pascal: path parameters and required query parameters as primitives (`long`, `int`, `boolean`…), the body, then optional query parameters as boxed types (`null` = not sent). Array query parameters are `java.util.List` and sent as repeated keys.
- **Return values**: nested class, `java.util.List<…>`, `String` (text or raw JSON), boxed primitive, or `void`.
- **Paged lists** read every page (`fetchAllPages`). As in Pascal, an overload without the criteria object is generated when the criteria have fields besides the paging ones.
- Deprecated endpoints are marked `@Deprecated`.
- A method name used by `CockpitItsmCore` (`call`, `list`, `put`…) is refused: rename the endpoint in the tree.

`CockpitItsmCore` provides the same services as the Pascal core: OAuth token (`authenticate`, renewed automatically, re-authentication on 401), `call` / `callJson` / `fetchAllPages` for endpoints that were not generated, `setToken` to share a token between instances, `setHttpClient` (proxy, TLS…), and `getBaseUrl` / `baseUrl(saas, tenant)`. Any non-2xx response throws `CockpitItsmCore.CockpitItsmException` (`getStatusCode()`, `getMessage()`, `getResponse()`).

```java
CockpitItsmApi api = new CockpitItsmApi(true, "mytenant", "myClientId", "myClientSecret");
try {
    java.util.List<CockpitItsmApi.EndUser> users = api.listEndUsers(null, java.util.Arrays.asList(4L, 9L), null);
    CockpitItsmApi.EndUser user = api.getEndUsers(42);
    user.position = "Team lead";
    user = api.postEndUsers(user);
} catch (CockpitItsmCore.CockpitItsmException e) {
    System.err.println(e.getMessage() + " (HTTP " + e.getStatusCode() + ")");
}
```

## Generated Python code

One module, `<module_name>.py`, next to `cockpit_itsm_core.py`. Requirements: **Python 3.8** or later, standard library only (`urllib`, `json`, `datetime`, `dataclasses`). The generated module passes `pyflakes` and `mypy`.

```python
# header: source spec version, generation date, @endpoint selection
from __future__ import annotations
...
from cockpit_itsm_core import CockpitItsmCore, CockpitItsmError, ...   # only the helpers used

@dataclass
class EndUser:                          # one dataclass per schema actually used
    id: Optional[int] = None            # None = missing / not sent
    firstName: Optional[str] = None
    department: Optional[ReferenceWithName] = None
    tags: Optional[List[Tag]] = None

    @classmethod
    def from_json(cls, src: Any) -> Optional[EndUser]: ...
    @classmethod
    def list_from_json(cls, src: Any) -> Optional[List[EndUser]]: ...
    def to_json(self) -> Dict[str, Any]: ...      # only for types that are sent
    @staticmethod
    def list_to_json(items: Optional[List[EndUser]]) -> List[Any]: ...


class CockpitItsmApi(CockpitItsmCore):
    def get_end_users(self, user_id: int) -> Optional[EndUser]: ...
    def list_end_users(
        self,
        criteria: Optional[PageRequestWithSearch] = None,
        *,
        only_with_portal_access: Optional[bool] = None,
        organization_ids: Optional[List[int]] = None,
        department_id: Optional[int] = None,
    ) -> Optional[List[EndUser]]: ...
```

| OpenAPI | Python |
|---|---|
| `string`, enum, raw JSON | `str` |
| `string` + `date-time` | `datetime.datetime` (aware, UTC; a naive value is taken as local time when sent) |
| `string` + `date` | `datetime.date` |
| `integer` / `number` / `boolean` | `int` / `float` / `bool` |
| object schema | dataclass |
| array | `List[…]` |

- **Fields** keep the JSON names (`firstName`); Python keywords and names that would hide a member (`to_json`…) get a trailing underscore. Read-only fields are never sent.
- **Method names** and **parameters** are snake_case. Path parameters, required query parameters and the body are positional; optional query parameters are **keyword-only** (`None` = not sent). List query parameters are sent as repeated keys.
- **Paged lists** read every page; the criteria object is an optional parameter (`None` = no criteria), so no overload is needed.
- Deprecated endpoints are marked `[DEPRECATED]` in their docstring.
- A method name used by `CockpitItsmCore` (`call`, `authenticate`…) is refused: rename the endpoint in the tree.

`CockpitItsmCore` (module `cockpit_itsm_core`) provides the same services as the other cores: OAuth token (renewed automatically, re-authentication on 401), `call` / `call_json` / `fetch_all_pages`, `set_token(token, expiry)` to share a token, `ssl_context`, `page_size`, `timeout`, `base_url` / `make_base_url(saas, tenant)`. The system proxy settings (`HTTPS_PROXY`…) are used by `urllib`. Any non-2xx response raises `CockpitItsmError` (`status_code`, `response`).

```python
from cockpit_itsm_api import CockpitItsmApi, CockpitItsmError

api = CockpitItsmApi(True, "mytenant", "myClientId", "myClientSecret")
try:
    users = api.list_end_users(organization_ids=[4, 9])
    user = api.get_end_users(42)
    user.position = "Team lead"
    user = api.post_end_users(user)
except CockpitItsmError as e:
    print(f"{e} (HTTP {e.status_code})")
```

## Generated Node.js code

One ES module, `<module-name>.mjs`, next to `cockpit-itsm-core.mjs`. Requirements: **Node.js 18** or later, no dependency (`fetch`, `FormData` and `AbortSignal.timeout` of Node.js). Types are given as **JSDoc** comments: no build step, and VS Code (or `tsc --checkJs`) shows the completion and the types of every schema. The generated module passes `tsc --checkJs --strict`.

```js
// header: source spec version, generation date, @endpoint selection
import { CockpitItsmCore, CockpitItsmError, ... } from './cockpit-itsm-core.mjs';  // only the helpers used

/**
 * @typedef {Object} EndUser              // one JSDoc type per schema actually used:
 * @property {number} [id]                // plain objects, undefined = missing / not sent
 * @property {string} [firstName]
 * @property {ReferenceWithName} [department]
 * @property {Date} [creationTimestamp]
 */

/** JSON conversion of EndUser */
export const EndUser = { fromJson(src), listFromJson(src), toJson(v), listToJson(items) };

export class CockpitItsmApi extends CockpitItsmCore {
  async getEndUsers(userId) { ... }                       // Promise<EndUser | undefined>
  async listEndUsers(criteria, options = {}) { ... }      // Promise<EndUser[] | undefined>, all pages
}
```

| OpenAPI | JavaScript |
|---|---|
| `string`, enum, raw JSON | `string` |
| `string` + `date-time` | `Date` (sent as UTC, `yyyy-mm-ddThh:nn:ss.zzzZ`) |
| `string` + `date` | `string` (`yyyy-mm-dd`) |
| `integer` / `number` | `number` |
| `boolean` | `boolean` |
| object schema | plain object (JSDoc type) |
| array | `Type[]` |

- **Module and class names**: the module name is the file name (`cockpit-itsm-api.mjs`); the class name is its PascalCase form (`CockpitItsmApi`).
- **Members** keep the JSON names. Read-only members are never sent; `undefined` and `null` are not sent. `null` items of a list are dropped when read.
- **Methods** are `async`, camelCase (same names as Java). Parameters: path parameters, required query parameters and the body are positional; optional query parameters are passed in an **options object** (`{ organizationIds: [4, 9] }`, undefined = not sent). List query parameters are sent as repeated keys.
- **Paged lists** read every page; the criteria object is an optional parameter (`undefined` = no criteria).
- Deprecated endpoints are marked `@deprecated` (shown struck out by VS Code).
- A method name used by `CockpitItsmCore` (`call`, `authenticate`…) is refused: rename the endpoint in the tree.

`CockpitItsmCore` (module `cockpit-itsm-core.mjs`) provides the same services as the other cores: OAuth token (renewed automatically, re-authentication on 401), `call` / `callJson` / `fetchAllPages`, `setToken(token, expiry)` to share a token, `pageSize`, `timeout` (ms), `baseUrl` / `makeBaseUrl(saas, tenant)`. Any non-2xx response, network error or invalid response throws `CockpitItsmError` (`statusCode`, `response`).

The `fetch` of Node.js ignores the `HTTPS_PROXY` variables and the Windows certificate store: for a proxy or an SSL inspection certificate, either set `NODE_EXTRA_CA_CERTS` (PEM file of the root certificate), or give your own `fetch` with `setFetch` (e.g. the `fetch` of the `undici` package with a `ProxyAgent`).

```js
import { CockpitItsmApi, CockpitItsmError } from './cockpit-itsm-api.mjs';

const api = new CockpitItsmApi(true, 'mytenant', 'myClientId', 'myClientSecret');
try {
  const users = await api.listEndUsers(undefined, { organizationIds: [4, 9] });
  const user = await api.getEndUsers(42);
  user.position = 'Team lead';
  await api.postEndUsers(user);
} catch (e) {
  if (e instanceof CockpitItsmError) console.error(`${e.message} (HTTP ${e.statusCode})`);
  else throw e;
}
```

---

## Generated C# code

One C# file, `<ClassName>.cs`, to add to a project next to `CockpitItsmCore.cs`. Requirements: **.NET 6** or later (`DateOnly`), no NuGet package (`HttpClient`, `System.Text.Json.Nodes`). The code is written with `#nullable enable` and compiles without warnings with `TreatWarningsAsErrors` and the `latest-recommended` analyzers (tested with .NET 8).

```csharp
// header: source spec version, generation date, @endpoint selection
#nullable enable
using static CockpitItsm.CockpitItsmCore;

namespace CockpitItsm
{
    public sealed class EndUser                    // one class per schema actually used
    {
        public long? Id { get; set; }              // PascalCase of the JSON name, null = missing / not sent
        public string? FirstName { get; set; }
        public ReferenceWithName? Department { get; set; }
        public DateTimeOffset? CreationTimestamp { get; set; }
        public static EndUser? FromJson(JsonNode? src) ...
        public static List<EndUser>? ListFromJson(JsonNode? src) ...
        public JsonObject ToJson() ...             // read-only members are not sent
        public static JsonArray ListToJson(IEnumerable<EndUser>? items) ...
    }

    public class CockpitItsmApi : CockpitItsmCore
    {
        public async Task<EndUser?> GetEndUsersAsync(long userId, CancellationToken cancellationToken = default) ...
        public async Task<List<EndUser>?> ListEndUsersAsync(PageRequestWithSearch? criteria = null,
            bool? onlyWithPortalAccess = null, List<long>? organizationIds = null, long? departmentId = null,
            CancellationToken cancellationToken = default) ...   // all pages
    }
}
```

| OpenAPI | C# |
|---|---|
| `string`, enum, raw JSON | `string?` |
| `string` + `date-time` | `DateTimeOffset?` (sent as UTC, `yyyy-MM-ddTHH:mm:ss.fffZ`) |
| `string` + `date` | `DateOnly?` |
| `integer` (int32 / int64) | `int?` / `long?` |
| `number` | `double?` |
| `boolean` | `bool?` |
| object schema | class |
| array | `List<T>?` |

- **Class name**: the file name (`CockpitItsmApi.cs` → `CockpitItsmApi`), in the namespace `CockpitItsm`. The name `CockpitItsmCore` is refused.
- **Methods** are `async` and end with `Async`. Parameters: path parameters, required query parameters and the body (or the criteria of a paged list) first, then the optional query parameters with a `null` default (not sent), then a `CancellationToken`.
- **Paged lists** read every page.
- Deprecated endpoints are marked `[Obsolete]`.
- A member named like its class (`Sort` in `Sort`) is qualified with `global::CockpitItsm.` where needed.
- A method name used by `CockpitItsmCore` (`CallAsync`, `AuthenticateAsync`…) is refused: rename the endpoint in the tree.

`CockpitItsmCore` (file `CockpitItsmCore.cs`, `IDisposable`) provides the same services as the other cores: OAuth token (renewed automatically, thread-safe, re-authentication on 401), `CallAsync` / `CallJsonAsync` / `FetchAllPagesAsync`, `SetToken(token, expiry)` to share a token, `PageSize`, `LastStatus`, `BaseUrl` / `MakeBaseUrl(saas, tenant)`. An optional `HttpClient` can be given to the constructor (proxy, certificates, timeout); otherwise the core creates one (system proxy). Any non-2xx response, network error or invalid response throws `CockpitItsmException` (`StatusCode`, `Response`; `StatusCode` = 0 for a network error).

```csharp
using CockpitItsm;

using var api = new CockpitItsmApi(true, "mytenant", "myClientId", "myClientSecret");
try
{
    var users = await api.ListEndUsersAsync(organizationIds: new List<long> { 4, 9 });
    var user = await api.GetEndUsersAsync(42);
    if (user != null)
    {
        user.Position = "Team lead";
        await api.PostEndUsersAsync(user);
    }
}
catch (CockpitItsmException e)
{
    Console.Error.WriteLine($"{e.Message} (HTTP {e.StatusCode})");
}
```

---

## Generated VB.NET code

One Visual Basic file, `<ClassName>.vb`, to add to a VB project next to `CockpitItsmCore.vb`. It is the C# class written in VB: same classes, same methods, same core services (see [Generated C# code](#generated-c-code)). Requirements: **.NET 6** or later, no NuGet package. The code is written with `Option Strict On` and compiles without warnings with `TreatWarningsAsErrors` (tested with .NET 8).

```vb
' header: source spec version, generation date, ' @endpoint selection
Option Strict On
Imports CockpitItsm.CockpitItsmCore

Namespace Global.CockpitItsm      ' independent of the root namespace of the project

    Public NotInheritable Class EndUser
        Public Property Id As Long?                       ' Nothing = missing / not sent
        Public Property FirstName As String
        Public Property Department As ReferenceWithName
        Public Property CreationTimestamp As DateTimeOffset?
        Public Shared Function FromJson(src As JsonNode) As EndUser ...
        Public Function ToJson() As JsonObject ...
    End Class

    Public Class CockpitItsmApi
        Inherits CockpitItsmCore
        Public Async Function GetEndUsersAsync(userId As Long, Optional cancellationToken As CancellationToken = Nothing) As Task(Of EndUser)
        Public Async Function ListEndUsersAsync(Optional criteria As PageRequestWithSearch = Nothing,
            Optional onlyWithPortalAccess As Boolean? = Nothing, Optional organizationIds As List(Of Long) = Nothing, ...) As Task(Of List(Of EndUser))
    End Class
End Namespace
```

- Types: `String`, `Integer?`, `Long?`, `Double?`, `Boolean?`, `DateTimeOffset?`, `DateOnly?`, classes and `List(Of T)`; required path and query parameters are not nullable.
- The namespace is declared `Global.CockpitItsm`, so it does not depend on the root namespace of the project.
- VB is **case insensitive**: names that differ only by case get a trailing `_` (`Url` / `URL` → `Url`, `Url_`), keywords too (`Option_`, `Date_`), and a class hidden by a property or a parameter of the same name (`endUser As EndUser`) is written `Global.CockpitItsm.EndUser` where needed.
- Deprecated endpoints are marked `<Obsolete>`.

```vb
Imports CockpitItsm

Using api As New CockpitItsmApi(True, "mytenant", "myClientId", "myClientSecret")
    Try
        Dim users = Await api.ListEndUsersAsync(organizationIds:=New List(Of Long) From {4, 9})
        Dim user = Await api.GetEndUsersAsync(42)
        user.Position = "Team lead"
        Await api.PostEndUsersAsync(user)
    Catch e As CockpitItsmException
        Console.Error.WriteLine($"{e.Message} (HTTP {e.StatusCode})")
    End Try
End Using
```

---

## Generated PowerShell code

One script module, `<ModuleName>.psm1`, next to `CockpitItsmCore.ps1`, which it dot-sources. Requirements: **Windows PowerShell 5.1** or **PowerShell 7+**, no module to install (`System.Net.Http.HttpClient` through a small C# 5 helper compiled with `Add-Type` at import). Each endpoint is an advanced function (`[CmdletBinding()]`) with comment-based help, so `Get-Help` and tab completion work.

```powershell
Import-Module .\CockpitItsmApi.psm1
Connect-CockpitItsm -SaaS -Tenant mytenant -ClientId myClientId -ClientSecret $secret
$users = Find-CockpitEndUsers -OrganizationIds 4, 9         # all pages
$user  = Get-CockpitEndUsers -UserId 42
$user.position = 'Team lead'
Invoke-CockpitEndUsers -EndUser $user
try { Get-CockpitEndUsers -UserId 0 }
catch [CockpitItsm.CockpitItsmException] { "$($_.Exception.Message) (HTTP $($_.Exception.StatusCode))" }
Disconnect-CockpitItsm
```

- **Function names** follow `Verb-CockpitNoun` with an approved verb, so `Import-Module` shows no warning: `Get` → `Get`, `List` → `Find`, `Post` → `Invoke`, `Put` → `Set`, `Delete` → `Remove`, `Patch` → `Update`; a custom name starting with an approved verb keeps it (`Search-CockpitEndUsers`), any other name becomes `Invoke-Cockpit<Name>`. In the tree, a PowerShell name can be typed directly (`Get-CockpitEndUser`); it is stored as `GetEndUser`.
- **Parameters**: path parameters, required query parameters and the body are mandatory; optional query parameters are sent only when given. Bodies and criteria are hashtables or PSCustomObjects; `$null` members are not sent, `[datetime]` values are sent as UTC.
- **Results** are PSCustomObjects with the JSON member names, dates converted to `[datetime]`, and the type name `CockpitItsm.<Schema>` (usable in format files or with `$obj.PSTypeNames`).
- **Paged lists** read every page; the criteria are an optional `-Criteria` parameter.
- Deprecated endpoints say so in their help.

`CockpitItsmCore.ps1` provides `Connect-CockpitItsm` (`-SaaS`, `-Tenant`, `-ClientId`, `-ClientSecret`, `-PageSize`, `-TimeoutSec`, `-SkipCertificateCheck`), `Disconnect-CockpitItsm`, `Get-CockpitItsmConnection`, `Invoke-CockpitItsmRequest` (`-Method`, `-PathQuery`, `-Body`, `-Raw`) and `Get-CockpitItsmAllPages`, exported with the generated functions. `Connect-CockpitItsm` requests the token at once, so wrong credentials are reported there; the token is then renewed automatically, with re-authentication on 401. Any non-2xx response or network error throws `CockpitItsm.CockpitItsmException` (`StatusCode`, `Response`; `StatusCode` = 0 for a network error). On Windows PowerShell 5.1, TLS 1.2 is enabled by the core.

---

## Test page

The Test page calls the API **dynamically**, through `uCockpitItsmCore`, using the spec version selected in the API tab. No generated unit is involved. As a result, every endpoint can be tried, including the ones the generator does not support, such as the `GET` variants that carry a body.

### Configuration

| Field | Description |
|---|---|
| **SaaS** | Ticked: `https://{tenant}.cockpit-itsm.com`. Unticked: `https://{host}`. A host that already has a scheme (`http://host:8080`) is used as is |
| **Tenant / host** | Tenant name or host name |
| **ClientId / ClientSecret** | OAuth 2.0 API access (scope `public-api`) |
| **Remember the secret** | Saves the secret in `CIPAT.ini` **in clear text**. Off by default: the secret is then kept only for the session |
| **Test connection** | Requests a new token and shows the result |

The computed base URL is displayed next to the button. Changing any field discards the current token. The token is requested automatically by the first call and renewed when it expires or when the API answers 401.

### Sending a request

1. Select the endpoint in the tree. Its title and description are shown above the request.
2. Fill in the **parameters** grid:
   - path parameters are required;
   - empty query parameters are not sent;
   - list parameters take comma-separated values (`4,9`) and are sent as repeated keys.
3. Edit the **body**. It is filled with a template built from the schema when the endpoint is selected (select it again to get the template back):
   - only writable members are included;
   - references are reduced to `{"id": 0}`;
   - enums get their first value, `example` values from the spec are used, dates are `null`;
   - paged requests get `page` 0 and `pageSize` 10 at the right path.

   Endpoints whose body is a plain text string start with an empty editor; the text is sent raw. The JSON is validated before sending.
4. Optional: **All pages** (paged lists only) reads every page through `FetchAllPages` and shows the merged `content` array. The core's `PageSize` (500) replaces the `pageSize` from the body. Without this option, the body is sent as is, so you control `page` and `pageSize`.
5. Click **Send**.

The request body and the response are SynEdit editors with JSON highlighting (`TSynJSONSyn`), line numbers and folding of `{}` / `[]`.

The response pane shows a status line: `METHOD full URL - HTTP status - duration - size` (or the item count when all pages were read). Below it comes the body, formatted when it is JSON. Error responses (4xx/5xx) show the server's JSON error. Network errors (connection refused, TLS, timeout) show the exception class and message.

---

## Generated code

### Unit layout

```
UNIT uCockpitItsmApi;
// header: source spec version, generation date, @endpoint selection
{$IFDEF FPC}{$mode delphi}{$H+}{$ENDIF}
INTERFACE
USES {$IFDEF FPC} SysUtils, fpjson {$ELSE} System.SysUtils, System.JSON {$ENDIF}, uCockpitItsmCore;
TYPE
  ty<Schema> = RECORD ... END;            // only the schemas actually used,
  ty<Schema>s = ARRAY OF ty<Schema>;      // dependencies declared first
  TCockpitItsmInstance = CLASS(TCockpitItsmBase)
    // one method per selected endpoint
  END;
// JSON <-> record conversion functions (public)
IMPLEMENTATION
  ...
END.
```

The generated unit is pure ASCII: non-ASCII characters are removed from comments. It needs no BOM in Delphi. Do not edit it by hand; regenerate it instead.

### Type mapping

| OpenAPI | Pascal |
|---|---|
| `string` | `STRING` |
| `string` + `date-time` | `TDateTime` (local time) |
| `string` + `date` | `TDateTime` (date only, sent as `yyyy-mm-dd`) |
| `string` + `enum` | `STRING` (stays robust when the vendor adds values) |
| `integer` + `int32` | `Integer` |
| `integer` (int64 or no format) | `Int64` |
| `number` | `Double` |
| `boolean` | `Boolean` (optional query parameters use `TCockpitBool`) |
| `$ref` to an object schema | `ty<Schema>` record |
| array of `$ref` | `ty<Schema>s` |
| array of primitives | `TCockpitStrings`, `TCockpitInt64s`, `TCockpitIntegers`, `TCockpitDoubles`, `TCockpitBooleans`, `TCockpitDates` |
| map (`additionalProperties`), untyped or inline object | `STRING` containing raw JSON |

### Records

- One record per schema reachable from the selected endpoints (request bodies, responses, paged items, criteria), plus their nested schemas.
- Schemas whose names differ only by case are merged into a single type, because Pascal identifiers are case-insensitive. In every spec checked so far they are structurally identical. The PascalCase variant wins.
- Field names keep the JSON names. Reserved words get a trailing underscore (`type` → `type_`).
- Each field carries the spec description as a comment. Read-only fields are marked `[read-only]`.
- If `tyXs` would collide with an existing record name, the array type is called `tyXArray` instead.

### Method signatures

Parameters always come in this order:

1. path parameters (required);
2. required query parameters;
3. request body:
   - a record: `CONST AEndUser: tyEndUser`;
   - an array: `CONST AItems: …`;
   - text: `CONST AText: STRING`;
   - raw JSON: `CONST AJson: STRING`;
4. optional query parameters, with defaults:
   - `''` for strings;
   - `0` for numbers and dates (the parameter is not sent);
   - `cbUnset` for booleans;
   - `NIL` for arrays.

Optional booleans use `TCockpitBool = (cbUnset, cbFalse, cbTrue)`, so "not sent" can be told apart from `false`. Array query parameters are sent as repeated keys: `organizationIds=4&organizationIds=9`.

Return values:

| Response | Return type |
|---|---|
| Object schema | `ty<Schema>` |
| Array | `ty<Schema>s` or a primitive array type |
| Paged list | `ty<Item>s` with **all** items from all pages |
| JSON string / non-JSON content | `STRING` |
| Untyped object | `STRING` (raw JSON) |
| No content | `PROCEDURE` |

### Paged lists

An endpoint is treated as a paged list when **both** conditions hold:

- its response schema has `content` (an array of objects) and `totalNumberOfPages`;
- its request body schema contains, at some depth, an object with `page` and `pageSize`.

The generator finds the path to that object, because it depends on the schema:

| Body schema | Page path |
|---|---|
| `PageRequestWithSearch` | `pageRequest` |
| `CustomPropertiesList`, `SecuredDataList` | `pageRequestBean` |
| `List` (infrastructure, tasks, office equipment) | `pageRequestWithSearchBean.pageRequest` |
| `TicketSearchPageRequest`, `OpenTicketsPageRequest`, … | *(root)* |

`TCockpitItsmBase.FetchAllPages` then:

1. creates the page object if it is missing;
2. sends page `0`, `1`, `2`, … with `pageSize` = `PageSize` (500 by default, the API maximum);
3. reads `totalNumberOfPages` and `totalNumberOfElements` from the first response;
4. stops after the last page, or as soon as a page comes back empty;
5. truncates the merged result to `totalNumberOfElements`.

If the body schema has fields besides the paging ones (search query, tags, ticket filters…), **two overloads** are generated:

```pascal
FUNCTION ListEndUsers(AOnlyWithPortalAccess: TCockpitBool = cbUnset; ...): tyEndUsers; OVERLOAD;
FUNCTION ListEndUsers(CONST ACriteria: tyPageRequestWithSearch; AOnlyWithPortalAccess: TCockpitBool = cbUnset; ...): tyEndUsers; OVERLOAD;
```

The first overload calls the second with `Default(tyPageRequestWithSearch)`. In the criteria record, `page` and `pageSize` are overwritten by the core.

### Serialization rules (records → JSON)

These rules are applied when a record is sent:

| Field | Rule |
|---|---|
| `readOnly` in the spec | never sent |
| `STRING` (optional) | omitted when empty |
| `id` / `…Id` integer (optional) | omitted when `0` |
| other integers, `Double`, `Boolean` | always sent |
| `TDateTime` (optional) | omitted when `0`; when required, `0` → `null` |
| raw JSON `STRING` (optional) | omitted when empty |
| nested record with an `id` (reference) | omitted when `id = 0` |
| other nested records | always sent |
| arrays (optional) | omitted when empty |
| fields listed in `required` | always sent |

Consequences:

- `POST /api/end-users` with `id = 0` creates a user, and with an id it updates that user. This matches the API's "create or update" behaviour.
- References only need their `id`; the API ignores the other reference fields, and most of them are read-only.

### Deserialization rules (JSON → records)

- A field that is missing or `null` gets the default value: `''`, `0`, `False`, `0` date, empty array, or a `Default()` record.
- Numbers sent as strings, and strings sent as numbers, are converted.
- Dates with a time-zone offset (`Z`, `+0000`, `+02:00`) are converted to **local time**.

---

## Runtime core: uCockpitItsmCore.pas

The file is saved as UTF-8 **with a BOM**, which Delphi needs for the accented messages. All conditional code is in this unit; the generated unit has no `{$IFDEF}` except in its `USES` clause.

| | Delphi (10.1 Berlin or later) | Lazarus / FPC 3.2+ |
|---|---|---|
| HTTP | `System.Net.HttpClient` (`THTTPClient`) | Windows: **WinHTTP** (`winhttp.dll`, native TLS, no DLL to ship). Linux/macOS: `fphttpclient` + `opensslsockets` |
| JSON | `System.JSON` | `fpjson` + `jsonparser` |
| `TJSONValue` | native | alias of `TJSONData` |

### TCockpitItsmInstance / TCockpitItsmBase

`TCockpitItsmInstance` (generated) inherits from `TCockpitItsmBase` (core):

```pascal
CONSTRUCTOR Create(ASaaS: Boolean; CONST ATenant, AClientId, AClientSecret: STRING);
```

| Property | Description |
|---|---|
| `SaaS` | `True` → `https://{tenant}.cockpit-itsm.com`; `False` → `https://{tenant}` |
| `Tenant` | Tenant name (SaaS) or host name (on premise). An on-premise value that already contains a scheme (`http://host:8080`) is used as is |
| `ClientId`, `ClientSecret` | OAuth 2.0 API access configured in the portal (scope `public-api`) |
| `PageSize` | Page size for paged lists (default 500) |
| `Timeout` | Connection and I/O timeout in ms (default 60000) |
| `AccessToken` | Current token (read only) |
| `LastStatus` | HTTP status of the last call (read only) |
| `BaseUrl` | Computed base URL |

Changing `SaaS`, `Tenant`, `ClientId` or `ClientSecret` discards the current token.

### Authentication

- `Authenticate` sends `POST {BaseUrl}/oauth2/token` as `multipart/form-data` with:
  - `grant_type=client_credentials`;
  - `client_id`;
  - `client_secret`;
  - `scope=public-api`.
- The token is cached until `expires_in` − 60 seconds. You never need to call `Authenticate` yourself: the first API call does it.
- If an API call returns **401**, the core authenticates again once and retries the call.
- Requests carry the header `Authorization: Bearer <token>`.

### HTTP transport

- Every request has the header `Accept: application/json`.
- Bodies are sent as UTF-8 with `Content-Type: application/json`. `POST`, `PUT` and `PATCH` always send a body, even an empty one.
- Text bodies (endpoints whose body is a plain `string`, such as `update-title` or `close`) are sent **as raw text**, without JSON quotes.
- Responses are decoded as UTF-8. A text response that arrives as a JSON string literal is unquoted.

### Error handling

Any non-2xx response raises `ECockpitItsmError`:

| Member | Content |
|---|---|
| `StatusCode` | HTTP status, or `0` when there is no HTTP response or the JSON is invalid |
| `Message` | `Cockpit ITSM : erreur HTTP <code> - <message>` |
| `Response` | Raw response body |

The message comes from `errorMessage` (API errors), or from `error_description` / `error` (OAuth errors). If neither is present, it is the start of the response body.

Network errors from the HTTP library (DNS, TLS, timeouts) are not wrapped; they reach the caller unchanged. Messages are declared as `RESOURCESTRING`.

### Dates

- `IsoToDateTime`: parses `yyyy-mm-dd[Thh:nn[:ss[.fff]]][Z|±hh[:]mm]` into local time.
- `DateTimeToIso`: converts local time to UTC, formatted as `yyyy-mm-ddThh:nn:ss.zzzZ`.
- `DateToIsoDate`: formats `yyyy-mm-dd`.

### Strings and encoding

- **Delphi**: strings are UTF-16 and are converted to and from UTF-8 at the transport layer.
- **FPC**: strings are UTF-8, as everywhere in Lazarus, and bytes are sent and received without conversion. The core sets `DefaultSystemCodePage := CP_UTF8` in its initialization section. This is exactly what LazUTF8 does in every LCL application, and it is needed in console programs because `fpjson` returns `UTF8String` values.
- **FPC on Windows**: HTTP goes through WinHTTP. No OpenSSL DLL is needed, and the system proxy settings are used (automatic proxy, with a fallback to the default proxy). Transport errors are reported with the WinHTTP code: 12002 timeout, 12007 host name not resolved, 12029 cannot connect, 12175 TLS error.

### Low-level access

These public methods also work for endpoints that were not generated:

```pascal
FUNCTION Call(CONST AMethod, APathQuery: STRING; CONST ABody: STRING = ''): STRING;        // raw response
FUNCTION CallJson(CONST AMethod, APathQuery: STRING; CONST ABody: STRING = ''): TJSONValue; // caller frees
FUNCTION FetchAllPages(CONST AMethod, APathQuery: STRING; ABody: TJSONObject; CONST APagePath: STRING): TJSONArray;
```

Helper groups:

| Group | Functions |
|---|---|
| URL | `UrlEncode`, `AddQuery`, `QBool`, `QFloat` |
| JSON reading | `JStr`, `JInt`, `JInt64`, `JFloat`, `JBool`, `JDate`, `JRaw`, `JObj`, `JArr`, … |
| JSON building | `JNewObj`, `JAddStr`, `JAddInt`, `JAddValue`, `StrsToJArr`, … |

---

## Usage examples

```pascal
USES
  uCockpitItsmCore, uCockpitItsmApi;

PROCEDURE Demo;
VAR
  Cockpit: TCockpitItsmInstance;
  Users: tyEndUsers;
  User: tyEndUser;
  Criteria: tyPageRequestWithSearch;
  Ids: TCockpitInt64s;
BEGIN
  Cockpit := TCockpitItsmInstance.Create(True, 'mytenant', 'myClientId', 'myClientSecret');
  TRY
    TRY
      // All end-users (every page)
      Users := Cockpit.ListEndUsers;

      // Filtered: search query + query parameters
      Criteria := Default(tyPageRequestWithSearch);
      Criteria.query := 'dupont';
      SetLength(Ids, 2);
      Ids[0] := 4;
      Ids[1] := 9;
      Users := Cockpit.ListEndUsers(Criteria, cbTrue, Ids);

      // Read, modify, update
      User := Cockpit.GetEndUsers(42);
      User.position := 'Team lead';
      User := Cockpit.PostEndUsers(User);

      // Text body
      Cockpit.PostTicketUpdateDescription(1234, 'New description');
    EXCEPT
      ON E: ECockpitItsmError DO
        ShowMessage(Format('%s (HTTP %d)', [E.Message, E.StatusCode]));
    END;
  FINALLY
    Cockpit.Free;
  END;
END;
```

On-premise portal:

```pascal
Cockpit := TCockpitItsmInstance.Create(False, 'itsm.mycompany.ch', ClientId, ClientSecret);
```

---

## Settings file

`CIPAT.ini` sits next to the executable (`Application.ExeName` with the extension changed):

```ini
[General]
Folder=<JSON folder>

[Options]
IgnoreInfoVersion=1
IgnoreTexts=0
IgnoreRefCase=0

[Generator]
Language=<Pascal, Python, Java, Node.js, C#, PowerShell or VB.NET>
UnitFile=<last generated Pascal unit>
UnitFileJava=<last generated Java class>
UnitFilePython=<last generated Python module>
UnitFileNode=<last generated Node.js module>
UnitFileCSharp=<last generated C# class>
UnitFilePowerShell=<last generated PowerShell module>
UnitFileVB=<last generated VB.NET class>
HideUnsupported=0
HideDeprecated=0

[Versions]
document.json=2026.8.4|1793391347

[Test]
SaaS=1
Tenant=<tenant or host>
ClientId=<client id>
SaveSecret=0
ClientSecret=<only when SaveSecret=1, clear text>
```

---

## Known limitations and assumptions

- **Test page**: requests are synchronous; the window is busy until the answer arrives (60 s timeout).
- **Delphi**: the core and the generated code are written for Delphi 10.1 Berlin or later. Only the FPC side was compiled and tested: all 266 supported endpoints, against several spec versions and a mock server.
- **Text bodies**: endpoints whose body is a plain `string` receive the raw text with `Content-Type: application/json`. This has not been checked against a real portal.
- **Authorization header**: the spec text mentions `Authentication: Bearer: …`. The core sends the standard OAuth header `Authorization: Bearer …`.
- **Enums** are plain strings; there are no constants for their values.
- **XML** content types are ignored; JSON is always used.
- **Header parameters** (`X-CSRF-TOKEN`) are ignored.
- **Binary downloads** (`attachments.zip`, `objects.xlsx`, public key) return the raw body as a `STRING`.
- **C# / VB.NET / PowerShell**: the C# and VB.NET code was compiled and tested with .NET 8 only, the PowerShell module with PowerShell 7.4 only (Linux), against a mock server. The PowerShell code is written for Windows PowerShell 5.1 too, but was not run on it.
- **Password grant**: the spec marks the `password` flow as deprecated; only `client_credentials` is implemented.
