unit uAppController;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Rtti,
  Web.HTTPApp,
  Horse, Horse.Core;

type
  TVerbosHttp = (vGet, vPost, vPut, vPatch, vDelete);
  TLocaisParametrosRequisicao = (pNotDefined, pRoute, pQuery, pHeader, pBody);
  TTiposParametro = (tpNotDefined, tpString, tpNumber, tpInteger, tpBoolean, tpArray, tpFile, tpObject);
  TTipoSubModelo = (tsmList, tsmDictionary, tsmInterface);

  RotaRaiz = class(TCustomAttribute)
    private
      FRotaRaiz: string;
      FNome: string;
    public
      property RotaRaiz: string read FRotaRaiz write FRotaRaiz;
      property Nome: string read FNome write FNome;
      constructor Create(RotaRaiz, Nome: string);
  end;

  Rota = class(TCustomAttribute)
    private
      FRota: string;
      FMetodo: TVerbosHttp;
      FDescricao: string;
      FPermissoes: string;
      FContentTypeDefault: string;
      FModeloResposta: string;
    public
      property Permissoes: string         read FPermissoes          write FPermissoes;
      property Metodo: TVerbosHttp        read FMetodo              write FMetodo;
      property Rota: string               read FRota                write FRota;
      property Descricao: string          read FDescricao           write FDescricao;
      property ContentTypeDefault: string read FContentTypeDefault  write FContentTypeDefault;
      property ModeloResposta: string     read FModeloResposta      write FModeloResposta;

      constructor Create(Metodo: TVerbosHttp; Rota, Descricao: string); overload;
      constructor Create(Metodo: TVerbosHttp; Rota, Descricao, ModeloResposta: string); overload;
      constructor Create(Metodo: TVerbosHttp; Rota, Descricao, ModeloResposta, Permissoes: string); overload;

      constructor Create(Metodo: TVerbosHttp;
        Rota, Descricao, ModeloResposta, Permissoes, ContentTypeDefault: string); overload;
  end;

  ParametroRota = class(TCustomAttribute)
    private
      FLocal: TLocaisParametrosRequisicao;
      FDescricao: string;
      FNome: string;
      FObrigatorio: boolean;
      FTipo: TTiposParametro;
      FFormato: string;
    public
      property Local: TLocaisParametrosRequisicao read FLocal       write FLocal;
      property Nome: string                       read FNome        write FNome;
      property Descricao: string                  read FDescricao   write FDescricao;
      property Tipo: TTiposParametro              read FTipo        write FTipo;
      property Obrigatorio: boolean               read FObrigatorio write FObrigatorio;
      property Formato: string                    read FFormato     write FFormato;

      constructor Create(Nome, Descricao: string; Tipo: TTiposParametro;
        Local: TLocaisParametrosRequisicao; Obrigatorio: Boolean); overload;
      constructor Create(Nome, Descricao: string; Tipo: TTiposParametro;
        Local: TLocaisParametrosRequisicao; Obrigatorio: Boolean; Formato: string); overload;

  end;

  TClassInterfacedObject = class of TInterfacedObject;

  Modelo = class(TCustomAttribute)
    private
      FDescricao: string;
      FClasse: TClassInterfacedObject;
      FNome: string;
    public
      property Nome: string                   read FNome      write FNome;
      property Descricao: string              read FDescricao write FDescricao;
      property Classe: TClassInterfacedObject read FClasse    write FClasse;

      constructor Create(Nome, Descricao : string; Classe: TClassInterfacedObject); overload;
  end;

  SubModelo = class (TCustomAttribute)
    private
      FDescricao: string;
      FClasse: TClassInterfacedObject;
      FNome: string;
      FTipo: TTipoSubModelo;
    public
      property Nome: string                   read FNome      write FNome;
      property Descricao: string              read FDescricao write FDescricao;
      property Classe: TClassInterfacedObject read FClasse    write FClasse;
      property Tipo: TTipoSubModelo           read FTipo      write FTipo;

      constructor Create(Nome, Descricao : string); overload;
      constructor Create(Nome, Descricao : string; TipoLista: Boolean; Classe: TClassInterfacedObject); overload;
  end;


  TAppController = class;
  TCLassAppController = class of TAppController;

  TAppController = class(TInterfacedObject)
    private
      class var FPermissoes: TDictionary<string, string>;
      class var FRotas: TDictionary<string, string>;
      class var FMetodos: TDictionary<string, string>;

      function FormatarRota(RotaExecutada: string; Metodo: TMethodType): string;
      function ChaveRota(RotaExecutada: string; Metodo: TMethodType): string;

    protected
      FRequest: THorseRequest;
      FResponse: THorseResponse;

      constructor CreateNew; virtual;
      procedure Execute; virtual;
      function RotaExecutada: string;

    public
      class property Permissoes: TDictionary<string, string> read FPermissoes write FPermissoes;
      class property Metodos: TDictionary<string, string> read FMetodos write FMetodos;
      class property Rotas: TDictionary<string, string> read FRotas write FRotas;

      class procedure Handle(Req: THorseRequest; Res: THorseResponse; Next: TProc); virtual; {final;}
  end;

