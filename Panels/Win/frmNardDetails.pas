unit frmNardDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls,dmDatabase, Data.DB;

type
  TNardDetailsFrm = class(TForm)
    edArdID: TDBEdit;
    dsNardDetails: TDataSource;
    edGroupId: TDBEdit;
    edProcessId: TDBEdit;
    edName: TDBEdit;
    edConnection: TDBEdit;
    edIp: TDBEdit;
    edFirmware: TDBEdit;
    lblID: TLabel;
    lblGroup: TLabel;
    lblProcess: TLabel;
    lblName: TLabel;
    lblFirmware: TLabel;
    lblConnection: TLabel;
    lblIp: TLabel;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NardDetailsFrm: TNardDetailsFrm;

implementation

{$R *.dfm}

procedure TNardDetailsFrm.btnCancelClick(Sender: TObject);
begin
dmDb.tblNardDetails.Cancel;
ModalResult:=mrCancel;
end;

procedure TNardDetailsFrm.btnSaveClick(Sender: TObject);
begin





dmDb.tblNardDetails.Post;

ModalResult:=mrOk;
end;

end.
