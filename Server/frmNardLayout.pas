unit frmNardLayout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, Data.DB, Vcl.Grids, Vcl.DBGrids,NardView, Vcl.ComCtrls;

type
  TNardLayoutFrm = class(TForm)
    btnUpdate: TButton;
    lblItemID: TLabel;
    dlgSelPic: TOpenPictureDialog;
    DBGrid1: TDBGrid;
    dsScreenVals: TDataSource;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnSetV: TButton;
    pcMain: TPageControl;
    tsGen: TTabSheet;
    tsImg: TTabSheet;
    tsAct: TTabSheet;
    edNardID: TEdit;
    lnlID: TLabel;
    cbShowName: TCheckBox;
    edName: TEdit;
    lblTop: TLabel;
    lblHeight: TLabel;
    edHeight: TEdit;
    edTop: TEdit;
    lblLeft: TLabel;
    lblWidth: TLabel;
    edWidth: TEdit;
    edLeft: TEdit;
    edNormalImg: TEdit;
    lblAlert: TLabel;
    edAlertImg: TEdit;
    btnSelectA: TButton;
    Button1: TButton;
    edOnImg: TEdit;
    lblOnImg: TLabel;
    lblNormal: TLabel;
    btnSelectN: TButton;
    btnSelectO: TButton;
    edOfflineImg: TEdit;
    lblOffline: TLabel;
    cmbAction: TComboBox;
    cmbActionValType: TComboBox;
    lblType: TLabel;
    edValID: TEdit;
    lblIndex: TLabel;
    lblAction: TLabel;
    GroupBox1: TGroupBox;
    edVLeft: TEdit;
    edVSize: TEdit;
    lblNameSize: TLabel;
    lblNameLeft: TLabel;
    edVtop: TEdit;
    lblNameTop: TLabel;
    pcActions: TPageControl;
    tsActionMain: TTabSheet;
    EdMin: TEdit;
    edMax: TEdit;
    lblMax: TLabel;
    lblValMin: TLabel;
    edStep: TEdit;
    edParam2: TEdit;
    lblParam2: TLabel;
    lblStepBy: TLabel;
    tsActionUp: TTabSheet;
    edParam1Up: TEdit;
    edParam2Up: TEdit;
    edParam3Up: TEdit;
    edParam4Up: TEdit;
    lblParam1Up: TLabel;
    lblParam2Ip: TLabel;
    lblParam3Up: TLabel;
    lblParam4Up: TLabel;
    procedure beOnlineImgLeftButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectNClick(Sender: TObject);
    procedure btnSelectOClick(Sender: TObject);
    procedure btnSelectAClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteClick(Sender: TObject);
    procedure edTopChange(Sender: TObject);
    procedure edLeftChange(Sender: TObject);
    procedure edWidthChange(Sender: TObject);
    procedure edHeightChange(Sender: TObject);
    function  UpdateScreenNard:boolean;
    procedure cbShowNameClick(Sender: TObject);
    procedure btnSetVClick(Sender: TObject);
    procedure cmbActionChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    ItemID:integer;
    NardID:integer;
    ScreenID:integer;
    Nard:tNardView;
    NeedSaved:boolean;
  end;

var
  NardLayoutFrm: TNardLayoutFrm;

implementation

{$R *.dfm}

uses dmDatabase,frmScreenVals,frmMsg;



procedure TNardLayoutFrm.beOnlineImgLeftButtonClick(Sender: TObject);
begin
//button click..

end;

procedure TNardLayoutFrm.btnAddClick(Sender: TObject);
var
aFrm:tScreenValsFrm;
begin
//add a screen value..
aFrm:=tScreenValsFrm.Create(application);
aFrm.ItemID:=ItemID;
aFrm.NardId:=NardID;
aFrm.ScreenID:=ScreenID;
aFrm.SVID:=0;
aFrm.ShowModal;
aFrm.Free;

end;

procedure TNardLayoutFrm.btnDeleteClick(Sender: TObject);
begin
//delete a screen value
if dmDb.qryScreenVals.RecordCount>0 then
if MsgYesNo('Delete Screen value ?')  then
  dmDb.qryScreenVals.delete;


end;

