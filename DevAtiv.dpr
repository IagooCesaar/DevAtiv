program DevAtiv;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uHorseApp in 'src\shared\http\uHorseApp.pas';

var App: THorseApp;
begin
  try
    App := THorseApp.CreateNew(8486);
    App.Listen;
  finally
    FreeAndNil(App);
  end;
end.
