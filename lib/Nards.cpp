/*
   NARDS - N_etworked ARD_uino S_ystem..
   Created 3.12.2023 by ~q  qubits.us
   
   Wifi Version..
   
*/
#include "Nards.h"
#include <Update.h>

  Nard::Nard(){
   //init vars   
   _intervalPing = 10000;
   _started = false;
   _registered = false;
   _byteSet = nullptr;
   _byteGet = nullptr;
   _wordGet = nullptr;
   _wordSet = nullptr;
   _intGet = nullptr;
   _intSet = nullptr;
   _exeCmd = nullptr;
   _int32Get = nullptr;
   _int32Set = nullptr;
   _uint32Get = nullptr;
   _uint32Set = nullptr;
   _floatGet = nullptr;
   _floatSet = nullptr;
   _strGet = nullptr;
   _strSet = nullptr;
   _blobGet = nullptr;
   _blobSet = nullptr;
   _imgGet = nullptr;
   _paramGet = nullptr;
   _paramSet = nullptr;
   _hashResp = nullptr;
   _displayName = "Nard\0";
   _ipAddress = "0.0.0.0\0";
   _nardID = 1;
   _groupID = 1;
   _processID = 1;   
   _lastRecon = 0;
   _intervalRecon = 10000;   
   _nard.setTimeout(300);
   _recvState = RECV_HEADER;
   _recvCount = 0;
   
  }

//let's begin
bool Nard::begin(char *host, int port) {
  _host = host;
  _port = port;

  if (_nard.connect(host, port)) {
    _started = true;
    delay(1000);//give server some time..
    //register with server..
    _register();
  }
  return _started;
}

bool Nard::isRegistered(){
  return _registered;
}

bool Nard::isStarted(){
  return _started;
}
//setup call backs..
void Nard::onBytes(ByteGet getByte, ByteSet setByte) {
  _byteGet = getByte;
  _byteSet = setByte;
}

void Nard::onWords(WordGet getWord, WordSet setWord) {
  _wordGet = getWord;
  _wordSet = setWord;
}

void Nard::onInts(IntGet getInt, IntSet setInt) {
  _intGet = getInt;
  _intSet = setInt;
}

void Nard::onInt32s(Int32Get getInt32, Int32Set setInt32) {
  _int32Get = getInt32;
  _int32Set = setInt32;
}

void Nard::onUInt32s(UInt32Get getUInt32, UInt32Set setUInt32) {
  _uint32Get = getUInt32;
  _uint32Set = setUInt32;
}

void Nard::onFloats(FloatGet getFloat, FloatSet setFloat) {
  _floatGet = getFloat;
  _floatSet = setFloat;
}

void Nard::onStrings(StrGet getStr, StrSet setStr) {
  _strGet = getStr;
  _strSet = setStr;
}

void Nard::onBlobs(BlobGet getBlob, BlobSet setBlob) {
  _blobGet = getBlob;
  _blobSet = setBlob;
}


void Nard::onCommand(ExeCmd cmdExe) {
  _exeCmd = cmdExe;
}

void Nard::onParams(ParamGet getParam, ParamSet setParam){
  _paramGet = getParam;
  _paramSet = setParam;
}

void Nard::onHashResp(HashResp respHash) {
  _hashResp = respHash;
}

void Nard::onImage(ImgGet getImg) {
  _imgGet = getImg;
}

bool Nard::setPingInterval(uint16_t interval) {
  bool result = false;
  if (interval > 999) {
    _intervalPing = interval;
    result = true;
  }
  return result;
}

bool Nard::setReg(char *str, uint16_t id, uint16_t group, uint16_t process){
  bool result = false;
  //already registed..
  if (!_registered) {
  _displayName = str;
  _nardID = id;
  _groupID = group;
  _processID = process;
  result = true;
  }
  return result;
}

bool Nard::connected() {
  bool c = false;
  if (_started) {
    c = _nard.connected();
  }
  return c;
}



void Nard::poll() {
 if (_nard.connected()){ 
  //check for incoming packets..
   _lastRecon = millis();
  _checkIncoming();
  //send a nop
  if (millis() - _lastPing >= _intervalPing) {
    _lastPing = millis();
    if (!_OTAbegun)
    _ping();
  }
  } else
    {
      //try to reconnect..
      _reconnect();
    }
}

void Nard::_reconnect(){
  //try to reconnect..
  if (!_started) return;
  if (!_registered) return;
  if (millis()-_lastRecon >= _intervalRecon){
    _lastRecon = millis();
    if (_nard.connect(_host, _port)){
         _register();
    }
  }
}


