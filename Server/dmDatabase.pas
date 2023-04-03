unit dmDatabase;

interface

uses
  System.SysUtils, System.Classes,Vcl.Dialogs, ZAbstractTable, ZDataset, Data.DB, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractConnection, ZConnection, ZSequence, ZTransaction, ZMemTable, frxClass, frxDBSet,
  Vcl.Imaging.jpeg,VCL.Forms;

type
  TdmDB = class(TDataModule)
    dbConn: TZConnection;
    ArdsQry: TZQuery;
    tblNardDetails: TZTable;
    seqArds: TZSequence;
    seqLogs: TZSequence;
    LogsQry: TZQuery;
    dbTrans: TZTransaction;
    rptLogs: TfrxReport;
    dsLogs: TfrxDBDataset;
    qryLogRpt: TZQuery;
    mtReportTitle: TZMemTable;
    dsLogTitle: TfrxDBDataset;
    mtReportTitleLocation: TStringField;
    mtReportTitleReportRange: TStringField;
    frxUserDataSet1: TfrxUserDataSet;
    qryGen: TZQuery;
    seqCommands: TZSequence;
    qryCommands: TZQuery;
    qryCommandsCOMMANDID: TZIntegerField;
    qryCommandsARDID: TZIntegerField;
    qryCommandsCOMMAND: TZSmallIntField;
    qryCommandsOP1: TZSmallIntField;
    qryCommandsOP2: TZSmallIntField;
    qryCommandsOP3: TZSmallIntField;
    qryCommandsOP4: TZSmallIntField;
    qryNardValues: TZQuery;
    qryNardValuesARDID: TZIntegerField;
    qryNardValuesVALINDEX: TZIntegerField;
    qryNardValuesDISPLAYNAME: TZUnicodeStringField;
    qryNardValuesVALUEINT: TZInt64Field;
    qryNardValuesVALUEFLOAT: TZDoubleField;
    ArdsQryARDID: TZIntegerField;
    ArdsQryGROUPID: TZIntegerField;
    ArdsQryPROCESSID: TZIntegerField;
    ArdsQryDISPLAYNAME: TZUnicodeStringField;
    ArdsQryLASTIP: TZUnicodeStringField;
    ArdsQryLASTCONNECTION: TZDateTimeField;
    ArdsQryONLINE: TZBooleanField;
    ArdsQryFIRMWARE: TZBCDField;
    tblNardDetailsARDID: TZIntegerField;
    tblNardDetailsGROUPID: TZIntegerField;
    tblNardDetailsPROCESSID: TZIntegerField;
    tblNardDetailsDISPLAYNAME: TZUnicodeStringField;
    tblNardDetailsLASTIP: TZUnicodeStringField;
    tblNardDetailsLASTCONNECTION: TZDateTimeField;
    tblNardDetailsONLINE: TZBooleanField;
    tblNardDetailsFIRMWARE: TZBCDField;
    LogsQrySTAMP: TZDateTimeField;
    LogsQryARDID: TZIntegerField;
    LogsQryVALUETYPE: TZIntegerField;
    LogsQryVALUEINDEX: TZIntegerField;
    LogsQryVALUEINT: TZInt64Field;
    LogsQryVALUEFLOAT: TZDoubleField;
    qryLogRptSTAMP: TZDateTimeField;
    qryLogRptARDID: TZIntegerField;
    qryLogRptVALUETYPE: TZIntegerField;
    qryLogRptVALUEINDEX: TZIntegerField;
    qryLogRptVALUEINT: TZInt64Field;
    qryLogRptVALUEFLOAT: TZDoubleField;
    qryCommandsVALUEINT: TZInt64Field;
    qryCommandsVALUEFLOAT: TZDoubleField;
    qryScreens: TZQuery;
    qryScreenItems: TZQuery;
    qryScreensSCREENID: TZIntegerField;
    qryScreensDISPLAYNAME: TZUnicodeStringField;
    seqScreens: TZSequence;
    qryImg: TZQuery;
    qryScreenVals: TZQuery;
    qryScrnV: TZQuery;
    seqItemId: TZSequence;
    qryScreenItemsSCREENID: TZIntegerField;
    qryScreenItemsITEMID: TZIntegerField;
    qryScreenItemsARDID: TZIntegerField;
    qryScreenItemsDISPLAYNAME: TZUnicodeStringField;
    qryScreenItemsPOSLEFT: TZIntegerField;
    qryScreenItemsPOSTOP: TZIntegerField;
    qryScreenItemsHEIGHT: TZIntegerField;
    qryScreenItemsWIDTH: TZIntegerField;
    qryScreenItemsOFFLINEIMG: TZUnicodeStringField;
    qryScreenItemsONLINEIMG: TZUnicodeStringField;
    qryScreenItemsALERTIMG: TZUnicodeStringField;
    qryImgSTAMP: TZDateTimeField;
    qryImgARDID: TZIntegerField;
    qryImgIMAGE: TZBlobField;
    qryScreenValsSCREENID: TZIntegerField;
    qryScreenValsITEMID: TZIntegerField;
    qryScreenValsARDID: TZIntegerField;
    qryScreenValsVALINDEX: TZIntegerField;
    qryScreenValsVALUETYPE: TZIntegerField;
    qryScreenValsDISPLAYNUM: TZIntegerField;
    qryScreenValsTRIGIVAL: TZIntegerField;
    qryScreenValsTRIGFVAL: TZSingleField;
    qryScreenValsTRIGCALC: TZIntegerField;
    qryScreenValsTRIGTYPE: TZIntegerField;
    seqScreenVals: TZSequence;
    qryScrnVSCREENID: TZIntegerField;
    qryScrnVITEMID: TZIntegerField;
    qryScrnVARDID: TZIntegerField;
    qryScrnVVALINDEX: TZIntegerField;
    qryScrnVVALUETYPE: TZIntegerField;
    qryScrnVDISPLAYNUM: TZIntegerField;
    qryScrnVTRIGIVAL: TZIntegerField;
    qryScrnVTRIGFVAL: TZSingleField;
    qryScrnVTRIGCALC: TZIntegerField;
    qryScrnVTRIGTYPE: TZIntegerField;
    qryScrnVPOSLEFT: TZIntegerField;
    qryScrnVPOSTOP: TZIntegerField;
    qryScrnVFONTSIZE: TZIntegerField;
    qryScrnVFONTCOLOR: TZIntegerField;
    qryScrnVSVID: TZIntegerField;
    qryScrnVVALI: TZInt64Field;
    qryScrnVVALF: TZDoubleField;
    qryScreenItemsONIMG: TZUnicodeStringField;
    qryScreenItemsOFFIMG: TZUnicodeStringField;
    qryScreenItemsSHOWNAME: TZBooleanField;
    qryScreenItemsDNLEFT: TZIntegerField;
    qryScreenItemsDNTOP: TZIntegerField;
    qryScreenItemsDNSIZE: TZIntegerField;
    qryScreenValsPOSLEFT: TZIntegerField;
    qryScreenValsPOSTOP: TZIntegerField;
    qryScreenValsFONTSIZE: TZIntegerField;
    qryScreenValsFONTCOLOR: TZIntegerField;
    qryScreenValsSVID: TZIntegerField;
    qrySourceList: TZQuery;
    qrySourceListSKETCHID: TZIntegerField;
    qrySourceListSTAMP: TZDateTimeField;
    qrySourceListARDID: TZIntegerField;
    qrySourceListVER: TZBCDField;
    qrySourceListFILENAME: TZUnicodeStringField;
    seqSketchID: TZSequence;
    qryFirmwareList: TZQuery;
    seqFirmwareId: TZSequence;
    qryFirmwareListFIRMID: TZIntegerField;
    qryFirmwareListSTAMP: TZDateTimeField;
    qryFirmwareListARDID: TZIntegerField;
    qryFirmwareListVER: TZBCDField;
    qryFirmwareListFIRMWARE: TZBlobField;
    qryHashes: TZQuery;
    seqHashId: TZSequence;
    qryHashesHASHID: TZIntegerField;
    qryHashesHASH: TZInt64Field;
    qryHashesGROUPID: TZIntegerField;
    qryHashesDISPLAYNAME: TZUnicodeStringField;
    qryHashesACCESSLEVEL: TZIntegerField;
    qryHashesLASTACCESS: TZDateTimeField;
    qryLogView: TZQuery;
    qryScreenItemsACTIONID: TZIntegerField;
    qryScreenItemsACTIONVAL: TZIntegerField;
    qryScreenItemsACTIONVALTYPE: TZIntegerField;
    qryScreenItemsACTIONVALMIN: TZIntegerField;
    qryScreenItemsACTIONVALMAX: TZIntegerField;
    qryScreenItemsACTIONVALSTEP: TZIntegerField;
    qryFirmwareListFILENAME: TZUnicodeStringField;
    qryFirmwareListNOTE: TZUnicodeStringField;
    qrySourceListSKETCH: TZBlobField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetNextNardID:integer;
    function CheckNardIDexists(aID:integer):boolean;
    function EditNard(aID:integer):boolean;
    function DeleteNard(aID:integer):boolean;
    function CheckDBString(dbString:String):String;
    procedure SaveImg;
    function ScrambledEggs(Action, Src, Key : String) : String;
    function Hash(aStr:string):UInt32;

  end;

