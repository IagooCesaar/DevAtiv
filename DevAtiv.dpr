program DevAtiv;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uHorseApp in 'src\shared\http\uHorseApp.pas',
  uAppController in 'src\shared\http\uAppController.pas',
  uRegistraControllers in 'src\shared\http\controllers\uRegistraControllers.pas',
  Modules.Teste.Controller.TesteController in 'src\modules\teste\controller\Modules.Teste.Controller.TesteController.pas',
  uSingletonDictionary in 'src\shared\container\uSingletonDictionary.pas';

var App: THorseApp;
begin
  try
    App := THorseApp.CreateNew(8486);
    App.Start;
  finally
    FreeAndNil(App);
  end;
end.
