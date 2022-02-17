unit uAppController;

interface

uses
  System.SysUtils, Horse;

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

  end;

implementation

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

end.
