unit frmScreenVals;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TScreenValsFrm = class(TForm)
    btnCancel: TButton;
    btnSave: TButton;
    rgCalcType: TRadioGroup;
    edIndex: TEdit;
    cmbType: TComboBox;
    edDisplay: TEdit;
    edTrigVal: TEdit;
    cmbTrigType: TComboBox;
    edTop: TEdit;
    edLeft: TEdit;
    edFontSize: TEdit;
    edFontColor: TEdit;
    lblIndex: TLabel;
    lblType: TLabel;
    lblDisplay: TLabel;
    lblTrigVal: TLabel;
    lblTrigType: TLabel;
    lblTop: TLabel;
    lblLeft: TLabel;
    lblFontColor: TLabel;
    lblFontSize: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ScreenID:integer;
    ItemID:integer;
    NardId:integer;
    SVID:integer;
  end;

var
  ScreenValsFrm: TScreenValsFrm;

implementation

{$R *.dfm}

uses dmDatabase;

procedure TScreenValsFrm.btnCancelClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

procedure TScreenValsFrm.btnSaveClick(Sender: TObject);
begin

if SVID=0 then
  begin
   //inserting
   SVID:=dmDb.seqScreenVals.GetNextValue;
   dmDb.qryGen.Active:=false;
   dmDb.qryGen.SQL.Clear;
   dmDb.qryGen.SQL.Add('insert into ScreenValues');
  if cmbType.ItemIndex=0 then
  //int trigger
   dmDb.qryGen.SQL.Add('Values('+IntToStr(ScreenID)+', '+IntToStr(ItemID)+
   ', '+IntToStr(NardId)+','+edIndex.Text+','+IntToStr(cmbType.ItemIndex)+
   ','+edDisplay.Text+','+edTrigVal.Text+', 0,'+IntToStr(rgCalcType.ItemIndex)+
   ','+IntToStr(cmbTrigType.ItemIndex)+','+edLeft.Text+','+edTop.Text+
   ','+edFontSize.Text+','+edFontColor.Text+','+IntToStr(SVID)+')') else
   //float trigger
   dmDb.qryGen.SQL.Add('Values('+IntToStr(ScreenID)+', '+IntToStr(ItemID)+
   ', '+IntToStr(NardId)+','+edIndex.Text+','+IntToStr(cmbType.ItemIndex)+
   ','+edDisplay.Text+', 0, '+edTrigVal.Text+','+IntToStr(rgCalcType.ItemIndex)+
   ','+IntToStr(cmbTrigType.ItemIndex)+','+edLeft.Text+','+edTop.Text+
   ','+edFontSize.Text+','+edFontColor.Text+','+IntToStr(SVID)+')');


   try
   dmDb.qryGen.ExecSql;
   except on e:exception do
     begin
       ShowMessage('Error saving screen value:'+#10+#13+e.Message);
       exit;
     end;

   end;




  end else
     begin
     //updating
     dmDb.qryGen.Active:=false;
     dmDb.qryGen.SQL.Clear;
     dmDb.qryGen.SQL.Add('update ScreenValues s SET');
     dmDb.qryGen.SQL.Add('s.ArdID='+IntToStr(NardID)+' ,s.ValIndex='+edIndex.Text+' , s.ValueType='+IntToStr(cmbType.ItemIndex)+', ');
     dmDb.qryGen.SQL.Add('s.DisplayNum='+edDisplay.Text+', ');
     if cmbType.ItemIndex=0 then
      //int trigger
     dmDb.qryGen.SQL.Add('s.TrigIval='+edTrigVal.Text+', ') else
     //float trigger
     dmDb.qryGen.SQL.Add('s.TrigFval='+edTrigVal.Text+', ');
     dmDb.qryGen.SQL.Add('s.TrigCalc='+intToStr(rgCalcType.ItemIndex)+' , s.TrigType='+IntToStr(cmbTrigType.ItemIndex)+', ');
     dmDb.qryGen.SQL.Add('s.PosLeft='+edLeft.Text+' , s.PosTop='+edTop.Text+', s.FontSize='+edFontSize.Text+', s.FontColor='+edFontColor.Text);
     dmDb.qryGen.SQL.Add('Where s.SVID='+IntToStr(SVID));



       try
        dmDb.qryGen.ExecSql;
         except on e:exception do
         begin
         ShowMessage('Error saving screen value:'+#10+#13+e.Message);
         exit;
         end;

       end;

     end;



ModalResult:=mrOK;
end;

end.
