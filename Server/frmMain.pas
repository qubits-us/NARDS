unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,System.IniFiles, Vcl.Graphics,System.Contnrs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, uNARDserver,
  uPacketDefs, IdStack, Vcl.StdCtrls,Vcl.Themes,
  NardView, Vcl.Imaging.pngimage,ZDbcIntfs, Vcl.ExtCtrls,dmDatabase, Vcl.ToolWin,frmNardLayout;

type
  TMainFrm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    File2: TMenuItem;
    sbMain: TStatusBar;
    Server1: TMenuItem;
    Server2: TMenuItem;
    Stop1: TMenuItem;
    Stop2: TMenuItem;
    mLog: TMemo;
    Nards1: TMenuItem;
    Logs1: TMenuItem;
    menLogsReport: TMenuItem;
    tmrRefreshNards: TTimer;
    pmNard: TPopupMenu;
    AddNard1: TMenuItem;
    pnlTop: TPanel;
    btnMode: TButton;
    btnPrevScreen: TButton;
    edCurrentScreen: TEdit;
    btnNextScreen: TButton;
    btnNew: TButton;
    btnDelete: TButton;
    btnEdit: TButton;
    Help1: TMenuItem;
    Help2: TMenuItem;
    heme1: TMenuItem;
    heme2: TMenuItem;
    Dark1: TMenuItem;
    View1: TMenuItem;
    View2: TMenuItem;
    ScreenPanel1: TMenuItem;
    List1: TMenuItem;
    Hashes1: TMenuItem;
    menLogView: TMenuItem;
    menLogManage: TMenuItem;
    procedure File2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Server2Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Stop2Click(Sender: TObject);
    procedure OnServerLog(Sender: TObject);
    procedure OnServerError(Sender: TObject);
    procedure OnNewNard(Sender: TObject);
    procedure OnNardDisconnect(Sender:TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GetNardCntx;
    procedure NardClick(Sender:tObject);
    procedure ShowNardInfo(aNard:integer);
    procedure NardExecute(aNard:integer;aCmd:integer);
    procedure NardToggle(aNardId:integer;aItemId:integer);
    procedure NardSet(aNardId:integer;aItemId:integer);
    procedure NardShowImage(aNardId:integer);
    procedure UpdateNards;
    procedure tmrRefreshNardsTimer(Sender: TObject);
    procedure menLogsReportClick(Sender: TObject);
    procedure RecreateNards;
    procedure btnModeClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure AddNard;
    procedure LayoutNard(aNard:tNardView);
    procedure pnlMainEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure heme2Click(Sender: TObject);
    procedure Dark1Click(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure Help2Click(Sender: TObject);
    procedure List1Click(Sender: TObject);
    procedure List2Click(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnNextScreenClick(Sender: TObject);
    procedure btnPrevScreenClick(Sender: TObject);
    procedure OnVarChanged(Sender: TObject);
    procedure View2Click(Sender: TObject);
    procedure ScreenPanel1Click(Sender: TObject);
    procedure Hashes1Click(Sender: TObject);
    procedure menLogManageClick(Sender: TObject);
    procedure menLogViewClick(Sender: TObject);
    procedure NardSetParam(aNard: TNardView);
    procedure NardDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NardUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  private
    { Private declarations }
  public
    { Public declarations }
    Nards:TComponentList;
  end;

var
  MainFrm: TMainFrm;
  LayoutFrm:TNardLayoutFrm;
  ServerIP: String;
  BroadCastIp:String;
  ServerPort: String;

 // Nards: array[0..15] of TNardView;
 // aNard:TNardView;

  NardsOnline: integer;
  LayOutMode:Boolean;
  CurrentScreen: integer;

implementation

{$R *.dfm}

uses frmNardList,frmNardView,frmReportLogs,frmGetStr,frmAbout,frmServerConfig,frmSourceView,frmMsg,
     frmHashList, frmManageLogs,frmLogView,frmNardValAdj,frmNardImages;


function IpToBroadcast(ipStr:String):String;
var
aCount:integer;
aPos:integer;
begin
result:='';
//ipStr should be like ###.###.###.###
//first block
aPos:=Pos('.',ipStr);
if aPos>0 then
result:=Copy(ipStr,1,aPos);
Delete(ipStr,1,aPos);
//second block
aPos:=Pos('.',ipStr);
if aPos>0 then
result:=result+Copy(ipStr,1,aPos);
Delete(ipStr,1,aPos);
//third block
aPos:=Pos('.',ipStr);
if aPos>0 then
result:=result+Copy(ipStr,1,aPos);
Delete(ipStr,1,aPos);

result:=result+'255';
end;



procedure TMainFrm.RecreateNards;
var
  i, aLeft, numNards, aGap: integer;
  aHeight,aWidth:integer;
  aView:tNardView;
  aFileName:String;
  params:TParamSet;
begin

   aGap:=0;
    Nards.Destroy;
    dmDb.ArdsQry.Active:=false;
    dmDb.ArdsQry.SQL.Clear;
    dmDB.ArdsQry.SQL.Add('select * from ards');
    dmDB.ArdsQry.Active:=true;
    numNards := dmDb.ArdsQry.RecordCount;
    Nards := tComponentList.Create(true);



    aLeft := 2;

    dmDb.qryScreenItems.Active:=false;
    dmDb.qryScreenItems.SQL.Clear;
    dmDb.qryScreenItems.SQL.Add('select * from ScreenItems where ScreenId='+IntToStr(CurrentScreen));
    dmDb.qryScreenItems.Active:=true;
  if dmDb.qryScreenItems.RecordCount> 0 then
   begin

    //how many nard are we laying out..
    numNards:=dmDb.qryScreenItems.RecordCount;
    aLeft := 2;


    if numNards > 0 then
    begin
    aGap:=0;

      for i := 0 to numNards-1 do
      begin
        //added h and w setting 4.1.2023 ~q
         aHeight:=dmDb.qryScreenItemsHEIGHT.Value;
         aWidth:=dmDb.qryScreenItemsWIDTH.Value;
         //set defaults if 0s
         if aHeight = 0 then aHeight := 96;
         if aWidth = 0 then aWidth := 96;



        aView:= TNardView.Create(self,aWidth,aHeight);
        aView.Parent := self;
        aView.ParentColor := false;
        aView.Color := clNavy;
        aView.Top:=dmDb.qryScreenItemsPOSTOP.Value;
        aView.Left := dmDb.qryScreenItemsPOSLEFT.Value;
        aView.NardNumber := dmDb.qryScreenItemsARDID.Value;
        aView.ItemID := dmDb.qryScreenItemsITEMID.Value;
        aView.IsOn :=false;
        aFileName:=dmDb.qryScreenItemsOFFLINEIMG.Value;
       if FileExists(ExtractFilePath(Application.ExeName)+'\images\'+aFileName) then
        begin
        // start offline..
         try
           aView.NardImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'\images\'+aFileName);
         finally
           ;
         end;
        end else
           mLog.Lines.Insert(0,'Bad file name!');

         if dmDb.qryScreenItemsACTIONID.Value=7 then
          begin
          aView.OnDown:=NardDown;
          aView.OnUp:=NardUp;
          aView.ParamIndex:=dmDb.qryScreenItemsACTIONVAL.Value;
          params[0]:=dmDb.qryScreenItemsPARAMUP1.Value;
          params[1]:=dmDb.qryScreenItemsPARAMUP2.Value;
          params[2]:=dmDb.qryScreenItemsPARAMUP3.Value;
          params[3]:=dmDb.qryScreenItemsPARAMUP4.Value;
          aView.UpParams:=params;
          params[0]:=dmDb.qryScreenItemsACTIONVALTYPE.Value;
          params[2]:=dmDb.qryScreenItemsACTIONVALMIN.Value;
          params[3]:=dmDb.qryScreenItemsACTIONVALMAX.Value;
          params[1]:=dmDb.qryScreenItemsACTIONVALSTEP.Value;
          aView.DownParams:=params;
          aView.NoClick:=true;
          end;
         if dmDb.qryScreenItemsACTIONID.Value=6 then
          begin
          aView.ParamIndex:=dmDb.qryScreenItemsACTIONVAL.Value;
          params[0]:=dmDb.qryScreenItemsACTIONVALTYPE.Value;
          params[2]:=dmDb.qryScreenItemsACTIONVALMIN.Value;
          params[3]:=dmDb.qryScreenItemsACTIONVALMAX.Value;
          params[1]:=dmDb.qryScreenItemsACTIONVALSTEP.Value;
          aView.DownParams:=params;
          end;

         aView.OnClicked:=NardClick;
         aView.OnEndDock:=pnlMainEndDock;
         aView.OnLine := true;
        Nards.Add(aView);
       try
        dmDb.qryScreenItems.Next;
       finally
         ;
       end;

      end;

    end;
   end;





    //close qry
    dmDb.ArdsQry.Active:=false;


end;


//update display
procedure TMainFrm.UpdateNards;
var
  I: Integer;
  alert,modeOn,trig:boolean;
  aFileName:String;
begin
    dmDb.qryScreenItems.Active:=false;
    dmDb.qryScreenItems.SQL.Clear;
    dmDb.qryScreenItems.SQL.Add('select * from ScreenItems where ScreenId='+IntToStr(CurrentScreen));
    dmDb.qryScreenItems.Active:=true;
    I:=0;
  if dmDb.qryScreenItems.RecordCount> 0 then
   begin
   if dmDb.qryScreenItems.RecordCount = Nards.Count then
     begin
     //how many nard are we laying out..
      while not dmDb.qryScreenItems.EOF do
       begin
        //numNards:=dmDb.qryScreenItems.RecordCount;
        dmDb.ArdsQry.Active:=false;
        dmDb.ArdsQry.SQL.Clear;
        dmDB.ArdsQry.SQL.Add('select * from ards');
        dmDB.ArdsQry.SQL.Add('where ArdId='+IntToStr(dmDb.qryScreenItemsARDID.Value));
        dmDB.ArdsQry.Active:=true;
        tNardView(Nards.Items[I]).OnLine := dmDb.ArdsQryONLINE.Value;
        tNardView(Nards.Items[I]).NardNumber:=dmDb.qryScreenItemsARDID.Value;
        tNardView(Nards.Items[I]).NardName:=dmDb.qryScreenItemsDISPLAYNAME.Value;
        tNardView(Nards.Items[I]).LblNardName.Top:=dmDb.qryScreenItemsDNTOP.Value;
        tNardView(Nards.Items[I]).LblNardName.Left:=dmDb.qryScreenItemsDNLEFT.Value;
        tNardView(Nards.Items[I]).LblNardName.Font.Size:=dmDb.qryScreenItemsDNSIZE.Value;
        if dmDb.qryScreenItemsSHOWNAME.Value then
         tNardView(Nards.Items[I]).LblNardName.Visible:=true else
           tNardView(Nards.Items[I]).LblNardName.Visible:=false;
        try
         if dmDb.ArdsQryONLINE.Value then
          begin
          aFileName:=ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsOnlineImg.Value;
          if FileExists(aFileName) then
           begin
           try
            tNardView(Nards.Items[I]).NardImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsOnlineImg.Value);
           finally
             ;
           end;
           end;
          end else
            begin
            aFileName:=ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsOfflineImg.Value;
             if FileExists(aFileName) then
              begin
              try
               tNardView(Nards.Items[I]).NardImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsOfflineImg.Value);
              finally
                ;
              end;
              end;
            end;
        finally
          ;
        end;

        if dmDb.ArdsQryONLINE.Value then
        begin
        alert:=false;
        modeOn:=False;
        trig:=false;
        dmDb.qryScrnV.Active:=false;
        dmDb.qryScrnV.Params[0].AsInteger:=CurrentScreen;
        dmDb.qryScrnV.Params[1].AsInteger:=dmDb.qryScreenItemsITEMID.Value;
        dmDb.qryScrnV.Active:=true;
        if dmDb.qryScrnV.RecordCount>0 then
         begin
         while not dmDb.qryScrnV.Eof do
          begin
            //do we have a trig
            if dmDb.qryScrnVTRIGTYPE.Value> 0 then
             begin
               //check for a trigger..
              case dmDb.qryScrnVTRIGCALC.Value of
                0: begin //>
                   if dmDb.qryScrnVVALUETYPE.Value = 0 then
                    trig := dmDb.qryScrnVTRIGIVAL.Value > dmDb.qryScrnVVALI.Value else
                    trig := dmDb.qryScrnVTRIGFVAL.Value > dmDb.qryScrnVVALF.Value;
                   end;
                1: begin //=
                    if dmDb.qryScrnVVALUETYPE.Value = 0 then
                     trig := dmDb.qryScrnVTRIGIVAL.Value = dmDb.qryScrnVVALI.Value else
                     trig := dmDb.qryScrnVTRIGFVAL.Value = dmDb.qryScrnVVALF.Value;

                   end;
                2:begin  //<
                   if dmDb.qryScrnVVALUETYPE.Value = 0 then
                    trig := dmDb.qryScrnVTRIGIVAL.Value < dmDb.qryScrnVVALI.Value else
                    trig := dmDb.qryScrnVTRIGFVAL.Value < dmDb.qryScrnVVALF.Value;

                  end;
              end;

             if trig then
                begin
                trig:=false;
                 if dmDb.qryScrnVTRIGTYPE.Value = 1 then
                   modeOn:= true else
                 if dmDb.qryScrnVTRIGTYPE.Value = 2 then
                   alert:=true;
                end;



             end;

             //display things..
             if dmDb.qryScrnVDISPLAYNUM.Value = 1 then
               begin
                 //display value 1
                 tNardView(Nards.Items[I]).LblVal1.Top:=dmDb.qryScrnVPOSTOP.Value;
                 tNardView(Nards.Items[I]).LblVal1.Left:=dmDb.qryScrnVPOSLEFT.Value;
                 tNardView(Nards.Items[I]).LblVal1.Font.Size:=dmDb.qryScrnVFONTSIZE.Value;
                 tNardView(Nards.Items[I]).LblVal1.Visible:=true;
                 if dmDb.qryScrnVVALUETYPE.Value = 0 then
                  tNardView(Nards.Items[I]).LblVal1.Caption:=IntToStr(dmDb.qryScrnVVALI.Value) else
                 if dmDb.qryScrnVVALUETYPE.Value = 1 then
                  tNardView(Nards.Items[I]).LblVal1.Caption:=FormatFloat('#,##0.0;(#,##0.0)',dmDb.qryScrnVVALF.Value);
               end;

             if dmDb.qryScrnVDISPLAYNUM.Value = 2 then
               begin
                 //display value 1
                 tNardView(Nards.Items[I]).LblVal2.Top:=dmDb.qryScrnVPOSTOP.Value;
                 tNardView(Nards.Items[I]).LblVal2.Left:=dmDb.qryScrnVPOSLEFT.Value;
                 tNardView(Nards.Items[I]).LblVal2.Font.Size:=dmDb.qryScrnVFONTSIZE.Value;
                 tNardView(Nards.Items[I]).LblVal2.Visible:=true;
                 if dmDb.qryScrnVVALUETYPE.Value = 0 then
                  tNardView(Nards.Items[I]).LblVal2.Caption:=IntToStr(dmDb.qryScrnVVALI.Value) else
                 if dmDb.qryScrnVVALUETYPE.Value = 1 then
                  tNardView(Nards.Items[I]).LblVal2.Caption:=FormatFloat('#,##0.0;(#,##0.0)',dmDb.qryScrnVVALF.Value);
               end;


            dmDb.qryScrnV.Next;

          end;
          //check for raised alerts ot modeOns..
          if alert then
            begin
            aFileName:=ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsAlertImg.Value;
             if FileExists(aFileName) then
              begin
              try
              tNardView(Nards.Items[I]).NardImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsAlertImg.Value);
              finally
                ;
              end;
              end;
             end else
             if modeOn then
               begin
                aFileName:=ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsOnImg.Value;
                if FileExists(aFileName) then
                begin
                 tNardView(Nards.Items[I]).NardImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsOnImg.Value);
                end;
               end;
         end;
        end; //if online..

          try
            dmDb.qryScreenItems.Next;
          finally
          ;
          end;


        Inc(i);

       end;

     end else
        begin
          //count does not match
          //recreate all nards..
          RecreateNards;
          //refresh once out of here..
          tmrRefreshNards.Enabled:=true;
        end;

   end else RecreateNards;//just get rid of em..


  dmDb.ArdsQry.Active:=false;
  dmDb.qryScrnV.Active:=false;
  dmDb.qryScreenItems.Active:=false;


