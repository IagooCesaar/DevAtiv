unit uHorseApp;

interface

uses
  System.SysUtils, System.Rtti, Web.HTTPApp,
  Horse, Horse.Core, Horse.Jhonson, Horse.HandleException,
  uAppController;

type
  THorseApp = class(THorse)
  private
    FPorta: Integer;
  public
    function RotaToMethodType(Verbo: TVerbosHttp): TMethodType;
    procedure AddController(Classe: TClassAppController); overload;
    constructor CreateNew(Porta: Integer);
  end;

implementation

uses
  uRegistraControllers, uSingletonDictionary;

{ THorseApp }

procedure THorseApp.AddController(Classe: TClassAppController);
var
  Controller          : TObject;
  Ctx                 : TRttiContext;
  Tp                  : TRttiType;
  atr                 : TCustomAttribute;
  mtd                 : TRttiMethod;
  //Rota Raiz
  _RotaRaiz           : string;
  _RotaRaizNome       : string;
  _Swagger            : Boolean;
  //Rota
  _Rota               : string;
  _RotaHorse          : string;
  _Metodo             : TVerbosHttp;
  _TipoMetodo         : TMethodType;
  _Descricao          : string;
  _Permissoes         : string;
  _ContentTypeDefault : string;
  _ModeloResposta     : string;

  sKey                : string;


  iPosParam           : integer;
  iQtdParams          : integer;
  iPosDivFim          : integer;
  sTrechoRotaFim      : string;
begin
  Controller          := nil;
  try
    Classe.Metodos    := TSingletonDictionary.GetInstance.Metodos;
    Classe.Permissoes := TSingletonDictionary.GetInstance.Permissoes;
    Classe.Rotas      := TSingletonDictionary.GetInstance.Rotas;
    Classe.ConfigRota := TSingletonDictionary.GetInstance.ConfigRota;

    Controller  := Classe.Create;
    Ctx         := TRttiContext.Create;
    Tp          := Ctx.GetType(Controller.ClassInfo);

    //Atributos da classe
    for atr in Tp.GetAttributes do begin
      _RotaRaiz     := (RotaRaiz(atr).RotaRaiz);
      _RotaRaizNome := (RotaRaiz(atr).Nome);
      _Swagger      := (RotaRaiz(atr).Swagger);
    end;
    for mtd in Tp.GetMethods do begin
      //Atributos dos métodos
      for atr in mtd.GetAttributes do begin
        if atr is Rota then begin
          _RotaHorse          := _RotaRaiz + (atr as Rota).Rota;
          _Metodo             := (atr as Rota).Metodo;
          _TipoMetodo         := Self.RotaToMethodType(_Metodo);
          _Descricao          := (atr as Rota).Descricao;
          _Permissoes         := (atr as Rota).Permissoes;
          _ContentTypeDefault := (atr as Rota).ContentTypeDefault;
          _ModeloResposta     := (atr as Rota).ModeloResposta;

          _Rota       := _RotaHorse;
          (*iPosParam   := Pos(':', _Rota);
          iQtdParams  := 0;
          while iPosParam > 0 do begin
            Inc(iQtdParams);
            iPosDivFim        := Pos('/', Copy(_Rota, iPosParam, Length(_Rota)));
            sTrechoRotaFim    := '';
            if iPosDivFim > 0 then
              sTrechoRotaFim  := Copy(
                Copy(_Rota, iPosParam, Length(_Rota)),
                iPosDivFim, Length(_Rota)
              );

            _Rota := Copy(_rota, 0, iPosParam-1);
            _Rota := _Rota+ '{param'+iQtdParams.ToString+'}'+sTrechoRotaFim;

            iPosParam   := Pos(':', _Rota);
          end;*)

          sKey := uAppController.GeraChaveRota(_RotaHorse, _TipoMetodo);

          Classe.Metodos.Add(sKey,mtd.Name);
          Classe.Permissoes.Add(mtd.Name, _Permissoes);
          Classe.ConfigRota.Add(sKey, _ContentTypeDefault);

          if _Swagger then begin
            //Pendente
          end;
          case _Metodo of
            vGet:     Self.Get(_RotaHorse, Classe.Handle);
            vPost:    Self.Post(_RotaHorse, Classe.Handle);
            vPut:     Self.Put(_RotaHorse, Classe.Handle);
            vPatch:   Self.Patch(_RotaHorse, Classe.Handle);
            vDelete:  Self.Delete(_RotaHorse, Classe.Handle);
          end;

        end else
        if atr is ParametroRota and _Swagger then  begin

        end else
        if atr is Modelo and _Swagger then  begin

        end else
        if atr is SubModelo and _Swagger then  begin

        end;
      end;
    end;
  finally
    Controller.DisposeOf;
    Ctx.Free;
  end;
end;

constructor THorseApp.CreateNew(Porta: Integer);
begin
  inherited Create;
  FPorta    := Porta;
  Self.Port := Porta;

  FPorta := Porta;
  Self.Use(Jhonson);
  Self.Use(HandleException);

  TRegistraControllers.Registrar(Self);

  Self.Get('/ping',
    procedure (req: THorseRequest; res: THorseResponse)
    begin
      Res.Send('{ "message": "pong" }');
    end
  );
end;

function THorseApp.RotaToMethodType(Verbo: TVerbosHttp): TMethodType;
begin
  case Verbo of
    vGet    : Result := mtGet;
    vPost   : Result := mtPost;
    vPut    : Result := mtPut;
    vPatch  : Result := mtPatch;
    vDelete : Result := mtDelete;
  end;
end;

end.
