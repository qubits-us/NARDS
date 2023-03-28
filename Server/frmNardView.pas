unit frmNardView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,dmDatabase, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.ComCtrls;

type
  TNardViewFrm = class(TForm)
    edNardID: TEdit;
    lblNardID: TLabel;
    btnExec: TButton;
    edExec: TEdit;
    lblCommand: TLabel;
    edIndex: TEdit;
    lblIndex: TLabel;
    edValue: TEdit;
    lblValue: TLabel;
    btnSet: TButton;
    btnGet: TButton;
    dsValues: TDataSource;
    cmbType: TComboBox;
    Label1: TLabel;
    dsImg: TDataSource;
    pgMain: TPageControl;
    tsValues: TTabSheet;
    tsImages: TTabSheet;
    dgValues: TDBGrid;
    btnRefresh: TButton;
    btnClose: TButton;
    DBImage1: TDBImage;
    DBNavigator1: TDBNavigator;
    procedure btnCloseClick(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnNameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NardID:integer;
  end;

var
  NardViewFrm: TNardViewFrm;

implementation

uses uPacketDEfs,uNardServer,frmGetStr;

{$R *.dfm}

procedure TNardViewFrm.btnCloseClick(Sender: TObject);
begin
//close modal form..
ModalResult:=mrOK;

end;

procedure TNardViewFrm.btnExecClick(Sender: TObject);
var
nid:integer;
begin
//execute a function on remote nard..

  dmDB.qryGen.Active:=False;
  dmDB.qryGen.SQL.Clear;
  dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
  dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4)');
   nid:=dmDB.seqCommands.GetNextValue;
   dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_EXE)+', '+edExec.Text+', 0, 0, 0);');
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

end;

procedure TNardViewFrm.btnGetClick(Sender: TObject);
var
nid:integer;
begin
//get a value from nard..
  dmDB.qryGen.Active:=False;
  dmDB.qryGen.SQL.Clear;
  dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
  dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4)');
   nid:=dmDB.seqCommands.GetNextValue;
   dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_GET)+', '+edIndex.Text+', '+IntToStr(cmbType.ItemIndex)+', 0, 0);');
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



end;

procedure TNardViewFrm.btnNameClick(Sender: TObject);
var
aFrm:TGetStrFrm;
aName:String;
begin
//change var name..
if dmDb.qryNardValues.RecordCount>0 then
  begin
   aFrm:=tGetStrFrm.Create(Application);
   aFrm.edValue.Text:=dmDb.qryNardValuesDISPLAYNAME.Value;
   aFrm.ShowModal;
   aName:=aFrm.edValue.Text;
   aFrm.Free;
   if aName<>dmDb.qryNardValuesDISPLAYNAME.Value then
     begin
     dmDb.qryGen.Active:=false;
     dmDb.qryGen.SQL.Clear;
     dmDb.qryGen.SQL.Add('update Ardvalues set DisplayName='''+aName+'''');
     dmDb.qryGen.SQL.Add('where ArdId='+IntToStr(dmDb.qryNardValuesARDID.Value)+' AND ValIndex='+IntToStr(dmDb.qryNardValuesValIndex.Value));
     dmDb.qryGen.ExecSQL;
     end;
  end;


end;

procedure TNardViewFrm.btnRefreshClick(Sender: TObject);
begin
//refresh nard values

    dmDB.qryNardValues.Active:=False;
    dmDb.qryNardValues.SQL.Clear;
    dmDb.qryNardValues.SQL.Add('select * from ArdValues a where a.ArdID= '+IntToStr(NardID));
    dmDb.qryNardValues.Active:=true;
    dmDb.qryNardValues.Refresh;

end;

procedure TNardViewFrm.btnSetClick(Sender: TObject);
var
nid,tmpInt:integer;
b1,b2,aType:byte;
aDouble:double;
aBigInt:Int64;
begin
//set a nard val..
  dmDB.qryGen.Active:=False;
  dmDB.qryGen.SQL.Clear;
  dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
  dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4, VALUEINT, VALUEFLOAT)');
   nid:=dmDB.seqCommands.GetNextValue;
    case cmbType.ItemIndex of
      SG_BYTE:begin
               b1:=StrToInt(edValue.Text);
               b2:=0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_SET)+
               ', '+edIndex.Text+', '+IntToStr(cmbType.ItemIndex)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0, 0 );');
              end;
      SG_WORD:begin
               tmpInt:=StrToInt(edValue.Text);
               b2:= tmpInt and $FF;
               b1:= tmpInt shr 8;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_SET)+
               ', '+edIndex.Text+', '+IntToStr(cmbType.ItemIndex)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0, 0 );');
              end;
      SG_INT16:begin
               tmpInt:=StrToInt(edValue.Text);
               b2:= tmpInt and $FF;
               b1:= tmpInt shr 8;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_SET)+
               ', '+edIndex.Text+', '+IntToStr(cmbType.ItemIndex)+', '+IntToStr(b1)+', '+IntToStr(b2)+',0 ,0 );');
              end;
      SG_INT32:begin
               tmpInt:=StrToInt(edValue.Text);
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_SET)+
               ', '+edIndex.Text+', '+IntToStr(cmbType.ItemIndex)+', '+IntToStr(b1)+', '+IntToStr(b2)+','+IntToStr(tmpInt)+' ,0 );');
              end;
      SG_UINT32:begin
               aBigInt:=StrToInt(edValue.Text);
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_SET)+
               ', '+edIndex.Text+', '+IntToStr(cmbType.ItemIndex)+', '+IntToStr(b1)+', '+IntToStr(b2)+','+IntToStr(aBigInt)+' ,0 );');
              end;
      SG_FLT4:begin
               aDouble:=StrToFloat(edValue.Text);
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_SET)+
               ', '+edIndex.Text+', '+IntToStr(cmbType.ItemIndex)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0 , '+FloatToStr(aDouble)+' );');
              end;
      SG_FLT8:begin
               aDouble:=StrToFloat(edValue.Text);
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_SET)+
               ', '+edIndex.Text+', '+IntToStr(cmbType.ItemIndex)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0 , '+FloatToStr(aDouble)+' );');
              end;
    end;

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

end;

procedure TNardViewFrm.FormCreate(Sender: TObject);
begin
dmDb.qryImg.Active:=true;
end;

end.
