program DevAtiv;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson;

var App: THorse;

begin
  App := THorse.Create;
  App.Port  := 8486;
  App.Use(Jhonson);

  App.Get('/ping',
    procedure (req: THorseRequest; res: THorseResponse)
    begin
      Res.Send('{ "message": "pong" }');
    end
  );

  App.Listen;

end.
