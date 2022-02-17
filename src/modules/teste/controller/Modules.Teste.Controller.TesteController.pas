unit Modules.Teste.Controller.TesteController;

interface

uses
  System.SysUtils,
  uAppController, Horse;

type
  [RotaRaiz('/teste', 'Teste Rota Ping')]
  TTesteController = class(TAppController)
    [Rota(vGet, '/ping/:qtd', 'Pequeno teste de conexão')]
    procedure getPing;
  end;

implementation

{ TTesteController }

procedure TTesteController.getPing;
var qtd: integer;
begin
  qtd := Self.FRequest.Params.Field('qtd').AsInteger;
  Self.FResponse.Send('{ "message": "ping-pong", "qtd": '+qtd.ToString+' }').Status(ThttpStatus.Ok)
end;

end.
