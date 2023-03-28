unit frmServerConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IniFiles;

type
  TServerConfigFrm = class(TForm)
    btnCancel: TButton;
    btnSave: TButton;
    edServerName: TEdit;
    edServerIp: TEdit;
    lblServerName: TLabel;
    lblServerIP: TLabel;
    edServerPort: TEdit;
    lblServerPort: TLabel;
    GroupBox1: TGroupBox;
    edHost: TEdit;
    lblDBPort: TLabel;
    edDBport: TEdit;
    lblDbUser: TLabel;
    edDbUser: TEdit;
    lblHost: TLabel;
    edDbPass: TEdit;
    lblDbPass: TLabel;
    lblDbName: TLabel;
    edDbName: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerConfigFrm: TServerConfigFrm;

implementation
uses dmDatabase;

{$R *.dfm}

procedure TServerConfigFrm.btnCancelClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

procedure TServerConfigFrm.btnSaveClick(Sender: TObject);
var
aIni:TIniFile;
aStr:string;
begin

//save config changes..
aIni := tIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
aIni.WriteString('Server','Name',edServerName.Text);
aIni.WriteString('Server','IP',edServerIp.Text);
aIni.WriteString('Server','Port',edServerPort.Text);

aIni.WriteString('DB','Host',edHost.Text);
aIni.WriteString('DB','Port',edDbPort.Text);
aIni.WriteString('DB','User',edDbUser.Text);
aStr:=edDbPass.Text;
if aStr = '' then aStr :='qubits' else
  begin
    aStr:=dmDb.ScrambledEggs('E',aStr,'stibuq');
  end;
aIni.WriteString('DB','Pass',aStr);
aIni.Free;

//close form
ModalResult:=mrOK;
end;

procedure TServerConfigFrm.FormCreate(Sender: TObject);
var
aIni:TIniFile;
aStr:string;
begin

aIni := tIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
edServerName.Text:=aIni.ReadString('Server','Name','NARDS');
aStr:=aIni.ReadString('Server','IP','');
if aStr<>'' then
edServerIp.Text:=aStr;
edServerPort.Text:=aIni.ReadString('Server','Port','12000');

edHost.Text:=aIni.ReadString('DB','Host','localhost');
edDbPort.Text:=aIni.ReadString('DB','Port','3050');
edDbUser.Text:=aIni.ReadString('DB','User','SYSDBA');
edDbName.Text:=aIni.ReadString('DB','Name','NARDS');
aStr:=aIni.ReadString('DB','Pass','');
if aStr = '' then aStr :='qubits' else
  begin
    aStr:=dmDb.ScrambledEggs('D',aStr,'stibuq');
  end;
edDbPass.Text:=aStr;

aIni.Free;


end;

end.