end;




procedure TMainFrm.View2Click(Sender: TObject);
begin
//view messages clicked..
//hide or show server messages..
if View2.Checked then
  begin
  View2.Checked:=false;
  mLog.Visible:=false;
  end else
    begin
    View2.Checked:=true;
    mLog.Visible:=true;
    end;
end;

procedure TMainFrm.menLogManageClick(Sender: TObject);
var
aFrm:tManageLogsFrm;
begin
//manage logs
aFrm:=tManageLogsFrm.Create(Application);
aFrm.ShowModal;
aFrm.Free;
end;

procedure TMainFrm.menLogViewClick(Sender: TObject);
var
aFrm:tLogViewFrm;
begin
 //
 aFrm:=tLogViewFrm.Create(Application);
 aFrm.ShowModal;
 aFrm.Free;
end;

procedure TMainFrm.LayoutNard(aNard:tNardView);
var
aFileName:string;
begin

 if  LayOutFrm.ItemID<>aNard.ItemID then
  begin
    //check for pending save needed..
    if LayoutFrm.NeedSaved then
       begin
         if MsgYesNo('Save changes to screen item?') then
         LayoutFrm.UpdateScreenNard;
       end;

  //lay it out..
       dmDb.qryScreenItems.Active:=false;
       dmDb.qryScreenItems.SQL.Clear;
       dmDb.qryScreenItems.SQL.Add('Select * from ScreenItems');
       dmDb.qryScreenItems.SQL.Add('Where ItemId='+IntToStr(aNard.ItemID));
       dmDb.qryScreenItems.Active:=true;
       dmDb.qryScreenVals.Active:=false;
       dmDb.qryScreenVals.SQL.Clear;
       dmDb.qryScreenVals.SQL.Add('Select * from ScreenValues');
       dmDb.qryScreenVals.SQL.Add('Where ItemId='+IntToStr(aNard.ItemID));
       dmDb.qryScreenVals.Active:=true;


  LayOutFrm.ItemID:=aNard.ItemID;
  LayOutFrm.lblItemID.Caption:=IntToStr(aNard.ItemID);
  LayOutFrm.edNardID.Text:=IntToStr(aNard.NardNumber);
  LayOutFrm.edTop.Text:=IntToStr(aNard.Top);
  LayOutFrm.edLeft.Text:=IntToStr(aNard.Left);
  LayoutFrm.NardID:=aNard.NardNumber;
  LayoutFrm.ScreenID:=CurrentScreen;
  if dmDb.qryScreenItems.RecordCount >0 then
    begin
      //main
      LayOutFrm.cbShowName.Checked:=dmDb.qryScreenItemsSHOWNAME.Value;
      LayOutFrm.edName.Text:=dmDb.qryScreenItemsDISPLAYNAME.Value;
      LayOutFrm.Nard.LblNardName.Caption:=dmDb.qryScreenItemsDISPLAYNAME.Value;
      LayOutFrm.edVtop.Text:=IntToStr(dmDb.qryScreenItemsDNTOP.Value);
      LayOutFrm.edVleft.Text:=IntToStr(dmDb.qryScreenItemsDNLEFT.Value);
      //using custom w and h
      LayOutFrm.edWidth.Text:=IntToStr(dmDb.qryScreenItemsWidth.Value);
      LayOutFrm.edHeight.Text:=IntToStr(dmDb.qryScreenItemsHeight.Value);
      LayOutFrm.edVSize.Text:=IntToStr(dmDb.qryScreenItemsDNSIZE.Value);

      //action tab 4.1.2023 ~q
      LayOutFrm.cmbAction.ItemIndex:=dmDb.qryScreenItemsActionID.Value;
      LayOutFrm.edValId.Text:=IntToStr(dmDb.qryScreenItemsActionVal.Value);
       if LayOutFrm.cmbAction.ItemIndex>5 then
      LayOutFrm.edParam2.Text:=IntToStr(dmDb.qryScreenItemsActionValType.Value) else
      LayOutFrm.cmbActionValType.ItemIndex:=dmDb.qryScreenItemsActionValType.Value;
      LayOutFrm.edStep.Text:=IntToStr(dmDb.qryScreenItemsActionValStep.Value);
      LayOutFrm.edMin.Text:=IntToStr(dmDb.qryScreenItemsActionValMin.Value);
      LayOutFrm.edMax.Text:=IntToStr(dmDb.qryScreenItemsActionValMax.Value);
      if LayOutFrm.cmbAction.ItemIndex>5 then
       begin
        LayOutFrm.lblStepBy.Caption:='Param 1';
        LayOutFrm.lblValMin.Caption:='Param 3';
        LayOutFrm.lblMax.Caption:='Param 4';
        LayOutFrm.lblIndex.Caption:='Param Id';
        LayOutFrm.edParam2.Visible:=true;
        LayOutFrm.lblParam2.Visible:=true;
        LayOutFrm.cmbActionValType.Visible:=false;
        LayOutFrm.lblType.Visible:=false;
        LayOutFrm.tsActionUp.TabVisible:=true;
        LayOutFrm.tsActionMain.Caption:='Down';
       end else
         begin
         LayOutFrm.lblStepBy.Caption:='Step';
         LayOutFrm.lblValMin.Caption:='Min';
         LayOutFrm.lblMax.Caption:='Max';
         LayOutFrm.lblIndex.Caption:='Val Id';
         LayOutFrm.edParam2.Visible:=false;
         LayOutFrm.lblParam2.Visible:=false;
         LayOutFrm.cmbActionValType.Visible:=true;
         LayOutFrm.lblType.Visible:=true;
         LayOutFrm.pcActions.TabIndex:=0;
         LayOutFrm.tsActionUp.TabVisible:=false;
         LayOutFrm.tsActionMain.Caption:='Val';
         end;

      LayOutFrm.edParam1Up.Text:=IntToStr(dmDb.qryScreenItemsParamUp1.Value);
      LayOutFrm.edParam2Up.Text:=IntToStr(dmDb.qryScreenItemsParamUp2.Value);
      LayOutFrm.edParam3Up.Text:=IntToStr(dmDb.qryScreenItemsParamUp3.Value);
      LayOutFrm.edParam4Up.Text:=IntToStr(dmDb.qryScreenItemsParamUp4.Value);

      //img tab
      LayOutFrm.edNormalImg.Text:=dmDb.qryScreenItemsONLINEIMG.Value;
      LayOutFrm.edOnImg.Text:=dmDb.qryScreenItemsONIMG.Value;
      LayOutFrm.edOfflineImg.Text:=dmDb.qryScreenItemsOFFLINEIMG.Value;
      LayOutFrm.edAlertImg.Text:=dmDb.qryScreenItemsALERTIMG.Value;
          aFileName:=ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsOnlineImg.Value;
          if FileExists(aFileName) then
           begin
           try
            LayOutFrm.Nard.NardImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'\images\'+dmDb.qryScreenItemsOnlineImg.Value);
           finally
             ;
           end;
           end;

    end;
    LayoutFrm.NeedSaved:=false;
    dmDb.qryScreenItems.Active:=false;
  end else
     begin
     aNard.DragKind:=dkDock;
     aNard.DragMode:=dmManual;
     aNard.UseDockManager:=true;
     aNard.BeginDrag(true);
     end;