//check for incoming packets
bool Nard::_checkIncoming() {
  bool result = false;
  int extraRecvd = 0;
 if (_recvState == RECV_HEADER){ 
  //check for incoming packet
  if (_nard.available() >= sizeof(NardPacket)) {
    //have a packet
    if (_nard.read(_buff, sizeof(NardPacket)) == sizeof(NardPacket)) {
      //got a header..
      if (_buff[0] == IDENT_HI && _buff[1] == IDENT_LO) {
        //matches our ident, copy buff to structure..
        memcpy(&_hdr, &_buff, sizeof(NardPacket));
        //check for extra data..
        if (_hdr.DataSize > 0 && _hdr.DataSize < 512){
          //zero buff
          memset(_buff, 0, sizeof(_buff));
          extraRecvd = _nard.read(_buff, _hdr.DataSize);
         if ( extraRecvd == _hdr.DataSize) {
          result = true;
          //leave eaxtra data in buffer for later processing..
         }
        } else if (_hdr.DataSize == 0){
         result = true; //just a header
        } else {
           //need more
           _recvState = RECV_EXTRA;
           _recvCount = 0;
        }
        
          if (result && _recvState == RECV_HEADER){ 
          //process incoming..
          _processIncoming();  
      }
      //zero buff
      memset(_buff, 0, sizeof(_buff));
     }
    
   }
   }
  } else
    if (_recvState == RECV_EXTRA){
      
     if (_nard.available() >= _hdr.DataSize ) {
       //recv a chunk
          extraRecvd = _nard.read(_buff, _hdr.DataSize);
          _recvCount+=extraRecvd;
          
         if ( _recvCount == _hdr.DataSize) {
          result = true;
          //leave eaxtra data in buffer for later processing..
          _recvState = RECV_HEADER;
          _recvCount = 0;
         }
      
          if (result){ 
          //process incoming..
          _processIncoming();  
          //zero buff
          memset(_buff, 0, sizeof(_buff));
           }
        }
    }
  
  
  return result;
}

//process incoming packet..
void Nard::_processIncoming() {
  switch (_hdr.Command) {
    case CMD_ACK:
      {
        _processACK();
        break;
      }
    case CMD_NAK:
      { 
        break;
      }
    case CMD_SET:
      {
        _processSet();
        break;
      }
    case CMD_GET:
      {
        _processGet();
        break;
      }
    case CMD_EXE:
      {
        _processExe();
        break;
      }
      case CMD_HASH:
      {
        _respHash();
        break;
      }
      case  CMD_PARAMS:
      {
        if (_hdr.Options[0]==PARAM_GET){
          _getParam();
        } else
        {
          if (_hdr.Options[0]==PARAM_SET){
            _setParam();
          }
        }
        break;
      }
      case  CMD_OTA:
      { 
        if (_hdr.Options[0]==OTA_BEGIN){
          _onOTAbegin();
        } else
          if (_hdr.Options[0]==OTA_CHUNK){
            _onOTAchunk();
          } else
          if (_hdr.Options[0]==OTA_END){
            _onOTAend();
          } 
        
        break;
      }
}
}

//process returning acknowledgements..
void Nard::_processACK() {
  switch (_hdr.Options[0]) {
    case CMD_REG:
      {
        //got a good reg..
        _registered = true;
        break;
      }
  }
}

//incoming set var command..
//identify type of var..
bool Nard::_processSet() {
  //set var
  switch (_hdr.Options[1]) {
    case SG_BYTE:
      {
        _setByte();
        break;
      }
    case SG_WORD:
      {
        _setWord();
        break;
      }
    case SG_INT16:
      {
        _setInt();
        break;
      }
      case SG_INT32:
      {
        _setInt32();
        break;
      }
        case SG_UINT32:
      {
        _setUInt32();
        break;
      }
        case SG_FLT4:
      {
        _setFloat();
        break;
      }
        case SG_STR:
      {
        _setStr();
        break;
      }
        case SG_BLOB:
      {
        _setBlob();
        break;
      }
}
}

//incoming get var command..
//identify type of var..
bool Nard::_processGet() {
  //get var
  switch (_hdr.Options[1]) {
    case SG_BYTE:
      {
        _getByte();
        break;
      }
    case SG_WORD:
      {
        _getWord();
        break;
      }
    case SG_INT16:
      {
        _getInt();
        break;
      }
      case SG_INT32:
      {
        _getInt32();
        break;
      }
      case SG_UINT32:
      {
        _getUInt32();
        break;
      }
      case SG_FLT4:
      {
        _getFloat();
        break;
      }
      case SG_STR:
      {
        _getStr();
        break;
      }
      case SG_JPG:
      {
        _getImg();
        break;
      }
      case SG_BLOB:
      {
        _getBlob();
        break;
      }
}
}

//execute a function..
bool Nard::_processExe() {
  bool result = false;
  //execute procedure
  if (_exeCmd != nullptr) {
    result = _exeCmd(_hdr.Options[0]);
    if (result) {
      //send an ack
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_EXE;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    } else {
      //send nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_EXE;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    }
  } else {
    //send nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_EXE;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
  }
  return result;
}


bool Nard::_onOTAbegin(){
    int32_t value ;
    if (_hdr.DataSize == sizeof(int32_t)){
       //get the firm size  
       memcpy(&value,&_buff,sizeof(int32_t));
       _firmSize = value;
       _firmChunk = 0;
       _firmRecvd = 0;
       _OTAbegun = true;
      // Serial.print("Starting update, Firm size");
      // Serial.println(_firmSize);
       Update.begin(_firmSize);
       Serial.println("Requesting chunk 1");
       //start asking for chunks
       _hdr.Command = CMD_OTA;
       _hdr.Options[0] = OTA_CHUNK;
       _hdr.DataSize = 0;
       int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));    
       return true;                  
    } else
      {
       //send nak back
       _hdr.Command = CMD_NAK;
       _hdr.Options[0] = CMD_OTA;
       _hdr.DataSize = 0;
       int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));        
       return false;
      }
}

