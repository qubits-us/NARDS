#include <WiFi.h>
#include <esp_camera.h>
#include "Nards.h"

// Pin definition for CAMERA_MODEL_AI_THINKER
#define PWDN_GPIO_NUM     32
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM      0
#define SIOD_GPIO_NUM     26
#define SIOC_GPIO_NUM     27

#define Y9_GPIO_NUM       35
#define Y8_GPIO_NUM       34
#define Y7_GPIO_NUM       39
#define Y6_GPIO_NUM       36
#define Y5_GPIO_NUM       21
#define Y4_GPIO_NUM       19
#define Y3_GPIO_NUM       18
#define Y2_GPIO_NUM        5
#define VSYNC_GPIO_NUM    25
#define HREF_GPIO_NUM     23
#define PCLK_GPIO_NUM     22

camera_config_t config;


const char *ssid = "Jelly";
const char *password = "2019jammified";

char *host = "192.168.0.51";  // IP of nards server
int port = 12000;             // server port


Nard nard;



//how many command
const byte NumCommands = 7;
//the commands to watch for
const char* Commands[] = {"SET", "GET", "TEMP", "STAT", "CONN", "RECON", "IMG"};
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

void OnJpg(void);
bool OnGetByte(const uint8_t index, uint8_t* value);
bool OnSetByte(const uint8_t index,const uint8_t value);
bool OnGetWord(const uint8_t index, uint16_t* value);
bool OnSetWord(const uint8_t index,const uint16_t value);
bool OnGetInt(const uint8_t index, int16_t* value);
bool OnSetInt(const uint8_t index,const int16_t value);
bool OnGeFloat(const uint8_t index, float* value);
bool OnSetFloat(const uint8_t index,const float value);
bool OnExeCommand(const uint8_t index);


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
  //start cam
  initCamera();
 //setup call backs..
  nard.onBytes(OnGetByte, OnSetByte);
  nard.onWords(OnGetWord, OnSetWord);
  nard.onInts(OnGetInt, OnSetInt);
  nard.onFloats(OnGetFloat, OnSetFloat);
  nard.onCommand(OnExeCommand);
  nard.onImage(OnJpg);
  nard.setReg("Nard X", 1, 0, 0);

  if (nard.begin(host, port)) {
    Serial.println("Nard connected..");
  }
  
  Serial.println("Commands: SET GET TEMP STAT CONN RECON IMG");
}


void initCamera() {
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;
  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;
  config.pin_sscb_sda = SIOD_GPIO_NUM;
  config.pin_sscb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;
  config.xclk_freq_hz = 20000000;
  config.pixel_format = PIXFORMAT_JPEG; 
  
  if(psramFound()){
    config.frame_size = FRAMESIZE_CIF;//FRAMESIZE_UXGA; // FRAMESIZE_ + QVGA|CIF|VGA|SVGA|XGA|SXGA|UXGA
    config.jpeg_quality = 10;
    config.fb_count = 2;
  } else {
    config.frame_size = FRAMESIZE_QVGA;
    config.jpeg_quality = 12;
    config.fb_count = 1;
  }  
  // Init Camera
  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }  
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
         case 6:SendJpg(); break;
     }    
     Serial.println("Commands: SET GET TEMP STAT CONN RECON IMG");
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



void OnJpg(){
  SendJpg();
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

bool OnSetByte(const uint8_t index,const  uint8_t value) {
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

bool OnSetWord(const uint8_t index,const  uint16_t value) {
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

bool OnSetInt(const uint8_t index,const  int16_t value) {
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

bool OnSetFloat(const uint8_t index,const  float value) {
  bool result = false;
  switch (index) {
    case 0: FloatArray[0] = value; result = true; break;
    case 1: FloatArray[1] = value; result = true; break;
    case 2: FloatArray[2] = value; result = true; break;
    case 3: FloatArray[3] = value; result = true; break;
    case 4: FloatArray[4] = value; result = true; break;
  }
}

void SendJpg() {      
camera_fb_t * fb = NULL;
  fb = esp_camera_fb_get();  
  if(!fb) {
    Serial.println("Camera capture failed");
    return;
  }
  nard.logJpg(fb->buf, fb->len);
  esp_camera_fb_return(fb); 
}