var
  dmDB: TdmDB;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}



{

//djb2
uint32_t Nard::_hash(char *str){
    uint32_t hash = 5381;
    int c;
    while (c = *str++)
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
    return hash;
}

function TDmDb.Hash(aStr:string):UInt32;
var
  I: Integer;
begin
result :=0;
if length(aStr)>0 then
  begin
  result := $1505;
  for I := 1 to length(aStr) do
     result := ((result shl 5)+result)+Ord(aStr[i]);
  end;
end;






function TDmDb.ScrambledEggs(Action, Src, Key : String) : String;
var
   KeyLen    : Integer;
   KeyPos    : Integer;
   offset    : Integer;
   dest      : string;
   SrcPos    : Integer;
   SrcAsc    : Integer;
   TmpSrcAsc : Integer;
   Range     : Integer;
begin


  ScrambledEggs:='';
  // if its blank then nothing to do exit
  // added trim to try to stop errrors.
  if Trim(Src)='' then Exit;

    Try
  dest:='';
  KeyLen:=Length(Key);
  KeyPos:=0;
  SrcPos:=0;
  SrcAsc:=0;
  Range:=256;
  if Action = UpperCase('E') then
  begin
    Randomize;
    offset:=Random(Range);
    dest:=format('%1.2x',[offset]);
    for SrcPos := 1 to Length(Src) do
    begin
      SrcAsc:=(Ord(Src[SrcPos]) + offset) MOD 255;
      if KeyPos < KeyLen then KeyPos:= KeyPos + 1 else KeyPos:=1;
      SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);
      dest:=dest + format('%1.2x',[SrcAsc]);
      offset:=SrcAsc;
    end;
  end;
  if Action = UpperCase('D') then
  begin
    offset:=StrToInt('$'+ copy(src,1,2));
    SrcPos:=3;
    repeat
    if Length(src) > 2 then
     begin
      SrcAsc:=StrToInt('$'+ copy(src,SrcPos,2));
      if KeyPos < KeyLen Then KeyPos := KeyPos + 1 else KeyPos := 1;
      TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
      if TmpSrcAsc <= offset then
        TmpSrcAsc := 255 + TmpSrcAsc - offset
      else
        TmpSrcAsc := TmpSrcAsc - offset;
      dest := dest + chr(TmpSrcAsc);
      offset:=srcAsc;
      SrcPos:=SrcPos + 2;
     End;
    until SrcPos >= Length(Src);
  end;
    Finally
  ScrambledEggs:=dest;
  End;