procedure TNardLayoutFrm.btnEditClick(Sender: TObject);
var
aFrm:tScreenValsFrm;
begin
//edit a screen value..
if dmDb.qryScreenVals.RecordCount>0 then
  begin
  aFrm:=tScreenValsFrm.Create(application);
  aFrm.ItemID:=ItemID;
  aFrm.NardId:=NardID;
  aFrm.ScreenID:=ScreenID;
  aFrm.SVID:=dmDb.qryScreenValsSVID.Value;
  aFrm.edIndex.Text:=IntToStr(dmDb.qryScreenValsVALINDEX.Value);
  aFrm.cmbType.ItemIndex:=dmDb.qryScreenValsValueType.Value;
  aFrm.edDisplay.Text:=IntToStr(dmDb.qryScreenValsDisplayNum.Value);
  aFrm.cmbTrigType.ItemIndex:=dmDb.qryScreenValsTrigType.Value;
  if (dmDb.qryScreenValsValueType.Value=0) then
  aFrm.edTrigVal.Text:=IntToStr(dmDb.qryScreenValsTrigIVal.Value) else
  aFrm.edTrigVal.Text:=FloatToStr(dmDb.qryScreenValsTrigFVal.Value);
  aFrm.rgCalcType.ItemIndex:=dmDb.qryScreenValsTrigCalc.Value;
  aFrm.edTop.Text:=IntToStr(dmDb.qryScreenValsPosTop.Value);
  aFrm.edLeft.Text:=IntToStr(dmDb.qryScreenValsPosLeft.Value);
  aFrm.edFontSize.Text:=IntToStr(dmDb.qryScreenValsFontSize.Value);
  aFrm.edFontColor.Text:=IntToStr(dmDb.qryScreenValsFontColor.Value);

  aFrm.ShowModal;
  aFrm.Free;
  dmDb.qryScreenVals.Refresh;

  end;
end;

procedure TNardLayoutFrm.btnSelectAClick(Sender: TObject);
begin
//select an image...
dlgSelPic.InitialDir:=ExtractFilePath(Application.ExeName)+'\images\';
if dlgSelPic.Execute then
  begin
   edAlertImg.Text:=ExtractFileName(dlgSelPic.FileName);
   NeedSaved:=true;
  end;

end;

procedure TNardLayoutFrm.btnSelectNClick(Sender: TObject);
begin
//select an image...
dlgSelPic.InitialDir:=ExtractFilePath(Application.ExeName)+'\images\';
if dlgSelPic.Execute then
  begin
   edNormalImg.Text:=ExtractFileName(dlgSelPic.FileName);
   NeedSaved:=true;
  end;



end;

procedure TNardLayoutFrm.btnSelectOClick(Sender: TObject);
begin
//select an image...
dlgSelPic.InitialDir:=ExtractFilePath(Application.ExeName)+'\images\';
if dlgSelPic.Execute then
  begin
   edOfflineImg.Text:=ExtractFileName(dlgSelPic.FileName);
   NeedSaved:=true;
  end;

end;

procedure TNardLayoutFrm.btnSetVClick(Sender: TObject);
begin
//set new vals to nard view..
if dmDb.qryScreenVals.RecordCount>0 then
  begin
  if dmDb.qryScreenValsDISPLAYNUM.Value=1 then
    begin
    Nard.LblVal1.Left:=dmDb.qryScreenValsPOSLEFT.Value;
    Nard.LblVal1.Top:=dmDb.qryScreenValsPOSTOP.Value;
    Nard.LblVal1.Font.Size:=dmDb.qryScreenValsFONTSIZE.Value;
    Nard.LblVal1.Visible:=true;
    end else
  if dmDb.qryScreenValsDISPLAYNUM.Value=2 then
    begin
    Nard.LblVal2.Left:=dmDb.qryScreenValsPOSLEFT.Value;
    Nard.LblVal2.Top:=dmDb.qryScreenValsPOSTOP.Value;
    Nard.LblVal2.Font.Size:=dmDb.qryScreenValsFONTSIZE.Value;
    Nard.LblVal2.Visible:=true;
    end;


  end;

Nard.LblNardName.Left:=StrToInt(edVleft.Text);
Nard.LblNardName.Top:=StrToInt(edVtop.Text);
Nard.LblNardName.Font.Size:=StrToInt(edVSize.Text);
Nard.LblNardName.Caption:=edName.Text;
if cbShowName.Checked then
   Nard.LblNardName.Visible:=true else
     Nard.LblNardName.Visible:=false;

end;

function TNardLayoutFrm.UpdateScreenNard:boolean;
begin
   result:=false;