end;

procedure TMainFrm.List1Click(Sender: TObject);
var
aFrm:tNardListFrm;
begin
//list nards..
aFrm:=tNardListFrm.Create(Application);
aFrm.ShowModal;
aFrm.Free;
UpdateNards;
end;

procedure TMainFrm.List2Click(Sender: TObject);
var
aFrm:tSourceViewFrm;
begin
//show cource
aFrm:=tSourceViewFrm.Create(application);
aFrm.ShowModal;
aFrm.Free;
end;

procedure TMainFrm.NardClick(Sender: TObject);
var
aFrm:TNardViewFrm;
aNardID:integer;
aItemId:integer;
ActId:integer;
aCmd:integer;
begin
  //clicked on a nard
if Sender is tNardView then
  begin
   if LayOutMode then
    begin
      LayoutNard(tNardView(Sender));
    end else
   begin
    if not tNardView(Sender).NoClick then
    begin
      aNardID:=tNardView(Sender).NardNumber;
      aItemId:=tNardView(Sender).ItemID;
      ActId:=0;
      dmDb.qryScreenItems.Active:=false;
      dmDb.qryScreenItems.SQL.Clear;
      dmDb.qryScreenItems.SQL.Add('Select * from ScreenItems');
      dmDb.qryScreenItems.SQL.Add('Where ItemId='+IntToStr(aItemID));
      dmDb.qryScreenItems.Active:=true;
      if dmDb.qryScreenItems.RecordCount = 1 then
         begin
           aCmd:=dmDb.qryScreenItemsActionVal.Value;
           ActID:=dmDb.qryScreenItemsActionId.Value;
           case ActID of
            1:ShowNardInfo(aNardId);//info
            2:NardExecute(aNardId,aCmd);//exec
            3:NardToggle(aNardId,aItemId);//tog
            4:NardSet(aNardId,aItemID);//adj
            5:NardShowImage(aNardID);//imgs
            6:NardSetParam(tNardView(Sender));//Set Params
           end;

         end;
       dmDb.qryScreenItems.Active:=false;
    end;
   end;
  end;