bool Nard::_onOTAchunk(){
     //must have something, but can't have too much..  
    if (_hdr.DataSize > 0 && _hdr.DataSize <= OTA_CHUNK_SIZE && _OTAbegun){
       _firmChunk++;
       _firmRecvd+=_hdr.DataSize;
       Update.write( _buff, _hdr.DataSize);
      // Serial.println(_firmChunk);
       //ask for next chunk
       _hdr.Command = CMD_OTA;
       _hdr.Options[0] = OTA_CHUNK;
       _hdr.DataSize = 0;
       int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));    
       return true;                  
    } else
      {
        if (_OTAbegun){
          _OTAbegun = false;
          Update.abort();       
        }
       //send nak back
       _hdr.Command = CMD_NAK;
       _hdr.Options[0] = CMD_OTA;
       _hdr.DataSize = 0;
       int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));        
       return false;
      }
  
}

bool Nard::_onOTAend(){
  if (_firmRecvd == _firmSize){
    //Serial.println("Update completed..");
   if ( Update.end(true)){
    ESP.restart();
   } else
     {
       //just send nak back
       _hdr.Command = CMD_NAK;
       _hdr.Options[0] = CMD_OTA;
       _hdr.DataSize = 0;
       int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));  
       _OTAbegun = false;      
       return false;
     }
  } else
     { //abort update
       Update.abort();
       //send nak back
       _hdr.Command = CMD_NAK;
       _hdr.Options[0] = CMD_OTA;
       _hdr.DataSize = 0;
       int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));   
       _OTAbegun = false;     
       return false;
    
      }
}


