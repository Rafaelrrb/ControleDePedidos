unit Dm.Principal;

interface

uses
  System.SysUtils, System.Classes, RESTRequest4D, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.JSON;

type
  TDmPrincipal = class(TDataModule)
    TabProdutos: TFDMemTable;
    TabPedidos: TFDMemTable;
    TabConfig: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FItens: TJSONArray;
    FEntrega: Double;
    FSubtotal: Double;
    FId_usuario: Integer;
    { Private declarations }
  public
    procedure ListarCardapio;
    procedure ListarPedidos;
    procedure CarregarConfig;
    procedure GerarPedido;
    procedure AddProdutoSacola(id_produto, qtd: integer; nome, url_foto: string;
                                vl_unitario, vl_total: double);

    property Itens: TJSONArray read FItens write FItens;
    property Subtotal: Double read FSubtotal write FSubtotal;
    property Entrega: Double read FEntrega write FEntrega;
    property Id_Usuario: Integer read FId_usuario write FId_usuario;
  end;

var
  DmPrincipal: TDmPrincipal;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

const
    URL_BASE = 'http://localhost:3000';
    //URL_BASE = 'http://192.168.0.102:3000';

procedure TDmPrincipal.ListarCardapio;
var
    resp: IResponse;
begin
    TabProdutos.FieldDefs.Clear;

    resp := TRequest.New.BaseURL(URL_BASE)
            .Resource('produtos/cardapio')
            .DataSetAdapter(TabProdutos)
            .Accept('application/json')
            .Get;

    if resp.StatusCode <> 200 then
        raise Exception.Create('Erro ao carregar produtos: ' + resp.Content);
end;

procedure TDmPrincipal.ListarPedidos;
var
    resp: IResponse;
begin
    TabPedidos.FieldDefs.Clear;

    resp := TRequest.New.BaseURL(URL_BASE)
            .Resource('pedidos')
            .DataSetAdapter(TabPedidos)
            .Accept('application/json')
            .Get;

    if resp.StatusCode <> 200 then
        raise Exception.Create('Erro ao carregar pedidos: ' + resp.Content);
end;

procedure TDmPrincipal.CarregarConfig;
var
    resp: IResponse;
begin
    TabConfig.FieldDefs.Clear;

    resp := TRequest.New.BaseURL(URL_BASE)
            .Resource('configs')
            .DataSetAdapter(TabConfig)
            .Accept('application/json')
            .Get;

    if resp.StatusCode <> 200 then
        raise Exception.Create('Erro ao carregar configurações: ' + resp.Content)
    else
        Entrega := TabConfig.FieldByName('vl_entrega').AsFloat;
end;

procedure TDmPrincipal.DataModuleCreate(Sender: TObject);
begin
    FItens := TJSONArray.Create;
end;

procedure TDmPrincipal.DataModuleDestroy(Sender: TObject);
begin
    FItens.DisposeOf;
end;

procedure TDmPrincipal.AddProdutoSacola(id_produto, qtd: integer;
                                     nome, url_foto: string;
                                     vl_unitario, vl_total: double);
var
    item: TJSONObject;
begin
    item := TJSONObject.Create;
    item.AddPair('id_produto', TJSONNumber.Create(id_produto));
    item.AddPair('nome', nome);
    item.AddPair('qtd', TJSONNumber.Create(qtd));
    item.AddPair('vl_unitario', TJSONNumber.Create(vl_unitario));
    item.AddPair('vl_total', TJSONNumber.Create(vl_total));
    item.AddPair('url_foto', url_foto);

    Itens.Add(item);
end;

procedure TDmPrincipal.GerarPedido;
var
    resp: IResponse;
    json: TJSONObject;
begin
    try
        json := TJSONObject.Create;
        json.AddPair('id_usuario', TJSONNumber.Create(Id_Usuario));
        json.AddPair('vl_subtotal', TJSONNumber.Create(Subtotal));
        json.AddPair('vl_entrega', TJSONNumber.Create(Entrega));
        json.AddPair('vl_total', TJSONNumber.Create(Entrega + Subtotal));
        json.AddPair('itens', Itens);

        resp := TRequest.New.BaseURL(URL_BASE)
                .Resource('pedidos')
                .Accept('application/json')
                .AddBody(json.ToJSON)
                .Post;

        if resp.StatusCode <> 201 then
            raise Exception.Create(resp.Content)
        else
        begin
            //Entrega := 0;
            Subtotal := 0;
            Itens := TJSONArray.Create;
        end;

    finally
        json.DisposeOf;
    end;
end;


end.
