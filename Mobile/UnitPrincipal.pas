unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, uFunctions, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, uLoading;

type
  TFrmPrincipal = class(TForm)
    rectToolbar: TRectangle;
    Image1: TImage;
    imgSacola: TImage;
    rectAbas: TRectangle;
    imgAba1: TImage;
    imgAba2: TImage;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    lvCardapio: TListView;
    lvPedido: TListView;
    lytDetalheProd: TLayout;
    rectDetalheProd: TRectangle;
    rectFundo: TRectangle;
    imgFoto: TImage;
    Layout1: TLayout;
    lblDescricao: TLabel;
    rectRodape: TRectangle;
    Layout3: TLayout;
    imgMenos: TImage;
    imgMais: TImage;
    lblQtd: TLabel;
    rectAdicionar: TRectangle;
    lblTotal: TLabel;
    imgFecharDetalhe: TImage;
    lblNome: TLabel;
    lblValor: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lvCardapioUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgAba1Click(Sender: TObject);
    procedure lvCardapioItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgFecharDetalheClick(Sender: TObject);
    procedure imgMenosClick(Sender: TObject);
    procedure rectAdicionarClick(Sender: TObject);
    procedure imgSacolaClick(Sender: TObject);
  private
    procedure AddCategoria(categoria: string);
    procedure AddProduto(id_produto: integer;
                         nome, descricao, url_foto: string;
                         valor: double);
    procedure ListarProdutos;
    procedure ThreadProdutosTerminate(Sender: TObject);
    procedure MudarAba(img: Timage);
    procedure ListarPedidos;
    procedure AddPedido(id_pedido, qtd_item: integer; dt_pedido, status: string;
      valor: double);
    procedure CalculaQtd(vl: integer);
    procedure CalculaTotal;
    procedure ThreadPedidosTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Dm.Principal, UnitSacola;

function DescrStatus(st: string): string;
begin
    if (st = 'A') then Result := 'Aguardando'
    else if (st = 'P') then Result := 'Pedido em produção'
    else if (st = 'E') then Result := 'Saiu para entrega'
    else Result := '';
end;

procedure TFrmPrincipal.AddCategoria(categoria: string);
var
    item: TListViewItem;
begin
    item := lvCardapio.Items.Add;

    with item do
    begin
        Tag := 0;
        Height := 70;
        TListItemText(Objects.FindDrawable('txtTitulo')).Text := categoria;
    end;
end;

procedure TFrmPrincipal.AddProduto(id_produto: integer;
                                   nome, descricao, url_foto: string;
                                   valor: double);
var
    item: TListViewItem;
