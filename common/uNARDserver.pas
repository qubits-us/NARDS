{ NARDS Server
  Networked ARDuino System

  Created 3.12.2023 ~q  qubits.us


  be it harm none, do as ye wish..

}
unit uNARDserver;

interface

uses
  Classes, SyncObjs, SysUtils, System.Generics.Collections, System.IOUtils,
  IdGlobal, IdContext, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, IdUdpServer, IdSocketHandle, IdExceptionCore,
  uPacketDefs, ZAbstractTable, ZDataset, Data.DB, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractConnection, ZConnection, ZDbcIntfs
{$IFDEF ANDROID}, androidapi.JNI.Net, androidapi.JNIBridge, androidapi.JNI,
  androidapi.JNI.JavaTypes, androidapi.JNI.Os, FMX.Helpers.Android,
  androidapi.Helpers,
  androidapi.JNI.GraphicsContentViewText {$ENDIF};

type
  TComms_Event = procedure(Sender: TObject) of object;
  TComms_Error = procedure(Sender: TObject; const aMsg: String) of object;
  TComms_Status = procedure(Sender: TObject; const AStatus: String) of object;

  // data stored in q's
type
  tPacketData = record
    DataType: byte;
    Data: tBytes;
  end;

  // sends udp broadcast packets, auto configures clients
type
  TDiscoveryThread = class(TThread)
  private
    fUdp: TIdUDPServer;
    fLock: TCriticalSection;
    fErrorEvent: TComms_Error;
    fPauseEvent: TEvent;
    fDiscvEvent: TEvent;
    fLastError: String;
    fPaused: boolean;
    fPort: integer;
    fCount: integer;
    fSrvName: String;
    fSrvIP: String;
    fSrvPort: integer;
    fBurp: boolean;
    fDiscvSent: integer;
    procedure SetDiscvSent(aValue: integer);
    function GetDiscvSent: integer;
    procedure IncDiscvSent;
    function GetPort: integer;
    procedure SetPort(aValue: integer);
    procedure SetPause(const aValue: boolean);
    function GetPause: boolean;
    procedure SetServerIp(aValue: String);
    function GetServerIP: String;
    procedure SetServerPort(aValue: integer);
    function GetServerPort: integer;
    procedure SetServerName(aValue: String);
    function GetServerName: String;
    procedure OnUDPError(AThread: TIdUDPListenerThread;
      ABinding: TIdSocketHandle; const AMessage: string;
      const AExceptionClass: TClass);
    function CheckPacketIdent(Const AIdent: TIdentArray): boolean;
    procedure Burp;

  protected
    procedure Execute; override;
    procedure DoErrorMsg;
  public
    Constructor Create(aLock: TCriticalSection);
    destructor Destroy; override;
    property OnError: TComms_Error read fErrorEvent write fErrorEvent;
    property Paused: boolean read GetPause write SetPause;
    property Port: integer read GetPort write SetPort;
    property ServerPort: integer read GetServerPort;
    property ServerIP: string read GetServerIP write SetServerIp;
    property ServerName: String read GetServerName write SetServerName;
    property DiscvSent: integer read GetDiscvSent;
  end;

  // Nard context object, each connection gets one..
type
  tNardCntx = Class(TObject)
  private
    fCrit: TCriticalSection;
    fOutQue: tQueue<tPacketData>;
    fRegged: boolean;
    fNardID: integer;
    fDbUser: string;
    fDbPass: String;
    fDbConnType: byte;
    fDbName: string;
    fDbHost: string;
    fDbPort: integer;
    fDbConn: TZConnection;
    fQryGen: TZQuery;
    fBuff: tBytes;
    fHdr: tPacketHdr;
    fSent: integer;
    fDrop: integer;
    fReshDB: integer;
    fCommandID:integer;
    fLastCommandId:integer;
    fContext: tIdContext;
    function GetDrop: integer;
    procedure IncDrop;
    procedure ZeroSent;
    function GetSent: integer;
    procedure IncSent;
    function GetContext: tIdContext;
    function Pop: tPacketData;
  public
    Constructor Create;
    Destructor Destroy; override;
    function GetOutGoing: integer;
    procedure Process(aContext: tIdContext);
    procedure Push(aPacket: tPacketData);
    property Context: tIdContext read GetContext;
    property PacketsSent: integer read GetSent;
    property PacketsDrop: integer read GetDrop;
  End;

  // the server object

type
  tNardServer = Class(TObject)
  private
    fCrit: TCriticalSection;
    fLogQue: tQueue<string>;
    fErrorQue: tQueue<string>;
    fServer: TIdTCPServer;
    fServerName: String;
    fIp: string;
    fPort: integer;
    fDiscvPort: integer;
    fCommandID: integer;
    fRecv: integer;
    fSent: integer;
    fBad: integer;
    fDiscoveryEnabled: boolean;
    //db connection info
    fDbUser: string;
    fDbPass: String;
    fDbConnType: byte;
    fDbName: string;
    fDbHost: string;
    fDbPort: integer;

    fCommsError: TComms_Event;
    fStatus: TComms_Status;
    fLogEvent: TComms_Event;
    fDisconnect: TComms_Event;
    fNewNard: TComms_Event;
    fSetVar:tComms_Event;
    fDiscvThrd: TDiscoveryThread; // discovery

{$IFDEF ANDROID}
    fWifiLockEngaged: boolean;
    fWifiManager: JWifiManager;
    fMultiCastLock: JWifiManager_MulticastLock;
    function GetWiFiManager: JWifiManager;
    procedure GetWifiLock;
    procedure ReleaseWifiLock;
{$ENDIF}
    function IsOnline: boolean;
    function GetConnCount: integer;
    function GetBad: integer;
    procedure IncBad;
    function GetSent: integer;
    procedure IncSent;
    function GetRecv: integer;
    procedure IncRecv;
    procedure SetCommandID(val:integer);
    function GetCommandID:integer;
    procedure SetServerName(aValue: string);
    procedure SetDiscovery(aValue: boolean);
    procedure SetDiscoveryPort(aValue: integer);
    procedure Log(aMsg: String);
    procedure LogError(aMsg: String);
    procedure trigDisconnect;
    procedure trigNewNard;
    procedure trigSetVar;
    procedure OnConnect(aContext: tIdContext);
    procedure OnContextCreated(aContext: tIdContext);
    procedure OnDisconnect(aNardCtx: tIdContext);
    procedure OnStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure OnException(aContext: tIdContext; AException: Exception);
    procedure OnExecute(aContext: tIdContext);
    function CheckIdent(aHdr: tPacketHdr): boolean;
    procedure piRecvPacket(aPacketCtx: tNardCntx);
    procedure piRecvNAK(aPacketCtx: tNardCntx);
    procedure piRecvNOP(aPacketCtx: tNardCntx);
    procedure piRecvReg(aNardCtx: tNardCntx);
    procedure piRecvGet(aNardCtx: tNardCntx);
    procedure piRecvSet(aNardCtx: tNardCntx);
    procedure piRecvSetnLog(aNardCtx: tNardCntx);
    procedure piRecvHash(aNardCtx: tNardCntx);
    procedure piRecvGetParams(aNardCtx: tNardCntx);
    procedure piRecvSetParams(aNardCtx: tNardCntx);
    procedure piRecvSetnLogParams(aNardCtx: tNardCntx);
    procedure piSetCommandID(aNardCtx:tNardCntx);

  public
    Constructor Create;
    Destructor Destroy; override;
    procedure DoError;
    procedure DoStatus(AStatus: string);
    procedure DoLog;
    procedure DoNewNard;
    procedure DoSetVar;
    procedure DoDisconnect;
    function PopLog: string;
    function PopErrorLog: string;
    procedure Start;
    procedure Stop;

    property DbName:string read fDbName write fDbName;
    property DbUser:string read fDbUser write fDbUser;
    property DbPass:string read fDbPass write fDbPass;
    property DbHost:string read fDbHost write fDbHost;
    property DbPort:integer read fDbPort write fDbPort;
    property DbConnType:byte read fDbConnType write fDbConnType;
    property OnError: TComms_Event read fCommsError write fCommsError;
    property OnState: TComms_Status read fStatus write fStatus;
    property OnLog: TComms_Event read fLogEvent write fLogEvent;
    property OnDisconn: TComms_Event read fDisconnect write fDisconnect;
    property OnConn: TComms_Event read fNewNard write fNewNard;
    property OnSetVar:TComms_Event read fSetVar write fSetVar;
    property Port: integer read fPort write fPort;
    property DiscvPort: integer read fDiscvPort write SetDiscoveryPort;
    property IP: string read fIp write fIp;
    property Online: boolean read IsOnline;
    property CommandID:integer read GetCommandID write SetCommandID;
    property ServerName: String read fServerName write SetServerName;
    property DiscoveryEnabled: boolean read fDiscoveryEnabled
      write SetDiscovery;
    property Connections: integer read GetConnCount;
    property PacketsRecv: integer read GetRecv;
    property PacketsSent: integer read GetSent;
    property PacketsBad: integer read GetBad;

  End;

  // global server object..
var
  PacketSrv: tNardServer;

implementation

{ TDiscoveryThread }
constructor TDiscoveryThread.Create(aLock: TCriticalSection);
begin
  fLock := aLock;
  fPaused := true;
  fPort := 12001; // port should be one port above what clients listen on..
  fSrvIP := '127.0.0.1';
  fSrvPort := 9000;
  fSrvName := 'NARDS';
  fBurp := false;
  fCount := 0;

  fPauseEvent := TEvent.Create(nil, true, false, '');
  fDiscvEvent := TEvent.Create(nil, true, false, '');
  try
    fUdp := TIdUDPServer.Create(nil);
    fUdp.DefaultPort := fPort;
    fUdp.BroadcastEnabled := true;
    fUdp.OnUDPException := OnUDPError;
    fUdp.ThreadedEvent := true;
  finally;
  end;

  inherited Create(false);

end;

// clean house!!
destructor TDiscoveryThread.Destroy;
begin
  // kill the udp socket srvr
  if Assigned(fUdp) then
  begin
    if fUdp.Active then
      fUdp.Active := false;
    try
      fUdp.Free;
    finally;
    end;
  end;

  Terminate; // shut down please
  fPauseEvent.SetEvent; // release it..
  fDiscvEvent.SetEvent; // release it..
  // might already be done..
  if not Finished then
    WaitFor; // no hang ups please gods!!
  fPauseEvent.Free; // bye
  fDiscvEvent.Free; // bye
  fLock := nil; // remove ref
  inherited; // and everything else..

end;

// excuse me.. :)
procedure TDiscoveryThread.Burp;
var
  aPacket: TDiscoveryPacket;
  aBytes: tBytes;
  aBuff: TIdBytes;
