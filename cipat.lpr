PROGRAM cipat;

{$mode delphi}{$H+}

USES
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, Forms, uApiDiff, uApiGen, uMain, uAbout, SynEditOptionsDialog,
  SynColorDialogForm, SynEditSettings;

{$R *.res}

BEGIN
  RequireDerivedFormResource := True;
  Application.Scaled:=True;
  Application.Title:='CIPAT - Cockpit ITSM Public API toolkit';
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
END.
