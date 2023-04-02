unit frmNardImages;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,dmDatabase, Vcl.ExtCtrls, Vcl.DBCtrls, Data.DB;

type
  TNardImagesFrm = class(TForm)
    btnClose: TButton;
    dsImages: TDataSource;
    dbStamp: TDBText;
    dbImg: TDBImage;
    dbnImg: TDBNavigator;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NardImagesFrm: TNardImagesFrm;

implementation

{$R *.dfm}

procedure TNardImagesFrm.btnCloseClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

end.