//server wants a byte..
bool Nard::_getByte() {
  bool good = false;
  uint8_t result;
  if (_byteGet != nullptr) {
    good = _byteGet(_hdr.Options[0],&result);
    if (good) {  //got it, thank you..
      //send byte back..
      _hdr.Command = CMD_SET;
      //byte into option 2
      _hdr.Options[2] = result & 0xff;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    } else {  //bad result from call back..
      //send nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_GET;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    }
  } else {  //no call back set..
    //send nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_GET;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
  }
  return good;
}

//server sets a byte...
bool Nard::_setByte() {
  bool result = false;
  if (_byteSet != nullptr) {
    result = _byteSet(_hdr.Options[0], _hdr.Options[2],_hdr.NardId);
    if (result) {
      //got something..
      //send an ack back
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_SET;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    } else {
      //nothing..
      //send an nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }
  } else {
    //no call back set..
    //send an nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_SET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
}

//server wants a word..
bool Nard::_getWord() {
  bool good = false;
  uint16_t result;
  if (_wordGet != nullptr) {
    good = _wordGet(_hdr.Options[0],&result);
    if (good) {
      //got it, thanks...
      _hdr.Command = CMD_SET;
      _hdr.Options[3] = result & 0xff;
      _hdr.Options[2] = result >> 8;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    } else {
      //bad result..
      //send nak
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_GET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }

  } else {
    //no call back, send nak
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_GET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
  return good;
}


//server sets a word..
bool Nard::_setWord() {
  bool result = false;
  if (_wordSet != nullptr) {
    uint16_t value = (_hdr.Options[2] << 8) | _hdr.Options[3];
    result = _wordSet(_hdr.Options[0], value,_hdr.NardId);
    if (result) {
      //got something..
      //send an ack back
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    } else {
      //nothing..
      //send an nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }
  } else {
    //no call back set..
    //send an nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_SET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
}


//server wants an int..
bool Nard::_getInt() {
  int16_t result;
  bool good;
  if (_intGet != nullptr) {
    good = _intGet(_hdr.Options[0],&result);
    if (good) {
      //got it, thanks...
      _hdr.Command = CMD_SET;
      _hdr.Options[3] = result & 0xff;
      _hdr.Options[2] = result >> 8;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    } else {
      //bad result..
      //send nak
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_GET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }

  } else {
    //no call back, send nak
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_GET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
  return good;
}


//server sets an int..
bool Nard::_setInt() {
  bool result = false;
  if (_intSet != nullptr) {
    uint16_t value = (_hdr.Options[2] << 8) | _hdr.Options[3];
    result = _intSet(_hdr.Options[0], value,_hdr.NardId);
    if (result) {
      //got something..
      //send an ack back
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    } else {
      //nothing..
      //send an nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }
  } else {
    //no call back set..
    //send an nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_SET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
}



//server wants an int32..
bool Nard::_getInt32() {
  //should min int32..
  int32_t result = 0;
  bool good;
  if (_int32Get != nullptr) {
    good = _int32Get(_hdr.Options[0],&result);
    if (good) {
      //got it, thanks...
      _hdr.Command = CMD_SET;
      _hdr.Options[3] = 0;
      _hdr.Options[2] = 0;
      _hdr.DataSize = sizeof(int32_t);
      //zero buff
      memset(_buff, 0, sizeof(_buff));
      memcpy(&_buff,&_hdr,sizeof(_hdr));
      memcpy(&_buff[sizeof(_hdr)],&result,sizeof(int32_t));
      int sent = _nard.write((uint8_t *)&_buff, sizeof(NardPacket) + _hdr.DataSize);
      result = (sent == sizeof(NardPacket) + _hdr.DataSize);
    } else {
      //bad result..
      //send nak
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_GET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }

  } else {
    //no call back, send nak
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_GET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
  return good;
}


//server sets an int32..
bool Nard::_setInt32() {
  bool result = false;
  if (_int32Set != nullptr) {
    uint32_t value ;
    memcpy(&value,&_buff,sizeof(int32_t));
    result = _int32Set(_hdr.Options[0], value,_hdr.NardId);
    if (result) {
      //got something..
      //send an ack back
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    } else {
      //nothing..
      //send an nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }
  } else {
    //no call back set..
    //send an nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_SET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
}



//server wants an uint32..
bool Nard::_getUInt32() {
  //should min int32..
  uint32_t result = 0;
  bool good;
  if (_uint32Get != nullptr) {
    good = _uint32Get(_hdr.Options[0],&result);
    if (good) {
      //got it, thanks...
      _hdr.Command = CMD_SET;
      _hdr.Options[3] = 0;
      _hdr.Options[2] = 0;
      _hdr.DataSize = sizeof(uint32_t);
      //zero buff
      memset(_buff, 0, sizeof(_buff));
      memcpy(&_buff,&_hdr,sizeof(_hdr));
      memcpy(&_buff[sizeof(_hdr)],&result,sizeof(uint32_t));
      int sent = _nard.write((uint8_t *)&_buff, sizeof(NardPacket) + _hdr.DataSize);
      result = (sent == sizeof(NardPacket) + _hdr.DataSize);
    } else {
      //bad result..
      //send nak
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_GET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }

  } else {
    //no call back, send nak
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_GET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
  return good;
}


//server sets an uint32..
bool Nard::_setUInt32() {
  bool result = false;
  if (_uint32Set != nullptr) {
    uint32_t value ;
    memcpy(&value,&_buff,sizeof(uint32_t));
    result = _uint32Set(_hdr.Options[0], value,_hdr.NardId);
    if (result) {
      //got something..
      //send an ack back
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    } else {
      //nothing..
      //send an nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }
  } else {
    //no call back set..
    //send an nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_SET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
}





//server wants a float..
bool Nard::_getFloat() {
  //should min int32..
  float result = 0;
  bool good;
  if (_floatGet != nullptr) {
    good = _floatGet(_hdr.Options[0],&result);
    if (good) {
      //got it, thanks...
      _hdr.Command = CMD_SET;
      _hdr.Options[3] = 0;
      _hdr.Options[2] = 0;
      _hdr.DataSize = sizeof(float);
      //zero buff
      memset(_buff, 0, sizeof(_buff));
      memcpy(&_buff,&_hdr,sizeof(_hdr));
      memcpy(&_buff[sizeof(_hdr)],&result,sizeof(float));
      int sent = _nard.write((uint8_t *)&_buff, sizeof(NardPacket) + _hdr.DataSize);
      result = (sent == sizeof(NardPacket) + _hdr.DataSize);
    } else {
      //bad result..
      //send nak
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_GET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }

  } else {
    //no call back, send nak
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_GET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
  return good;
}


//server sets a float..
bool Nard::_setFloat() {
  bool result = false;
  if (_floatSet != nullptr) {
    float value ;
    memcpy(&value,&_buff,sizeof(float));
    result = _floatSet(_hdr.Options[0], value,_hdr.NardId);
    if (result) {
      //got something..
      //send an ack back
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    } else {
      //nothing..
      //send an nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }
  } else {
    //no call back set..
    //send an nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_SET;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
}


// Strings..

//server wants a str..
bool Nard::_getStr() {
  //should min int32..
  char result[MAX_STR] ;
  bool good = false;
  if (_strGet != nullptr) {
    good = _strGet(_hdr.Options[0],result);
    if (good) {
      //got it, thanks...
      _hdr.Command = CMD_SET;
      _hdr.Options[3] = 0;
      _hdr.Options[2] = 0;
      _hdr.DataSize = strlen(result);
      //zero buff
      memset(_buff, 0, sizeof(_buff));
      memcpy(&_buff,&_hdr,sizeof(_hdr));
      memcpy(&_buff[sizeof(_hdr)],result,strlen(result));
      int sent = _nard.write((uint8_t *)&_buff, sizeof(NardPacket) + _hdr.DataSize);
      good = (sent == sizeof(NardPacket) + _hdr.DataSize);
    } else {
      //bad result..
      //send nak
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_GET;
      _hdr.DataSize = 0;
      _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    }

  } else {
    //no call back, send nak
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_GET;
    _hdr.DataSize = 0;
    _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
  }
  return good;
}


//server sets a string..
bool Nard::_setStr() {
  bool good = false;
  if (_strSet != nullptr) {
    char value[_hdr.DataSize+1] ;
    _buff[_hdr.DataSize] = 0;
    memcpy(value,&_buff,_hdr.DataSize+1);
    good = _strSet(_hdr.Options[0], value,_hdr.NardId);
    if (good) {
      //got something..
      //send an ack back
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      good = (sent == sizeof(NardPacket));
    } else {
      //nothing..
      //send an nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
    }
  } else {
    //no call back set..
    //send an nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_SET;
    _hdr.DataSize = 0;
  }
  return good;
}



// Blobs..

//server wants a blob..
bool Nard::_getBlob() {
  //should min int32..
  byte result[MAX_STR];
  int32_t size = MAX_STR;
  bool good = false;
  if (_strGet != nullptr) {
    good = _blobGet(_hdr.Options[0],(uint8_t *)&result,(int32_t *)&size);
    if (good) {
      //got it, thanks...
      _hdr.Command = CMD_SET;
      _hdr.Options[3] = 0;
      _hdr.Options[2] = 0;
      _hdr.DataSize = size;
      //zero buff
      memset(_buff, 0, sizeof(_buff));
      memcpy(&_buff,&_hdr,sizeof(_hdr));
      memcpy(&_buff[sizeof(_hdr)],result,sizeof(result));
      int sent = _nard.write((uint8_t *)&_buff, sizeof(NardPacket) + _hdr.DataSize);
      good = (sent == sizeof(NardPacket) + _hdr.DataSize);
    } else {
      //bad result..
      //send nak
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_GET;
      _hdr.DataSize = 0;
      _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    }

  } else {
    //no call back, send nak
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_GET;
    _hdr.DataSize = 0;
    _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
  }
  return good;
}


//server sets a blob..
bool Nard::_setBlob() {
  bool good = false;
  if (_blobSet != nullptr) {
    byte value[_hdr.DataSize] ;
    int32_t size = _hdr.DataSize;
    memcpy(value,&_buff,size);
    good = _blobSet(_hdr.Options[0], value, size, _hdr.NardId);
    if (good) {
      //got something..
      //send an ack back
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      good = (sent == sizeof(NardPacket));
    } else {
      //nothing..
      //send an nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_SET;
      _hdr.DataSize = 0;
    }
  } else {
    //no call back set..
    //send an nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_SET;
    _hdr.DataSize = 0;
  }
  return good;
}





// Params


bool Nard::_setParam(){
  bool result = false;
  if (_paramSet != nullptr) {
    int16_t params[4];
    memcpy(&params,&_buff,sizeof(params));
    result = _paramSet(_hdr.Options[1], params[0],params[1],params[2],params[3]);
    if (result) {
      //good result
      //send an ack back
      _hdr.Command = CMD_ACK;
      _hdr.Options[0] = CMD_PARAMS;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    } else {
      //bad result..
      //send an nak back
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_PARAMS;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      result = (sent == sizeof(NardPacket));
    }
  } else {
    //no call back set..
    //send an nak back
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_PARAMS;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    result = (sent == sizeof(NardPacket));
  }
  
}

//server wants some params..
bool Nard::_getParam() {
  int16_t params[4];
  bool good;
  if (_paramGet != nullptr) {
    good = _paramGet(_hdr.Options[1],&params[0],&params[1],&params[2],&params[3]);
    if (good) {
      //got it, thanks...
      _hdr.Command = CMD_PARAMS;
      _hdr.Options[0] = PARAM_SET;
      //leave 1 alone..
      _hdr.Options[2] = 0;
      _hdr.Options[3] = 0;
      _hdr.DataSize = sizeof(params);
      //zero buff
      memset(_buff, 0, sizeof(_buff));
      memcpy(&_buff,&_hdr,sizeof(_hdr));
      memcpy(&_buff[sizeof(_hdr)],&params,sizeof(params));
      int sent = _nard.write((uint8_t *)&_buff, sizeof(NardPacket) + _hdr.DataSize);
      good = (sent == sizeof(NardPacket) + _hdr.DataSize);
    } else {
      //bad result..
      //send nak
      _hdr.Command = CMD_NAK;
      _hdr.Options[0] = CMD_PARAMS;
      _hdr.DataSize = 0;
      int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
      good = (sent == sizeof(NardPacket));
    }

  } else {
    //no call back, send nak
    _hdr.Command = CMD_NAK;
    _hdr.Options[0] = CMD_PARAMS;
    _hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&_hdr, sizeof(NardPacket));
    good = (sent == sizeof(NardPacket));
  }
  return good;
}



//set and log a byte..
bool Nard::logVar(const uint8_t index, const uint8_t val,  uint16_t idNard ){
  //set and log a byte
  bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = idNard;
    Hdr.Command = CMD_SETNLOG;
    Hdr.Options[0] = index;
    Hdr.Options[1] = SG_BYTE;
    Hdr.Options[2] = val;
    Hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent == sizeof(NardPacket)) result = true;
  }   
  return result;
}

bool Nard::logVar(const uint8_t index, const uint16_t val,  uint16_t idNard ){
  //log a word
  bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = idNard;
    Hdr.Command = CMD_SETNLOG;
    Hdr.Options[0] = index;
    Hdr.Options[1] = SG_WORD;
    Hdr.Options[3] = val & 0xff;
    Hdr.Options[2] = val >> 8;
    Hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent == sizeof(NardPacket)) result = true;
  }   
  return result;
}

bool Nard::logVar(const uint8_t index, const int16_t val,  uint16_t idNard ){
  //log a int
  bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = idNard;
    Hdr.Command = CMD_SETNLOG;
    Hdr.Options[0] = index;
    Hdr.Options[1] = SG_INT16;
    Hdr.Options[3] = val & 0xff;
    Hdr.Options[2] = val >> 8;
    Hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent == sizeof(NardPacket)) result = true;
  }   
  return result;
}

bool Nard::logVar(const uint8_t index, const uint32_t val,  uint16_t idNard ){
  //log a u long..
bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardBuff4Packet pack;
    pack.Hdr.Ident[0] = IDENT_HI;
    pack.Hdr.Ident[1] = IDENT_LO;
    pack.Hdr.NardId = idNard;
    pack.Hdr.Command = CMD_SETNLOG;
    pack.Hdr.Options[0] = index;
    pack.Hdr.Options[1] = SG_UINT32;
    pack.Hdr.Options[3] = 0;
    pack.Hdr.Options[2] = 0;
    pack.Hdr.DataSize = sizeof(val);
    memcpy(&pack.buf,&val,sizeof(val));
    int sent = _nard.write((uint8_t *)&pack, sizeof(NardBuff4Packet));
    if (sent == sizeof(NardBuff4Packet)) result = true;
  }   
  return result;
}

bool Nard::logVar(const uint8_t index, const int32_t val,  uint16_t idNard ){
  
  //log a int32
bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardBuff4Packet pack;
    pack.Hdr.Ident[0] = IDENT_HI;
    pack.Hdr.Ident[1] = IDENT_LO;
    pack.Hdr.NardId = idNard;
    pack.Hdr.Command = CMD_SETNLOG;
    pack.Hdr.Options[0] = index;
    pack.Hdr.Options[1] = SG_INT32;
    pack.Hdr.Options[3] = 0;
    pack.Hdr.Options[2] = 0;
    pack.Hdr.DataSize = sizeof(val);
    memcpy(&pack.buf,&val,sizeof(val));
    int sent = _nard.write((uint8_t *)&pack, sizeof(NardBuff4Packet));
    if (sent == sizeof(NardBuff4Packet)) result = true;
  }   
  return result; 
}

bool Nard::logVar(const uint8_t index, const float val,  uint16_t idNard ){
   //log a float
bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardBuff4Packet pack;
    pack.Hdr.Ident[0] = IDENT_HI;
    pack.Hdr.Ident[1] = IDENT_LO;
    pack.Hdr.NardId = idNard;
    pack.Hdr.Command = CMD_SETNLOG;
    pack.Hdr.Options[0] = index;
    pack.Hdr.Options[1] = SG_FLT4;
    pack.Hdr.Options[3] = 0;
    pack.Hdr.Options[2] = 0;
    pack.Hdr.DataSize = sizeof(val);
    memcpy(&pack.buf,&val,sizeof(val));
    int sent = _nard.write((uint8_t *)&pack, sizeof(NardBuff4Packet));
    if (sent == sizeof(NardBuff4Packet)) result = true;
  }   
  return result;
}


bool Nard::logVar(const uint8_t index, const char* val,  uint16_t idNard ){
   //logs and sets a string
bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    _hdr.Ident[0] = IDENT_HI;
    _hdr.Ident[1] = IDENT_LO;
    _hdr.NardId = idNard;
    _hdr.Command = CMD_SETNLOG;
    _hdr.Options[0] = index;
    _hdr.Options[1] = SG_STR;
    _hdr.Options[3] = 0;
    _hdr.Options[2] = 0;
    _hdr.DataSize = strlen(val);
    memcpy(&_buff,&_hdr,sizeof(_hdr));
    memcpy(&_buff[sizeof(_hdr)],val,strlen(val));
    
    int sent = _nard.write((uint8_t *)&_buff, sizeof(_hdr)+_hdr.DataSize);
    if (sent == (sizeof(_hdr)+_hdr.DataSize)) result = true;
  }   
  return result;
  
}





bool Nard::setVar(const uint8_t index, const uint8_t val,  uint16_t idNard){
  //set a byte
  bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = idNard;
    Hdr.Command = CMD_SET;
    Hdr.Options[0] = index;
    Hdr.Options[1] = SG_BYTE;
    Hdr.Options[2] = val;
    Hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent == sizeof(NardPacket)) result = true;
  }   
  return result;
}

bool Nard::setVar(const uint8_t index, const uint16_t val,  uint16_t idNard){
  bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = idNard;
    Hdr.Command = CMD_SET;
    Hdr.Options[0] = index;
    Hdr.Options[1] = SG_WORD;
    Hdr.Options[3] = val & 0xff;
    Hdr.Options[2] = val >> 8;
    Hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent == sizeof(NardPacket)) result = true;
  }   
  return result;
  //set a word
}

bool Nard::setVar(const uint8_t index, const int16_t val,  uint16_t idNard){
  //set an int
  bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = idNard;
    Hdr.Command = CMD_SET;
    Hdr.Options[0] = index;
    Hdr.Options[1] = SG_INT16;
    Hdr.Options[3] = val & 0xff;
    Hdr.Options[2] = val >> 8;
    Hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent == sizeof(NardPacket)) result = true;
  }   
  return result;
}

bool Nard::setVar(const uint8_t index, const uint32_t val,  uint16_t idNard){
  //log a u long..
bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardBuff4Packet pack;
    pack.Hdr.Ident[0] = IDENT_HI;
    pack.Hdr.Ident[1] = IDENT_LO;
    pack.Hdr.NardId = idNard;
    pack.Hdr.Command = CMD_SET;
    pack.Hdr.Options[0] = index;
    pack.Hdr.Options[1] = SG_UINT32;
    pack.Hdr.Options[3] = 0;
    pack.Hdr.Options[2] = 0;
    pack.Hdr.DataSize = sizeof(val);
    memcpy(&pack.buf,&val,sizeof(val));
    int sent = _nard.write((uint8_t *)&pack, sizeof(NardBuff4Packet));
    if (sent == sizeof(NardBuff4Packet)) result = true;
  }   
  return result;
}

