unit Modules.Teste.Controller.TesteController;

interface

uses
  uAppController, Horse;

type
  [RotaRaiz('/teste', 'Teste Rota Ping')]
  TTesteController = class(TAppController)
    [Rota(vGet, '/ping', 'Pequeno teste de conexão')]
    procedure getPing;
  end;

implementation

{ TTesteController }

procedure TTesteController.getPing;
begin
  Self.FResponse.Send('{ "message": "ping-pong" }').Status(ThttpStatus.Ok)
end;

end.
