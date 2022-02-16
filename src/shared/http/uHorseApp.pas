unit uHorseApp;

interface

uses
  System.SysUtils, Horse, Horse.Jhonson;

type
  THorseApp = class(THorse)
  private
    FPorta: Integer;
  public
    constructor CreateNew(Porta: Integer);
  end;

implementation

{ THorseApp }

constructor THorseApp.CreateNew(Porta: Integer);
begin
  inherited Create;
  FPorta    := Porta;
  Self.Port := Porta;

  FPorta := Porta;
  Self.Use(Jhonson);

  Self.Get('/ping',
    procedure (req: THorseRequest; res: THorseResponse)
    begin
      Res.Send('{ "message": "pong" }');
    end
  );
end;

end.
