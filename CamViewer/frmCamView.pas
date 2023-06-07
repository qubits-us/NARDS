unit frmCamView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, OverbyteIcsWndControl, OverbyteIcsWSocket, Vcl.StdCtrls, Vcl.ExtCtrls,VCL.Imaging.jpeg;

type
  TCamViewFrm = class(TForm)
    pnlTop: TPanel;
    pblBottom: TPanel;
    imgCam: TImage;
    edIP: TEdit;
    Label1: TLabel;
    btnClose: TButton;
    sckCam: TWSocket;
    lblPort: TLabel;
    edPort: TEdit;
    btnConnect: TButton;
    mLog: TMemo;
    btnDiscon: TButton;
    edBadPacks: TEdit;
    procedure sckCamDataAvailable(Sender: TObject; ErrCode: Word);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconClick(Sender: TObject);
    procedure sckCamSessionConnected(Sender: TObject; ErrCode: Word);
    procedure sckCamSessionClosed(Sender: TObject; ErrCode: Word);
    procedure sckCamError(Sender: TObject);
    procedure sckCamException(Sender: TObject; SocExcept: ESocketException);
    procedure sckCamSocksConnected(Sender: TObject; ErrCode: Word);
    procedure sckCamSocksError(Sender: TObject; Error: Integer; Msg: string);
    procedure sckCamBgException(Sender: TObject; E: Exception; var CanClose: Boolean);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CamViewFrm: TCamViewFrm;
  imgBuff:TBytes;
  imgSize:Int32;
  RecvCount:integer;
  imgRecvd:boolean;
  badPacks:integer;
  CamStrm:tMemoryStream;
  NumImgs:integer;

implementation

{$R *.dfm}


procedure TCamViewFrm.FormCreate(Sender: TObject);
begin
 //
 SetLength(imgBuff,200000);
 //ShowMessage(IntToStr(Length(imgBuff)));
 imgRecvd:=false;
 imgSize:=0;
 RecvCount:=0;
 CamStrm:=tMemoryStream.Create;
 mLog.Lines.Insert(0,'Ready..');
 sckCam.BufSize:=200000;
 NumImgs:=0;
 BadPacks:=0;
end;
procedure TCamViewFrm.btnCloseClick(Sender: TObject);
begin
Close;
end;

procedure TCamViewFrm.btnConnectClick(Sender: TObject);
begin
imgSize:=0;
RecvCount:=0;
sckCam.Port:=edPort.Text;
sckCam.Addr:=edIp.Text;
sckCam.Connect;
mLog.Lines.Insert(0,'Connecting...');
end;

procedure TCamViewFrm.btnDisconClick(Sender: TObject);
begin
sckCam.Close;
RecvCount:=0;
imgSize:=0;
end;

procedure TCamViewFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
CamStrm.Free;
end;

procedure TCamViewFrm.sckCamBgException(Sender: TObject; E: Exception; var CanClose: Boolean);
begin
mlog.Lines.Insert(0,E.Message);
end;

procedure TCamViewFrm.sckCamDataAvailable(Sender: TObject; ErrCode: Word);
var
Len:integer;
jpg:tJpegImage;
begin
//got something..
 jpg:=nil;
 if imgSize=0 then
    begin
     Len:=sckCam.Receive(@imgBuff[0],SizeOf(imgSize));
      if Len>=sizeOf(imgSize) then
       move(imgBuff[0],imgSize,SizeOf(imgSize));
       RecvCount:=0;
       mLog.Lines.Insert(0,'Recieving image:'+IntToStr(imgSize));
    end;

  if imgSize>0 then
    begin
     Len:=sckCam.Receive(@imgBuff[RecvCount],imgSize-RecvCount);
    if Len>0 then
     begin
     RecvCount:=Len+RecvCount;
      if (RecvCount = imgSize) then
        begin
         CamStrm.SetSize(imgSize);
         CamStrm.Position:=0;
         CamStrm.Write(imgBuff[0],imgSize);
         CamStrm.Position:=0;
           try
             jpg:=tJpegImage.Create;

             jpg.LoadFromStream(CamStrm);
             imgCam.Picture.Assign(jpg);

           except on e:exception do
             begin
              mLog.Lines.Insert(0,e.Message);
              Inc(BadPacks);
              edBadPacks.Text:=IntToStr(BadPacks);
              imgSize:=0;
              RecvCount:=0;
             end;
           end;

           if Assigned(jpg) then jpg.Free;
             imgSize:=0;
             RecvCount:=0;
        end;
     end;
    end;


end;

procedure TCamViewFrm.sckCamError(Sender: TObject);
begin
mLog.Lines.Insert(0,'Error');
end;

procedure TCamViewFrm.sckCamException(Sender: TObject; SocExcept: ESocketException);
begin
mLog.Lines.Insert(0,'Sock Error:')
end;

procedure TCamViewFrm.sckCamSessionClosed(Sender: TObject; ErrCode: Word);
begin
mLog.Lines.Insert(0,'Disconnected..');
end;

procedure TCamViewFrm.sckCamSessionConnected(Sender: TObject; ErrCode: Word);
begin
mLog.Lines.Insert(0,'Connected..');
end;

procedure TCamViewFrm.sckCamSocksConnected(Sender: TObject; ErrCode: Word);
begin
mLog.Lines.Insert(0,'Socks Connected:'+IntToStr(ErrCode));
end;

procedure TCamViewFrm.sckCamSocksError(Sender: TObject; Error: Integer; Msg: string);
begin
mLog.Lines.Insert(0,'Socks Error:'+IntToStr(Error)+' '+Msg);
end;

end.