end;

procedure TMainFrm.NardSetParam(aNard: TNardView);
var
params:TParamSet;
NardId,nid,ParamIndx:Integer;
Online:boolean;
begin
//
if not LayOutMode then
 begin
   params:=aNard.DownParams;
   NardID:=aNard.NardNumber;
   ParamIndx:=aNard.ParamIndex;
   Online:=aNard.Online;
   //set params..
   if Online then
    begin
     dmDB.qryGen.Active:=False;
     dmDB.qryGen.SQL.Clear;
     dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
     dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4, VALUEINT, VALUEFLOAT)');
     nid:=dmDB.seqCommands.GetNextValue;
     dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_PARAMS)+
       ', '+IntToStr(params[0])+', '+IntToStr(params[1])+', '+IntToStr(params[2])+', '+
       IntToStr(params[3])+', '+IntToStr(ParamIndx)+', 0 );');
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
    end;//if online
 end;//not in layoutmode
end;


procedure TMainFrm.NardDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
params:TParamSet;
NardId,nid,ParamIndx:Integer;
Online:boolean;
begin
  //down
if not LayOutMode then
 begin
  if Sender is tNardView then
   begin
  // mLog.Lines.Insert(0,'Down');
   params:=tNardView(Sender).DownParams;
   NardID:=tNardView(Sender).NardNumber;
   ParamIndx:=tNardView(Sender).ParamIndex;
   Online:=tNardView(Sender).Online;
   //set params..
   if Online then
    begin
     dmDB.qryGen.Active:=False;
     dmDB.qryGen.SQL.Clear;
     dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
     dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4, VALUEINT, VALUEFLOAT)');
     nid:=dmDB.seqCommands.GetNextValue;
     dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_PARAMS)+
       ', '+IntToStr(params[0])+', '+IntToStr(params[1])+', '+IntToStr(params[2])+', '+
       IntToStr(params[3])+', '+IntToStr(ParamIndx)+', 0 );');
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
    end;//if online

   end;//if we are a nard view
 end;//not in layoutmode
end;

procedure TMainFrm.NardUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
params:TParamSet;
NardId,nid,ParamIndx:Integer;
Online:Boolean;
begin
  //down
if not LayOutMode then
 begin
  if Sender is tNardView then
   begin
  // mLog.Lines.Insert(0,'Up');
   params:=tNardView(Sender).UpParams;
   NardID:=tNardView(Sender).NardNumber;
   ParamIndx:=tNardView(Sender).ParamIndex;
   Online:=tNardView(Sender).Online;
   //set params..
   if Online then
    begin
      dmDB.qryGen.Active:=False;
      dmDB.qryGen.SQL.Clear;
      dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
      dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4, VALUEINT, VALUEFLOAT)');
      nid:=dmDB.seqCommands.GetNextValue;
      dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(NardID)+', '+IntToStr(CMD_PARAMS)+
        ', '+IntToStr(params[0])+', '+IntToStr(params[1])+', '+IntToStr(params[2])+', '+
        IntToStr(params[3])+', '+IntToStr(ParamIndx)+', 0 );');
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
   end;
 end;
end;