begin

  // try to broadcast a discovery packet
  FillPacketIdent(aPacket.PacketIdent);
  // server name
  aBytes := TEncoding.ANSI.GetBytes(fSrvName);
  if (Length(aBytes) > 0) AND (Length(aBytes) < Length(aPacket.ServerName)) then
    Move(aBytes[0], aPacket.ServerName[0], Length(aBytes))
  else
    aPacket.ServerName[0] := 0;
  // server ip
  aBytes := TEncoding.ANSI.GetBytes(fSrvIP);
  if (Length(aBytes) > 0) AND (Length(aBytes) < Length(aPacket.ServerIP)) then
    Move(aBytes[0], aPacket.ServerIP[0], Length(aBytes))
  else
    aPacket.ServerIP[0] := 0;
  // server port
  aBytes := TEncoding.ANSI.GetBytes(IntToStr(fSrvPort));
  if (Length(aBytes) > 0) AND (Length(aBytes) < Length(aPacket.ServerPort)) then
    Move(aBytes[0], aPacket.ServerPort[0], Length(aBytes))
  else
    aPacket.ServerPort[0] := 0;

  SetLength(aBytes, 0); // all done with this..
  // take me struct and stuff it into an indy buff..
  SetLength(aBuff, SizeOf(aPacket));
  Move(aPacket, aBuff[0], SizeOf(aPacket));
  // our broadcast port is 1 less than default..
  try
    fUdp.Broadcast(aBuff, fUdp.DefaultPort - 1);
    IncDiscvSent;
  except
    on e: Exception do
    begin
      fLastError := 'Burp Error: ' + e.Message;
      Synchronize(DoErrorMsg);
    end;
  end;
  SetLength(aBuff, 0); // bye
end;

// how many discv packets recvs
procedure TDiscoveryThread.SetDiscvSent(aValue: integer);
begin
  fLock.Enter;
  try
    fDiscvSent := aValue;
  finally
    fLock.Leave;

  end;
end;

// get em
function TDiscoveryThread.GetDiscvSent;
begin
  fLock.Enter;
  try
    result := fDiscvSent;
  finally
    fLock.Leave;

  end;
end;

// inc em
procedure TDiscoveryThread.IncDiscvSent;
begin
  fLock.Enter;
  try
    Inc(fDiscvSent);
  finally
    fLock.Leave;

  end;
end;

// the port we use
procedure TDiscoveryThread.SetPort(aValue: integer);
begin
  fLock.Enter;
  try
    fPort := aValue;
  finally
    fLock.Leave;
  end;
end;

// get it..
function TDiscoveryThread.GetPort: integer;
begin
  fLock.Enter;
  try
    result := fPort;
  finally
    fLock.Leave;
  end;

end;

// server ip client should connect too..
procedure TDiscoveryThread.SetServerIp(aValue: String);
begin
  fLock.Enter;
  try
    fSrvIP := aValue;
  finally
    fLock.Leave;

  end;

end;

// get it..
function TDiscoveryThread.GetServerIP: String;
begin
  fLock.Enter;
  try
    result := fSrvIP;
  finally
    fLock.Leave;
  end;

end;

// the server port we connect too..
procedure TDiscoveryThread.SetServerPort(aValue: integer);
begin
  fLock.Enter;
  try
    fSrvPort := aValue;
  finally
    fLock.Leave;
  end;

end;

// get it
function TDiscoveryThread.GetServerPort;
begin
  fLock.Enter;
  try
    result := fSrvPort;
  finally
    fLock.Leave;

  end;
end;

// server name we listen for.. set this!! :)
procedure TDiscoveryThread.SetServerName(aValue: string);
begin
  fLock.Enter;
  try
    fSrvName := aValue;
  finally
    fLock.Leave;
  end;
end;

// get it..
function TDiscoveryThread.GetServerName: string;
begin
  fLock.Enter;
  try
    result := fSrvName;
  finally
    fLock.Leave;
  end;

end;

// just chill..
procedure TDiscoveryThread.SetPause(const aValue: boolean);
begin
  fLock.Enter;
  try
    if (not Terminated) and (fPaused <> aValue) then
    begin
      fPaused := aValue;
      if fPaused then
      begin
        fPauseEvent.ResetEvent;
        fUdp.Active := false;
      end
      else
      begin
        fPauseEvent.SetEvent;
        fUdp.Active := true;
      end;
    end;

  finally
    fLock.Leave;
  end;

end;

// get it
function TDiscoveryThread.GetPause: boolean;
begin
  fLock.Enter;
  try
    result := fPaused;

  finally
    fLock.Leave;
  end;

end;

// oops!!
procedure TDiscoveryThread.DoErrorMsg;
begin
  if Assigned(fErrorEvent) then
    fErrorEvent(self, fLastError);
end;

// does it match our packet identifier
function TDiscoveryThread.CheckPacketIdent(Const AIdent: TIdentArray): boolean;
var
  i: integer;
begin
  result := true;
  for i := Low(AIdent) to High(AIdent) do
    if AIdent[i] <> Ident_Packet[i] then
      result := false;
end;

// don't do much in here.. wait for pause or wait for packet received
procedure TDiscoveryThread.Execute;
begin

  while not Terminated do
  begin
    try

      if Terminated then
        exit;
      fPauseEvent.WaitFor(INFINITE); // pause
      if Terminated then
        exit;
      fDiscvEvent.WaitFor(1000); // wait for 1 sec
      Inc(fCount);
      if fCount > 9 then
      begin
        fCount := 0;
        Burp;
      end;
      if Terminated then
        exit;
      if not Terminated then
        fDiscvEvent.ResetEvent;

    finally;
    end;

  end;

end;

procedure TDiscoveryThread.OnUDPError(AThread: TIdUDPListenerThread;
  ABinding: TIdSocketHandle; const AMessage: string;
  const AExceptionClass: TClass);
begin
  fLastError := AMessage;
  Synchronize(DoErrorMsg);
end;

{ Nard Context }

Constructor tNardCntx.Create;
begin
  Inherited;
  SetLength(fBuff, 0);
  fSent := 0;
  fNardID := -1;
  fCommandID:=0;
  fLastCommandId:=0;
  fCrit := TCriticalSection.Create;
  fOutQue := tQueue<tPacketData>.Create;
  fDbConn := TZConnection.Create(nil);
  fDbConn.Protocol := 'firebird';
  fDbConn.Properties.Add('dialect=3');
  fDbConn.Properties.Add('FirebirdAPI=legacy');
  fDbConn.Properties.Add('RawStringEncoding=DB_CP');
  fDbConn.TransactIsolationLevel:= tiReadCommitted;
  fQryGen := TZQuery.Create(nil);
  fQryGen.Connection := fDbConn;
  fRegged := false;
end;

Destructor tNardCntx.Destroy;
begin
  fDbConn.Connected := false;
  fQryGen.Free;
  fDbConn.Free;
  SetLength(fBuff, 0);
  fOutQue.Free;
  fCrit.Free;
  Inherited;
end;

procedure tNardCntx.Push(aPacket: tPacketData);
begin
  fCrit.Enter;
  try
    if fOutQue.Count < MAX_QUES then
      fOutQue.Enqueue(aPacket)
    else
    begin
      // drop the packet
      try
        SetLength(aPacket.Data, 0);
      finally
        IncDrop;
      end;
    end;
  finally
    fCrit.Leave;
  end;

end;

function tNardCntx.Pop: tPacketData;
begin
  fCrit.Enter;
  try
    if fOutQue.Count > 0 then
      result := fOutQue.Dequeue
    else
      SetLength(result.Data, 0);
  finally
    fCrit.Leave;
  end;

end;

function tNardCntx.GetOutGoing: integer;
begin
  fCrit.Enter;
  try
    result := fOutQue.Count
  finally
    fCrit.Leave;
  end;

end;

function tNardCntx.GetDrop: integer;
begin
  fCrit.Enter;
  try
    result := fDrop;
  finally
    fCrit.Leave;
  end;

end;

procedure tNardCntx.IncDrop;
begin
  fCrit.Enter;
  try
    Inc(fDrop);
  finally
    fCrit.Leave;
  end;

end;

procedure tNardCntx.ZeroSent;
begin
  fCrit.Enter;
  try
    fSent := 0;
  finally
    fCrit.Leave;
  end;

end;

function tNardCntx.GetSent: integer;
begin
  fCrit.Enter;
  try
    result := fSent;
  finally
    fCrit.Leave;
  end;

end;

procedure tNardCntx.IncSent;
begin
  fCrit.Enter;
  try
    Inc(fSent);
  finally
    fCrit.Leave;
  end;

end;

function tNardCntx.GetContext: tIdContext;
begin
  result := fContext;
end;

procedure tNardCntx.Process(aContext: tIdContext);
var
  i, s, c: integer;
  aPack: tPacketData;
  aBuff: TIdBytes;
  failed: boolean;
  aSingle:single;
  aDouble:double;
  aInt:Int32;
  aUInt:UInt32;
  params:array[0..3] of Int16;
