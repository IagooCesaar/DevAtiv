unit Modules.Teste.Controller.TesteController;

interface

uses
  System.SysUtils,
  uAppController, Horse;

type
  [RotaRaiz('/teste', 'Teste Rota Ping')]
  TTesteController = class(TAppController)
    [Rota(vGet, '/ping/:route', 'Pequeno teste de conexão'),
    //ParametroRota('query'
    ]
    procedure getPing;
  end;

implementation

{ TTesteController }

procedure TTesteController.getPing;
var route: integer; query: string;
begin
  route := Self.FRequest.Params.Field('route').AsInteger;
  query := Self.FRequest.Query.Field('query').Asstring;

  Self.FResponse.Send(
    '{ "message": "ping-pong", "route": '+route.ToString+', "query": "'+query+'" }'
  ).Status(ThttpStatus.Ok);
end;

end.
