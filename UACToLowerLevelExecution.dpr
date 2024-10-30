program UACToLowerLevelExecution;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  MediumIL in 'MediumIL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Dark Vector');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