begin


  failed := false;
  i := GetOutGoing;

  if i > 0 then
  begin
    // send a que'd outgoing packet
    aPack := Pop;
    s := Length(aPack.Data);
    if s > 0 then
    begin
      // got something to send
      SetLength(aBuff, s);
      Move(aPack.Data[0], aBuff[0], s);
      aContext.Connection.IOHandler.Write(aBuff);
      IncSent;
      SetLength(aBuff, 0);
      SetLength(aPack.Data, 0);
    end;
  end;

  if tNardCntx(aContext.Data).fRegged then
  begin
    tNardCntx(aContext.Data).fQryGen.Active := false;
    tNardCntx(aContext.Data).fQryGen.SQL.Clear;
    tNardCntx(aContext.Data).fQryGen.SQL.Add('select * from ArdCommands a where a.ArdId=' +IntToStr(tNardCntx(aContext.Data).fNardID));
    try
      tNardCntx(aContext.Data).fQryGen.Active := true;
    except
      on e: Exception do
      begin
        failed := true;
      end;
    end;

    if not failed then
    begin
      if tNardCntx(aContext.Data).fQryGen.RecordCount > 0 then
      begin
        // got some records, process 1..
        c := tNardCntx(aContext.Data).fQryGen.FieldByName('CommandId').AsInteger;
      if (c<>tNardCntx(aContext.Data).fCommandID) then
       begin
        tNardCntx(aContext.Data).fCommandID:=c;
        tNardCntx(aContext.Data).fCommandID:=tNardCntx(aContext.Data).fQryGen.FieldByName('CommandId').AsInteger;
        tNardCntx(aContext.Data).fHdr.Command := tNardCntx(aContext.Data).fQryGen.FieldByName('Command').AsInteger;
       if tNardCntx(aContext.Data).fHdr.Command<> CMD_PARAMS then
        begin
          tNardCntx(aContext.Data).fHdr.Option[0] := tNardCntx(aContext.Data).fQryGen.FieldByName('Op1').AsInteger;
          tNardCntx(aContext.Data).fHdr.Option[1] := tNardCntx(aContext.Data).fQryGen.FieldByName('Op2').AsInteger;
          tNardCntx(aContext.Data).fHdr.Option[2] := tNardCntx(aContext.Data).fQryGen.FieldByName('Op3').AsInteger;
          tNardCntx(aContext.Data).fHdr.Option[3] := tNardCntx(aContext.Data).fQryGen.FieldByName('Op4').AsInteger;
          tNardCntx(aContext.Data).fHdr.DataSize:=0;
          SetLength(aBuff, SizeOf(tPacketHdr));
          case tNardCntx(aContext.Data).fHdr.Option[1] of
          SG_INT32:begin
                   tNardCntx(aContext.Data).fHdr.DataSize:=SizeOf(Int32);
                   SetLength(aBuff, SizeOf(tPacketHdr)+SizeOf(Int32));
                   aInt := tNardCntx(aContext.Data).fQryGen.FieldByName('ValueInt').AsInteger;
                   move(aInt,aBuff[SizeOf(tPacketHdr)],SizeOf(Int32));
                   end;
          SG_UINT32:begin
                    tNardCntx(aContext.Data).fHdr.DataSize:=SizeOf(UInt32);
                    SetLength(aBuff, SizeOf(tPacketHdr)+SizeOf(UInt32));
                    aUInt := tNardCntx(aContext.Data).fQryGen.FieldByName('ValueInt').AsInteger;
                    move(aUInt,aBuff[SizeOf(tPacketHdr)],SizeOf(UInt32));
                   end;
          SG_FLT4: begin
                   tNardCntx(aContext.Data).fHdr.DataSize:=SizeOf(Single);
                   SetLength(aBuff, SizeOf(tPacketHdr)+SizeOf(Single));
                   aSingle := tNardCntx(aContext.Data).fQryGen.FieldByName('ValueFloat').AsFloat;
                   move(aSingle,aBuff[SizeOf(tPacketHdr)],SizeOf(Single));
                   end;
          SG_FLT8: begin
                   tNardCntx(aContext.Data).fHdr.DataSize:=SizeOf(double);
                   SetLength(aBuff, SizeOf(tPacketHdr)+SizeOf(double));
                   aDouble := tNardCntx(aContext.Data).fQryGen.FieldByName('ValueFloat').AsFloat;
                   move(aDouble,aBuff[SizeOf(tPacketHdr)],SizeOf(Double));
                   end;

          end;
        end else
           begin
           //index is stored in valueint
           tNardCntx(aContext.Data).fHdr.Option[0] := PARAMS_SET;
           tNardCntx(aContext.Data).fHdr.Option[1] := tNardCntx(aContext.Data).fQryGen.FieldByName('ValueInt').AsInteger;
           tNardCntx(aContext.Data).fHdr.Option[2] := 0;
           tNardCntx(aContext.Data).fHdr.Option[3] := 0;
           tNardCntx(aContext.Data).fHdr.DataSize:=SizeOf(params);
           //params are in the ops
           params[0]:=tNardCntx(aContext.Data).fQryGen.FieldByName('Op1').AsInteger;
           params[1]:=tNardCntx(aContext.Data).fQryGen.FieldByName('Op2').AsInteger;
           params[2]:=tNardCntx(aContext.Data).fQryGen.FieldByName('Op3').AsInteger;
           params[3]:=tNardCntx(aContext.Data).fQryGen.FieldByName('Op4').AsInteger;
           SetLength(aBuff, SizeOf(tPacketHdr)+SizeOf(params));
           move(params,aBuff[SizeOf(tPacketHdr)],SizeOf(params));
           end;
          //move header in..
          Move(tNardCntx(aContext.Data).fHdr, aBuff[0], SizeOf(tPacketHdr));
          //send it off..
          aContext.Connection.IOHandler.Write(aBuff);
          IncSent;
          //release..
          SetLength(aBuff, 0);

           //delete command..
           tNardCntx(aContext.Data).fQryGen.Active := false;
           tNardCntx(aContext.Data).fQryGen.SQL.Clear;
           tNardCntx(aContext.Data).fQryGen.SQL.Add('delete from ArdCommands a where a.CommandId = ' + IntToStr(c));
          try
             tNardCntx(aContext.Data).fQryGen.ExecSQL;
           except on e:exception do
            begin
             tNardCntx(aContext.Data).fQryGen.Active := false;
            end else
              begin
              //remember..
              tNardCntx(aContext.Data).fCommandID:=tNardCntx(aContext.Data).fLastCommandID;
              tNardCntx(aContext.Data).fLastCommandID:=c;
              end;
          end;

       end else
           begin
             //old command.. try to delete..
            tNardCntx(aContext.Data).fQryGen.Active := false;
            tNardCntx(aContext.Data).fQryGen.SQL.Clear;
            tNardCntx(aContext.Data).fQryGen.SQL.Add('delete from ArdCommands a where a.CommandId = ' + IntToStr(c));
             try
               tNardCntx(aContext.Data).fQryGen.ExecSQL;
             except on e:exception do
               begin
               tNardCntx(aContext.Data).fQryGen.Active := false;
               end else
                 begin
                  //remember..
                 tNardCntx(aContext.Data).fCommandID:=tNardCntx(aContext.Data).fLastCommandID;
                 tNardCntx(aContext.Data).fLastCommandID:=c;
                 end;
             end;
           end;

      end else
         begin  //probaby don't need this as i changed to tiReadCommited..
           // tNardCntx(aContext.Data).fCommandID:=c;
           if tNardCntx(aContext.Data).fReshDB > 10 then
            begin
            tNardCntx(aContext.Data).fReshDB:=0;
            sleep(1);
            end else Inc(tNardCntx(aContext.Data).fReshDB);
         end;

    end;
  end;
end;

          {
            Nard Server

          }

Constructor tNardServer.Create;
begin
  Inherited;
  fCrit := TCriticalSection.Create;
  fLogQue := tQueue<string>.Create;
  fErrorQue := tQueue<string>.Create;
  fSent := 0; fRecv := 0; fBad := 0;
  fIp := '127.0.0.1';
    //db connection info
    fDbUser := 'SYSDBA';
    fDbPass := 'qubits';
    fDbConnType := 0; ;
    fDbName := 'NARDS';
    fDbHost := 'localhost';
    fDbPort := 3050;

  fServer := TIdTCPServer.Create(nil);
  fServer.OnConnect := OnConnect;
  fServer.OnContextCreated := OnContextCreated;
  fServer.OnDisconnect := OnDisconnect;
  fServer.OnStatus := OnStatus;
  fServer.OnException := OnException;
  fServer.OnExecute := OnExecute;

  // create our discovery thread
  fDiscvThrd := TDiscoveryThread.Create(fCrit);

{$IFDEF ANDROID}
fWifiLockEngaged := false; GetWifiLock;
{$ENDIF}
end;

Destructor tNardServer.Destroy;
 begin
   if fServer.Active then fServer.Active := false;

          // kill discovery thread
          if fDiscvThrd <> nil then
           begin
            fDiscvThrd.Free; // bye
           end;

          fLogQue.Free; fErrorQue.Free; fCrit.Free;

          // release the lock
{$IFDEF ANDROID}
          ReleaseWifiLock;
{$ENDIF}
          try
            fServer.Free;
             finally Inherited;
          end;
 end;

          { On Android we have to obtain the MultiCastLock in order to broadcast }

{$IFDEF ANDROID}
          // get the manager in charge of things..
function tPacketServer.GetWiFiManager: JWifiManager;
   var
   Obj: JObject;
begin
  result := nil;
    if fWifiLockEngaged then exit;
        // don't want another

  Obj := SharedActivityContext.getSystemService(TJContext.JavaClass.WIFI_SERVICE);
  if Assigned(Obj) then result := TJWiFiManager.Wrap((Obj as ILocalObject).GetObjectID);
end;


// get the lock, allows for receiving broadcast packets..
// also gonna grab our wifi ip while in here..
procedure tPacketServer.GetWifiLock;
  var
  info: JWiFiInfo;
   IP: string;
   lw: cardinal;
begin
   if fWifiLockEngaged then exit; // nothing to do here
    try fWifiManager := GetWiFiManager;
        // could be a nil, so check..
    if Assigned(fWifiManager) then
      begin fMultiCastLock :=
      fWifiManager.createMulticastLock(StringToJString('NardsAwesome'));
      fMultiCastLock.acquire;
      fWifiLockEngaged := true;
      // todo: change ip getter, wifimanager is no longer appreciated..
      info := fWifiManager.getConnectionInfo;
      lw := info.getIpAddress;
      lw := SwapBytes(lw); // swap the byte order, backwards on robots..
      IP := MakeUInt32IntoIPv4Address(lw);
      fIp := IP; // save it
      fDiscvThrd.ServerIP := fIp; // set for our udp discv
      end;
    Except on e: Exception do;
     end; // try
end;

// Release the lock when done..
procedure tPacketServer.ReleaseWifiLock;
 begin
   try
   // check the manager
   if Assigned(fWifiManager) then
    begin
    // check the lock
    If Assigned(fMultiCastLock) then
       if fMultiCastLock.isHeld then
        // are we still held..
          fMultiCastLock.Release; // bye

    end;
     Except on e: Exception do; // this will never happen right.. :)
   end; // try
 end;

{$ENDIF}
procedure tNardServer.Start;
begin
//
fServer.Active := false;
fServer.Bindings.Clear;
fServer.DefaultPort := fPort;
fServer.Bindings.Add.IPVersion := Id_IPv4;
fServer.Active := true;

end;

procedure tNardServer.Stop;
 begin
 //
 fServer.Active := false;

 end;

function tNardServer.IsOnline: boolean;
begin
  result := fServer.Active;
end;

function tNardServer.GetConnCount: integer;
 begin
   result := fServer.Contexts.Count;
 end;

 function tNardServer.GetBad: integer;
  begin
   fCrit.Enter;
   try result := fBad;
     finally fCrit.Leave;
   end;

  end;

procedure tNardServer.IncBad;
 begin
  fCrit.Enter;
   try Inc(fBad);
   finally
    fCrit.Leave;
   end;

 end;

function tNardServer.GetSent: integer;
 begin fCrit.Enter;
   try result := fSent;
    finally fCrit.Leave;
   end;

 end;

 procedure tNardServer.IncSent;
  begin
   fCrit.Enter;
    try Inc(fSent);
        finally
         fCrit.Leave;
    end;

  end;

function tNardServer.GetRecv: integer;
 begin
  fCrit.Enter;
        try
          result := fRecv;
            finally fCrit.Leave;
        end;

 end;

procedure tNardServer.IncRecv;
 begin
   fCrit.Enter;
     try Inc(fRecv);
        finally
      fCrit.Leave;
     end;

 end;



function tNardServer.GetCommandID: integer;
 begin
  fCrit.Enter;
        try
          result := fCommandID;
            finally
          fCrit.Leave;
        end;

 end;

procedure tNardServer.SetCommandID(val:integer);
 begin
   fCrit.Enter;
     try
       fCommandID := val;
        finally
      fCrit.Leave;
     end;

 end;



 procedure tNardServer.SetServerName(aValue: string);
 begin
   fServerName := aValue;
   fDiscvThrd.ServerName := fServerName;
 end;

 // start and stop the discovery thread..
procedure tNardServer.SetDiscovery(aValue: boolean);
begin
  if aValue then fDiscvThrd.Paused := false else fDiscvThrd.Paused:= true;
end;

// this will be the port we send out on..
// adding one to it, as we bind one port above..
// this allows running client and server on same cpu..
// server only transmits..
procedure tNardServer.SetDiscoveryPort(aValue: integer);
begin
 if aValue <> fDiscvPort then
  begin fDiscvPort := aValue;
  fDiscvThrd.Port := aValue + 1;
  end;
end;

procedure tNardServer.Log(aMsg: String);
begin

 // que up log message
 fCrit.Enter;
  try fLogQue.Enqueue(aMsg);
   finally fCrit.Leave;
  end;

 // trigger event
 TThread.Queue(nil,procedure begin if Assigned(PacketSrv) then PacketSrv.DoLog; end);

 end;

procedure tNardServer.LogError(aMsg: String);
 begin

 // que up log message
 fCrit.Enter;
  try fErrorQue.Enqueue(aMsg);
   finally fCrit.Leave;
  end;

        // trigger event
        TThread.Queue(nil,
          procedure
          begin
            if Assigned(PacketSrv) then
              PacketSrv.DoError;
          end);

 end;

procedure tNardServer.trigDisconnect;
 begin
 // trigger event
 TThread.Queue(nil,
 procedure
  begin
  if Assigned(PacketSrv) then
   PacketSrv.DoDisconnect;
  end);
 end;