implementation

uses
  System.TypInfo;


{ RotaRaiz }

constructor RotaRaiz.Create(RotaRaiz, Nome: string);
begin
  FRotaRaiz := RotaRaiz;
  FNome     := Nome;
end;

{ Rota }

constructor Rota.Create(Metodo: TVerbosHttp; Rota, Descricao, ModeloResposta,
  Permissoes, ContentTypeDefault: string);
begin
  Self.FMetodo              := Metodo;
  Self.FRota                := Rota;
  Self.FDescricao           := Descricao;
  Self.FModeloResposta      := ModeloResposta;
  Self.FPermissoes          := Permissoes;
  Self.FContentTypeDefault  := ContentTypeDefault;
end;

constructor Rota.Create(Metodo: TVerbosHttp; Rota, Descricao: string);
begin
  Create(Metodo, Rota, Descricao, '', '', '');
end;

constructor Rota.Create(Metodo: TVerbosHttp; Rota, Descricao,
  ModeloResposta: string);
begin
  Create(Metodo, Rota, Descricao, ModeloResposta, '', '');
end;

constructor Rota.Create(Metodo: TVerbosHttp; Rota, Descricao, ModeloResposta,
  Permissoes: string);
begin
  Create(Metodo, Rota, Descricao, ModeloResposta, Permissoes, '');
end;

{ ParametroRota }

constructor ParametroRota.Create(Nome, Descricao: string; Tipo: TTiposParametro;
  Local: TLocaisParametrosRequisicao; Obrigatorio: Boolean);
begin
  Create(Nome, Descricao, Tipo, Local, Obrigatorio, '');
end;

constructor ParametroRota.Create(Nome, Descricao: string; Tipo: TTiposParametro;
  Local: TLocaisParametrosRequisicao; Obrigatorio: Boolean; Formato: string);
begin
  Self.FNome        := Nome;
  Self.FDescricao   := Descricao;
  Self.FTipo        := Tipo;
  Self.FLocal       := Local;
  Self.FObrigatorio := Obrigatorio;
  Self.FFormato     := Formato;
end;

{ Modelo }

constructor Modelo.Create(Nome, Descricao: string;
  Classe: TClassInterfacedObject);
begin
  Self.FNome      := Nome;
  Self.FDescricao := Descricao;
  Self.FClasse    := Classe;
end;

{ SubModelo }

constructor SubModelo.Create(Nome, Descricao: string; TipoLista: Boolean;
  Classe: TClassInterfacedObject);
begin
  Self.FNome      := Nome;
  Self.FDescricao := Descricao;
  if TipoLista then
    Self.Tipo     := tsmList
  else
    Self.Tipo     := tsmInterface;
  Self.Classe     := Classe;
end;

constructor SubModelo.Create(Nome, Descricao: string);
begin
  Self.FNome      := Nome;
  Self.FDescricao := Descricao;
  Self.Tipo       := tsmDictionary;
  Self.Classe     := nil;
end;

{ TAppController }

function TAppController.ChaveRota(RotaExecutada: string;
  Metodo: TMethodType): string;
