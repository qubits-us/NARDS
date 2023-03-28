unit frmReportPreview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, frxClass, frxPreview;

type
  TReportPreviewFrm = class(TForm)
    rptPreview: TfrxPreview;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportPreviewFrm: TReportPreviewFrm;

implementation

{$R *.dfm}

procedure TReportPreviewFrm.btnCloseClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

end.