procedure tNardServer.trigNewNard;
 begin
 // trigger event
 TThread.Queue(nil,
  procedure
   begin
   if Assigned(PacketSrv) then
     PacketSrv.DoNewNard;
   end);
 end;

procedure tNardServer.trigSetVar;
 begin
 // trigger event
 TThread.Queue(nil,
  procedure
   begin
   if Assigned(PacketSrv) then
     PacketSrv.DoSetVar;
   end);
 end;


procedure tNardServer.OnConnect(aContext: tIdContext);
begin
   aContext.Data := tNardCntx.Create;
   // set db access params..
   tNardCntx(aContext.Data).fDbUser := fDbUser;
   tNardCntx(aContext.Data).fDbPass := fDbPass;
   tNardCntx(aContext.Data).fDbConnType := fDbConnType;
   tNardCntx(aContext.Data).fDbName := fDbName;
   tNardCntx(aContext.Data).fDbHost := fDbHost;
   tNardCntx(aContext.Data).fDbPort := fDbPort;
   tNardCntx(aContext.Data).fContext:=aContext;
   Log('New connection from ip:' + aContext.Binding.PeerIP);
   //trigNewNard;  trigger on register..
end;

procedure tNardServer.OnContextCreated(aContext: tIdContext);
begin
        //
end;

procedure tNardServer.OnDisconnect(aNardCtx: tIdContext);
begin
  if tNardCntx(aNardCtx.Data).fRegged then
   begin
    // set our offiline state..
    tNardCntx(aNardCtx.Data).fQryGen.Active := false;
    tNardCntx(aNardCtx.Data).fQryGen.SQL.Clear;
    tNardCntx(aNardCtx.Data).fQryGen.SQL.Add('UPDATE ARDS a SET a.Online = FALSE');
    tNardCntx(aNardCtx.Data).fQryGen.SQL.Add('WHERE a.ARDID = ' +IntToStr(tNardCntx(aNardCtx.Data).fNardID) + ' ;');
     try
     tNardCntx(aNardCtx.Data).fQryGen.ExecSQL
     except on e: Exception do;
     end;

   tNardCntx(aNardCtx.Data).fDbConn.Connected := false;
   end;
 aNardCtx.Data.Free; aNardCtx.Data := nil;
 Log('Disconnect ip:' + aNardCtx.Binding.PeerIP);
 trigDisconnect;
end;

procedure tNardServer.OnStatus(ASender: TObject;const AStatus: TIdStatus; const AStatusText: string);
begin
 //
 DoStatus(AStatusText);
end;

procedure tNardServer.OnException(aContext: tIdContext;AException: Exception);
begin
 //
  LogError(AException.Message);
end;

procedure tNardServer.DoError;
begin
 if Assigned(fCommsError) then fCommsError(nil);
end;

procedure tNardServer.DoStatus(AStatus: string);
begin
 if Assigned(fStatus) then fStatus(nil, AStatus);
end;

procedure tNardServer.DoLog;
begin
 if Assigned(fLogEvent) then fLogEvent(nil);
end;

procedure tNardServer.DoNewNard;
begin
 if Assigned(fNewNard) then fNewNard(nil);
end;

procedure tNardServer.DoSetVar;
begin
 if Assigned(fSetVar) then fSetVar(nil);
end;


procedure tNardServer.DoDisconnect;
begin
 if Assigned(fDisconnect) then fDisconnect(nil);
end;

function tNardServer.PopLog: string;
begin
  fCrit.Enter;
   try
   result := ''; if fLogQue.Count > 0 then result := fLogQue.Dequeue;
   finally fCrit.Leave;
   end;
end;

function tNardServer.PopErrorLog: string;
begin
fCrit.Enter;
  try
  result := '';
  if fErrorQue.Count > 0 then result :=fErrorQue.Dequeue;
  finally fCrit.Leave;
  end;
end;

procedure tNardServer.OnExecute(aContext: tIdContext);
var
i: integer;
aHdr: tPacketHdr; aBuff: TIdBytes; aGoodRead: boolean;
aPacketCxt: tNardCntx;
begin
 aPacketCxt := nil;
  // get out nard client object, stored in Data
  if Assigned(aContext.Data) then aPacketCxt := tNardCntx(aContext.Data);
  if Assigned(aPacketCxt) then
  begin
         // sends an outgoing packet
        if aPacketCxt.fCommandID<>GetCommandID then
          begin
           aPacketCxt.Process(aContext);
           // context sent an outgoing count it and zero it..
           if aPacketCxt.PacketsSent > 0 then
            begin IncSent;
            aPacketCxt.ZeroSent;
            end;
           // aPacketCxt.fCommandID:=GetCommandID;
          end;


         // try to read in a packet header..
         SetLength(aBuff, SizeOf(tPacketHdr));
         aGoodRead := false;
         aContext.Connection.IOHandler.CheckForDisconnect(true, true);
         i := aContext.Connection.IOHandler.InputBuffer.Size;

         if i >= SizeOf(tPacketHdr) then
           begin
            try aContext.Connection.IOHandler.ReadBytes(aBuff, SizeOf(tPacketHdr), false);
            aGoodRead := true;
            except on e: Exception do
             begin
             // swallow
             if e is EidReadTimeOut  then
             aGoodRead := false else
             LogError('ThrdExec Error:'+e.Message);
             end;
           end;
          end;

    if aGoodRead then
      begin
         if Length(aBuff) = SizeOf(tPacketHdr)then
           begin Move(aBuff[0], aHdr, SizeOf(tPacketHdr));
            if CheckIdent(aHdr) then
               begin IncRecv;
               // store header in context
               Move(aHdr, aPacketCxt.fHdr, SizeOf(tPacketHdr));
               if aHdr.DataSize > 0 then
                 begin
                  // need to get more data
                  SetLength(aBuff, aHdr.DataSize);
                  aContext.Connection.IOHandler.ReadBytes(aBuff, aHdr.DataSize, false);
                  if Length(aBuff) = aHdr.DataSize then
                   begin
                    // store extra data in fbuff -context
                    SetLength(aPacketCxt.fBuff, aHdr.DataSize);
                    Move(aBuff[0], aPacketCxt.fBuff[0], aHdr.DataSize);
                    // recv the packet..
                    piRecvPacket(aPacketCxt);
                    SetLength(aBuff, 0);
                   end else
                   begin
                    // bad size
                    IncBad; SetLength(aPacketCxt.fBuff, 0);
                    SetLength(aBuff, 0);
                    Log('Bad Data Buffer Size ' + aContext.Binding.PeerIP);
                   end;
                end else
                 begin
                  // recv the packet.. just a header..
                 piRecvPacket(aPacketCxt);
                 SetLength(aPacketCxt.fBuff, 0);
                 SetLength(aBuff, 0);
                 end;
             end else
              begin
              // bad ident
              SetLength(aPacketCxt.fBuff, 0);
              SetLength(aBuff, 0); IncBad;
              Log('Bad Ident Recvd ' + aContext.Binding.PeerIP);
              end;
            end else
              begin
               // bad buf size
              SetLength(aPacketCxt.fBuff, 0);
              SetLength(aBuff, 0); IncBad;
               Log('Bad Header Buffer Size ' + aContext.Binding.PeerIP);
               end;
      end;

  end;
       //take a nap
        sleep(1);
end;

function tNardServer.CheckIdent(aHdr: tPacketHdr): boolean;
var i: integer;
begin result := true;
 for i := Low(aHdr.Ident) to High(aHdr.Ident) do
  if aHdr.Ident[i] <>Ident_Packet[i] then result := false;
end;

procedure tNardServer.piRecvPacket(aPacketCtx: tNardCntx);
begin
        // process incoming packets, do a case on the incoming commands
      //  Log('Processing Packet Command:' + IntToStr(aPacketCtx.fHdr.Command) +
       //   ' from ip:' + aPacketCtx.Context.Binding.PeerIP);


        case aPacketCtx.fHdr.Command of
         CMD_NOP: piRecvNOP(aPacketCtx);
         CMD_NAK: piRecvNAK(aPacketCtx);
         CMD_REG: piRecvReg(aPacketCtx);
         CMD_SET: piRecvSet(aPacketCtx);
         CMD_GET: piRecvGet(aPacketCtx);
         CMD_SETNLOG: piRecvSetnLog(aPacketCtx);
         CMD_HASH: piRecvHash(aPacketCtx);
         CMD_PARAMS: begin
                       case aPacketCtx.fHdr.Option[0] of
                       PARAMS_GET: piRecvGetParams(aPacketCtx);
                       PARAMS_SET: piRecvSetParams(aPacketCtx);
                       PARAMS_SETNLOG: piRecvSetnLogParams(aPacketCtx);
                       end;
                     end;
         CMD_SETID: piSetCommandId(aPacketCtx);
        end;

end;