procedure TMainFrm.ShowNardInfo(aNard: Integer);
var
aFrm:TNardViewFrm;
begin
     //prep some qrys
     //values
    dmDb.qryNardValues.Active:=False;
    dmDb.qryNardValues.SQL.Clear;
    dmDb.qryNardValues.SQL.Add('select * from ArdValues a where a.ArdID= '+IntToStr(aNard));
    dmDb.qryNardValues.Active:=true;
     //params
    dmDb.qryNardParams.Active:=False;
    dmDb.qryNardParams.SQL.Clear;
    dmDb.qryNardParams.SQL.Add('select * from ArdParams a where a.ArdID= '+IntToStr(aNard));
    dmDb.qryNardParams.Active:=true;
    //images
    dmDb.qryImg.Active:=false;
    dmDb.qryImg.SQL.Clear;
    dmDb.qryImg.SQL.Add('select * from LogImg');
    dmDb.qryImg.SQL.Add('where ArdId='+IntToStr(aNard));
    dmDb.qryImg.Active:=true;

    aFrm:=TNardViewFrm.Create(application);
    aFrm.NardID:=aNard;
    aFrm.edNardID.Text:=IntToStr(aNard);
    aFrm.ShowModal;
    aFrm.Free;
    //close qrys
    dmDb.qryNardValues.Active:=false;
    dmDb.qryNardParams.Active:=False;
    dmDb.qryImg.Active:=false;

end;


procedure TMainFrm.NardExecute(aNard: Integer; aCmd: Integer);
var
nid:integer;
begin
//execute a function on remote nard..

  dmDB.qryGen.Active:=False;
  dmDB.qryGen.SQL.Clear;
  dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
  dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4)');
   nid:=dmDB.seqCommands.GetNextValue;
   dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNard)+', '+IntToStr(CMD_EXE)+', '+IntToStr(aCmd)+', 0, 0, 0);');
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

procedure TMainFrm.NardToggle(aNardId: Integer; aItemId: Integer);
var
nid,tmpInt:integer;
b1,b2,aType:byte;
aDouble:double;
aBigInt:Int64;
begin


    dmDB.qryNardValues.Active:=False;
    dmDb.qryNardValues.SQL.Clear;
    dmDb.qryNardValues.SQL.Add('select * from ArdValues a where a.ArdID= '+IntToStr(aNardId)+ ' AND a.ValIndex= '+IntToStr(dmDb.qryScreenItemsActionVal.Value));
    dmDb.qryNardValues.Active:=true;
    if dmDb.qryNardValues.RecordCount = 0 then
      begin
      //val does not exist nothing to do..
      dmDB.qryNardValues.Active:=False;
      exit;
      end;

 if dmDb.qryScreenItemsActionValType.Value < SG_FLT4 then
    begin
    aBigInt:=dmDb.qryNardValuesVALUEINT.Value;
    end else
       begin
       aBigInt:=Trunc(dmDb.qryNardValuesVALUEFLOAT.Value);
       end;
   //done with thee..
    dmDB.qryNardValues.Active:=False;
    dmDb.qryNardValues.SQL.Clear;


  //which way are we toggling..
 if dmDb.qryScreenItemsActionValMin.Value = aBigInt then
   aBigInt:= dmDb.qryScreenItemsActionValMax.Value else
      aBigInt:= dmDb.qryScreenItemsActionValMin.Value;




//set a nard val..
  dmDB.qryGen.Active:=False;
  dmDB.qryGen.SQL.Clear;
  dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
  dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4, VALUEINT, VALUEFLOAT)');
  nid:=dmDB.seqCommands.GetNextValue;

    case dmDb.qryScreenItemsActionValType.Value of
      SG_BYTE:begin
               b1:=aBigInt;
               b2:=0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_BYTE)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0, 0 );');
              end;
      SG_WORD:begin
               tmpInt:=aBigInt;
               b2:= tmpInt and $FF;
               b1:= tmpInt shr 8;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_WORD)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0, 0 );');
              end;
      SG_INT16:begin
               tmpInt:=aBigInt;
               b2:= tmpInt and $FF;
               b1:= tmpInt shr 8;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_INT16)+', '+IntToStr(b1)+', '+IntToStr(b2)+',0 ,0 );');
              end;
      SG_INT32:begin
               tmpInt:=aBigInt;
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_INT32)+', '+IntToStr(b1)+', '+IntToStr(b2)+','+IntToStr(tmpInt)+' ,0 );');
              end;
      SG_UINT32:begin
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_UINT32)+', '+IntToStr(b1)+', '+IntToStr(b2)+','+IntToStr(aBigInt)+' ,0 );');
              end;
      SG_FLT4:begin
               aDouble:=aBigInt;
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_FLT4)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0 , '+FloatToStr(aDouble)+' );');
              end;
      SG_FLT8:begin
               aDouble:=aBigInt;
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_FLT8)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0 , '+FloatToStr(aDouble)+' );');
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

procedure TMainFrm.NardSet(aNardId: Integer; aItemId: Integer);
var
nid,tmpInt:integer;
b1,b2,aType:byte;
aDouble:double;
aBigInt,aNewVal:Int64;
aDesc:String;
aFrm:tNardValAdjFrm;
begin


    dmDB.qryNardValues.Active:=False;
    dmDb.qryNardValues.SQL.Clear;
    dmDb.qryNardValues.SQL.Add('select * from ArdValues a where a.ArdID= '+IntToStr(aNardId)+ ' AND a.ValIndex= '+IntToStr(dmDb.qryScreenItemsActionVal.Value));
    dmDb.qryNardValues.Active:=true;
    if dmDb.qryNardValues.RecordCount = 0 then
      begin
      //val does not exist nothing to do..
      dmDB.qryNardValues.Active:=False;
      exit;
      end;

 if dmDb.qryScreenItemsActionValType.Value < SG_FLT4 then
    begin
    aBigInt:=dmDb.qryNardValuesVALUEINT.Value;
    end else
       begin
       aBigInt:=Trunc(dmDb.qryNardValuesVALUEFLOAT.Value);
       end;

   aDesc:=dmDb.qryNardValuesDisplayName.Value;

   //done with thee..
    dmDB.qryNardValues.Active:=False;
    dmDb.qryNardValues.SQL.Clear;

aFrm:=tNardValAdjFrm.Create(Self);
aFrm.ValMin:=dmDb.qryScreenItemsActionValMin.Value;
aFrm.ValMax:=dmDb.qryScreenItemsActionValMax.Value;
aFrm.OrigVal:=aBigInt;
if aDesc<>'' then
aFrm.lblValDesc.Caption:=aDesc else
  aFrm.lblValDesc.Caption:='Value at Index:'+IntToStr(dmDb.qryScreenItemsActionVal.Value);
aFrm.EdVal.Text:=IntToStr(aBigInt);
if aFrm.ShowModal <> mrOK then
  begin
  aFrm.Free;
  Exit;
  end;
   aBigInt:=aFrm.NewVal;
   aFrm.Free;