begin
  Result := RotaExecutada+'['+GetEnumName(TypeInfo(TMethodType), Integer(Metodo))+']';
end;

constructor TAppController.CreateNew;
begin
  inherited Create;
end;

procedure TAppController.Execute;
var
  Ctx         : TRttiContext;
  Tp          : TRttiType;
  sRota       : string;
  sMetodo     : string;
  sPermissoes : string;
  TipoMetodo  : TMethodType;
begin
  TipoMetodo  := THorseRequest(Self.FRequest).RawWebRequest.MethodType;
  sRota       := Self.RotaExecutada;
  try
    sMetodo     := Self.Metodos.Items[sRota];
    sPermissoes := Self.Permissoes.Items[sMetodo];
    //Dados perfil usuário do token
  except
    sMetodo     := Self.Metodos.Items[Self.FormatarRota(sRota, TipoMetodo)];
    sPermissoes := Self.Permissoes.Items[sMetodo];
  end;

  if (sPermissoes.Trim = '') or (true {ver se usuário tem permissão}) then begin
    Ctx := TRttiContext.Create;
    Tp  := Ctx.GetType(Self.ClassInfo);
    try
      Tp.GetMethod(sMetodo).Invoke(Self, []);
    finally
      Ctx.Free;
    end;
  end else begin
    //Self.Send('Você não tem autorização para executar este serviço.', 403);
  end;
end;

function TAppController.FormatarRota(RotaExecutada: string;
  Metodo: TMethodType): string;
var
  I: Integer;
  Partes: TStringList;
  Param: TPair<string, string>;
  Key: String;
begin
  Result := '';
  if RotaExecutada.Trim = '' then Exit;

  Key := Self.ChaveRota(RotaExecutada, Metodo);

  //Se não encontrar a rota na lista provavelmente foi registrada com parâmetros
  if not Self.Metodos.ContainsKey(Key) then begin
    //Se a rota executada continver '/:' e não foi encontrada, é por que há um erro na requisição e a rota não existe
    if Pos('/:', RotaExecutada) > 0 then begin
      Result := '';
      Exit;
    end;

    Partes := TStringList.Create;
    try
      //Realiza substituições
      Partes.Clear;
      Partes.Delimiter  := '/';
      Partes.DelimitedText  := RotaExecutada;
      for Param in Self.FRequest.Params.ToArray do begin
        for I := Partes.Count-1 downto 0 do begin
          if Param.Value = Partes.Strings[i] then begin
            Partes.Strings[i] := ':'+Param.Key;
            Break;
          end;
        end;
      end;
      //Se não encontrados parâmetros válidos, erro na requisição
      if Pos('/:', RotaExecutada) <= 0 then begin
        Result := '';
        Exit;
      end;
      Result := Self.FormatarRota(Partes.DelimitedText, Metodo);
    finally
      Partes.Free;
    end;
  end else
    Result := RotaExecutada;
end;

class procedure TAppController.Handle(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);
var Controller: TAppController;
begin
  Controller  := CreateNew;
  try
    try
      //Controller.BeforeExecute;
      Controller.Execute;
      //Controller.AfeterExecute;
    except
      {on E: EHorseException do
        raise EHorseException.Create(E.Status, getMSGErro(E.Error));

      on e: exception do
        raise Exception.Create(getMSGErro(E.Message));
      }
    end;
  finally
    Controller.DisposeOf;
  end;
end;

function TAppController.RotaExecutada: string;
var
  RotaExecutada: string;
  PathInfo: string;
  MethodType : TMethodType;
begin
  Result        := '';
  PathInfo      := THorseRequest(Self.FRequest).RawWebRequest.PathInfo;
  MethodType    := THorseRequest(Self.FRequest).RawWebRequest.MethodType;
  RotaExecutada := FormatarRota(PathInfo, MethodType);

  if RotaExecutada = '' then begin
    //Retorno Self.Send('Rota [' + PathInfo + '] não encontrada para este serviço.', 404);
    Exit;
  end;

  Result := Self.ChaveRota(RotaExecutada, MethodType);
end;

end.
