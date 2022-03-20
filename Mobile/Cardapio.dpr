program Cardapio;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  Dm.Principal in 'DataModule\Dm.Principal.pas' {DmPrincipal: TDataModule},
  uFunctions in 'Units\uFunctions.pas',
  uLoading in 'Units\uLoading.pas',
  UnitSacola in 'UnitSacola.pas' {FrmSacola};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TDmPrincipal, DmPrincipal);
  Application.CreateForm(TFrmSacola, FrmSacola);
  Application.Run;
end.
