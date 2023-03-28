unit frmReportLogs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,dmDatabase,frmReportPreview;

type
  TReportLogsFrm = class(TForm)
    dtStart: TDateTimePicker;
    dtEnd: TDateTimePicker;
    lblStart: TLabel;
    lblEnd: TLabel;
    btnClose: TButton;
    btnPreview: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportLogsFrm: TReportLogsFrm;

implementation

{$R *.dfm}

procedure TReportLogsFrm.btnCloseClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

procedure TReportLogsFrm.btnPreviewClick(Sender: TObject);
var
aStart,aEnd:tDateTime;
aFrm:tReportPreviewFrm;
begin
//run log report

aStart:=dtStart.DateTime;
aEnd:=dtEnd.DateTime;

if aEnd<aStart then
  begin
    ShowMessage('Error: End is before start'+#10+#13+'Please correct..');
    exit;
  end;

  dmDB.qryLogRpt.Active:=false;
  dmDB.qryLogRpt.SQL.Clear;
  dmDb.qryLogRpt.SQL.Add('select * from LogData l');
  dmDb.qryLogRpt.SQL.Add('where');
  dmDb.qryLogRpt.SQL.Add('l.Stamp BETWEEN CAST('''+FormatDateTime('yyyy-mm-dd hh:nn:ss',aStart)+
                          ''' AS TIMESTAMP) AND CAST('''+FormatDateTime('yyyy-mm-dd hh:nn:ss',aEnd)+''' AS TIMESTAMP) ');
  dmDb.qryLogRpt.Active:=true;
  aFrm:=tReportPreviewFrm.Create(application);
  dmDb.rptLogs.Preview:=aFrm.rptPreview;
  dmDb.rptLogs.ShowReport(true);
  aFrm.ShowModal;
  aFrm.Free;



end;

end.
