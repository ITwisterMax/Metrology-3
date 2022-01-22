program Laba3;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Analizator},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.CreateForm(TAnalizator, Analizator);
  Application.Run;
end.