//set a nard val..
  dmDB.qryGen.Active:=False;
  dmDB.qryGen.SQL.Clear;
  dmDB.qryGen.SQL.Add('INSERT INTO ARDCOMMANDS');
  dmDB.qryGen.SQL.Add('(COMMANDID, ARDID, COMMAND, OP1, OP2, OP3, OP4, VALUEINT, VALUEFLOAT)');
  nid:=dmDB.seqCommands.GetNextValue;

    case dmDb.qryScreenItemsActionValType.Value of
      SG_BYTE:begin
               b1:=aBigInt;
               b2:=0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_BYTE)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0, 0 );');
              end;
      SG_WORD:begin
               tmpInt:=aBigInt;
               b2:= tmpInt and $FF;
               b1:= tmpInt shr 8;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_WORD)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0, 0 );');
              end;
      SG_INT16:begin
               tmpInt:=aBigInt;
               b2:= tmpInt and $FF;
               b1:= tmpInt shr 8;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_INT16)+', '+IntToStr(b1)+', '+IntToStr(b2)+',0 ,0 );');
              end;
      SG_INT32:begin
               tmpInt:=aBigInt;
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_INT32)+', '+IntToStr(b1)+', '+IntToStr(b2)+','+IntToStr(tmpInt)+' ,0 );');
              end;
      SG_UINT32:begin
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_UINT32)+', '+IntToStr(b1)+', '+IntToStr(b2)+','+IntToStr(aBigInt)+' ,0 );');
              end;
      SG_FLT4:begin
               aDouble:=aBigInt;
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_FLT4)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0 , '+FloatToStr(aDouble)+' );');
              end;
      SG_FLT8:begin
               aDouble:=aBigInt;
               b1:= 0;
               b2:= 0;
               dmDB.qryGen.SQL.Add('VALUES('+IntToStr(nid)+', '+IntToStr(aNardID)+', '+IntToStr(CMD_SET)+
               ', '+IntToStr(dmDb.qryScreenItemsActionVal.Value)+', '+IntToStr(SG_FLT8)+', '+IntToStr(b1)+', '+IntToStr(b2)+', 0 , '+FloatToStr(aDouble)+' );');
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


procedure TMainFrm.NardShowImage(aNardId: Integer);
var
aFrm:tNardImagesFrm;
begin

    dmDb.qryImg.SQL.Clear;
    dmDb.qryImg.SQL.Add('select * from LogImg');
    dmDb.qryImg.SQL.Add('where ArdId='+IntToStr(aNardId));
    dmDb.qryImg.Active:=true;

aFrm:=tNardImagesFrm.Create(self);
aFrm.ShowModal;
aFrm.Free;

end;


procedure TMainFrm.btnDeleteClick(Sender: TObject);
begin
//delete a screen
 if MsgYesNo('Delete this screen?') then
   begin
    dmDb.qryGen.Active:=false;
    dmDb.qryGen.SQL.Clear;
    dmDb.qryGen.SQL.Add('delete from Screens');
    dmDb.qryGen.SQL.Add('where a.ScreenId='+IntToStr(CurrentScreen));
    dmDb.qryGen.ExecSql;
    dmDb.qryScreens.Active:=false;
    dmDb.qryScreens.SQL.Clear;
    dmDb.qryScreens.SQL.Add('select * from screens');
    dmDb.qryScreens.Active:=true;
    //are all screens gone..
    if dmDb.qryScreens.RecordCount = 0 then
      begin
        //add default screen..
       dmDb.qryScreens.Active:=false;
       dmDb.qryScreens.SQL.Clear;
       dmDb.qryScreens.SQL.Add('insert into screens values (1, ''default'')');
       dmDb.qryScreens.ExecSQL;
       dmDb.qryScreens.Active:=false;
       dmDb.qryScreens.SQL.Clear;
       dmDb.qryScreens.SQL.Add('select * from screens');
       dmDb.qryScreens.Active:=true;
      end;

    CurrentScreen:= dmDb.qryScreensScreenID.Value;
    edCurrentScreen.Text:=dmDb.qryScreensDISPLAYNAME.Value;

      UpdateNards;
      ShowMsg('Screen deleted..');


   end;


end;

procedure TMainFrm.btnEditClick(Sender: TObject);
var
aFrm:tGetStrFrm;
aStr:String;

begin
//edit screen name

