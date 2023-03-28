unit frmFirmwareList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,dmDatabase;

type
  TFirmwareListFrm = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FirmwareListFrm: TFirmwareListFrm;

implementation

{$R *.dfm}

procedure TFirmwareListFrm.Button4Click(Sender: TObject);
begin
ModalResult:=mrOK;
end;

end.
