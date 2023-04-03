unit frmNardList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,dmDatabase;

type
  TNardListFrm = class(TForm)
    dgNards: TDBGrid;
    BtnClose: TButton;
    dsArdsList: TDataSource;
    btnNew: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnSource: TButton;
    btnFirmware: TButton;
    procedure BtnCloseClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSourceClick(Sender: TObject);
    procedure btnFirmwareClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshList;
  end;

var
  NardListFrm: TNardListFrm;

implementation

{$R *.dfm}
uses frmNardDetails,frmSourceList,frmFirmwareList;

procedure TNardListFrm.RefreshList;
begin
dsArdsList.Enabled:=False;
dmDb.ArdsQry.Refresh;
dsArdsList.Enabled:=true;

end;

procedure TNardListFrm.BtnCloseClick(Sender: TObject);
begin
dmDb.ArdsQry.Active:=false;
ModalResult:=mrOK;
end;

procedure TNardListFrm.btnDeleteClick(Sender: TObject);
var
aNardID:integer;
aName:String;
begin
//delete a nard..

if dmDb.ArdsQry.RecordCount = 0 then exit;

aNardID:=dmDb.ArdsQryARDID.Value;
aName:=dmDb.ArdsQryDISPLAYNAME.Value;
if aName =  '' then aName := 'Blank';




if MessageDlg('Delete Nard '+aName+' Id:'+IntToStr(aNardID)+' ?',
    mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
   //delete it..

    dsArdsList.Enabled:=False;
    if dmDb.DeleteNard(aNardID) then
      begin
        //refresh nard list..
        RefreshList;

      end else dsArdsList.Enabled:=true;



  end;

end;

procedure TNardListFrm.btnEditClick(Sender: TObject);
var
aID:integer;
aFrm:tNardDetailsFrm;
begin
//edit a nard..
aId:=-1;
if dmDb.ArdsQry.RecordCount >0 then
   begin
    aID:=dmDb.ArdsQryARDID.Value;
   end;

if aId>-1 then
 begin
 if dmDb.EditNard(aID) then
    begin
    aFrm:=tNardDetailsFrm.Create(self);
    aFrm.ShowModal;
    aFrm.Free;
    RefreshList;
    end else ShowMessage('Error:Did not locate Nard Id: '+IntToStr(aID));
 end else ShowMessage('Error:Did not locate Nard Id: '+IntToStr(aID));





end;

procedure TNardListFrm.btnFirmwareClick(Sender: TObject);
var
aFrm:tFirmwareListFrm;
begin
if dmDb.ArdsQry.RecordCount>0 then
 begin
  dmDb.qryFirmwareList.Active:=false;
  dmDb.qryFirmwareList.SQL.Clear;
  dmDb.qryFirmwareList.SQL.Add('select * from firmwares where ardid='+IntToStr(dmDb.ArdsQryARDID.Value));
  dmDb.qryFirmwareList.Active:=true;
  aFrm:=tFirmwareListFrm.Create(application);
  aFrm.NardID:=dmDb.ArdsQryARDID.Value;
  aFrm.ShowModal;
  aFrm.Free;
  dmDb.qryFirmwareList.Active:=false;
 end;

end;

procedure TNardListFrm.btnNewClick(Sender: TObject);
var
aFrm:tNardDetailsFrm;
begin
//add a nard..
aFrm:=tNardDetailsFrm.Create(self);
dmDb.tblNardDetails.Active:=true;
dmDb.tblNardDetails.Insert;
aFrm.ShowModal;
aFrm.Free;
RefreshList;
end;

procedure TNardListFrm.btnSourceClick(Sender: TObject);
var
aFrm:tSourceListFrm;
begin
//view the source list
if dmDb.ArdsQry.RecordCount>0 then
 begin
  dmDb.qrySourceList.Active:=false;
  dmDb.qrySourceList.SQL.Clear;
  dmDb.qrySourceList.SQL.Add('select * from sketches where ardid='+IntToStr(dmDb.ArdsQryARDID.Value));
  dmDb.qrySourceList.Active:=true;
  aFrm:=tSourceListFrm.Create(application);
  aFrm.NardId:=dmDb.ArdsQryARDID.Value;
  aFrm.ShowModal;
  aFrm.Free;
  dmDb.qrySourceList.Active:=false;
 end;
end;

procedure TNardListFrm.FormCreate(Sender: TObject);
begin
dmDb.ArdsQry.Active:=false;
dmDb.ArdsQry.SQL.Clear;
dmDb.ArdsQry.SQL.Add('select * from Ards');
dmDb.ArdsQry.Active:=true;
end;

end.
