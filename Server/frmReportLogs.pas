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
    edNards: TEdit;
    cbAllNards: TCheckBox;
    lblNards: TLabel;
    cbAllVars: TCheckBox;
    edVarId: TEdit;
    Label2: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure cbAllNardsClick(Sender: TObject);
    procedure cbAllVarsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  dmDb.qryLogRpt.SQL.Add('SELECT r.STAMP, r.ARDID, r.VALUETYPE, r.VALUEINDEX, r.VALUEINT,r.VALUEFLOAT, a.DISPLAYNAME');
  dmDb.qryLogRpt.SQL.Add('FROM LOGDATA r');
  dmDb.qryLogRpt.SQL.Add('join ARDVALUES a on r.ARDID = a.ARDID and r.VALUEINDEX = a.VALINDEX');

  dmDb.qryLogRpt.SQL.Add('where');
  dmDb.qryLogRpt.SQL.Add('r.Stamp BETWEEN CAST('''+FormatDateTime('yyyy-mm-dd hh:nn:ss',aStart)+
                          ''' AS TIMESTAMP) AND CAST('''+FormatDateTime('yyyy-mm-dd hh:nn:ss',aEnd)+''' AS TIMESTAMP) ');
if not cbAllNards.Checked then
  dmDb.qryLogRpt.SQL.Add('AND r.ARDID='+edNards.Text);
if not cbAllVars.Checked then
  dmDb.qryLogRpt.SQL.Add('AND r.VALUEINDEX='+edVarId.Text);
//now let's order by stamp
  dmDb.qryLogRpt.SQL.Add('order by r.STAMP');

 try
  dmDb.qryLogRpt.Active:=true;
 except on e:exception do
   begin
     ShowMessage('SQL Error:'+e.Message);
     exit;
   end;

 end;
  aFrm:=tReportPreviewFrm.Create(application);
  dmDb.rptLogs.Preview:=aFrm.rptPreview;
  dmDb.rptLogs.ShowReport(true);
  aFrm.ShowModal;
  aFrm.Free;



end;

procedure TReportLogsFrm.cbAllNardsClick(Sender: TObject);
begin
if cbAllNards.Checked then
  begin
   edNards.Enabled:=false;
  end else
    begin
    edNards.Enabled:=true;

    end;
end;

procedure TReportLogsFrm.cbAllVarsClick(Sender: TObject);
begin
if cbAllVars.Checked then
  begin
   edVarId.Enabled:=false;
  end else
     begin
     edVarId.Enabled:=true;
     end;
end;

procedure TReportLogsFrm.FormCreate(Sender: TObject);
begin
dtStart.DateTime:=now-7;
dtEnd.DateTime:=now;
end;

end.
