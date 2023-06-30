#include <WiFi.h>
#include "Nards.h"



struct __attribute__((__packed__)) BlobData {
   uint16_t NardID;
   uint16_t GroupID;
   uint16_t ProcessID;
   float    Float1;
   float    Float2;
   float    Float3;
};

BlobData blob;



const char *ssid = "**********";
const char *password = "***********";

char *host = "192.168.0.51";  // IP of nards server
int port = 12000;             // server port


Nard nard;

char strArray[5][100]={"Hello\0","Hello\0","Hello\0","Hello\0","Hello\0"};


//how many command
const byte NumCommands = 6;
//the commands to watch for
const char* Commands[] = {"SET", "GET", "TEMP", "STAT", "CONN", "RECON"};
//buffer to store incomming
char buff[80];
//new value sent in XXX=100
int NewValue = 0;
//have we recv a command
bool CommandRecv = false;
//keep track of where we are
int CharCounter = 0;


//on board led for my esp32
const int led = 2;

uint8_t ByteArray[5];
word WordArray[5];
int   IntArray[5];
float FloatArray[5];
float temp = 80.4;

bool OnGetByte(const uint8_t index, uint8_t* value);
bool OnSetByte(const uint8_t index,const uint8_t value, const uint16_t idNard);
bool OnGetWord(const uint8_t index, uint16_t* value);
bool OnSetWord(const uint8_t index,const uint16_t value, const uint16_t idNard);
bool OnGetInt(const uint8_t index, int16_t* value);
bool OnSetInt(const uint8_t index,const int16_t value, const uint16_t idNard);
bool OnGeFloat(const uint8_t index, float* value);
bool OnSetFloat(const uint8_t index,const float value, const uint16_t idNard);
bool OnExeCommand(const uint8_t index);

bool OnGetStr(const uint8_t index, char* value);
bool OnSetStr(const uint8_t index,const char* value,uint16_t idNard);

bool OnGetBlob(const uint8_t index, uint8_t* value, int32_t* size);
bool OnSetBlob(const uint8_t index,const uint8_t* value, const int32_t size, const uint16_t idNard);



void setup(void) {

  pinMode(led, OUTPUT);
  digitalWrite(led, 0);

  Serial.begin(9600);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("Wfifi connecting");

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  //some fake blob data..
  blob.NardID = 100;
  blob.GroupID = 200;
  blob.ProcessID =  300;
  blob.Float1 = 3.14;
  blob.Float2 = 99.99;
  blob.Float3 = 1234.4321;

 //setup call backs..
  nard.onBytes(OnGetByte, OnSetByte);
  nard.onWords(OnGetWord, OnSetWord);
  nard.onInts(OnGetInt, OnSetInt);
  nard.onFloats(OnGetFloat, OnSetFloat);
  nard.onStrings(OnGetStr, OnSetStr);
  nard.onBlobs(OnGetBlob, OnSetBlob);  
  nard.onCommand(OnExeCommand);
  nard.setReg("Nard X", 1, 0, 0);

  if (nard.begin(host, port)) {
    Serial.println("Nard connected..");
  }
  delay(1000);
  Serial.println("Commands: SET GET TEMP STAT CONN RECON");
}


void loop(void) {
  nard.poll();
  CheckForCommand();
}



void CheckForCommand(){
  while (Serial.available())
  {
    char achar = Serial.read();
    if (achar != 10) {
      if (CharCounter < sizeof(buff)) {
        buff[CharCounter] = achar;
        CharCounter++;
      }
    } else CommandRecv = true;
  }
   //process incoming command..
   //use a switch statement for many commands..
  if (CommandRecv) {
    int cmd = ParseCommand(buff);
     switch (cmd){
         case 0:CmdSet(); break;
         case 1:CmdGet(); break;
         case 2:CmdTemp(); break;
         case 3:CmdStat(); break;
         case 4:CmdConn(); break;
         case 5:CmdReConn(); break;
     }    
     Serial.println("Commands: SET GET TEMP STAT CONN RECON");
    CommandRecv = false;
    CharCounter = 0;
    ZeroBuffer();
  }
}


void CmdReConn(){
    
    Serial.println("Attempting to connect..");
   if (nard.begin(host, port)){
      Serial.println("Connected to NARDS..");
   } else {
     Serial.println("Connection failed..");
   }
}



void CmdConn(){
  if (!nard.connected()){
    Serial.println("Attempting to connect..");
   if (nard.begin(host, port)){
      Serial.println("Connected to NARDS..");
   } else {
     Serial.println("Connection failed..");
   }
  } else {
    Serial.println("Already connected..");
  }
}

