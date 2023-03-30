unit frmManageLogs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TManageLogsFrm = class(TForm)
    btnClose: TButton;
    cbAllNards: TCheckBox;
    edNardID: TEdit;
    Label1: TLabel;
    rgType: TRadioGroup;
    cbAllData: TCheckBox;
    dtStart: TDateTimePicker;
    Label2: TLabel;
    Delete: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure cbAllNardsClick(Sender: TObject);
    procedure cbAllDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ManageLogsFrm: TManageLogsFrm;

implementation

{$R *.dfm}

uses dmDatabase,frmMsg;

procedure TManageLogsFrm.btnCloseClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

procedure TManageLogsFrm.cbAllDataClick(Sender: TObject);
begin
if cbAllData.Checked then
  begin
  dtStart.Enabled:=false;
  end else
    begin
    dtStart.Enabled:=true;
    end;
end;

procedure TManageLogsFrm.cbAllNardsClick(Sender: TObject);
begin
if cbAllNards.Checked then
  begin
  edNardID.Enabled:=false;
  end else
    begin
    edNardID.Enabled:=true;
    end;
end;

procedure TManageLogsFrm.DeleteClick(Sender: TObject);
var
aLogName:String;
allnards,alldata:boolean;
start:tDateTime;
aNard,aWhere:string;
begin
//delete from logs.
if MsgYesNo('Confirm delete from logs?') then
begin
  //delete data
  case rgType.ItemIndex of
      0:aLogName:='LogData';
      1:aLogName:='LogImg';
      2:aLogName:='LogHash';
  end;

  allnards:=false;
  alldata:=false;
  if cbAllNards.Checked then allnards:=true else aNard:=edNardId.Text;
  if cbAllData.Checked then alldata := true else start:=dtStart.DateTime;

  dmDb.qryGen.Active:=false;
  dmDb.qryGen.SQL.Clear;
  dmDb.qryGen.SQL.Add('Delete from '+aLogName);
  if (allnards or alldata) or (allnards and alldata) then
  begin
  if not allnards then
   begin
   aWhere:='Where ArdID='+aNard;
   if not alldata then aWhere:=aWhere+' AND Stamp < '+FormatDateTime('YYYY-MM-DD HH:NN',start);
   end else
     begin
     if not alldata then aWhere:='Where Stamp < '+FormatDateTime('YYYY-MM-DD HH:NN',start);;
     end;
  dmDb.qryGen.SQL.Add(aWhere);

  end;

  try
    dmDb.qryGen.ExecSQL;
  except on e:exception do
    begin
      ShowMessage('Error in SQL:'+e.Message);
      exit;
    end;

  end;

 ShowMsg('Log data deleted..');


end;

end;

procedure TManageLogsFrm.FormCreate(Sender: TObject);
begin
dtStart.DateTime:=NOW;
end;

end.
