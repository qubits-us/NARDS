{  NARDS
  Packet Definitions and helpers..

  3.4.2023- q

  be it harm none, do as ye wish..

}

unit uPacketDefs;

interface
uses
  System.SysUtils, System.Classes, System.SyncObjs,System.Generics.Collections;


const
//Packet Ident - ~q
Ident_Packet :array[0..1] of byte = (126, 113);
//max items in the q before we start dropping
MAX_QUES=101;
MAX_PARAMS=4;
OTA_DEF_CHUNK_SIZE=1024;

//Commands
CMD_NOP=0;//no opertation
CMD_ACK=0;//ack same as nop
CMD_NAK=1;//nack
CMD_REG=2;//register
CMD_SET=3;//set
CMD_GET=4;//get
CMD_EXE=5;//execute
CMD_SETNLOG=6;//sets and logs a var
CMD_HASH=7;//check a hash
CMD_PARAMS=8;//set or get int16 * MAX_PARAMS
CMD_OTA=99;//firmware update

CMD_SETID=1000;


//set and get value types..
SG_BYTE   = 0;
SG_WORD   = 1;
SG_INT16  = 2;
SG_INT32  = 3;
SG_UINT32 = 4;
SG_FLT4   = 5;
SG_FLT8   = 6;
SG_STR    = 7;
SG_JPG    = 8;


//hash values..
HASH_CHECK = 0;
HASH_PASS  = 1;
HASH_FAIL  = 2;

//Param option 0
PARAMS_GET = 0;
PARAMS_SET = 1;
PARAMS_SETNLOG = 2;

//option 0
OTA_BEGIN = 0;
OTA_CHUNK = 1;
OTA_END   = 2;

UDP_REFRESH = 0;







//type used in helper function
type
 TIdentArray = array[0..1] of byte;

    //udp discovery packets broadcast from server..
  type
     pDiscoveryPacket=^tDiscoveryPacket;
     tDiscoveryPacket =packed record
       PacketIdent:TIdentArray;
       ServerName :array[0..25] of byte;
       ServerIp   :array[0..13] of byte;
       ServerPort :array[0..13] of byte;
     end;


type
   tPacketUDP = packed record
     Ident : TIdentArray;
     Command:UInt16;
   end;


//packet header, preceeds all packets..
type
 pPacketHdr = ^tPacketHdr;
 tPacketHdr = packed record
  Ident : TIdentArray;//2 bytes
  Command : UInt16;//2 byte
  Option :array[0..3] of byte;//4 byte
  //-addional data size after header and not including header..
  DataSize : UInt32;//4 bytes
end;

type
  tRegStruct = packed record
    NardID:word;
    GroupID:word;
    ProcessID:word;
    DisplayName :array[0..19] of byte;
  //  IpAddress   :array[0..13] of byte;
  end;

  type
    pRegPacket = ^ tRegPacket;
    tRegPacket = packed record
      header :tPacketHdr;
      reg    :tRegStruct;
    end;

 type
    tSinglePacket = packed record
       header :tPacketHdr;
       value  :single;//4 byte float
    end;
 type
    tDoublePacket = packed record
       header :tPacketHdr;
       value  :double;//8 byte float
    end;

 type
    tParamPacket = packed record
         header:tPacketHdr;
         params:array[0..3] of Int16;//4 16 bit ints
    end;

    //used by panels..
type
   tCommandIdPacket = packed record
          header:tPacketHdr;
          CommandID:Int32;
   end;



function  CheckPacketIdent(Const AIdent:TIdentArray):boolean;
procedure FillPacketIdent(var aIdent:tIdentArray);
function  SwapBytes(Value: Cardinal): Cardinal;





implementation


//does it match our packet identifier
function CheckPacketIdent(Const AIdent:TIdentArray):boolean;
var
i:integer;
begin
   Result:=true;
     for I := Low(AIdent) to High(AIdent) do
       if AIdent[i]<>Ident_Packet[i] then result:=false;
end;
//fill our identifier
procedure FillPacketIdent(var aIdent:TIdentArray);
var
i:integer;
begin
     for I := Low(aIdent) to High(aIdent) do
        aIdent[i]:=Ident_Packet[i];

end;


function SwapBytes(Value: Cardinal): Cardinal;
type
  Bytes = packed array[0..3] of Byte;

begin
  Bytes(Result)[0]:= Bytes(Value)[3];
  Bytes(Result)[1]:= Bytes(Value)[2];
  Bytes(Result)[2]:= Bytes(Value)[1];
  Bytes(Result)[3]:= Bytes(Value)[0];
end;



end.