void CmdStat(){
  if (nard.connected()){
     Serial.println("Connected to NARDS");
     if (nard.isRegistered())
     Serial.println("Nard is registered"); else
     Serial.println("Nard is not registered.");
     if (nard.isStarted())
     Serial.println("Nard is started"); else
     Serial.println("Nard is not started.");
  } else
  {
    Serial.println("Not connected to NARDS");
  }
}

void CmdSet()
{
  nard.logVar(1,temp);
  
}
void CmdGet()
{
  nard.getVar(1, SG_FLT4);
}

void CmdTemp(){
  temp = temp - NewValue;
  
}
//splits incoming string
//into command and value
//returns the commands array position if found
//returns -1 if command was not found..
int ParseCommand(char* abuff) {

  int CommandNum = -1;
  int splits = 0;
  char* comm = nullptr;
  char* value = nullptr;
  Serial.println(abuff);

  for ( char* piece = strtok( abuff, "=");
        piece != nullptr;
        piece = strtok( nullptr, "=")) {
    if (splits == 0) {
      comm = piece;
      splits++;
    } else if (splits == 1) {
      value = piece;
      splits++;
    }
  }

  //convert and store our value
  if (value != nullptr) {
    Serial.println(value);
    NewValue = atoi(value);
  }

  if (comm != nullptr) {
    
    Serial.println(comm);
    for (int i = 0; i < NumCommands; i++) {
      if (strcmp(Commands[i], comm) == 0) {
        CommandNum = i;
        break;
      }
    }
  }
  return CommandNum;
}

//empties out the old..
void ZeroBuffer() {
  for (int i = 0; i < sizeof(buff); i++) {
    buff[i] = 0;
  }

}


bool OnGetBlob(const uint8_t index, uint8_t* value, int32_t* size){
  bool result = false;

  Serial.print("GetBlob index:");
  Serial.print(index);
  Serial.print(" Max Size:");
  Serial.write(*size);

  if (*size>=sizeof(blob)){
    memcpy(value, &blob,sizeof(blob));
     result = true;  
  Serial.print(" : ");
  Serial.write(*value);
  Serial.println("");
  } else
    Serial.println("blob data too big..");
  
  return result;
}

bool OnSetBlob(const uint8_t index,const uint8_t* value,const int32_t size, const uint16_t idNard){
  bool result = false;

  Serial.print("SetBlob index:");
  Serial.print(index);
  Serial.print(" Blob Size:");
  Serial.print(size);

  if (size==sizeof(blob)){
    memcpy(&blob, value,sizeof(blob));
     result = true;  
  Serial.print(" : ");
  Serial.print(blob.NardID);
  Serial.print(" : ");
  Serial.print(blob.GroupID);
  Serial.print(" : ");
  Serial.print(blob.ProcessID);
  Serial.print(" : ");
  Serial.print(blob.Float1);
  Serial.print(" : ");
  Serial.print(blob.Float2);
  Serial.print(" : ");
  Serial.print(blob.Float3);
  Serial.println("");
  } else
    Serial.println("blob data invalid size..");
  
  return result;
}



bool OnGetStr(const uint8_t index, char* value){
  bool result = false;

  Serial.print("GetStr index:");
  Serial.print(index);

  switch (index) {
    case 0: strcpy(value, strArray[0]); result = true; break;
    case 1: strcpy(value, strArray[1]); result = true; break;
    case 2: strcpy(value, strArray[2]); result = true; break;
    case 3: strcpy(value, strArray[3]); result = true; break;
    case 4: strcpy(value, strArray[4]); result = true; break;
  }
  Serial.print(" : ");
  Serial.println(value);
  return result;
}


bool OnSetStr(const uint8_t index,const char* value,uint16_t idNard){
  bool result = false;
  Serial.print("NardId: ");
  Serial.print(idNard);
  Serial.print(" SetStr index:");
  Serial.print(index);
  Serial.print(" : ");
  Serial.println(value);

  switch (index) {
    case 0: strcpy(strArray[0], value); result = true; break;
    case 1: strcpy(strArray[1], value); result = true; break;
    case 2: strcpy(strArray[2], value); result = true; break;
    case 3: strcpy(strArray[3], value); result = true; break;
    case 4: strcpy(strArray[4], value); result = true; break;
  }
}






