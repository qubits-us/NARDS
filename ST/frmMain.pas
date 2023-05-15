unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADTrmEmu, OoMisc, AdPort, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls;

type
  TMainFrm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    File2: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    pnlBottom: TPanel;
    ComPort: TApdComPort;
    serTerm: TAdTerminal;
    emuTTY: TAdTTYEmulator;
    emuVT100: TAdVT100Emulator;
    edPort: TEdit;
    lblPort: TLabel;
    cbBaud: TComboBox;
    lblBaud: TLabel;
    btnOpenClose: TButton;
    edLine: TEdit;
    btnSend: TButton;
    cbCR: TCheckBox;
    cbLF: TCheckBox;
    Label1: TLabel;
    erminal1: TMenuItem;
    menEmulation: TMenuItem;
    menEmuNone: TMenuItem;
    menEmuTTY: TMenuItem;
    menEmuVT100: TMenuItem;
    menCapture: TMenuItem;
    menTracing: TMenuItem;
    procedure btnOpenCloseClick(Sender: TObject);
    procedure ComPortPortOpen(Sender: TObject);
    procedure ComPortPortClose(Sender: TObject);
    procedure File2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSendClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure menCaptureClick(Sender: TObject);
    procedure menTracingClick(Sender: TObject);
    procedure menEmuNoneClick(Sender: TObject);
    procedure menEmuTTYClick(Sender: TObject);
    procedure menEmuVT100Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.dfm}

procedure TMainFrm.About1Click(Sender: TObject);
begin
ShowMessage('Nard Serial Terminal v1.0');
end;

procedure TMainFrm.btnOpenCloseClick(Sender: TObject);
begin
//open or close the port..
  if ComPort.Open then
      ComPort.Open:= false else
        begin
         try
          ComPort.ComNumber:=StrToInt(edPort.Text);
          ComPort.Baud:=StrToInt(cbBaud.Text);
          ComPort.Open:=True;
          except on e:Exception do
           begin
            ShowMessage(e.Message);
            exit;
           end;
         end;
        end;
end;

procedure TMainFrm.btnSendClick(Sender: TObject);
var
aLine:String;
begin
if ComPort.Open then
  begin
    if edLine.Text<>'' then
       begin
       aLine:=edLine.Text;
       if cbLF.Checked then
         aLine:=aLine+#10;
       if cbCR.Checked then
         aLine:=aLine+#13;
       ComPort.PutBlock(aLine,Length(aLine));
       edLine.Text:='';
       end;
  end;
end;

procedure TMainFrm.ComPortPortClose(Sender: TObject);
begin
btnOpenClose.Caption:='Open';
end;

procedure TMainFrm.ComPortPortOpen(Sender: TObject);
begin
btnOpenClose.Caption:='Close';
end;

procedure TMainFrm.File2Click(Sender: TObject);
begin
close;
end;

procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if Comport.Open then ComPort.DonePort;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
//create
  serTerm.StyleElements :=[];
end;

procedure TMainFrm.menCaptureClick(Sender: TObject);
begin
//capture
if menCapture.Checked then
 begin
 menCapture.Checked:=false;
 serTerm.Capture:=cmOff;
 end else
   begin
   menCapture.Checked:=true;
   serTerm.Capture:=cmOn;
   end;
end;

procedure TMainFrm.menEmuNoneClick(Sender: TObject);
begin
//
if not menEmuNone.Checked then
  begin
    menEmuNone.Checked:=true;
    menEmuTTY.Checked:=false;
    menEmuVT100.Checked:=false;
    serTerm.Emulator:=nil;
  end;
end;

procedure TMainFrm.menEmuTTYClick(Sender: TObject);
begin
//
if not menEmuTTY.Checked then
  begin
    menEmuNone.Checked:=false;
    menEmuTTY.Checked:=true;
    menEmuVT100.Checked:=false;
    serTerm.Emulator:=emuTTY;
  end;
end;

procedure TMainFrm.menEmuVT100Click(Sender: TObject);
begin
//
if not menEmuVT100.Checked then
  begin
    menEmuNone.Checked:=false;
    menEmuTTY.Checked:=false;
    menEmuVT100.Checked:=true;
    serTerm.Emulator:=emuVT100;
  end;
end;

procedure TMainFrm.menTracingClick(Sender: TObject);
begin
//tracing
if menTracing.Checked then
  begin
   ComPort.Tracing:=tlOff;
   menTracing.Checked:=false;
  end else
    begin
     ComPort.Tracing:=tlOn;
     menTracing.Checked:=true;
    end;
end;

end.