bool Nard::setVar(const uint8_t index, const int32_t val,  uint16_t idNard){
  //log a int232
bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;  
    NardBuff4Packet pack;
    pack.Hdr.Ident[0] = IDENT_HI;
    pack.Hdr.Ident[1] = IDENT_LO;
    pack.Hdr.NardId = idNard;
    pack.Hdr.Command = CMD_SET;
    pack.Hdr.Options[0] = index;
    pack.Hdr.Options[1] = SG_INT32;
    pack.Hdr.Options[3] = 0;
    pack.Hdr.Options[2] = 0;
    pack.Hdr.DataSize = sizeof(val);
    memcpy(&pack.buf,&val,sizeof(val));
    int sent = _nard.write((uint8_t *)&pack, sizeof(NardBuff4Packet));
    if (sent == sizeof(NardBuff4Packet)) result = true;
  }   
  return result;
  
}

bool Nard::setVar(const uint8_t index, const float val,  uint16_t idNard){
   //log a float
bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    NardBuff4Packet pack;
    pack.Hdr.Ident[0] = IDENT_HI;
    pack.Hdr.Ident[1] = IDENT_LO;
    pack.Hdr.NardId = idNard;
    pack.Hdr.Command = CMD_SET;
    pack.Hdr.Options[0] = index;
    pack.Hdr.Options[1] = SG_FLT4;
    pack.Hdr.Options[3] = 0;
    pack.Hdr.Options[2] = 0;
    pack.Hdr.DataSize = sizeof(val);
    memcpy(&pack.buf,&val,sizeof(val));
    int sent = _nard.write((uint8_t *)&pack, sizeof(NardBuff4Packet));
    if (sent == sizeof(NardBuff4Packet)) result = true;
  }   
  return result;
  
}


