unit frmSourceList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,dmDatabase, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TSourceListFrm = class(TForm)
    btnView: TButton;
    btnAdd: TButton;
    dbSource: TDBGrid;
    btnClose: TButton;
    dsSource: TDataSource;
    dlgSelectBin: TOpenDialog;
    dbNav: TDBNavigator;
    procedure btnCloseClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NardId:integer;
  end;

var
  SourceListFrm: TSourceListFrm;

implementation

{$R *.dfm}

uses frmSourceView;



procedure TSourceListFrm.btnAddClick(Sender: TObject);
var
aFileName:String;
BinStrm:tFileStream;
aFirmID:integer;
begin
//add a source file

if dlgSelectBin.Execute then
  begin
    aFileName:=dlgSelectBin.FileName;
    BinStrm:=tFileStream.Create(aFileName,fmOpenRead);
    aFirmId:=dmDb.seqSketchId.GetNextValue;
    dmDb.qryGen.Active:=false;
    dmDb.qryGen.SQL.Clear;
    dmDb.qryGen.SQL.Add('insert into sketches (sketchid,stamp,ardid,filename,sketch)');
    dmDb.qryGen.SQL.Add('values ('+IntToStr(aFirmID)+',CURRENT_TIMESTAMP,'+IntToStr(NardID)+', '''+ExtractFileName(aFileName)+''' ,:BIN)');
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

procedure TSourceListFrm.btnCloseClick(Sender: TObject);
begin
ModalResult:=mrOK;
end;

procedure TSourceListFrm.btnViewClick(Sender: TObject);
var
aFrm:tSourceViewFrm;
aStrm:tStream;
begin

if dmDb.qrySourceList.RecordCount>0 then
 begin
 //aStrm:=tMemoryStream.Create;

 aStrm:=dmDb.qrySourceList.CreateBlobStream(dmDb.qrySourceList.FieldByName('SKETCH'),bmRead);
 aFrm:=tSourceViewFrm.Create(self);
 aFrm.seSource.Lines.LoadFromStream(aStrm);

 aFrm.ShowModal;
 aFrm.Free;
 aStrm.Free;
 end;

end;

end.