procedure tNardServer.piRecvNOP(aPacketCtx: tNardCntx);
var aBuff: TIdBytes;
begin
 // server just sends a nop back
 SetLength(aBuff, SizeOf(tPacketHdr));
 Move(aPacketCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
 aPacketCtx.Context.Connection.IOHandler.Write(aBuff);
 SetLength(aBuff, 0); IncSent;
end;

procedure tNardServer.piRecvNAK(aPacketCtx: tNardCntx);
begin
   //why o' why..
   LogError('NAK: Option 0:'+IntToStr( aPacketCtx.fHdr.Option[0])+'Option 1:'+
    IntToStr( aPAcketCtx.fHdr.Option[1])+' NardIp:' + aPacketCtx.Context.Binding.PeerIP);
end;

procedure tNardServer.piSetCommandID(aNardCtx: tNardCntx);
var
aInt: Int32;//32 bits signed..
failed:boolean;
begin
 //
         failed:=false;
        if sizeOf(aNardCtx.fBuff) = sizeOf(Int32) then
         move(aNardCtx.fBuff[0],aInt,SizeOf(Int32)) else Failed := true;
       if not failed then
          begin
           SetCommandId(aInt);
          end;
end;


procedure tNardServer.piRecvReg(aNardCtx: tNardCntx);
var
 aBuff: TIdBytes;
 aReg: tRegStruct;
 aName, aIp: string;
 regFailed: boolean;
begin
 // try to register this nard..
 regFailed := false;

 if (Length(aNardCtx.fBuff) = SizeOf(tRegStruct)) then
  begin Move(aNardCtx.fBuff[0], aReg, SizeOf(tRegStruct));

  if (aReg.NardID > 0) and (aReg.NardID < 1000) then
   begin
        // set connection properties
        aNardCtx.fDbConn.HostName := aNardCtx.fDbHost;
        aNardCtx.fDbConn.Port := aNardCtx.fDbPort;
        aNardCtx.fDbConn.Database := aNardCtx.fDbName;
        aNardCtx.fDbConn.User := aNardCtx.fDbUser;
        aNardCtx.fDbConn.Password := aNardCtx.fDbPass;
        // connect to db
        aNardCtx.fDbConn.Connect; aNardCtx.fQryGen.SQL.Clear;
        aNardCtx.fQryGen.SQL.Add('select * from ards');
        aNardCtx.fQryGen.SQL.Add('where ardid= ' + IntToStr(aReg.NardID));
       try
        aNardCtx.fQryGen.Active := true;
        except on e:exception do
         begin
             LogError('NardCtx:Error opening ARDS: ' +e.Message + ' from ip:' + aNardCtx.Context.Binding.PeerIP);
             aNardCtx.fRegged := false;
            // drop db conn
            aNardCtx.fDbConn.Connected := false;
            // send a nak
            SetLength(aBuff, SizeOf(tPacketHdr));
            aNardCtx.fHdr.Command := CMD_NAK;
            aNardCtx.fHdr.Option[0] := CMD_REG;
            aNardCtx.fHdr.DataSize := 0;
            Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
            aNardCtx.Context.Connection.IOHandler.Write(aBuff);
            SetLength(aBuff, 0);
            IncSent;
            regFailed := true;
            exit;//outta here..
         end;
       end;


        if aNardCtx.fQryGen.RecordCount = 0 then
          begin
          // a new nard!!
          aName := TEncoding.ASCII.GetString(aReg.DisplayName);
          aName:=Trim(aName);
          if aName='' then aName:='Nard';
          aName:='Nard';
          //aIp := TEncoding.ASCII.GetString(aReg.IpAddress);
         // aIp:=Trim(aIp);
          aIp:=aNardCtx.Context.Binding.PeerIP;

          aNardCtx.fQryGen.Active := false; aNardCtx.fQryGen.SQL.Clear;
          aNardCtx.fQryGen.SQL.Add('insert into ards');
          aNardCtx.fQryGen.SQL.Add('(ARDID, GROUPID, PROCESSID, DISPLAYNAME, LASTIP, LASTCONNECTION, ONLINE)');
          aNardCtx.fQryGen.SQL.Add('Values ( ' + IntToStr(aReg.NardID) + ', ' +IntToStr(aReg.GroupID) + ', ' + IntToStr(aReg.ProcessID) + ' ,'+
          '''' + aName + ''', ' + '''' + aIp +''', CURRENT_TIMESTAMP, true )');
          try aNardCtx.fQryGen.ExecSQL;
           except on e: Exception do
             begin
             LogError('NardCtx:ExecSQL Error: ' +e.Message + ' from ip:' + aNardCtx.Context.Binding.PeerIP);
             aNardCtx.fRegged := false;
             // drop db conn
             aNardCtx.fDbConn.Connected := false;
               // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr)); aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_REG; aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff); SetLength(aBuff, 0);
             IncSent; regFailed := true;
             end;
          end;
          if (not regFailed) then
           begin aNardCtx.fRegged := true;
            // we are rigistered..
           // send an ak
           aNardCtx.fHdr.Command := CMD_ACK;
           aNardCtx.fHdr.Option[0] := CMD_REG;
           aNardCtx.fHdr.DataSize := 0;
           aNardCtx.fNardID := aReg.NardID;
           SetLength(aBuff, SizeOf(tPacketHdr));
           Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
           aNardCtx.Context.Connection.IOHandler.Write(aBuff);
           SetLength(aBuff, 0);
           IncSent;
           trigNewNard;
           end;

         end
          else if aNardCtx.fQryGen.RecordCount = 1 then
         begin
         //  aIp :=TEncoding.ASCII.GetString(aReg.IpAddress);
          // aIp := Trim(IP);

            // a returning nard!!
            aNardCtx.fQryGen.Active := false;
            aNardCtx.fQryGen.SQL.Clear;
            aNardCtx.fQryGen.SQL.Add('UPDATE ARDS a SET a.GroupID= ' +IntToStr(aReg.GroupID) + ', ');
            aNardCtx.fQryGen.SQL.Add('a.ProcessID = ' + IntToStr(aReg.ProcessID) +', '); aNardCtx.fQryGen.SQL.Add('a.LastIP = ''' + aIp + ''', ');
            aNardCtx.fQryGen.SQL.Add('a.LastConnection = CURRENT_TIMESTAMP, ');
            aNardCtx.fQryGen.SQL.Add('a.Online = TRUE');
            aNardCtx.fQryGen.SQL.Add('WHERE a.ARDID = ' +IntToStr(aReg.NardID) + ' ;');

          try aNardCtx.fQryGen.ExecSQL except on e: Exception do
           begin
            LogError('NardCtx:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
            aNardCtx.fRegged := false;
            // drop db conn
            aNardCtx.fDbConn.Connected := false;
            // send a nak
            SetLength(aBuff, SizeOf(tPacketHdr));
            aNardCtx.fHdr.Command := CMD_NAK;
            aNardCtx.fHdr.Option[0] := CMD_REG;
            aNardCtx.fHdr.DataSize := 0;
            Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
            aNardCtx.Context.Connection.IOHandler.Write(aBuff);
            SetLength(aBuff, 0);
            IncSent;
            regFailed := true;
           end;
          end;

          if (not regFailed) then
            begin
            // send an ak
            aNardCtx.fRegged := true; // we are rigistered..
            aNardCtx.fHdr.Command := CMD_ACK;
            aNardCtx.fHdr.Option[0] := CMD_REG;
            aNardCtx.fHdr.DataSize := 0;
            aNardCtx.fNardID := aReg.NardID;
            SetLength(aBuff, SizeOf(tPacketHdr));
            Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
            aNardCtx.Context.Connection.IOHandler.Write(aBuff);
            SetLength(aBuff, 0);
            IncSent;
            trigNewNard;
            end;
         end else
          begin
           // too many?? go away!!
           // send nak
           LogError('NardCtx: ' + IntToStr(aReg.NardID) +' :Error -too many records on same ID : from ip: ' +aNardCtx.Context.Binding.PeerIP);
           SetLength(aBuff, SizeOf(tPacketHdr));
           aNardCtx.fHdr.Command := CMD_NAK;
           aNardCtx.fHdr.Option[0] := CMD_REG;
           aNardCtx.fHdr.DataSize := 0;
           Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
           aNardCtx.Context.Connection.IOHandler.Write(aBuff);
           SetLength(aBuff, 0);
           IncSent;
          end;
   end else
     begin
     // invalid ardID
     LogError('NardCtx: ' + IntToStr(aReg.NardID) + ' :ID Error from ip: ' +aNardCtx.Context.Binding.PeerIP);
     SetLength(aBuff, SizeOf(tPacketHdr));
     aNardCtx.fHdr.Command := CMD_NAK;
     aNardCtx.fHdr.Option[0] := CMD_REG;
     aNardCtx.fHdr.DataSize := 0;
     Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
     aNardCtx.Context.Connection.IOHandler.Write(aBuff);
     SetLength(aBuff, 0);
     IncSent;
     end;

  end else
       begin
        // size mismatch!!
        LogError('NardCtx:Size Error from ip:' +aNardCtx.Context.Binding.PeerIP);
        SetLength(aBuff, SizeOf(tPacketHdr));
        aNardCtx.fHdr.Option[0] := CMD_REG;
        aNardCtx.fHdr.Command := CMD_NAK;
        aNardCtx.fHdr.DataSize := 0;
        Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
        aNardCtx.Context.Connection.IOHandler.Write(aBuff);
        SetLength(aBuff, 0);
        IncSent;
       end;

end;

procedure tNardServer.piRecvSet(aNardCtx: tNardCntx);
var
aInt: Int32;//32 bits signed..
aDouble:double;//8 byte float..
aSingle:single;//4 byte float..
alu : UInt32;//unsigned 32 bit
aBuff: TIdBytes;
SetFailed: boolean;
aStrm:tMemoryStream;
 begin
 // set a value
 if not aNardCtx.fRegged then exit; // outta here..
 SetFailed := false;

  if (aNardCtx.fHdr.Option[1] <= SG_FLT8) then
    begin
    // numbers
    aInt := 0;
    aDouble:=0;
    aSingle:=0;
    alu:=0;
    if aNardCtx.fHdr.Option[1] = SG_BYTE then aInt :=aNardCtx.fHdr.Option[2];//byte
    if aNardCtx.fHdr.Option[1] = SG_WORD then aInt :=aNardCtx.fHdr.Option[2] shl 8 or aNardCtx.fHdr.Option[3]; //word
    if aNardCtx.fHdr.Option[1] = SG_INT16 then aInt :=aNardCtx.fHdr.Option[2] shl 8 or aNardCtx.fHdr.Option[3]; //int_16
    if aNardCtx.fHdr.Option[1] = SG_INT32 then  //int32
      begin
       if sizeOf(aNardCtx.fBuff) = sizeOf(Int32) then
         move(aNardCtx.fBuff[0],aInt,SizeOf(Int32)) else SetFailed := true;
      end;
    if aNardCtx.fHdr.Option[1] = SG_UINT32 then  //unit32
      begin
       if sizeOf(aNardCtx.fBuff) = sizeOf(UInt32) then
         move(aNardCtx.fBuff[0],alu,SizeOf(UInt32)) else SetFailed := true;
      end;
    if (aNardCtx.fHdr.Option[1] = SG_FLT4) or (aNardCtx.fHdr.Option[1] = SG_FLT8) then   //floats
      begin
       if Length(aNardCtx.fBuff) = sizeOf(single) then
        begin
         move(aNardCtx.fBuff[0],aSingle,SizeOf(single));
         aDouble:=aSingle;
         end else
         if Length(aNardCtx.fBuff) = sizeOf(double) then
           begin
            move(aNardCtx.fBuff[0],aDouble,SizeOf(double));
            end else SetFailed:=true;
      end;

     if not SetFailed then
      begin
       aNardCtx.fQryGen.Active := false;
       aNardCtx.fQryGen.SQL.Clear;
       if (aNardCtx.fHdr.Option[1] < SG_FLT4) then
        begin //not floats
         aNardCtx.fQryGen.SQL.Add('UPDATE OR INSERT INTO ARDVALUES (ARDID, VALINDEX, VALUEINT)');
         if aNardCtx.fHdr.Option[1] < SG_UINT32 then
           aNardCtx.fQryGen.SQL.Add('VALUES(' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[0]) + ',' + IntToStr(aInt) + ')') else
           aNardCtx.fQryGen.SQL.Add('VALUES(' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[0]) + ',' + IntToStr(alu) + ')');
        end else

         if (aNardCtx.fHdr.Option[1] = SG_FLT4) or (aNardCtx.fHdr.Option[1] = SG_FLT8) then
          begin //floats
          aNardCtx.fQryGen.SQL.Add('UPDATE OR INSERT INTO ARDVALUES (ARDID, VALINDEX, VALUEFLOAT)');
          aNardCtx.fQryGen.SQL.Add('VALUES(' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[0]) + ',' + FloatToStr(aDouble) + ')');
          end;

        aNardCtx.fQryGen.SQL.Add('MATCHING (ARDID, VALINDEX)');
         try aNardCtx.fQryGen.ExecSQL;
           except on e: Exception do
            begin
             LogError('NardCtx:SetValue:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
             // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_SET;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
            IncSent;
            end;

         end;
      end;

      if not SetFailed then
       begin
        // send an ack
        SetLength(aBuff, SizeOf(tPacketHdr));
        aNardCtx.fHdr.Command := CMD_ACK;
        aNardCtx.fHdr.Option[0] := CMD_SET;
        aNardCtx.fHdr.Option[1] := 0;
        aNardCtx.fHdr.Option[2] := 0;
        aNardCtx.fHdr.Option[3] := 0;
        aNardCtx.fHdr.DataSize := 0;
        Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
        aNardCtx.Context.Connection.IOHandler.Write(aBuff);
        SetLength(aBuff, 0);
        IncSent;
        TrigSetVar;
        end else
            begin
             LogError('NardCtx:SetValue:Sizing Error:  from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
             // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_SET;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
            IncSent;
            end;


    end else
        begin
        //saving a jpeg??
         if (aNardCtx.fHdr.Option[1] = SG_JPG) AND (aNardCtx.fHdr.DataSize>0) then
          begin
            aStrm:=tMemoryStream.Create;
            aStrm.SetSize( aNardCtx.fHdr.DataSize);
            aStrm.Write(aNardCtx.fBuff, aNardCtx.fHdr.DataSize);
            aStrm.Position:=0;
            aNardCtx.fQryGen.Active := false;
            aNardCtx.fQryGen.SQL.Clear;
            aNardCtx.fQryGen.SQL.Add('INSERT INTO LOGIMG (STAMP, ARDID, IMAGE)');
            aNardCtx.fQryGen.SQL.Add('VALUES( CURRENT_TIMESTAMP,' + IntToStr(aNardCtx.fNardID) + ', :IMG );');
            aNardCtx.fQryGen.ParamByName('IMG').LoadFromStream(aStrm);
            aStrm.Destroy;
           try aNardCtx.fQryGen.ExecSQL;
              except on e: Exception do
              begin
               LogError('NardCtx:SetValue:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
                SetFailed := true;
               // send a nak
               SetLength(aBuff, SizeOf(tPacketHdr));
               aNardCtx.fHdr.Command := CMD_NAK;
               aNardCtx.fHdr.Option[0] := CMD_SET;
               aNardCtx.fHdr.Option[1] := 0;
               aNardCtx.fHdr.Option[2] := 0;
               aNardCtx.fHdr.Option[3] := 0;
               aNardCtx.fHdr.DataSize := 0;
               Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
               aNardCtx.Context.Connection.IOHandler.Write(aBuff);
               SetLength(aBuff, 0);
              IncSent;

              end;

           end;
           if not SetFailed then
            begin
            // send an ack
            SetLength(aBuff, SizeOf(tPacketHdr));
            aNardCtx.fHdr.Command := CMD_ACK;
            aNardCtx.fHdr.Option[0] := CMD_SET;
            aNardCtx.fHdr.Option[1] := 0;
            aNardCtx.fHdr.Option[2] := 0;
            aNardCtx.fHdr.Option[3] := 0;
            aNardCtx.fHdr.DataSize := 0;
            Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
            aNardCtx.Context.Connection.IOHandler.Write(aBuff);
            SetLength(aBuff, 0);
            IncSent;
            TrigSetVar;
            end;
          end;
        end;
 end;


procedure tNardServer.piRecvSetnLog(aNardCtx: tNardCntx);
var
aInt: Int32;
aDouble:double;//8 byte float..
aSingle:single;//4 byte float..
alu : UInt32;//unsigned 32 bit
aStrm:tMemoryStream;
aBuff: TIdBytes;
SetFailed: boolean;
 begin
 // set a value
 if not aNardCtx.fRegged then exit; // outta here..
 SetFailed := false;

  if (aNardCtx.fHdr.Option[1] <= SG_FLT8) then
    begin
    // ints
    aInt := 0;
    if aNardCtx.fHdr.Option[1] = SG_BYTE then  aInt := aNardCtx.fHdr.Option[2];
    if aNardCtx.fHdr.Option[1] = SG_WORD then  aInt := aNardCtx.fHdr.Option[2] shl 8 or aNardCtx.fHdr.Option[3];
    if aNardCtx.fHdr.Option[1] = SG_INT16 then aInt := aNardCtx.fHdr.Option[2] shl 8 or aNardCtx.fHdr.Option[3];
    if aNardCtx.fHdr.Option[1] = SG_INT32 then
      begin
       if sizeOf(aNardCtx.fBuff) = sizeOf(Int32) then
         move(aNardCtx.fBuff[0],aInt,SizeOf(Int32)) else SetFailed := true;
      end;
    if aNardCtx.fHdr.Option[1] = SG_UINT32 then  //unit32
      begin
       if sizeOf(aNardCtx.fBuff) = sizeOf(UInt32) then
         move(aNardCtx.fBuff[0],alu,SizeOf(UInt32)) else SetFailed := true;
      end;
    if (aNardCtx.fHdr.Option[1] = SG_FLT4) or (aNardCtx.fHdr.Option[1] = SG_FLT8) then   //floats
      begin
       if sizeOf(aNardCtx.fBuff) = sizeOf(single) then
        begin
         move(aNardCtx.fBuff[0],aSingle,SizeOf(single));
         aDouble:=aSingle;
         end else
         if sizeOf(aNardCtx.fBuff) = sizeOf(double) then
            move(aNardCtx.fBuff[0],aDouble,SizeOf(double)) else SetFailed:=true;
      end;

     if not SetFailed then
      begin
        aNardCtx.fQryGen.Active := false;
        aNardCtx.fQryGen.SQL.Clear;
           if (aNardCtx.fHdr.Option[1] < SG_FLT4) then
           begin //not floats
           aNardCtx.fQryGen.SQL.Add('UPDATE OR INSERT INTO ARDVALUES (ARDID, VALINDEX, VALUEINT)');
            if aNardCtx.fHdr.Option[1] < SG_UINT32 then
              aNardCtx.fQryGen.SQL.Add('VALUES(' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[0]) + ',' + IntToStr(aInt) + ')') else
           aNardCtx.fQryGen.SQL.Add('VALUES(' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[0]) + ',' + IntToStr(alu) + ')');
           end else

         if (aNardCtx.fHdr.Option[1] = SG_FLT4) or  (aNardCtx.fHdr.Option[1] = SG_FLT8) then
          begin //floats
          aNardCtx.fQryGen.SQL.Add('UPDATE OR INSERT INTO ARDVALUES (ARDID, VALINDEX, VALUEFLOAT)');
          aNardCtx.fQryGen.SQL.Add('VALUES(' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[0]) + ',' + FloatToStr(aDouble) + ')');
          end;

        aNardCtx.fQryGen.SQL.Add('MATCHING (ARDID, VALINDEX)');
          try aNardCtx.fQryGen.ExecSQL;
            except on e: Exception do
             begin
              LogError('NardCtx:SetValue:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
              // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_SETNLOG;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
             IncSent;
             exit;
            end;
          end;

      end;


      if not SetFailed then
       begin
       //now log it..
        aNardCtx.fQryGen.Active := false;
        aNardCtx.fQryGen.SQL.Clear;
        if (aNardCtx.fHdr.Option[1] < SG_FLT4) then
         begin
          aNardCtx.fQryGen.SQL.Add('INSERT INTO LOGDATA (STAMP, ARDID, VALUETYPE, VALUEINDEX, VALUEINT)');
           if (aNardCtx.fHdr.Option[1] < SG_UINT32) then
          aNardCtx.fQryGen.SQL.Add('VALUES( CURRENT_TIMESTAMP,' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[1])+
           ','+ IntToStr(aNardCtx.fHdr.Option[0])+ ',' + IntToStr(aInt) + ')') else
          aNardCtx.fQryGen.SQL.Add('VALUES( CURRENT_TIMESTAMP,' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[1])+
           ','+ IntToStr(aNardCtx.fHdr.Option[0])+ ',' + IntToStr(alu) + ')');
         end else
           begin
            aNardCtx.fQryGen.SQL.Add('INSERT INTO LOGDATA (STAMP, ARDID, VALUETYPE, VALUEINDEX, VALUEFLOAT)');
            aNardCtx.fQryGen.SQL.Add('VALUES( CURRENT_TIMESTAMP,' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[1])+
            ','+ IntToStr(aNardCtx.fHdr.Option[0])+ ',' + FloatToStr(aDouble) + ')');
           end;

         try aNardCtx.fQryGen.ExecSQL;
           except on e: Exception do
            begin
             LogError('NardCtx:LogValue:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
             SetFailed := true;
            // send a nak
            SetLength(aBuff, SizeOf(tPacketHdr));
            aNardCtx.fHdr.Command := CMD_NAK;
            aNardCtx.fHdr.Option[0] := CMD_SETNLOG;
            aNardCtx.fHdr.Option[1] := 0;
            aNardCtx.fHdr.Option[2] := 0;
            aNardCtx.fHdr.Option[3] := 0;
            aNardCtx.fHdr.DataSize := 0;
            Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
            aNardCtx.Context.Connection.IOHandler.Write(aBuff);
            SetLength(aBuff, 0);
            IncSent;
            exit;
            end;

         end;


        //set and logged.. send an ack back..
        if not SetFailed then
         begin
          // send an ack
          SetLength(aBuff, SizeOf(tPacketHdr));
          aNardCtx.fHdr.Command := CMD_ACK;
          aNardCtx.fHdr.Option[0] := CMD_SETNLOG;
          aNardCtx.fHdr.Option[1] := 0;
          aNardCtx.fHdr.Option[2] := 0;
          aNardCtx.fHdr.Option[3] := 0;
          aNardCtx.fHdr.DataSize := 0;
          Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
          aNardCtx.Context.Connection.IOHandler.Write(aBuff);
          SetLength(aBuff, 0);
          IncSent;
            trigSetVar;
         end else
           begin
             LogError('NardCtx:LogValue:Sizing Error from ip:' +aNardCtx.Context.Binding.PeerIP);
             SetFailed := true;
            // send a nak
            SetLength(aBuff, SizeOf(tPacketHdr));
            aNardCtx.fHdr.Command := CMD_NAK;
            aNardCtx.fHdr.Option[0] := CMD_SETNLOG;
            aNardCtx.fHdr.Option[1] := 0;
            aNardCtx.fHdr.Option[2] := 0;
            aNardCtx.fHdr.Option[3] := 0;
            aNardCtx.fHdr.DataSize := 0;
            Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
            aNardCtx.Context.Connection.IOHandler.Write(aBuff);
            SetLength(aBuff, 0);
            IncSent;

           end;
        end;

    end else
         begin
        //saving a jpeg??
         if (aNardCtx.fHdr.Option[1] = SG_JPG) AND (aNardCtx.fHdr.DataSize>0) then
          begin
           //  Log('Saving Jpeg size:'+IntToStr(aNardCtx.fHdr.DataSize));
            aStrm:=tMemoryStream.Create;
            aStrm.SetSize( aNardCtx.fHdr.DataSize);
            aStrm.Write(aNardCtx.fBuff, aNardCtx.fHdr.DataSize);
            aStrm.Position:=0;
            aNardCtx.fQryGen.Active := false;
            aNardCtx.fQryGen.SQL.Clear;
            aNardCtx.fQryGen.SQL.Add('INSERT INTO LOGIMG (STAMP, ARDID, IMAGE)');
            aNardCtx.fQryGen.SQL.Add('VALUES( CURRENT_TIMESTAMP,' + IntToStr(aNardCtx.fNardID) + ', :IMG );');
            aNardCtx.fQryGen.ParamByName('IMG').LoadFromStream(aStrm);
            aStrm.Destroy;
           try
             aNardCtx.fQryGen.ExecSQL;
              except on e: Exception do
              begin
               LogError('NardCtx:SetValue:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
                SetFailed := true;
               // send a nak
               SetLength(aBuff, SizeOf(tPacketHdr));
               aNardCtx.fHdr.Command := CMD_NAK;
               aNardCtx.fHdr.Option[0] := CMD_SET;
               aNardCtx.fHdr.Option[1] := 0;
               aNardCtx.fHdr.Option[2] := 0;
               aNardCtx.fHdr.Option[3] := 0;
               aNardCtx.fHdr.DataSize := 0;
               Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
               aNardCtx.Context.Connection.IOHandler.Write(aBuff);
               SetLength(aBuff, 0);
              IncSent;
              end;

           end;
           if not SetFailed then
            begin
            // send an ack
            SetLength(aBuff, SizeOf(tPacketHdr));
            aNardCtx.fHdr.Command := CMD_ACK;
            aNardCtx.fHdr.Option[0] := CMD_SET;
            aNardCtx.fHdr.Option[1] := 0;
            aNardCtx.fHdr.Option[2] := 0;
            aNardCtx.fHdr.Option[3] := 0;
            aNardCtx.fHdr.DataSize := 0;
            Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
            aNardCtx.Context.Connection.IOHandler.Write(aBuff);
            SetLength(aBuff, 0);
            IncSent;
            trigSetVar;
            end;
          end;


        end;

 end;




procedure tNardServer.piRecvGet(aNardCtx: tNardCntx);
var
aInt : Int32;//32 bits signed..
aDouble : double;//8 byte float..
aSingle : single;//4 byte float..
alu : UInt32;//unsigned 32 bit
aBuff: TIdBytes;
failed: boolean;

 begin
 // get a value
 if not aNardCtx.fRegged then exit; // outta here..
 failed := false;
 aInt:=0;
 aDouble:=0;
 aSingle:=0;
 alu:=0;

  if (aNardCtx.fHdr.Option[1] <= SG_FLT8) then
   begin
   // ints
   aInt := 0;
   aNardCtx.fQryGen.Active := false;
   aNardCtx.fQryGen.SQL.Clear;
   if (aNardCtx.fHdr.Option[1] < SG_FLT4) then
   aNardCtx.fQryGen.SQL.Add('Select ValueInt from ARDVALUES') else
   aNardCtx.fQryGen.SQL.Add('Select ValueFloat from ARDVALUES');

   aNardCtx.fQryGen.SQL.Add('Where ArdID=' + IntToStr(aNardCtx.fNardID) +' AND ValIndex=' + IntToStr(aNardCtx.fHdr.Option[0]));
     try
      aNardCtx.fQryGen.Active := true;
      except on e: Exception do
        begin
         LogError('NardCtx:GetValue:SQL Error: '+ e.Message + ' from ip:' + aNardCtx.Context.Binding.PeerIP);
         failed := true;
         // send a nak
         SetLength(aBuff, SizeOf(tPacketHdr));
         aNardCtx.fHdr.Command := CMD_NAK;
         aNardCtx.fHdr.Option[0] := CMD_GET;
         aNardCtx.fHdr.Option[1] := 0;
         aNardCtx.fHdr.Option[2] := 0;
         aNardCtx.fHdr.Option[3] := 0;
         aNardCtx.fHdr.DataSize := 0;
         Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
         aNardCtx.Context.Connection.IOHandler.Write(aBuff);
         SetLength(aBuff, 0);
         IncSent;
         exit;
        end;
     end;

       if aNardCtx.fQryGen.RecordCount = 0 then
         begin
         aNardCtx.fQryGen.Active:=false;
         LogError('NardCtx:GetValue:Error:No Records for index  from ip:' + aNardCtx.Context.Binding.PeerIP);
         failed := true;
         end else
           begin
             // check for nulls
             if aNardCtx.fQryGen.FieldCount = 0 then
              failed := true else
               if aNardCtx.fQryGen.Fields[0].IsNull then
                 failed := true;
               if failed then
                 begin
                 aNardCtx.fQryGen.Active:=false;
                 LogError('NardCtx:GetValue:Error:Null value for index  from ip:' + aNardCtx.Context.Binding.PeerIP);
                 end;
           end;



       if failed then
         begin
         // send a nak
         SetLength(aBuff, SizeOf(tPacketHdr));
         aNardCtx.fHdr.Command := CMD_NAK;
         aNardCtx.fHdr.Option[0] := CMD_GET;
         aNardCtx.fHdr.Option[1] := 0;
         aNardCtx.fHdr.Option[2] := 0;
         aNardCtx.fHdr.Option[3] := 0;
         aNardCtx.fHdr.DataSize := 0;
         Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
         aNardCtx.Context.Connection.IOHandler.Write(aBuff);
         SetLength(aBuff, 0);
         IncSent;
         exit;
         end;


     if not failed then
      begin
        // send data back
        if (aNardCtx.fHdr.Option[1] < SG_FLT4) then
          begin
           if (aNardCtx.fHdr.Option[1] < SG_UINT32) then
           aInt := aNardCtx.fQryGen.Fields[0].AsInteger else
           alu := aNardCtx.fQryGen.Fields[0].AsInteger
          end else
            begin
             if (aNardCtx.fHdr.Option[1] = SG_FLT4) then
             aSingle:= aNardCtx.fQryGen.Fields[0].AsFloat else
             aDouble:= aNardCtx.fQryGen.Fields[0].AsFloat;
            end;

        aNardCtx.fQryGen.Active := false;
        aNardCtx.fHdr.Option[2]:=0;
        aNardCtx.fHdr.Option[3]:=0;

        if aNardCtx.fHdr.Option[1]  = SG_BYTE then aNardCtx.fHdr.Option[2] := aInt and $FF;

        if (aNardCtx.fHdr.Option[1] = SG_WORD) or
           (aNardCtx.fHdr.Option[1] = SG_INT16 ) then
         begin
          aNardCtx.fHdr.Option[3] := aInt and $FF;
          aNardCtx.fHdr.Option[2] := aInt shr 8;
         end;

        // size the outgoing buff..
        SetLength(aBuff, SizeOf(tPacketHdr));
        // send a set command back
        aNardCtx.fHdr.Command := CMD_SET;
        aNardCtx.fHdr.DataSize := 0;



        if (aNardCtx.fHdr.Option[1] = SG_INT32) or
            (aNardCtx.fHdr.Option[1] = SG_UINT32) then
          begin
            aNardCtx.fHdr.DataSize := SizeOf(Int32);
            //resize outgoing buffer..
            SetLength(aBuff,SizeOf(tPacketHdr)+SizeOf(Int32));
           if (aNardCtx.fHdr.Option[1] = SG_INT32) then
             Move(aInt,aBuff[SizeOf(tPacketHdr)],SizeOf(Int32)) else
                if (aNardCtx.fHdr.Option[1] = SG_UINT32) then
                  Move(alu,aBuff[SizeOf(tPacketHdr)],SizeOf(Int32));
          end;

        if aNardCtx.fHdr.Option[1] = SG_FLT4 then
          begin
            aNardCtx.fHdr.DataSize := SizeOf(single);
            //resize outgoing buffer..
            SetLength(aBuff,SizeOf(tPacketHdr)+SizeOf(single));
            Move(aSingle,aBuff[SizeOf(tPacketHdr)],SizeOf(single));
          end;

        if aNardCtx.fHdr.Option[1] = SG_FLT8 then
          begin
            aNardCtx.fHdr.DataSize := SizeOf(double);
            //resize outgoing buffer..
            SetLength(aBuff,SizeOf(tPacketHdr)+SizeOf(double));
            Move(aDouble,aBuff[SizeOf(tPacketHdr)],SizeOf(double));
          end;


        //move header in
        Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
        //send it off..
        aNardCtx.Context.Connection.IOHandler.Write(aBuff);
        SetLength(aBuff, 0);
        IncSent;
      end;

   end else
    begin
        // ??

    end;

 end;

 procedure tNardServer.piRecvHash(aNardCtx: tNardCntx);
var
alu : UInt32;//unsigned 32 bit
aBuff: TIdBytes;
SetFailed: boolean;
aStrm:tMemoryStream;
 begin
 // set a value
 if not aNardCtx.fRegged then exit; // outta here..
 SetFailed := false;

  if (aNardCtx.fHdr.Option[0] = HASH_CHECK) then
    begin
    //recv a hash
    alu:=0;
       if sizeOf(aNardCtx.fBuff) = sizeOf(UInt32) then
         move(aNardCtx.fBuff[0],alu,SizeOf(UInt32)) else
         begin
             LogError('NardCtx:RecvHash:Buffer Size Error from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
             // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_HASH;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
            IncSent;
            exit;
         end;


     if not SetFailed then
      begin
          aNardCtx.fQryGen.Active := false;
          aNardCtx.fQryGen.SQL.Clear;
          aNardCtx.fQryGen.SQL.Add('Select * from Hashes');
          aNardCtx.fQryGen.SQL.Add('where Hash='+IntToStr(alu));
         try aNardCtx.fQryGen.Active := true;
           except on e: Exception do
            begin
             LogError('NardCtx:SetValue:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
             // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_HASH;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
            IncSent;
            exit;
            end;

         end;

        if aNardCtx.fQryGen.RecordCount = 1 then
          begin
          if aNardCtx.fQryGen.FieldByName('AccessLevel').AsInteger >0 then
            begin
            //access granted
            aNardCtx.fQryGen.Active:=false;
            aNardCtx.fQryGen.SQL.Add('INSERT INTO LOGHASH (STAMP, ARDID, HASH, PASS)');
            aNardCtx.fQryGen.SQL.Add('VALUES( CURRENT_TIMESTAMP,' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(alu)+', True )');
             try aNardCtx.fQryGen.ExecSQL;
               except on e: Exception do
                begin
                 LogError('NardCtx:RecvHash:Logging: ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
                  SetFailed := true;
                 // send a nak
                 SetLength(aBuff, SizeOf(tPacketHdr));
                 aNardCtx.fHdr.Command := CMD_NAK;
                 aNardCtx.fHdr.Option[0] := CMD_HASH;
                 aNardCtx.fHdr.Option[1] := 0;
                 aNardCtx.fHdr.Option[2] := 0;
                 aNardCtx.fHdr.Option[3] := 0;
                 aNardCtx.fHdr.DataSize := 0;
                 Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
                 aNardCtx.Context.Connection.IOHandler.Write(aBuff);
                 SetLength(aBuff, 0);
                 IncSent;
                 exit;
                end;

             end;
            end else
               begin
                 //access denied
                 SetFailed := true;
               aNardCtx.fQryGen.Active:=false;
               aNardCtx.fQryGen.SQL.Add('INSERT INTO LOGHASH (STAMP, ARDID, HASH, PASS)');
               aNardCtx.fQryGen.SQL.Add('VALUES( CURRENT_TIMESTAMP,' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(alu)+', False )');
                try aNardCtx.fQryGen.ExecSQL;
                  except on e: Exception do
                  begin
                    LogError('NardCtx:RecvHash:Logging: ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
                    SetFailed := true;
                    // send a nak
                    SetLength(aBuff, SizeOf(tPacketHdr));
                    aNardCtx.fHdr.Command := CMD_NAK;
                    aNardCtx.fHdr.Option[0] := CMD_HASH;
                    aNardCtx.fHdr.Option[1] := 0;
                    aNardCtx.fHdr.Option[2] := 0;
                    aNardCtx.fHdr.Option[3] := 0;
                    aNardCtx.fHdr.DataSize := 0;
                    Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
                    aNardCtx.Context.Connection.IOHandler.Write(aBuff);
                    SetLength(aBuff, 0);
                    IncSent;
                    exit;
                  end;
                end;
               end;
          end else SetFailed:=true;




      end;

      if not SetFailed then
       begin
        // send a pass
        SetLength(aBuff, SizeOf(tPacketHdr));
        aNardCtx.fHdr.Command := CMD_HASH;
        aNardCtx.fHdr.Option[0] := HASH_PASS;
        aNardCtx.fHdr.Option[1] := 0;
        aNardCtx.fHdr.Option[2] := 0;
        aNardCtx.fHdr.Option[3] := 0;
        aNardCtx.fHdr.DataSize := 0;
        Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
        aNardCtx.Context.Connection.IOHandler.Write(aBuff);
        SetLength(aBuff, 0);
        IncSent;
        TrigSetVar;
        end else
            begin
             LogError('NardCtx:Hash:Invalid Hash from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
             // send a fail
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_HASH;
             aNardCtx.fHdr.Option[0] := HASH_FAIL;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
            IncSent;
            end;


    end else
        begin
               LogError('NardCtx:Hash:Invalid Operation from ip:' +aNardCtx.Context.Binding.PeerIP);
                SetFailed := true;
               // send a nak
               SetLength(aBuff, SizeOf(tPacketHdr));
               aNardCtx.fHdr.Command := CMD_NAK;
               aNardCtx.fHdr.Option[0] := CMD_HASH;
               aNardCtx.fHdr.Option[1] := 0;
               aNardCtx.fHdr.Option[2] := 0;
               aNardCtx.fHdr.Option[3] := 0;
               aNardCtx.fHdr.DataSize := 0;
               Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
               aNardCtx.Context.Connection.IOHandler.Write(aBuff);
               SetLength(aBuff, 0);
              IncSent;
        end;


 end;


procedure tNardServer.piRecvGetParams(aNardCtx: tNardCntx);
var
params:array[0..3] of Int16;
aBuff: TIdBytes;
failed: boolean;

 begin
 // get a value
 if not aNardCtx.fRegged then exit; // outta here..
 failed := false;

   aNardCtx.fQryGen.Active := false;
   aNardCtx.fQryGen.SQL.Clear;
   aNardCtx.fQryGen.SQL.Add('Select * from ARDPARAMS');
   aNardCtx.fQryGen.SQL.Add('Where ArdID=' + IntToStr(aNardCtx.fNardID) +' AND ParamIndex=' + IntToStr(aNardCtx.fHdr.Option[1]));
     try
      aNardCtx.fQryGen.Active := true;
      except on e: Exception do
        begin
         LogError('NardCtx:GetValue:SQL Error: '+ e.Message + ' from ip:' + aNardCtx.Context.Binding.PeerIP);
         failed := true;
         // send a nak
         SetLength(aBuff, SizeOf(tPacketHdr));
         aNardCtx.fHdr.Command := CMD_NAK;
         aNardCtx.fHdr.Option[0] := CMD_PARAMS;
         aNardCtx.fHdr.Option[1] := 0;
         aNardCtx.fHdr.Option[2] := 0;
         aNardCtx.fHdr.Option[3] := 0;
         aNardCtx.fHdr.DataSize := 0;
         Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
         aNardCtx.Context.Connection.IOHandler.Write(aBuff);
         SetLength(aBuff, 0);
         IncSent;
         exit;
        end;
     end;

       if aNardCtx.fQryGen.RecordCount = 0 then
         begin
         aNardCtx.fQryGen.Active:=false;
         LogError('NardCtx:GetValue:Error:No Records for index  from ip:' + aNardCtx.Context.Binding.PeerIP);
         failed := true;
         end;



       if failed then
         begin
         // send a nak
         SetLength(aBuff, SizeOf(tPacketHdr));
         aNardCtx.fHdr.Command := CMD_NAK;
         aNardCtx.fHdr.Option[0] := CMD_PARAMS;
         aNardCtx.fHdr.Option[1] := 0;
         aNardCtx.fHdr.Option[2] := 0;
         aNardCtx.fHdr.Option[3] := 0;
         aNardCtx.fHdr.DataSize := 0;
         Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
         aNardCtx.Context.Connection.IOHandler.Write(aBuff);
         SetLength(aBuff, 0);
         IncSent;
         exit;
         end;


     if not failed then
      begin
        // send data back
        aNardCtx.fHdr.Option[2]:=0;
        aNardCtx.fHdr.Option[3]:=0;
        // size the outgoing buff..
        SetLength(aBuff, SizeOf(tPacketHdr));
        // send a set command back
        aNardCtx.fHdr.Command := CMD_PARAMS;
        aNardCtx.fHdr.Option[0]:=PARAMS_SET;
        aNardCtx.fHdr.DataSize := SizeOf(params);
        params[0]:=aNardCtx.fQryGen.FieldByName('P1').AsInteger;
        params[1]:=aNardCtx.fQryGen.FieldByName('P2').AsInteger;
        params[2]:=aNardCtx.fQryGen.FieldByName('P3').AsInteger;
        params[3]:=aNardCtx.fQryGen.FieldByName('P4').AsInteger;
        aNardCtx.fQryGen.Active := false;
        SetLength(aBuff,SizeOf(tPacketHdr)+SizeOf(params));
        Move(params,aBuff[SizeOf(tPacketHdr)],SizeOf(params));
        //move header in
        Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
        //send it off..
        aNardCtx.Context.Connection.IOHandler.Write(aBuff);
        SetLength(aBuff, 0);
        IncSent;
      end;


 end;

procedure tNardServer.piRecvSetParams(aNardCtx: tNardCntx);
var
params:array[0..3] of Int16;
aBuff: TIdBytes;
SetFailed: boolean;
 begin
 // set a value
 if not aNardCtx.fRegged then exit; // outta here..
 SetFailed := false;
 //check buff size..
 if Length(aNardCtx.fBuff) = sizeOf(params) then
    move(aNardCtx.fBuff[0],params,SizeOf(params)) else SetFailed := true;

 if not SetFailed then
   begin
       aNardCtx.fQryGen.Active := false;
       aNardCtx.fQryGen.SQL.Clear;
         aNardCtx.fQryGen.SQL.Add('UPDATE OR INSERT INTO ARDPARAMS (ARDID, PARAMINDEX, PARAM1, PARAM2, PARAM3, PARAM4)');
         aNardCtx.fQryGen.SQL.Add('VALUES(' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[1]) + ',' + IntToStr(params[0]) +
         ',' + IntToStr(params[1]) +',' + IntToStr(params[2]) +',' + IntToStr(params[3]) + ')');
        aNardCtx.fQryGen.SQL.Add('MATCHING (ARDID, PARAMINDEX)');
         try aNardCtx.fQryGen.ExecSQL;
           except on e: Exception do
            begin
             LogError('NardCtx:SetValue:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
             // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_PARAMS;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
             IncSent;
            end;

         end;
   end;

      if not SetFailed then
       begin
        // send an ack
        SetLength(aBuff, SizeOf(tPacketHdr));
        aNardCtx.fHdr.Command := CMD_ACK;
        aNardCtx.fHdr.Option[0] := CMD_PARAMS;
        aNardCtx.fHdr.Option[1] := 0;
        aNardCtx.fHdr.Option[2] := 0;
        aNardCtx.fHdr.Option[3] := 0;
        aNardCtx.fHdr.DataSize := 0;
        Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
        aNardCtx.Context.Connection.IOHandler.Write(aBuff);
        SetLength(aBuff, 0);
        IncSent;
        TrigSetVar;
        end else
            begin
             LogError('NardCtx:SetValue:Sizing Error:Buff size:'+IntToStr(Length(aNardCtx.fBuff))+'<> Param size:'+ IntToStr(sizeOf(params))+'  from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
             // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_PARAMS;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
            IncSent;
            end;
 end;


procedure tNardServer.piRecvSetnLogParams(aNardCtx: tNardCntx);
var
params:array[0..3] of Int16;
aBuff: TIdBytes;
SetFailed: boolean;
aStrm:tMemoryStream;
 begin
 // set a value
 if not aNardCtx.fRegged then exit; // outta here..
 SetFailed := false;
 //check buff size..
 if Length(aNardCtx.fBuff) = sizeOf(params) then
    move(aNardCtx.fBuff[0],params,SizeOf(params)) else SetFailed := true;

 if not SetFailed then
   begin
       aNardCtx.fQryGen.Active := false;
       aNardCtx.fQryGen.SQL.Clear;
         aNardCtx.fQryGen.SQL.Add('UPDATE OR INSERT INTO ARDPARAMS (ARDID, PARAMINDEX, PARAM1, PARAM2, PARAM3, PARAM4)');
         aNardCtx.fQryGen.SQL.Add('VALUES(' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[1]) + ',' + IntToStr(params[0]) +
         ',' + IntToStr(params[1]) +',' + IntToStr(params[2]) +',' + IntToStr(params[3]) + ')');
        aNardCtx.fQryGen.SQL.Add('MATCHING (ARDID, PARAMINDEX)');
         try aNardCtx.fQryGen.ExecSQL;
           except on e: Exception do
            begin
             LogError('NardCtx:SetValue:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
             // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_PARAMS;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
             IncSent;
            end;

         end;
   end;

    if not SetFailed then
     begin
       //now log it..
        aNardCtx.fQryGen.Active := false;
        aNardCtx.fQryGen.SQL.Clear;
        aNardCtx.fQryGen.SQL.Add('INSERT INTO LOGPARAMS (STAMP, ARDID, PARAMINDEX, PARAM1, PARAM2, PARAM3, PARAM4 )');
         aNardCtx.fQryGen.SQL.Add('VALUES( CURRENT_TIMESTAMP,' + IntToStr(aNardCtx.fNardID) + ',' +IntToStr(aNardCtx.fHdr.Option[1]) + ',' + IntToStr(params[0]) +
         ',' + IntToStr(params[1]) +',' + IntToStr(params[2]) +',' + IntToStr(params[3]) + ')');

         try aNardCtx.fQryGen.ExecSQL;
           except on e: Exception do
            begin
             LogError('NardCtx:LogValue:ExecSQL Error: ' + e.Message + ' from ip:' +aNardCtx.Context.Binding.PeerIP);
             SetFailed := true;
            // send a nak
            SetLength(aBuff, SizeOf(tPacketHdr));
            aNardCtx.fHdr.Command := CMD_NAK;
            aNardCtx.fHdr.Option[0] := CMD_PARAMS;
            aNardCtx.fHdr.Option[1] := 0;
            aNardCtx.fHdr.Option[2] := 0;
            aNardCtx.fHdr.Option[3] := 0;
            aNardCtx.fHdr.DataSize := 0;
            Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
            aNardCtx.Context.Connection.IOHandler.Write(aBuff);
            SetLength(aBuff, 0);
            IncSent;
            exit;
            end;

         end;
     end;






      if not SetFailed then
       begin
        // send an ack
        SetLength(aBuff, SizeOf(tPacketHdr));
        aNardCtx.fHdr.Command := CMD_ACK;
        aNardCtx.fHdr.Option[0] := CMD_PARAMS;
        aNardCtx.fHdr.Option[1] := 0;
        aNardCtx.fHdr.Option[2] := 0;
        aNardCtx.fHdr.Option[3] := 0;
        aNardCtx.fHdr.DataSize := 0;
        Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
        aNardCtx.Context.Connection.IOHandler.Write(aBuff);
        SetLength(aBuff, 0);
        IncSent;
        TrigSetVar;
        end else
            begin
             LogError('NardCtx:SetValue:Sizing Error:  from ip:' +aNardCtx.Context.Binding.PeerIP);
              SetFailed := true;
             // send a nak
             SetLength(aBuff, SizeOf(tPacketHdr));
             aNardCtx.fHdr.Command := CMD_NAK;
             aNardCtx.fHdr.Option[0] := CMD_PARAMS;
             aNardCtx.fHdr.Option[1] := 0;
             aNardCtx.fHdr.Option[2] := 0;
             aNardCtx.fHdr.Option[3] := 0;
             aNardCtx.fHdr.DataSize := 0;
             Move(aNardCtx.fHdr, aBuff[0], SizeOf(tPacketHdr));
             aNardCtx.Context.Connection.IOHandler.Write(aBuff);
             SetLength(aBuff, 0);
            IncSent;
            end;
 end;





end.