bool Nard::setVar(const uint8_t index, const char* val,  uint16_t idNard){
   //set a string
bool result = false;
  if (!_registered) return false;
if (_started) {
    if (idNard == 0) idNard =_nardID;
    _hdr.Ident[0] = IDENT_HI;
    _hdr.Ident[1] = IDENT_LO;
    _hdr.NardId = idNard;
    _hdr.Command = CMD_SET;
    _hdr.Options[0] = index;
    _hdr.Options[1] = SG_STR;
    _hdr.Options[3] = 0;
    _hdr.Options[2] = 0;
    _hdr.DataSize = strlen(val);
    memcpy(&_buff,&_hdr,sizeof(_hdr));
    memcpy(&_buff[sizeof(_hdr)],val,strlen(val));
    
    int sent = _nard.write((uint8_t *)&_buff, sizeof(_hdr)+_hdr.DataSize);
    if (sent == (sizeof(_hdr)+_hdr.DataSize)) result = true;
  }   
  return result;
  
}


bool Nard::setParams(const uint8_t index, const int16_t p1, const int16_t p2, const int16_t p3, const int16_t p4){
   //sends Params to server
bool result = false;
int16_t params[4];
  if (!_registered) return false;
if (_started) {
    NardParamPacket pack;
    pack.Hdr.Ident[0] = IDENT_HI;
    pack.Hdr.Ident[1] = IDENT_LO;
    pack.Hdr.NardId = _nardID;
    pack.Hdr.Command = CMD_PARAMS;
    pack.Hdr.Options[0] = PARAM_SET;
    pack.Hdr.Options[1] = index;
    pack.Hdr.Options[3] = 0;
    pack.Hdr.Options[2] = 0;
    pack.Hdr.DataSize = sizeof(params);
    pack.params[0]=p1;
    pack.params[1]=p2;
    pack.params[2]=p3;
    pack.params[3]=p4;
    int sent = _nard.write((uint8_t *)&pack, sizeof(NardParamPacket));
    if (sent == sizeof(NardParamPacket)) result = true;
  }   
  return result;
}