//execute a command..
bool  OnExeCommand(const uint8_t index){
  bool result = false;
  switch (index) {
    case 0: result = true; Serial.print("Execute command: "); Serial.println(index); break;
    case 1: result = true; Serial.print("Execute command: "); Serial.println(index); break;
    case 2: result = true; Serial.print("Execute command: "); Serial.println(index); break;
    case 3: result = true; Serial.print("Execute command: "); Serial.println(index); break;
    case 4: result = true; Serial.print("Execute command: "); Serial.println(index); break;
  }
  return result;
  
}

bool OnGetByte(const uint8_t index, uint8_t* value) {
  bool result = false;
  Serial.print("OnGetByte: ");
  Serial.println(index);

  switch (index) {
    case 0: *value = ByteArray[0]; result = true; break;
    case 1: *value = ByteArray[1]; result = true; break;
    case 2: *value = ByteArray[2]; result = true; break;
    case 3: *value = ByteArray[3]; result = true; break;
    case 4: *value = ByteArray[4]; result = true; break;
  }
  Serial.println("after switch");
  return result;
}

bool OnSetByte(const uint8_t index,const  uint8_t value, const uint16_t idNard) {
  bool result = false;
  Serial.print("OnSetByte: ");
  Serial.print(index);
  Serial.print(" : ");
  Serial.println(value);
  switch (index) {
    case 0: ByteArray[0] = value; result = true; break;
    case 1: ByteArray[1] = value; result = true; break;
    case 2: ByteArray[2] = value; result = true; break;
    case 3: ByteArray[3] = value; result = true; break;
    case 4: ByteArray[4] = value; result = true; break;
  }
}

bool OnGetWord(const uint8_t index, uint16_t* value) {
  bool result = false;
  Serial.print("OnGetWord: ");
  Serial.println(index);

  switch (index) {
    case 0: *value = WordArray[0]; result = true; break;
    case 1: *value = WordArray[1]; result = true; break;
    case 2: *value = WordArray[2]; result = true; break;
    case 3: *value = WordArray[3]; result = true; break;
    case 4: *value = WordArray[4]; result = true; break;
  }
  return result;
}

bool OnSetWord(const uint8_t index,const  uint16_t value, const uint16_t idNard) {
  bool result = false;
  Serial.print("OnSetWord: ");
  Serial.print(index);
  Serial.print(" : ");
  Serial.println(value);
  
  switch (index) {
    case 0: WordArray[0] = value; result = true; break;
    case 1: WordArray[1] = value; result = true; break;
    case 2: WordArray[2] = value; result = true; break;
    case 3: WordArray[3] = value; result = true; break;
    case 4: WordArray[4] = value; result = true; break;
  }
}

bool OnGetInt(const uint8_t index, int16_t* value) {
  bool result = false;
  Serial.print("OnGetInt: ");
  Serial.println(index);

  switch (index) {
    case 0: *value = IntArray[0]; result = true; break;
    case 1: *value = IntArray[1]; result = true; break;
    case 2: *value = IntArray[2]; result = true; break;
    case 3: *value = IntArray[3]; result = true; break;
    case 4: *value = IntArray[4]; result = true; break;
  }
  return result;
}

bool OnSetInt(const uint8_t index,const  int16_t value, const uint16_t idNard) {
  bool result = false;
  Serial.print("OnSetInt: ");
  Serial.print(index);
  Serial.print(" : ");
  Serial.println(value);
  switch (index) {
    case 0: IntArray[0] = value; result = true; break;
    case 1: IntArray[1] = value; result = true; break;
    case 2: IntArray[2] = value; result = true; break;
    case 3: IntArray[3] = value; result = true; break;
    case 4: IntArray[4] = value; result = true; break;
  }
}


bool OnGetFloat(const uint8_t index, float* value) {
  bool result = false;

  switch (index) {
    case 0: *value = FloatArray[0]; result = true; break;
    case 1: *value = FloatArray[1]; result = true; break;
    case 2: *value = FloatArray[2]; result = true; break;
    case 3: *value = FloatArray[3]; result = true; break;
    case 4: *value = FloatArray[4]; result = true; break;
  }
  return result;
}

bool OnSetFloat(const uint8_t index,const  float value, const uint16_t idNard) {
  bool result = false;
  switch (index) {
    case 0: FloatArray[0] = value; result = true; break;
    case 1: FloatArray[1] = value; result = true; break;
    case 2: FloatArray[2] = value; result = true; break;
    case 3: FloatArray[3] = value; result = true; break;
    case 4: FloatArray[4] = value; result = true; break;
  }
}

