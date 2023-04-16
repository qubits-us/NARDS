unit frmReportPreview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, frxClass, frxPreview;

type
  TReportPreviewFrm = class(TForm)
    rptPreview: TfrxPreview;
    btnClose: TButton;
    btnPrint: TButton;
    btnPageSetup: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnPageSetupClick(Sender: TObject);
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

procedure TReportPreviewFrm.btnPageSetupClick(Sender: TObject);
begin
//show page setup
rptPreview.PageSetupDlg;
end;

procedure TReportPreviewFrm.btnPrintClick(Sender: TObject);
begin
//print
rptPreview.Print;
end;

end.