bool Nard::getVar(const uint8_t index, const uint8_t type, uint16_t idNard ){
  bool fail = true;
  if (!_registered) return !fail;
    if (_started) {
    if (idNard == 0) idNard =_nardID;      
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = idNard;
    Hdr.Command = CMD_GET;
    Hdr.Options[0] = index;
    Hdr.Options[1] = type;
    Hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent == sizeof(NardPacket)) fail = false;
  }
  return !fail;
}


//execute a command on a remote nard..
bool Nard::remoteCmd(const uint8_t nardId, const uint8_t cmd){
  bool fail = true;
  if (!_registered) return !fail;
    if (_started) {
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = nardId;
    Hdr.Command = CMD_EXE;
    Hdr.Options[0] = cmd;
    Hdr.Options[1] = 0;
    Hdr.Options[2] = 0;
    Hdr.Options[3] = 0;
    Hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent == sizeof(NardPacket)) fail = false;
  }
  return !fail;
}


bool Nard::_getImg(void){
  bool fail = true;
  if (!_registered) return !fail;
    if (_started) {
     if (_imgGet != nullptr) {
    _imgGet();
     }
    }  
}

//set a blob
bool Nard::setBlob(const uint8_t index, const uint8_t *buff, const int32_t size, uint16_t idNard){
  bool fail = false;
  if (!_registered) return fail;
    if (_started) {
      if (idNard ==0) idNard = _nardID;
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = idNard;
    Hdr.Command = CMD_SET;
    Hdr.Options[0] = index;
    Hdr.Options[1] = SG_BLOB;
    Hdr.DataSize = size;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent =! sizeof(NardPacket)) fail = true;
    if (!fail){
    int sent = _nard.write(buff, size);
    if (sent =! size) fail = true;
    }  
  }
  return !fail;  
}



