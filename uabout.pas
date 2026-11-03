UNIT uAbout;

(*
  "About" window shared by the StopStart suite (Compiler, Configurator, Help).

  Everything is read at run time, nothing is hard-coded in the applications:
  - icon and title       : Application.Icon / Application.Title
  - version, copyright,
    description          : version information of the executable
                           (Project > Options > Version Info)
  - system information   : target OS / CPU, FPC, LCL, date of the executable,
                           can be copied to the clipboard (support)

  Usage:
    USES uAbout;
    ShowAbout;                                   // description = FileDescription
    ShowAbout('Generates the Java scripts...');  // explicit description

  "About..." entry in the system menu of a form (Windows):
    PROCEDURE TfrmMain.FormShow(Sender: TObject);
    BEGIN
      AddAboutToSystemMenu(Self);
    END;
  No effect if already done for the current handle: OnShow adds it again
  if the LCL has recreated the handle of the window (BorderStyle,
  ShowInTaskBar...). No effect outside Windows.
*)

{$mode objfpc}{$H+}

INTERFACE

USES
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

TYPE
  { TfrmAbout }

  TfrmAbout = CLASS(TForm)
    bvlSeparator: TBevel;
    btnCopy: TButton;
    btnOK: TButton;
    imgIcon: TImage;
    lblCopyright: TLabel;
    lblDescription: TLabel;
    lblTitle: TLabel;
    lblVersion: TLabel;
    memInfo: TMemo;
    PROCEDURE btnCopyClick(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
  PRIVATE
    PROCEDURE ShowIcon;
    PROCEDURE FillSystemInfo;
    PROCEDURE AdjustLayout;
  PUBLIC
  END;

(* Version of the executable (FileVersion), '' if missing *)
FUNCTION AppVersion: STRING;
(* A value of the version information ('FileVersion', 'LegalCopyright',
   'FileDescription', 'CompanyName', ...), '' if missing *)
FUNCTION AppVersionInfo(CONST pKey: STRING): STRING;
(* Shows the "About" window (modal) *)
PROCEDURE ShowAbout(CONST pDescription: STRING = '');
(* Adds "About..." to the system menu of pForm (Windows) *)
PROCEDURE AddAboutToSystemMenu(pForm: TCustomForm; CONST pDescription: STRING = '');

IMPLEMENTATION

{$R *.lfm}

USES
  {$IFDEF WINDOWS} Windows, {$ENDIF}
  Types,
  LCLIntf,
  LCLType,
  Math,
  LCLVersion,
  Clipbrd,
  fileinfo,
  {$IFDEF WINDOWS} winpeimagereader {$ELSE} elfreader {$ENDIF};

FUNCTION AppVersionInfo(CONST pKey: STRING): STRING;
VAR
  FVI: TFileVersionInfo;
BEGIN
  Result := '';
  FVI := TFileVersionInfo.Create(NIL);
  TRY
    TRY
      FVI.FileName := Application.ExeName;
      FVI.ReadFileInfo;
      Result := Trim(FVI.VersionStrings.Values[pKey]);
    EXCEPT
      Result := '';
    END;
  FINALLY
    FVI.Free;
  END;
END;

FUNCTION AppVersion: STRING;
BEGIN
  Result := AppVersionInfo('FileVersion');
END;

PROCEDURE ShowAbout(CONST pDescription: STRING);
VAR
  Frm: TfrmAbout;
BEGIN
  Frm := TfrmAbout.Create(Application);
  TRY
    IF pDescription <> '' THEN BEGIN
      Frm.lblDescription.Caption := pDescription;
      Frm.AdjustLayout;
    END;
    Frm.ShowModal;
  FINALLY
    Frm.Free;
  END;
END;

{$IFDEF WINDOWS}
CONST
  // Command id of the system menu: < $F000 (SC_xxx commands of Windows)
  // and multiple of 16 (the 4 low-order bits are reserved).
  SC_ABOUT = $0110;

TYPE
  tySysMenuHook = RECORD
    Wnd         : HWND;
    OldProc     : WNDPROC;
    Description : STRING;
  END;

VAR
  SysMenuHooks: ARRAY OF tySysMenuHook;

FUNCTION FindSysMenuHook(pWnd: HWND): INTEGER;
VAR
  I: INTEGER;
BEGIN
  Result := -1;
  FOR I := 0 TO High(SysMenuHooks) DO
    IF SysMenuHooks[I].Wnd = pWnd THEN Exit(I);
END;

(* Window procedure inserted in front of the LCL one: handles SC_ABOUT,
   passes everything else on. WM_NCDESTROY: removes the hook (handle destroyed). *)
FUNCTION AboutWndProc(pWnd: HWND; pMsg: UINT; pWParam: WPARAM; pLParam: LPARAM): LRESULT; STDCALL;
VAR
  I, J    : INTEGER;
  OldProc : WNDPROC;
BEGIN
  I := FindSysMenuHook(pWnd);
  IF I < 0 THEN Exit(DefWindowProc(pWnd, pMsg, pWParam, pLParam));
  OldProc := SysMenuHooks[I].OldProc;

  IF (pMsg = WM_SYSCOMMAND) AND ((pWParam AND $FFF0) = SC_ABOUT) THEN BEGIN
    ShowAbout(SysMenuHooks[I].Description);
    Exit(0);
  END;

  IF pMsg = WM_NCDESTROY THEN BEGIN
    {$PUSH}{$WARN 4055 OFF}   // LONG_PTR <-> pointer: same size in 32 and 64 bits
    SetWindowLongPtr(pWnd, GWLP_WNDPROC, LONG_PTR(OldProc));
    {$POP}
    FOR J := I TO High(SysMenuHooks) - 1 DO SysMenuHooks[J] := SysMenuHooks[J + 1];
    SetLength(SysMenuHooks, Length(SysMenuHooks) - 1);
  END;

  Result := CallWindowProc(OldProc, pWnd, pMsg, pWParam, pLParam);
END;
{$ENDIF}

PROCEDURE AddAboutToSystemMenu(pForm: TCustomForm; CONST pDescription: STRING);
{$IFDEF WINDOWS}
VAR
  Wnd   : HWND;
  Menu  : HMENU;
  N     : INTEGER;
{$ENDIF}
BEGIN
  {$IFDEF WINDOWS}
  Wnd := pForm.Handle;
  IF FindSysMenuHook(Wnd) >= 0 THEN Exit;            // already done for this handle
  Menu := GetSystemMenu(Wnd, FALSE);
  IF Menu = 0 THEN Exit;
  AppendMenuW(Menu, MF_SEPARATOR, 0, NIL);
  AppendMenuW(Menu, MF_STRING, SC_ABOUT, 'About...');

  N := Length(SysMenuHooks);
  SetLength(SysMenuHooks, N + 1);
  SysMenuHooks[N].Wnd         := Wnd;
  SysMenuHooks[N].Description := pDescription;
  {$PUSH}{$WARN 4055 OFF}     // LONG_PTR <-> pointer: same size in 32 and 64 bits
  SysMenuHooks[N].OldProc     := WNDPROC(SetWindowLongPtr(Wnd, GWLP_WNDPROC, LONG_PTR(@AboutWndProc)));
  {$POP}
  {$ENDIF}
END;

{ TfrmAbout }

PROCEDURE TfrmAbout.FormCreate(Sender: TObject);
VAR
  Version, Copyright: STRING;
BEGIN
  Caption := 'About ' + Application.Title;
  ShowIcon;
  lblTitle.Caption := Application.Title;

  Version := AppVersion;
  IF Version <> '' THEN lblVersion.Caption := 'Version ' + Version
                   ELSE lblVersion.Caption := 'Version not available';

  lblDescription.Caption := AppVersionInfo('FileDescription');

  Copyright := AppVersionInfo('LegalCopyright');
  IF Copyright = '' THEN Copyright := AppVersionInfo('CompanyName');
  lblCopyright.Caption := Copyright;
  lblCopyright.Visible := Copyright <> '';

  FillSystemInfo;
  AdjustLayout;
END;

PROCEDURE TfrmAbout.AdjustLayout;
// Window fitted to its content: width of the title and of the information
// lines (within the screen), title wrapped if still too long, labels stacked
// under the title, information memo as high as its lines.
// Explicit positions: the anchors of the form are removed, otherwise the LCL
// would apply them again (with the distances of the design) when showing.
VAR
  Bmp: Graphics.TBitmap;      // Windows.TBitmap (record) would hide it
  I, W, Need, Y, LineH, Margin, Gap: INTEGER;
BEGIN
  Margin := Scale96ToForm(16);
  Gap := Scale96ToForm(4);
  bvlSeparator.Anchors := [akLeft, akTop];
  memInfo.Anchors := [akLeft, akTop];
  btnCopy.Anchors := [akLeft, akTop];
  btnOK.Anchors := [akLeft, akTop];
  lblDescription.Anchors := [akLeft, akTop];

  // Text measured with the fonts of the controls (bitmap canvas: no window
  // handle needed in OnCreate)
  Bmp := Graphics.TBitmap.Create;
  TRY
    Bmp.Canvas.Font.Assign(lblTitle.Font);
    Need := lblTitle.Left + Bmp.Canvas.TextWidth(lblTitle.Caption) + Margin;
    Bmp.Canvas.Font.Assign(memInfo.Font);
    LineH := Bmp.Canvas.TextHeight('Wg');
    W := 0;
    FOR I := 0 TO memInfo.Lines.Count - 1 DO
      W := Max(W, Bmp.Canvas.TextWidth(memInfo.Lines[I]));
    // memo borders and inner margins, scroll bar kept in reserve
    Need := Max(Need, memInfo.Left + W + GetSystemMetrics(SM_CXVSCROLL) + Scale96ToForm(16) + Margin);
  FINALLY
    Bmp.Free;
  END;
  ClientWidth := Min(Max(ClientWidth, Need), Screen.WorkAreaWidth - 2 * Margin);
  // Memo sized to its content: scroll bar only if the screen is too narrow
  IF Need <= ClientWidth THEN memInfo.ScrollBars := ssNone
                         ELSE memInfo.ScrollBars := ssAutoHorizontal;

  // Labels: full width, wrapped when needed, stacked under the title
  Y := lblTitle.Top;
  lblTitle.AutoSize := False;
  lblTitle.WordWrap := True;
  lblTitle.Width := ClientWidth - lblTitle.Left - Margin;
  lblTitle.AutoSize := True;
  Inc(Y, lblTitle.Height + Gap);
  lblVersion.Top := Y;
  Inc(Y, lblVersion.Height + Gap);
  lblDescription.Visible := lblDescription.Caption <> '';
  IF lblDescription.Visible THEN
  BEGIN
    lblDescription.Top := Y;
    lblDescription.Width := ClientWidth - lblDescription.Left - Margin;
    lblDescription.AutoSize := True;
    Inc(Y, lblDescription.Height + Gap);
  END;
  IF lblCopyright.Visible THEN
  BEGIN
    lblCopyright.Top := Y;
    Inc(Y, lblCopyright.Height + Gap);
  END;

  // Separator, information (as high as its lines) and buttons, full width
  Y := Max(Y, imgIcon.Top + imgIcon.Height + Gap) + Gap;
  bvlSeparator.SetBounds(Margin, Y, ClientWidth - 2 * Margin, bvlSeparator.Height);
  memInfo.SetBounds(Margin, Y + 2 * Gap, ClientWidth - 2 * Margin,
    memInfo.Lines.Count * LineH + Scale96ToForm(16));
  Y := memInfo.Top + memInfo.Height + 2 * Gap;
  btnCopy.SetBounds(Margin, Y, btnCopy.Width, btnCopy.Height);
  btnOK.SetBounds(ClientWidth - Margin - btnOK.Width, Y, btnOK.Width, btnOK.Height);
  ClientHeight := Y + btnOK.Height + 3 * Gap;
END;

PROCEDURE TfrmAbout.ShowIcon;
// Image of the application icon closest to the size of the TImage
VAR
  Ico: TIcon;
BEGIN
  IF Application.Icon.Count = 0 THEN Exit;
  Ico := TIcon.Create;
  TRY
    Ico.Assign(Application.Icon);
    Ico.Current := Ico.GetBestIndexForSize(Size(imgIcon.Width, imgIcon.Height));
    imgIcon.Picture.Assign(Ico);
  FINALLY
    Ico.Free;
  END;
END;

PROCEDURE TfrmAbout.FillSystemInfo;
VAR
  ExeDate: LONGINT;
BEGIN
  memInfo.Lines.BeginUpdate;
  TRY
    memInfo.Lines.Clear;
    memInfo.Lines.Add('Application : ' + Application.Title + ' ' + AppVersion);
    memInfo.Lines.Add('Executable  : ' + Application.ExeName);
    ExeDate := FileAge(Application.ExeName);
    IF ExeDate <> -1 THEN
      memInfo.Lines.Add('Built on    : ' + FormatDateTime('dd.mm.yyyy hh:nn', FileDateToDateTime(ExeDate)));
    memInfo.Lines.Add('Target      : ' + {$I %FPCTARGETOS%} + ' / ' + {$I %FPCTARGETCPU%});
    memInfo.Lines.Add('Compiler    : FPC ' + {$I %FPCVERSION%} + ' - LCL ' + lcl_version);
  FINALLY
    memInfo.Lines.EndUpdate;
  END;
END;

PROCEDURE TfrmAbout.btnCopyClick(Sender: TObject);
BEGIN
  Clipboard.AsText := memInfo.Lines.Text;
END;

END.
