unit frmHashList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,dmDatabase;

type
  THashListFrm = class(TForm)
    btnClose: TButton;
    btnDel: TButton;
    btnAdd: TButton;
    DBGrid1: TDBGrid;
    dsHashes: TDataSource;
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HashListFrm: THashListFrm;

implementation

{$R *.dfm}
uses frmMsg,frmGetStr;

procedure THashListFrm.btnAddClick(Sender: TObject);
var
aHash:uint32;
aStr:String;
aId:integer;
begin
//add a hash
aStr:=GetStr('Enter ID to hash.');
if aStr<>'UserCanceled' then
  begin
    aHash:=dmDb.Hash(aStr);

    aId:=dmDb.seqHashId.GetNextValue;

    dmDb.qryGen.Active:=False;
    dmDb.qryGen.SQL.Clear;
    dmDb.qryGen.SQL.Add('insert into hashes (HASHID, HASH, GROUPID, ACCESSLEVEL, LASTACCESS)');
    dmDb.qryGen.SQL.Add('values('+IntToStr(aId)+', '+IntToStr(aHash)+', 0, 0, CURRENT_TIMESTAMP )');
   try
    dmDb.qryGen.ExecSQL;
   except on e:exception do
     begin
       ShowMessage('Error in SQL:'+e.Message);
       exit;
     end;

   end;
    ShowMsg('Hash Added..');
    dmDb.qryHashes.Refresh;

  end;




end;

procedure THashListFrm.btnCloseClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

procedure THashListFrm.btnDelClick(Sender: TObject);
begin
//delete a hash
if MsgYesNo('Delete this hash?') then
  begin
    //delete hash
   if dmDb.qryHashes.RecordCount >0 then
     dmDb.qryHashes.Delete;
   dmDb.qryHashes.Refresh;

  end;
end;

end.
