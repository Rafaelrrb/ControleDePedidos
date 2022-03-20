unit UnitSacola;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,
  FMX.StdCtrls, uFunctions;

type
  TFrmSacola = class(TForm)
    rectToolbar: TRectangle;
    Label1: TLabel;
    imgVoltar: TImage;
    rectAdicionar: TRectangle;
    lblFinalizar: TLabel;
    rectRodape: TRectangle;
    Layout1: TLayout;
    Label2: TLabel;
    lblSubtotal: TLabel;
    Layout2: TLayout;
    Label4: TLabel;
    lblTotal: TLabel;
    Layout3: TLayout;
    Label6: TLabel;
    LblEntrega: TLabel;
    lvSacola: TListView;
    procedure FormShow(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure rectAdicionarClick(Sender: TObject);
  private
    procedure AddProduto(id_produto, qtd: integer; nome, url_foto: string;
      vl_unitario, vl_total: double);
    procedure ListarSacola;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSacola: TFrmSacola;

implementation

{$R *.fmx}

uses Dm.Principal;

procedure TFrmSacola.AddProduto(id_produto, qtd: integer;
                                nome, url_foto: string;
                                vl_unitario, vl_total: double);
var
    item: TListViewItem;
begin
    item := lvSacola.Items.Add;

    with item do
    begin
        Tag := id_produto;
        Height := 80;

        TListItemText(Objects.FindDrawable('txtNome')).Text := nome;
        TListItemText(Objects.FindDrawable('txtQtd')).Text := qtd.ToString + ' x ' +
                                                            FormatFloat('R$ #,##0.00', vl_unitario);
        TListItemText(Objects.FindDrawable('txtValor')).Text := FormatFloat('R$ #,##0.00', vl_total);
        TListItemText(Objects.FindDrawable('imgFoto')).TagString := url_foto;
    end;
end;

procedure TFrmSacola.ListarSacola;
var
    i: integer;
begin
    lvSacola.Items.Clear;
    lvSacola.BeginUpdate;
    DmPrincipal.Subtotal := 0;

    for i := 0 to DmPrincipal.Itens.Size - 1 do
    begin
        AddProduto(DmPrincipal.Itens[i].GetValue<integer>('id_produto', 0),
                   DmPrincipal.Itens[i].GetValue<integer>('qtd', 0),
                   DmPrincipal.Itens[i].GetValue<string>('nome', ''),
                   DmPrincipal.Itens[i].GetValue<string>('url_foto', ''),
                   DmPrincipal.Itens[i].GetValue<double>('vl_unitario', 0),
                   DmPrincipal.Itens[i].GetValue<double>('vl_total', 0));

        DmPrincipal.Subtotal := DmPrincipal.Subtotal +
                                DmPrincipal.Itens[i].GetValue<double>('vl_total', 0);
    end;

    lvSacola.EndUpdate;
    DownloadFoto(lvSacola, 'imgFoto');

    lblSubtotal.Text := FormatFloat('R$ #,##0.00', DmPrincipal.Subtotal);
    lblEntrega.Text := FormatFloat('R$ #,##0.00', DmPrincipal.Entrega);
    lblTotal.Text := FormatFloat('R$ #,##0.00', DmPrincipal.Subtotal + DmPrincipal.Entrega);
end;

procedure TFrmSacola.rectAdicionarClick(Sender: TObject);
begin
    try
        DmPrincipal.GerarPedido;
        close;
    except on ex:exception do
        showmessage('Erro ao gerar pedido: ' + ex.Message);
    end;
end;

procedure TFrmSacola.FormShow(Sender: TObject);
begin
    ListarSacola;
end;

procedure TFrmSacola.imgVoltarClick(Sender: TObject);
begin
    close;
end;

end.
