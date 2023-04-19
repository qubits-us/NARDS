unit frmLogView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  dmDatabase, Vcl.ExtDlgs;

type
  TLogViewFrm = class(TForm)
    pnlBottom: TPanel;
    dgResult: TDBGrid;
    Button1: TButton;
    mSQL: TMemo;
    BtnExecSQL: TButton;
    dsLogs: TDataSource;
    btnExport: TButton;
    dlgExportFile: TSaveTextFileDialog;
    procedure Button1Click(Sender: TObject);
    procedure BtnExecSQLClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogViewFrm: TLogViewFrm;

implementation

{$R *.dfm}

procedure TLogViewFrm.BtnExecSQLClick(Sender: TObject);
begin
try
dmDb.qryLogView.Active:=false;
dmDb.qryLogView.SQL.Clear;
dmDb.qryLogView.SQL.Add(mSQL.Lines.Text);
dmDb.qryLogView.Active:=true;
except on e:exception do
  begin
    ShowMessage('Error in SQL:'+#10+#13+e.Message);
    exit;
  end;
end;
end;

procedure TLogViewFrm.btnExportClick(Sender: TObject);
var
aFileName,aLine:String;
ExportFile:TextFile;
i:integer;
begin

   if not dmDb.qryLogView.Active then exit;
   if dmDb.qryLogView.RecordCount = 0 then exit;




//export results..
aFileName:='';
if dlgExportFile.Execute then
  aFileName:=dlgExportFile.FileName;
if aFileName<>'' then
   begin

       AssignFile(ExportFile,aFileName);
      try
       ReWrite(ExportFile);
      except on e:Exception do
       begin
        ShowMessage('Error creating export file.'+#10+#13+e.Message);
        exit;
       end;
      end;

     try
     aLine:='';
      for i:=0 to dmDb.qryLogView.FieldCount-1 do
        begin
          aLine:=aLine+dmDb.qryLogView.Fields[i].DisplayName+',';
        end;

      WriteLn(ExportFile,aLine);
      aLine:='';

      dmDb.qryLogView.First;
       while not dmDb.qryLogView.Eof do
          begin
           aLine:='';
           for i:=0 to dmDb.qryLogView.FieldCount-1 do
            begin
             aLine:=aLine+dmDb.qryLogView.Fields[i].AsString+',';
            end;
          WriteLn(ExportFile,aLine);
          dmDb.qryLogView.Next;
          end;
     finally
       CloseFile(ExportFile);
     end;
     dmDb.qryLogView.First;
     ShowMessage('Export completed..');
   end;


end;

procedure TLogViewFrm.Button1Click(Sender: TObject);
begin
ModalResult:=mrOk;
end;

procedure TLogViewFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
dmDb.qryLogView.Active:=false;

end;

end.
