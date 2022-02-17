unit uRegistraControllers;

interface

uses
  System.Classes, System.SysUtils,
  uHorseApp;

type
  TRegistraControllers = class
    public
      class procedure Registrar(App: THorseApp);
  end;

implementation

uses
  Modules.Teste.Controller.TesteController;

{ TRegistraControllers }

class procedure TRegistraControllers.Registrar(App: THorseApp);
begin
  App.AddController(TTesteController);
end;

end.
