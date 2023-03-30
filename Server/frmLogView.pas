unit frmLogView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  dmDatabase;

type
  TLogViewFrm = class(TForm)
    pnlBottom: TPanel;
    dgResult: TDBGrid;
    Button1: TButton;
    mSQL: TMemo;
    BtnExecSQL: TButton;
    dsLogs: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure BtnExecSQLClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
dmDb.qryLogView.Active:=false;
dmDb.qryLogView.SQL.Clear;
dmDb.qryLogView.SQL.Add(mSQL.Lines.Text);
dmDb.qryLogView.Active:=true;

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
