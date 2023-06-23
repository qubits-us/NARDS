/*
   NARDS - N_etworked ARD_uino S_ystem..
   Created 3.12.2023 by ~q  qubits.us
   

   
*/
#include <Arduino.h>
#include <WiFi.h>
#include <WiFiClient.h>

#ifndef Nards_h
#define Nards_h
#endif

#define NARD_VER_LO 1
#define NARD_VER_HI 0
// Packet Identification
#define IDENT_LO 113
#define IDENT_HI 126
// Commands..
#define CMD_ACK     0
#define CMD_NAK     1
#define CMD_REG     2
#define CMD_SET     3
#define CMD_GET     4
#define CMD_EXE     5
#define CMD_SETNLOG 6
#define CMD_HASH    7
#define CMD_PARAMS  8
#define CMD_OTA  99

//Defines for Set and Get
#define SG_BYTE    0
#define SG_WORD    1
#define SG_INT16   2
#define SG_INT32   3
#define SG_UINT32  4
#define SG_FLT4    5
#define SG_FLT8    6
#define SG_STR     7
#define SG_JPG     8
//Hash codes..
#define HASH_CHECK  0
#define HASH_PASS 1
#define HASH_FAIL 2
//param command options 0, index in 1
#define PARAM_GET 0
#define PARAM_SET 1
#define PARAM_SETNLOG 2

#define OTA_BEGIN  0
#define OTA_CHUNK  1
#define OTA_END    2
#define OTA_CHUNK_SIZE 4096

#define RECV_HEADER 0
#define RECV_EXTRA  1

//registration structure
struct __attribute__((__packed__)) NardReg {
   uint16_t NardID;
   uint16_t GroupID;
   uint16_t ProcessID;
   char     DisplayName[20];
};



//nard packet..
struct __attribute__((__packed__)) NardPacket {
  byte      Ident[2];
  uint16_t NardId;
  uint16_t  Command;
  byte      Options[4];
  uint32_t  DataSize;
};

//nard reg packet..
struct __attribute__((__packed__)) NardRegPacket {
 NardPacket hdr;
 NardReg    reg;
};

//nard 4 byte buffer packet..
struct __attribute__((__packed__)) NardBuff4Packet {
 NardPacket Hdr;
 byte       buf[4];
};

//nard param packet..
struct __attribute__((__packed__)) NardParamPacket {
 NardPacket Hdr;
 int16_t    params[4];
};



