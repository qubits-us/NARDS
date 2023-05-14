unit frmFirmwareList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,dmDatabase, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TFirmwareListFrm = class(TForm)
    dsFirmwares: TDataSource;
    dbgFirmwares: TDBGrid;
    btnAdd: TButton;
    btnLoad: TButton;
    btnClose: TButton;
    dlgSelectBin: TOpenDialog;
    dTxtFileName: TDBText;
    dbNotes: TDBMemo;
    lblNotes: TLabel;
    DBNavigator1: TDBNavigator;
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NardID:integer;
  end;

var
  FirmwareListFrm: TFirmwareListFrm;

implementation

{$R *.dfm}

uses frmMsg,uNARDserver,uPacketDefs;

procedure TFirmwareListFrm.btnAddClick(Sender: TObject);
var
aFileName:String;
BinStrm:tFileStream;
aFirmID:integer;
begin

//add a firmware

if dlgSelectBin.Execute then
  begin
    aFileName:=dlgSelectBin.FileName;
    BinStrm:=tFileStream.Create(aFileName,fmOpenRead);
    aFirmId:=dmDb.seqFirmwareId.GetNextValue;
    dmDb.qryGen.Active:=false;
    dmDb.qryGen.SQL.Clear;
    dmDb.qryGen.SQL.Add('insert into firmwares (firmid,stamp,ardid,firmware)');
    dmDb.qryGen.SQL.Add('values ('+IntToStr(aFirmID)+',CURRENT_TIMESTAMP,'+IntToStr(NardID)+',:BIN)');
    dmDb.qryGen.ParamByName('BIN').LoadFromStream(BinStrm);
    BinStrm.Destroy;
    try
      dmDb.qryGen.ExecSQL;
    except on e:exception do
      begin
        ShowMessage('ExecSQL error:'+e.Message);
        dmDb.qryGen.Active:=false;
        dmDb.qryGen.SQL.Clear;
        exit;
      end;

    end;
    dmDb.qryGen.Active:=false;
    dmDb.qryGen.SQL.Clear;
    ShowMessage(aFileName +' has been added.');
  end;


end;

procedure TFirmwareListFrm.btnCloseClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

//load a firmware..
procedure TFirmwareListFrm.btnLoadClick(Sender: TObject);
var
nid:integer;
aFirmId:integer;
aName:string;
begin

aFirmId:=-1;
  if dmDb.qryFirmwareList.RecordCount> 0 then
    begin
     aFirmId:=dmDb.qryFirmwareListFirmId.Value;
     aName:=dmDb.qryFirmwareListFileName.Value;
    end;

 if aFirmId>0 then
  begin
   if MsgYesNo('Load firmware: '+IntToStr(aFirmId)+':'+aName) then
   begin
     //load a firmware..
     dmDB.qryGen.Active:=False;
     dmDB.qryGen.SQL.Clear;
     dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
     dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4, VALUEINT, VALUEFLOAT)');
     nid:=dmDB.seqCommands.GetNextValue;
     dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_OTA)+
      ', '+IntToStr(aFirmId)+', 0, 0, 0, 0, 0 );');
     try
       dmDB.qryGen.ExecSQL;
      except on e:exception do
        begin
        ShowMessage(e.message);
        end;

     end;
     //set new command id to server..
     //causes clients to refresh dbs..
     PacketSrv.CommandID:=nid;
     ShowMsg('Firmware update command sent..');
   end;

  end;

end;

end.
