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
    procedure btnRemoveClick(Sender: TObject);
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

procedure TFirmwareListFrm.btnLoadClick(Sender: TObject);
begin
//load a firmware..

end;

procedure TFirmwareListFrm.btnRemoveClick(Sender: TObject);
begin
//delete record..
end;

end.