aFrm:=tGetStrFrm.Create(Application);
aFrm.lblCaption.Caption:='Change screen name..';
aFrm.edValue.Text:=edCurrentScreen.Text;
if aFrm.ShowModal= mrOK then
  begin
  aStr:=aFrm.edValue.Text;
  aFrm.Free;
  if aStr<>'' then
    begin
    dmDb.qryGen.Active:=false;
    dmDb.qryGen.SQL.Clear;
    dmDb.qryGen.SQL.Add('update Screens a set a.DisplayName='''+aStr+'''');
    dmDb.qryGen.SQL.Add('where a.ScreenId='+IntToStr(CurrentScreen));
    dmDb.qryGen.ExecSql;
    edCurrentScreen.Text:=aStr;
    end;
  end else aFrm.Free;
end;

procedure TMainFrm.btnModeClick(Sender: TObject);
begin
if not LayOutMode then
  begin
    LayOutMode:=true;
    btnMode.Caption:='L';
     LayoutFrm:=tNardLayoutFrm.Create(self);
     LayoutFrm.Show;
     btnPrevScreen.Visible:=false;
     btnNextScreen.Visible:=false;
     btnEdit.Visible:=false;
  end else
     begin
       LayOutMode:=false;
       btnMode.Caption:='N';
       if Assigned(LayoutFrm) then
         begin
           LayoutFrm.Free;
           LayoutFrm :=nil;
         end;
     btnPrevScreen.Visible:=true;
     btnNextScreen.Visible:=true;
     btnEdit.Visible:=true;

     UpdateNards;
     end;
end;

procedure TMainFrm.AddNard;
var
  i, aLeft, numNards, aGap: integer;
  aView:tNardView;
begin
  //

        aView:= TNardView.Create(self,96,96);
        i:=dmDB.seqItemId.GetNextValue;


        aView.Parent := self;
        aView.ParentColor := false;
        aView.Color := clNavy;
        aView.Top:=50;
        aView.Left := 50;
        aView.StyleElements := [];
        aView.IsOn :=true;
        aView.NardNumber := 1;
        aView.OnLine := false;
        aView.OnClicked:=NardClick;
        aView.ItemID:=i;
        Nards.Add(aView);


       dmDb.qryScreenItems.Active:=false;
       dmDb.qryScreenItems.SQL.Clear;
       dmDb.qryScreenItems.SQL.Add('insert into ScreenItems');
       dmDb.qryScreenItems.SQL.Add('(ScreenID, ItemID, ArdID, PosLeft, PosTop, height, width)');
       dmDb.qryScreenItems.SQL.Add('Values('+IntToStr(CurrentScreen)+','+IntToStr(i)+', 1, 50, 50, 96, 96);');
       dmDb.qryScreenItems.ExecSQL;





end;

procedure TMainFrm.btnNewClick(Sender: TObject);
var
aName:String;
aID:integer;
begin
if LayOutMode then
  begin
  //add a nard to this screen
  AddNard;
  end else
     begin
       //add a new screen
     aName:=GetStr('Enter new screen name..');
     if aName <> 'UserCanceled' then
      begin
       aId:=dmDb.seqScreens.GetCurrentValue;
       dmDb.qryGen.Active:=false;
       dmDb.qryGen.SQL.Clear;
       dmDb.qryGen.SQL.Add('insert into screens values ('+IntToStr(aId)+', '''+aName+''' )');
       try
        dmDb.qryGen.ExecSQL;
       except on e:exception do
         begin
           ShowMessage('Error creating screen: '+e.Message);
           exit;
         end;
       end;
       dmDb.qryScreens.Refresh;
       dmDb.qryScreens.Last;
       CurrentScreen:= dmDb.qryScreensScreenID.Value;
       edCurrentScreen.Text:=dmDb.qryScreensDISPLAYNAME.Value;
      end;
     end;
end;

//next screen please..
procedure TMainFrm.btnNextScreenClick(Sender: TObject);
begin
if not dmDb.qryScreens.Eof then
  begin
    dmDb.qryScreens.Next;
    CurrentScreen:= dmDb.qryScreensScreenID.Value;
    edCurrentScreen.Text:=dmDb.qryScreensDISPLAYNAME.Value;
    UpdateNards;
  end;
end;
//prev screen please..
procedure TMainFrm.btnPrevScreenClick(Sender: TObject);
begin
if not dmDb.qryScreens.Bof then
  begin
    dmDb.qryScreens.Prior;
    CurrentScreen:= dmDb.qryScreensScreenID.Value;
    edCurrentScreen.Text:=dmDb.qryScreensDISPLAYNAME.Value;
    UpdateNards;
  end;
end;

procedure TMainFrm.Dark1Click(Sender: TObject);
begin
//dark theme
if not Dark1.Checked then
  begin
    heme2.Checked:=False;
    Dark1.Checked:=True;
    mLog.Color:=clBlack;
    mLog.Font.Color:=clLime;
    TStyleManager.SetStyle('Windows11 Modern Dark');
  end;
end;

//exit click
procedure TMainFrm.File2Click(Sender: TObject);
begin
  close;
end;

procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  aView:tNardView;
  aIni:tIniFile;
begin

//save selected theme for next start..
aIni := tIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
aIni.WriteString('General','Ver','1');
 if Dark1.Checked then
   aIni.WriteInteger('General','Theme',0) else
   aIni.WriteInteger('General','Theme',1);
aIni.Free;



try
if Assigned(PacketSrv) then
 begin
 //stop server
  PacketSrv.Stop;
 //free it..
  PacketSrv.Free;
 end;
// free all the nards!! :P
  Nards.Destroy;
// close db connection
  dmDb.dbConn.Disconnect;
// free the datamodule
  dmDb.Free;
  if Assigned(LayoutFrm) then
      LayoutFrm.Free;

finally
  ;//bye
end;
end;




procedure TMainFrm.FormCreate(Sender: TObject);
var
  i, aLeft, numNards: integer;
  aHeight, aWidth :integer;
  aView:tNardView;
  aGap:integer;
  aFileName,aStr:String;
  aIni:tIniFile;
  ServerIp,ServerPort,ServerName:string;
  DbUser,DbPass,DbHost,DbPort,DbName:string;
  params:tParamSet;
begin

//will pop up a window on program close noting any leaks..
//see any pop ups?? :P
ReportMemoryLeaksOnShutdown:= true;
 // so sad.. :(
 numNards := 0;
 //the NARD LIST.. :)
 Nards := tComponentList.Create(true);
  // create datamodule
  dmDb := TdmDb.Create(self);

//load config..
aIni := tIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  if aIni.ReadInteger('General','Theme',0) = 1 then
    begin
    heme2.Checked:=True;
    Dark1.Checked:=false;
    mLog.Color:=clSkyBlue;
    mLog.Font.Color:=clBlack;
    TStyleManager.SetStyle('Sky');
    end;


ServerName:=aIni.ReadString('Server','Name','NARDS');
aStr:=aIni.ReadString('Server','IP','');
if aStr<>'' then
ServerIp:=aStr;
ServerPort:=aIni.ReadString('Server','Port','12000');

DbHost:=aIni.ReadString('DB','Host','localhost');
DbPort:=aIni.ReadString('DB','Port','3050');
DbUser:=aIni.ReadString('DB','User','SYSDBA');
DbName:=aIni.ReadString('DB','Name','NARDS');
//descramble the eggs.. :P
aStr:=aIni.ReadString('DB','Pass','');
if aStr = '' then aStr :='qubits' else
  begin
    aStr:=dmDb.ScrambledEggs('D',aStr,'stibuq');
  end;
DbPass:=aStr;

aIni.Free;//done with you..


   //set saved connection properties..
   dmDb.dbConn.HostName:=DbHost;
   dmDb.dbConn.Port:=StrToInt(DbPort);
   dmDb.dbConn.Database:=DbName;
   dmDb.dbConn.User:=DbUser;
   dmDb.dbConn.Password:=DbPass;


  try
    dmDb.dbConn.Connect;
  except
    on e: exception do
    begin
      ShowMessage('error connecting to db!!!'+#10+#13+e.Message);
    end;
  end;

  if dmDb.dbConn.Connected then
  begin
    dmDb.ArdsQry.SQL.Clear;
    dmDb.ArdsQry.SQL.Add('select * from Ards');
    dmDb.ArdsQry.Active := true;
    numNards := dmDb.ArdsQry.RecordCount;

  dmDb.qryScreens.Active:=false;
  dmDb.qryScreens.SQL.Clear;
  dmDb.qryScreens.SQL.Add('select * from screens');
  dmDb.qryScreens.Active:=true;
  if dmDb.qryScreens.RecordCount = 0 then
    begin
      //add default screen..
     dmDb.qryScreens.Active:=false;
     dmDb.qryScreens.SQL.Clear;
     dmDb.qryScreens.SQL.Add('insert into screens values (1, ''default'')');
     dmDb.qryScreens.ExecSQL;
     dmDb.qryScreens.Active:=false;
     dmDb.qryScreens.SQL.Clear;
     dmDb.qryScreens.SQL.Add('select * from screens');
     dmDb.qryScreens.Active:=true;
    end;

    CurrentScreen:= dmDb.qryScreensScreenID.Value;
    edCurrentScreen.Text:=dmDb.qryScreensDISPLAYNAME.Value;

    dmDb.qryScreenItems.Active:=false;
    dmDb.qryScreenItems.SQL.Clear;
    dmDb.qryScreenItems.SQL.Add('select * from ScreenItems where ScreenId='+IntToStr(CurrentScreen));
    dmDb.qryScreenItems.Active:=true;
  if dmDb.qryScreenItems.RecordCount> 0 then
   begin

    //how many nard are we laying out..
    numNards:=dmDb.qryScreenItems.RecordCount;
    aLeft := 2;


    if numNards > 0 then
    begin
    aGap:=0;

      for i := 0 to numNards-1 do
      begin
        //added h and w setting 4.1.2023 ~q
         aHeight:=dmDb.qryScreenItemsHEIGHT.Value;
         aWidth:=dmDb.qryScreenItemsWIDTH.Value;
         //set defaults if 0s
         if aHeight = 0 then aHeight := 96;
         if aWidth = 0 then aWidth := 96;

        aView:= TNardView.Create(self, aWidth, aHeight);
        aView.Parent := self;
        aView.ParentColor := false;
        aView.Color := clNavy;
        aView.Top:=dmDb.qryScreenItemsPOSTOP.Value;
        aView.Left := dmDb.qryScreenItemsPOSLEFT.Value;
        aView.NardNumber := dmDb.qryScreenItemsARDID.Value;
        aView.ItemID := dmDb.qryScreenItemsITEMID.Value;
        aView.IsOn :=false;
        aFileName:=dmDb.qryScreenItemsOFFLINEIMG.Value;
       if FileExists(ExtractFilePath(Application.ExeName)+'\images\'+aFileName) then
        begin
        // start offline..
       try
         aView.NardImage.LoadFromFile(ExtractFilePath(Application.ExeName)+'\images\'+aFileName);
       finally
         ;
       end;
        end else
           ShowMessage('Bad file name!');


         if dmDb.qryScreenItemsACTIONID.Value=7 then
          begin
          aView.OnDown:=NardDown;
          aView.OnUp:=NardUp;
          aView.ParamIndex:=dmDb.qryScreenItemsACTIONVAL.Value;
          params[0]:=dmDb.qryScreenItemsPARAMUP1.Value;
          params[1]:=dmDb.qryScreenItemsPARAMUP2.Value;
          params[2]:=dmDb.qryScreenItemsPARAMUP3.Value;
          params[3]:=dmDb.qryScreenItemsPARAMUP4.Value;
          aView.UpParams:=params;
          params[0]:=dmDb.qryScreenItemsACTIONVALTYPE.Value;
          params[2]:=dmDb.qryScreenItemsACTIONVALMIN.Value;
          params[3]:=dmDb.qryScreenItemsACTIONVALMAX.Value;
          params[1]:=dmDb.qryScreenItemsACTIONVALSTEP.Value;
          aView.DownParams:=params;
          aView.NoClick:=true;
          end;
         if dmDb.qryScreenItemsACTIONID.Value=6 then
          begin
          aView.ParamIndex:=dmDb.qryScreenItemsACTIONVAL.Value;
          params[0]:=dmDb.qryScreenItemsACTIONVALTYPE.Value;
          params[2]:=dmDb.qryScreenItemsACTIONVALMIN.Value;
          params[3]:=dmDb.qryScreenItemsACTIONVALMAX.Value;
          params[1]:=dmDb.qryScreenItemsACTIONVALSTEP.Value;
          aView.DownParams:=params;
          end;

         aView.OnClicked:=NardClick;
         aView.OnEndDock:=pnlMainEndDock;
         aView.OnLine := false;
        Nards.Add(aView);
       try
        dmDb.qryScreenItems.Next;
       finally
         ;
       end;

      end;

    end;
   end;

    //close qry
    dmDb.ArdsQry.Active:=false;
  end;



  //create our server object..
  PacketSrv := tNardServer.Create;
  PacketSrv.Port := StrToInt(ServerPort);
  PacketSrv.ServerName := ServerName;
  PacketSrv.OnLog := OnServerLog;
  PacketSrv.OnError := OnServerError;
  PacketSrv.OnConn := OnNewNard;
  PacketSrv.OnDisconn := OnNardDisconnect;
  PacketSrv.OnSetVar := OnVarChanged;
  PacketSrv.DbName:=DbName;
  PacketSrv.DbUser:=DbUser;
  PacketSrv.DbPass:=DbPass;
  PacketSrv.DbHost:=DbHost;
  PacketSrv.DbPort:=StrToInt(DbPort);
  //todo: allow for overriding ip??
  PacketSrv.IP := GStack.LocalAddress;
  ServerIP := PacketSrv.IP;
  sbMain.Panels[1].Text := 'Nards: 0';
  BroadCastIp:=IpToBroadCast(ServerIp);

  //broadcast nard updates to other terminals
  dmDb.sckUDP.BufSize:=100;
  dmDb.sckUDP.LocalAddr:=ServerIP;
  dmDb.sckUDP.Addr:=BroadCastIp;
  dmDb.sckUDP.Connect;

end;

procedure TMainFrm.GetNardCntx;
begin
  //
end;

procedure TMainFrm.Hashes1Click(Sender: TObject);
var
aFrm:tHashListFrm;
begin
//our hash list..

dmDb.qryHashes.Active := true;
aFrm:=THashListFrm.Create(application);
aFrm.ShowModal;
aFrm.Free;

dmDb.qryHashes.Active := false;

end;

procedure TMainFrm.Help2Click(Sender: TObject);
var
aFrm:tAboutFrm;
begin
//help about..
aFrm:=tAboutFrm.Create(Application);
aFrm.ShowModal;
aFrm.Free;
end;

procedure TMainFrm.heme2Click(Sender: TObject);
begin
//light theme
if Dark1.Checked then
  begin
    heme2.Checked:=True;
    Dark1.Checked:=false;
    mLog.Color:=clSkyBlue;
    mLog.Font.Color:=clBlack;
    TStyleManager.SetStyle('Sky');
  end;
end;

procedure TMainFrm.menLogsReportClick(Sender: TObject);
var
aFrm:TReportLogsFrm;
begin
//log reports
aFrm:=tReportLogsFrm.Create(application);
aFrm.ShowModal;
aFrm.Free;
end;

procedure TMainFrm.ScreenPanel1Click(Sender: TObject);
begin
//view screen panel..
//hide or show the screen selection panel..
if ScreenPanel1.Checked then
  begin
   pnlTop.Visible:=false;
   ScreenPanel1.Checked:=false;
  end else
     begin
     ScreenPanel1.Checked:=true;
     pnlTop.Visible:=true;
     end;
end;

procedure TMainFrm.Server2Click(Sender: TObject);
begin
  // start server
  if (not PacketSrv.OnLine) then
    PacketSrv.Start;
  sbMain.Panels[2].Text := 'Server Online..';
  mLog.Lines.Insert(0, 'Server started..');
end;

procedure TMainFrm.Stop1Click(Sender: TObject);
begin
  // stop server
  if (PacketSrv.OnLine) then
    PacketSrv.Stop;
  sbMain.Panels[2].Text := 'Server Offline..';
  sbMain.Panels[1].Text := 'Nards: 0';
  mLog.Lines.Insert(0, 'Server stopped..');
end;

procedure TMainFrm.Stop2Click(Sender: TObject);
var
aFrm:tServerConfigFrm;
begin
  aFrm:=tServerConfigFrm.Create(Application);
  aFrm.ShowModal;
  aFrm.Free;
end;

procedure TMainFrm.tmrRefreshNardsTimer(Sender: TObject);
begin
tmrRefreshNards.Enabled:=false;
UpdateNards;
end;

procedure TMainFrm.OnVarChanged(Sender: TObject);
begin
  tmrRefreshNards.Enabled:=true;
  dmDb.BroadCast;
end;

procedure TMainFrm.OnServerLog(Sender: TObject);
var
  logStr: String;
begin
  // server logged something
  logStr := PacketSrv.PopLog;
  if logStr <> '' then
    mLog.Lines.Insert(0,logStr);
if mLog.Lines.Count = 999 then mLog.Lines.Clear;
end;

procedure TMainFrm.pnlMainEndDock(Sender, Target: TObject; X, Y: Integer);
begin
//ending the dock..
if LayOutMode then
 begin
  if Sender is TNardView then
   begin
    LayOutFrm.edTop.Text:=IntToStr(TNardView(Sender).Top);
    LayOutFrm.edLeft.Text:=IntToStr(TNardView(Sender).Left);
   end;
  end;
end;

procedure TMainFrm.OnServerError(Sender: TObject);
var
  logStr: String;
begin
  // server logged something
  logStr := PacketSrv.PopErrorLog;
  if logStr <> '' then
    mLog.Lines.Insert(0,'Error: ' + logStr);
if mLog.Lines.Count = 999 then mLog.Lines.Clear;

end;

procedure TMainFrm.OnNewNard(Sender: TObject);
begin
  //
  mLog.Lines.Insert(0,'Nard connect..');
  sbMain.Panels[1].Text := 'Nards: ' + IntToStr(PacketSrv.Connections);
  tmrRefreshNards.Enabled:=true;
  dmDb.BroadCast;
end;

procedure TMainFrm.OnNardDisconnect(Sender:TObject);
begin
  mLog.Lines.Insert(0,'Nard disconnect..');
  sbMain.Panels[1].Text := 'Nards: ' + IntToStr(PacketSrv.Connections);
  tmrRefreshNards.Enabled:=true;
  dmDb.BroadCast;
end;


end.