end;




procedure TDmDb.SaveImg;
var
buffer:TBytes;
size:integer;
jpeg:tJpegImage;
ms:tMemoryStream;
alert,modeOn,trig:boolean;
begin
 // seqScreens.GetCurrentValue

  alert:=false;
  modeOn:=False;
  trig:=false;
 dmDb.qryScrnV.Active:=false;
 dmDb.qryScrnV.Params[0].AsInteger:=1;//CurrentScreen;
 dmDb.qryScrnV.Params[1].AsInteger:=dmDb.qryScreenItemsITEMID.Value;
 dmDb.qryScrnV.Active:=true;
 if dmDb.qryScrnV.RecordCount>0 then
   begin
   while not dmDb.qryScrnV.Eof do
    begin
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
     dmDb.qryScrnV.Next;
    end;
   end;



 jpeg:=tJpegImage.Create;
 jpeg.LoadFromFile(ExtractFilePath(Application.ExeName)+'\images\PlantOnline.jpg');
 ms:=tMemoryStream.Create;
 jpeg.SaveToStream(ms);
 jpeg.Destroy;
 size:=ms.Size;
 ms.Position:=0;
if size>0 then
 begin
   ShowMessage('size='+intToStr(size));
   setLength(buffer,size);
   ShowMessage(IntToStr(buffer[0]));
   ms.ReadBuffer(buffer[0], length(buffer));
   ms.Position:=0;
  // ms.Destroy;
   ShowMessage(IntToStr(buffer[0]));
   qryGen.Active:=false;
   qryGen.SQL.Clear;
   qryGen.SQL.Add('insert into LogImg');
   qryGen.SQL.Add('Values (CURRENT_TIMESTAMP, :ID, :IMG);');
   qryGen.ParamByName('ID').AsInteger:=1;
   qryGen.ParamByName('IMG').LoadFromStream(ms);
