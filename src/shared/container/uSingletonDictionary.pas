unit uSingletonDictionary;

interface

uses
  System.generics.collections;

type
  TSingletonDictionary = class
    private
      FMetodos: TDictionary<string, string>;
      FPermissoes: TDictionary<string, string>;
      FRotas: TDictionary<string, string>;
      FConfigRota: TDictionary<string, string>;

    public
      property Metodos: TDictionary<string,string> read FMetodos write FMetodos;
      property Permissoes: TDictionary<string,string> read FPermissoes write FPermissoes;
      property Rotas: TDictionary<string,string> read FRotas write FRotas;
      property ConfigRota: TDictionary<string, string> read FConfigRota write FConfigRota;

      class function GetInstance: TSingletonDictionary;
      destructor Destroy;
    strict private
      class var FInstance: TSingletonDictionary;
      constructor Create;
  end;

implementation

{ TSingletonDictionary }

constructor TSingletonDictionary.Create;
begin
  FMetodos    := TDictionary<string, string>.Create;
  FPermissoes := TDictionary<string, string>.Create;
  FRotas      := TDictionary<string, string>.Create;
  FConfigRota := TDictionary<string, string>.Create;
end;

destructor TSingletonDictionary.Destroy;
begin
  FMetodos.DisposeOf;
  FPermissoes.DisposeOf;
  FRotas.DisposeOf;
  FConfigRota.DisposeOf;
end;

class function TSingletonDictionary.GetInstance: TSingletonDictionary;
begin
  If FInstance = nil Then FInstance := TSingletonDictionary.Create();
  Result := FInstance;
end;

end.