if ItemID = 0 then
  begin
      exit;
  end;


 dmDb.qryGen.Active:=false;
 dmDb.qryGen.SQL.Clear;
 dmDb.qryGen.SQL.Add('update ScreenItems a set a.ArdID='+edNardID.Text+',');
 dmDb.qryGen.SQL.Add('a.PosLeft='+edLeft.Text+', a.PosTop='+edTop.Text+',');
 dmDb.qryGen.SQL.Add('a.OnlineImg='''+edNormalImg.Text+''',a.OfflineImg='''+edOfflineImg.Text+
                      ''', a.AlertImg= '''+edAlertImg.Text+''' ,a.OnImg= '''+edOnImg.Text+'''');
 dmDb.qryGen.SQL.Add('where a.Screenid= '+IntToStr(ScreenID)+' AND a.ItemId= '+IntToStr(ItemId));
 try
 dmDb.qryGen.ExecSql;

 except on e:exception do
    begin
      ShowMessage('Error saving ScreenItem:'+e.Message);
       exit;
    end;

 end;

NeedSaved:=false;
result:=true;
end;

procedure TNardLayoutFrm.btnUpdateClick(Sender: TObject);
begin
if ItemID = 0 then
  begin
      ShowMsg('Please fist select a nard..');
      exit;
  end;


 dmDb.qryGen.Active:=false;
 dmDb.qryGen.SQL.Clear;
 dmDb.qryGen.SQL.Add('update ScreenItems a set a.ArdID='+edNardID.Text+', a.DISPLAYNAME='''+edName.Text+''',');
 dmDb.qryGen.SQL.Add('a.ShowName='+BoolToStr(cbShowName.Checked,true)+' ,a.PosLeft='+edLeft.Text+', a.PosTop='+edTop.Text+',');
 dmDb.qryGen.SQL.Add('a.Width='+edWidth.Text+' ,a.Height='+edHeight.Text+',a.DNLeft='+edVLeft.Text+' ,a.DNTop='+edVTop.Text+', a.DNSize='+edVSize.Text+',');
 if cmbAction.ItemIndex>5 then
 dmDb.qryGen.SQL.Add('a.ActionID='+IntToStr(cmbAction.ItemIndex)+' ,a.ActionVal='+edValId.Text+',a.ActionValType='+
    edParam2.Text+' ,a.ActionValMin='+edMin.Text+', a.ActionValMax='+edMax.Text+', a.ActionValStep='+edStep.Text+',')
    else
 dmDb.qryGen.SQL.Add('a.ActionID='+IntToStr(cmbAction.ItemIndex)+' ,a.ActionVal='+edValId.Text+',a.ActionValType='+
    IntToStr(cmbActionValType.ItemIndex)+' ,a.ActionValMin='+edMin.Text+', a.ActionValMax='+edMax.Text+', a.ActionValStep='+edStep.Text+',');

 dmDb.qryGen.SQL.Add('a.ParamUp1='+edParam1Up.Text+' ,a.ParamUp2='+edParam2Up.Text+',a.ParamUp3='+edParam3Up.Text+' ,a.ParamUp4='+edParam4Up.Text+',');
 dmDb.qryGen.SQL.Add('a.OnlineImg='''+edNormalImg.Text+''',a.OfflineImg='''+edOfflineImg.Text+
                      ''', a.AlertImg= '''+edAlertImg.Text+''' ,a.OnImg= '''+edOnImg.Text+'''');
 dmDb.qryGen.SQL.Add('where a.Screenid= '+IntToStr(ScreenID)+' AND a.ItemId= '+IntToStr(ItemId));
 try
 dmDb.qryGen.ExecSql;

 except on e:exception do
    begin
      ShowMessage('Error updating db.'+#10+#13+e.Message);
       exit;
    end;

 end;

 ShowMsg('Record updated...');
NeedSaved:=false;

end;

procedure TNardLayoutFrm.cbShowNameClick(Sender: TObject);
begin
//
if not cbShowName.Checked then
  begin
//  if Nard.IsOn then Nard.IsOn:=false;
  if Nard.LblNardName.Visible then Nard.LblNardName.Visible:=false;
  end else
    begin
//    if not Nard.IsOn then Nard.IsOn:=true;
    if not Nard.LblNardName.Visible then Nard.LblNardName.Visible:=true;
    end;

end;

procedure TNardLayoutFrm.cmbActionChange(Sender: TObject);
begin
//changing..
if cmbAction.ItemIndex>5 then
  begin
  lblStepBy.Caption:='Param 1';
  lblValMin.Caption:='Param 3';
  lblMax.Caption:='Param 4';
  lblIndex.Caption:='Param Id';
  edParam2.Visible:=true;
  lblParam2.Visible:=true;
  cmbActionValType.Visible:=false;
  lblType.Visible:=false;
  tsActionUp.TabVisible:=true;
  tsActionMain.Caption:='Down';
  end else
     begin
     lblStepBy.Caption:='Step';
     lblValMin.Caption:='Min';
     lblMax.Caption:='Max';
     lblIndex.Caption:='Val Id';
     edParam2.Visible:=false;
     lblParam2.Visible:=false;
     cmbActionValType.Visible:=true;
     lblType.Visible:=true;
     pcActions.TabIndex:=0;
     tsActionUp.TabVisible:=false;
     tsActionMain.Caption:='Val';
     end;

end;

procedure TNardLayoutFrm.edHeightChange(Sender: TObject);
begin
   NeedSaved:=true;

end;

procedure TNardLayoutFrm.edLeftChange(Sender: TObject);
begin
   NeedSaved:=true;

end;

procedure TNardLayoutFrm.edTopChange(Sender: TObject);
begin
NeedSaved:=true;
end;

procedure TNardLayoutFrm.edWidthChange(Sender: TObject);
begin
   NeedSaved:=true;

end;

procedure TNardLayoutFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
try
Nard.Free;
finally
  ;
end;
end;

procedure TNardLayoutFrm.FormCreate(Sender: TObject);
begin
ItemID:=0;
Nard:=tNardView.Create(self,96,96);
Nard.Parent:=self;
Nard.Left:=432;
Nard.Top:=172;
Nard.Color:=clNavy;
NeedSaved:=false;
end;

end.