bool Nard::setJpg(const uint8_t *buff, const int32_t size){
  bool fail = false;
  if (!_registered) return fail;
    if (_started) {
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = _nardID;
    Hdr.Command = CMD_SET;
    Hdr.Options[0] = 0;
    Hdr.Options[1] = SG_JPG;
    Hdr.DataSize = size;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent =! sizeof(NardPacket)) fail = true;
    if (!fail){
    int sent = _nard.write(buff, size);
    if (sent =! size) fail = true;
    }  
  }
  return !fail;  
}



bool Nard::logJpg(const uint8_t *buff, const int32_t size){
  bool fail = false;
  if (!_registered) return fail;
    if (_started) {
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = _nardID;
    Hdr.Command = CMD_SETNLOG;
    Hdr.Options[0] = 0;
    Hdr.Options[1] = SG_JPG;
    Hdr.DataSize = size;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent =! sizeof(NardPacket)) fail = true;
    if (!fail){
    int sent = _nard.write(buff, size);
    if (sent =! size) fail = true;
    }
  }
  return !fail;
}



bool Nard::_register() {
  //register with nard server
  if (_nard.connected()) {
    NardRegPacket pack;
    pack.hdr.Command = CMD_REG;
    pack.hdr.DataSize = sizeof(NardReg);
    pack.hdr.Ident[0] = IDENT_HI;
    pack.hdr.Ident[1] = IDENT_LO;
    pack.reg.GroupID = _groupID;
    pack.reg.NardID = _nardID;
    pack.reg.ProcessID = _processID;
    memcpy(pack.reg.DisplayName, _displayName, strlen(_displayName));
    int sent = _nard.write((uint8_t *)&pack, sizeof(NardRegPacket));
  }
}

bool Nard::_ping() {
  //send a nop to server..
  bool result = false;
  if (_started) {
    NardPacket Hdr;
    Hdr.Ident[0] = IDENT_HI;
    Hdr.Ident[1] = IDENT_LO;
    Hdr.NardId = _nardID;
    Hdr.Command = 0;
    Hdr.Options[0] = 0;
    Hdr.DataSize = 0;
    int sent = _nard.write((uint8_t *)&Hdr, sizeof(NardPacket));
    if (sent == sizeof(NardPacket)) result = true;
  }
  return result;
}

//check a code..
bool Nard::checkCode(char *str){
  bool result = false;
 if (!_registered) return false;
 if (_started) {
    uint32_t h = _hash(str);
    NardBuff4Packet pack;
    pack.Hdr.Ident[0] = IDENT_HI;
    pack.Hdr.Ident[1] = IDENT_LO;
    pack.Hdr.NardId = _nardID;
    pack.Hdr.Command = CMD_HASH;
    pack.Hdr.Options[0] = HASH_CHECK;
    pack.Hdr.Options[1] = 0;
    pack.Hdr.Options[3] = 0;
    pack.Hdr.Options[2] = 0;
    pack.Hdr.DataSize = sizeof(h);
    memcpy(&pack.buf,&h,sizeof(h));
    int sent = _nard.write((uint8_t *)&pack, sizeof(NardBuff4Packet));
    if (sent == sizeof(NardBuff4Packet)) result = true;
  }   
  return result;
}

void Nard::_respHash(){
//got a hash response back from server
  bool valid = false;
  if (_hdr.Options[0]== HASH_PASS) valid = true;
  if (_hashResp != nullptr) {
    _hashResp(valid);
  }  
}

//djb2
uint32_t Nard::_hash(char *str){
    uint32_t hash = 5381;
    int c;
    while (c = *str++)
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
    return hash;
}