//   qryGen.ParamByName('IMG').SetBlobData(@buffer[0],size);
   setLength(buffer,0);
   qryGen.Prepare;
   qryGen.ExecSQL;
   ShowMessage('Pic inserted');
  ms.Destroy;
 end;



end;

//firebird sql string use a single quote...
function TdmDB.CheckDBString(dbString:String):String;
var
i,CharCount,CharPos:integer;
strLength:integer;
begin
//qryGen.ParamByName('PIC').SetBlobData()
// set our result in case there is nothing to do.
Result:=dbString;
CharPos:=POS('''',dbString);
strLength:=Length(dbString);
if CharPos=0 then exit;// nothing to do
if strLength=0 then exit;//nothing to do
if (CharPos>0) and (strLength>1) then
begin
CharCount:=0;
for i := 1 to strLength do    // Iterate
begin
if dbString[i]='''' then Inc(CharCount);
end;    // for
end;


// not sure why anyone would do this but best to check
if (strLength=1) and (CharPos=1) then
begin
Result:='''''';
Exit;
end;
// not sure why anyone would do this but they will!!
if StrLength=CharCount then
begin
Result:='Bad String';
exit;
end;
// apost is at the end so add 2 more to the string
if (CharCount=1) and (CharPos=strLength) then
begin
result:=dbString+'''';
exit;
end;

 result:='';// zero out the result string
for i := 1 to strLength do    // Iterate
begin

if dbString[i]='''' then
begin
if i=strLength then
result:=result+'''' else
result:=result+'''''';
end else result:=result+dbString[i];
end;    // for

end;



function TdmDB.DeleteNard(aID:integer):boolean;
begin
  //delete a nard..
  result:=true;
  qryGen.Active:=false;
  qryGen.SQL.Clear;
  qryGen.SQL.Add('delete from ARDS where ARDID='+IntToStr(aID));

  try
    qryGen.ExecSQL;
  except on e:Exception do
    begin
      result:=false;
      ShowMessage(e.Message);
    end;
  end;



end;



function TdmDB.EditNard(aID:integer):boolean;
begin
 //fina nard and edit its record..
if not tblNardDetails.Active then tblNardDetails.Active:=true;
  if tblNardDetails.Locate('ARDID',aID,[]) then
     begin
       tblNardDetails.Edit;
       result:=true;
     end else result:=false;

end;


function TdmDB.GetNextNardID:integer;
begin
  result:=1;
  qryGen.Active:=false;
  qryGen.SQL.Clear;
  qryGen.SQL.Add('select ARDID from ARDS order by ARDID DESC');
  qryGen.SQL.Add('fetch first 1 rows only;');
  qryGen.Active:=true;
  if qryGen.RecordCount=1 then
  result:=qryGen.Fields[0].AsInteger +1 else
    result:=1;
  qryGen.Active:=false;
end;


function TdmDB.CheckNardIDexists(aID:integer):boolean;
begin
  // check for id already in use..
  result:=true;
  qryGen.Active:=false;
  qryGen.SQL.Clear;
  qryGen.SQL.Add('select ARDID from ARDS where ARDID='+IntToStr(aID));
  qryGen.Active:=true;
  if qryGen.RecordCount>0 then result := true else result := false;
  qryGen.Active:=true;


end;



procedure TdmDB.DataModuleCreate(Sender: TObject);
begin
  //
end;

end.