begin
    item := lvCardapio.Items.Add;

    with item do
    begin
        Tag := id_produto;
        Height := 100;

        TListItemText(Objects.FindDrawable('txtTitulo')).Text := nome;
        TListItemText(Objects.FindDrawable('txtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('txtValor')).Text := FormatFloat('R$ #,##0.00', valor);
        TListItemText(Objects.FindDrawable('txtValor')).TagFloat := valor;
        TListItemImage(Objects.FindDrawable('imgFoto')).TagString := url_foto;
    end;
end;

procedure TFrmPrincipal.AddPedido(id_pedido, qtd_item: integer;
                                   dt_pedido, status: string;
                                   valor: double);
var
    item: TListViewItem;
begin
    item := lvPedido.Items.Add;

    with item do
    begin
        Tag := id_pedido;
        Height := 80;

        TListItemText(Objects.FindDrawable('txtPedido')).Text := 'Pedido ' + id_pedido.ToString;
        TListItemText(Objects.FindDrawable('txtData')).Text := Copy(dt_pedido, 1, 10) + ' - ' + qtd_item.ToString +
                                                               ' itens' + ' - ' +
                                                               DescrStatus(status);
        TListItemText(Objects.FindDrawable('txtValor')).Text := FormatFloat('R$ #,##0.00', valor);
    end;
end;

procedure TFrmPrincipal.ThreadProdutosTerminate(Sender: TObject);
begin
    lvCardapio.EndUpdate;
    TLoading.Hide;

    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

    DownloadFoto(lvCardapio, 'imgFoto');
end;

procedure TFrmPrincipal.ThreadPedidosTerminate(Sender: TObject);
begin
    lvPedido.EndUpdate;
    TLoading.Hide;

    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;
end;

procedure TFrmPrincipal.ListarProdutos;
var
    t: TThread;
    categoria_anterior : string;
begin
    lvCardapio.Items.Clear;
    lvCardapio.BeginUpdate;
    TLoading.Show(FrmPrincipal, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(5000);
        DmPrincipal.ListarCardapio;

        with DmPrincipal.TabProdutos do
        begin
            while NOT EOF do
            begin
                if categoria_anterior <> fieldbyname('categoria').asstring then
                    AddCategoria(fieldbyname('categoria').asstring);

                AddProduto(fieldbyname('id_produto').asinteger,
                           fieldbyname('nome').asstring,
                           fieldbyname('descricao').asstring,
                           fieldbyname('url_foto').asstring,
                           fieldbyname('preco').asfloat);

                categoria_anterior := fieldbyname('categoria').asstring;
                Next;
            end;
        end;
    end);

    t.OnTerminate := ThreadProdutosTerminate;
    t.Start;
end;

procedure TFrmPrincipal.ListarPedidos;
var
    t: TThread;
begin
    lvPedido.Items.Clear;
    lvPedido.BeginUpdate;
    TLoading.Show(FrmPrincipal, 'Carregando Pedidos...');

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(5000);
        DmPrincipal.ListarPedidos;

        with DmPrincipal.TabPedidos do
        begin
            while NOT EOF do
            begin
                AddPedido(fieldbyname('id_pedido').asinteger,
                          fieldbyname('qtd_item').asinteger,
                          fieldbyname('dt_pedido').asstring,
                          fieldbyname('status').asstring,
                          fieldbyname('vl_total').asfloat);

                Next;
            end;
        end;
    end);

    t.OnTerminate := ThreadPedidosTerminate;
    t.Start;
end;

procedure TFrmPrincipal.lvCardapioItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    imgFoto.TagString := TListItemImage(AItem.Objects.FindDrawable('imgFoto')).TagString;
    imgFoto.Bitmap := TListItemImage(AItem.Objects.FindDrawable('imgFoto')).Bitmap;
    imgFoto.Tag := AItem.tag; // id_produto;

    lblNome.Text := TListItemText(AItem.Objects.FindDrawable('txtTitulo')).Text;
    lblDescricao.Text := TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Text;
    lblValor.Text := TListItemText(AItem.Objects.FindDrawable('txtValor')).Text;
    lblValor.TagFloat := TListItemText(AItem.Objects.FindDrawable('txtValor')).TagFloat;

    CalculaQtd(0);
    CalculaTotal;

    lytDetalheProd.Visible := true;
end;

procedure TFrmPrincipal.lvCardapioUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if AItem.Tag = 0 then  // Categoria
    begin
        TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Visible := false;
        TListItemText(AItem.Objects.FindDrawable('txtValor')).Visible := false;
        TListItemImage(AItem.Objects.FindDrawable('imgFoto')).Visible := false;

        TListItemText(AItem.Objects.FindDrawable('txtTitulo')).PlaceOffset.X := 5;
        TListItemText(AItem.Objects.FindDrawable('txtTitulo')).PlaceOffset.Y := 30;
        TListItemText(AItem.Objects.FindDrawable('txtTitulo')).Font.Size := 22;
    end
    else
    begin
        TListItemText(AItem.Objects.FindDrawable('txtTitulo')).PlaceOffset.X := 96;
        TListItemText(AItem.Objects.FindDrawable('txtTitulo')).PlaceOffset.Y := 11;
        TListItemText(AItem.Objects.FindDrawable('txtTitulo')).Font.Size := 16;
    end;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    DmPrincipal.CarregarConfig;
    DmPrincipal.Id_Usuario := 1; // Vem do login...
    ListarProdutos;
end;

procedure TFrmPrincipal.MudarAba(img: Timage);
begin
    imgAba1.Opacity := 0.4;
    imgAba2.Opacity := 0.4;
    img.Opacity := 1;

    TabControl1.GotoVisibleTab(img.Tag);

    if img.Tag = 1 then // Aba pedidos...
        ListarPedidos;
end;

procedure TFrmPrincipal.rectAdicionarClick(Sender: TObject);
begin
    try
        DmPrincipal.AddProdutoSacola(imgFoto.Tag,  // id_produto
                                     lblQtd.Tag,   // qtd
                                     lblNome.Text, // nome produto
                                     imgFoto.TagString, // url_foto
                                     lblValor.TagFloat, // vl_unit
                                     lblValor.TagFloat * lblQtd.Tag);  // vl_total
        lytDetalheProd.Visible := false;
    except on ex:exception do
        showmessage('Erro ao inserir produto: ' + ex.Message);
    end;
end;

procedure TFrmPrincipal.imgAba1Click(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

procedure TFrmPrincipal.imgFecharDetalheClick(Sender: TObject);
begin
    lytDetalheProd.Visible := false;
end;

procedure TFrmPrincipal.CalculaQtd(vl: integer);
begin
    try
        if vl = 0 then
            lblQtd.Tag := 1
        else
            lblQtd.Tag := lblQtd.Tag + vl;

        if lblQtd.Tag = 0 then
            lblQtd.Tag := 1;

        lblQtd.Text := lblQtd.Tag.ToString;
    except
        lblQtd.Text := '1';
        lblQtd.Tag := 1;
    end;
end;

procedure TFrmPrincipal.CalculaTotal;
begin
    try
        lblTotal.Text := 'Adicionar ' + FormatFloat('R$ #,##0.00', lblValor.TagFloat * lblQtd.Tag);
    except
        lblTotal.Text := 'Adicionar ' + FormatFloat('R$ #,##0.00', 0);
    end;
end;

procedure TFrmPrincipal.imgMenosClick(Sender: TObject);
begin
    CalculaQtd(TImage(Sender).Tag);
    CalculaTotal;
end;

procedure TFrmPrincipal.imgSacolaClick(Sender: TObject);
begin
    if NOT Assigned(FrmSacola) then
        Application.CreateForm(TFrmSacola, FrmSacola);

    FrmSacola.Show;
end;

end.