class Nard {
public:
       Nard(); 
  bool begin(char* host, int port);
  typedef bool    (*ByteGet)  (const uint8_t, uint8_t*);
  typedef bool    (*ByteSet)  (const uint8_t, const uint8_t);
  typedef bool    (*WordGet)  (const uint8_t, uint16_t*);
  typedef bool    (*WordSet)  (const uint8_t, const uint16_t);  
  typedef bool    (*IntGet)   (const uint8_t, int16_t*);
  typedef bool    (*IntSet)   (const uint8_t, const int16_t);  
  typedef bool    (*Int32Get) (const uint8_t, int32_t*);
  typedef bool    (*Int32Set) (const uint8_t, const int32_t);  
  typedef bool    (*UInt32Get)(const uint8_t, uint32_t*);
  typedef bool    (*UInt32Set)(const uint8_t, const uint32_t);  
  typedef bool    (*FloatGet) (const uint8_t, float*);
  typedef bool    (*FloatSet) (const uint8_t, const float);  
  typedef bool    (*ExeCmd)   (const uint8_t); 
  typedef void    (*HashResp) (const bool);
  typedef void    (*ImgGet)   (void);
  typedef bool    (*ParamGet)   (const uint8_t, int16_t*,int16_t*,int16_t*,int16_t*);
  typedef bool    (*ParamSet)   (const uint8_t, const int16_t, const int16_t, const int16_t, const int16_t);  
  bool setPingInterval(uint16_t interval); 
  bool setReg(char *str, uint16_t id, uint16_t group, uint16_t process); 
  bool connected();
  //call backs from server..
  void onBytes(ByteGet getByte, ByteSet setByte);
  void onWords(WordGet getWord, WordSet setWord);
  void onInts(IntGet getInt, IntSet setInt);
  void onInt32s(Int32Get getInt32, Int32Set setInt32);
  void onUInt32s(UInt32Get getUInt32, UInt32Set setUInt32);
  void onFloats(FloatGet getFloat, FloatSet setFloat);
  void onCommand(ExeCmd cmdExe);
  void onHashResp(HashResp respHash);
  void onImage(ImgGet getImg);
  void onParams(ParamGet getParam, ParamSet setParam);
  void poll();
  //sets and logs a var..
  bool logVar(const uint8_t index, const uint8_t val);
  bool logVar(const uint8_t index, const uint16_t val);
  bool logVar(const uint8_t index, const int16_t val);
  bool logVar(const uint8_t index, const uint32_t val);
  bool logVar(const uint8_t index, const int32_t val);
  bool logVar(const uint8_t index, const float val);
  //sets a var without logging..
  bool setVar(const uint8_t index, const uint8_t val);
  bool setVar(const uint8_t index, const uint16_t val);
  bool setVar(const uint8_t index, const int16_t val);
  bool setVar(const uint8_t index, const uint32_t val);
  bool setVar(const uint8_t index, const int32_t val);
  bool setVar(const uint8_t index, const float val);
  //request a var from server..
  bool getVar(const uint8_t index, const uint8_t type);
  //execute a command on a remote nard..
  bool remoteCmd(const uint8_t nardId, const uint8_t cmd);
  //logs a new jpg to the server
  bool logJpg(const uint8_t* buff, const int32_t size);
  //sets a new jpg to server
  bool setJpg(const uint8_t* buff, const int32_t size);
  bool checkCode(char *str);
  bool setParams(const uint8_t index, const int16_t p1, const int16_t p2, const int16_t p3, const int16_t p4);
private:
  WiFiClient _nard;
  char* _displayName;
  char* _ipAddress;
  word  _nardID;
  word  _groupID;
  word  _processID;
  char* _host;
  int   _port;
  bool  _started;  
  bool  _registered;
  int   _recvCount;
  byte  _recvState;
  NardPacket _hdr;
  unsigned long _lastPing;
  int     _intervalPing;
  unsigned long _lastRecon;
  int    _intervalRecon;
  byte    _buff[OTA_CHUNK_SIZE];
  int32_t _firmSize;
  int32_t _firmRecvd;
  int    _firmChunk;
  bool   _OTAbegun;
  ByteGet _byteGet;
  ByteSet _byteSet;
  WordGet _wordGet;
  WordSet _wordSet;
  IntGet  _intGet;
  IntSet  _intSet;
  Int32Get  _int32Get;
  Int32Set  _int32Set;
  UInt32Get  _uint32Get;
  UInt32Set  _uint32Set;
  FloatSet  _floatSet;
  FloatGet  _floatGet;
  ExeCmd  _exeCmd;
  ParamGet _paramGet;
  ParamSet _paramSet;
  HashResp _hashResp;
  ImgGet _imgGet;
  bool _checkIncoming();
  void _reconnect();
  bool _processGet();
  bool _processSet();
  bool _processExe();
  bool _getByte();
  bool _setByte();
  bool _getWord();
  bool _setWord();
  bool _getInt();
  bool _setInt();
  bool _getInt32();
  bool _setInt32();
  bool _getUInt32();
  bool _setUInt32();
  bool _getFloat();
  bool _setFloat();
  bool _getImg();
  bool _getParam();
  bool _setParam();
  bool _onExec();
  bool _onOTAbegin();
  bool _onOTAchunk();
  bool _onOTAend();
  void _processIncoming();  
  void _processACK();
  void _respHash();
  bool _register();
  bool _ping();
  uint32_t _hash(char *str);
 };



 