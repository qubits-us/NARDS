/**********************************************************************
  Filename    : Camera Car
  Product     : Freenove 4WD Car for ESP32
  Auther      : www.freenove.com
  Modification: 2021/03/05
**********************************************************************/

/*

NardBot - 4.7.2023 ~q

Modified Freenove 4WD car to be controlled by Nards Server..


*/

#include <Arduino.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiAP.h>
#include "esp_camera.h"
#include "Nards.h"
#include "Freenove_4WD_Car_WiFi.h"
#include "Freenove_4WD_Car_Emotion.h"
#include "Freenove_4WD_Car_WS2812.h"
#include "Freenove_4WD_Car_For_ESP32.h"

bool videoFlag = 1;
//nard params
bool OnSetParams(const uint8_t index,const  int16_t p1,const  int16_t p2,const  int16_t p3,const  int16_t p4);
bool OnGetParams(const uint8_t index, int16_t* p1, int16_t* p2, int16_t* p3, int16_t* p4);
//nard commands
bool OnExeCommand(const uint8_t index);
//nards wants a jpg
void OnJpg(void);


void WiFi_Init() {
  ssid_Router     =   "*****";    //Modify according to your router name
  password_Router =   "******";    //Modify according to your router password
  ssid_AP         =   "nard-bot";    //ESP32 turns on an AP and calls it nard-bot
  password_AP     =   "nard-bot";    //Set your AP password for ESP32 to nard-bot
  frame_size      =    FRAMESIZE_CIF;//400*296
}

char *host = "192.168.0.51";  // IP of nards server
int port = 12000;             // server port

//cam server vars
unsigned long lastCap = 0;
int capDelay = 100;


WiFiServer server_Camera(12001);
Nard nard;

void setup() {
  Buzzer_Setup();           //Buzzer initialization
  Serial.begin(115200);
  Serial.setDebugOutput(true);
  WiFi_Init();              //WiFi paramters initialization
  WiFi_Setup(0);            //Start AP Mode. If you want to connect to a router, change 1 to 0.
  //set nard call backs..
  nard.onParams(OnGetParams, OnSetParams);
  nard.onCommand(OnExeCommand);
  nard.onImage(OnJpg);  
  //set registration
  nard.setReg("NardBot-1", 20, 1, 1);
  //connect and attempt reg..
  if (nard.begin(host, port)) {
   // Serial.println("Nard connected..");
  }
  
 // server_Cmd.begin(4000);   //Start the command server
  server_Camera.begin(12001);//Turn on the camera server

  cameraSetup();            //Camera initialization
  Emotion_Setup();          //Emotion initialization
  WS2812_Setup();           //WS2812 initialization
  PCA9685_Setup();          //PCA9685 initialization
  //Light_Setup();            //Light initialization
  //Track_Setup();            //Track initialization

  disableCore0WDT();        //Turn off the watchdog function in kernel 0
  xTaskCreateUniversal(loopTask_Camera, "loopTask_Camera", 8192, NULL, 0, NULL, 0);
  xTaskCreateUniversal(loopTask_WTD, "loopTask_WTD", 8192, NULL, 0, NULL, 0);
  Serial.println("Ready..");
}

void loop() {
  
     nard.poll();
     
      //while connected..
     if (nard.connected()){ 
      Emotion_Show(emotion_task_mode);//Led matrix display function
      WS2812_Show(ws2812_task_mode);//Car color lights display function
     // Car_Select(carFlag);//ESP32 Car mode selection function
     } else Motor_Move(0, 0, 0, 0);//Stop the car
     // ESP.restart();
}




//execute a command..
bool  OnExeCommand(const uint8_t index){
  bool result = false;
  return result;  
}



bool OnSetParams(const uint8_t index,const  int16_t p1,const  int16_t p2,const  int16_t p3,const  int16_t p4) {
  bool result = false;
  switch (index) {
    case  CMD_LED_MOD:{ //Serial.println("SetParams: LED Mode");
            WS2812_SetMode(p1);
            result = true; 
            break;
           }
    case CMD_LED:{ //Serial.println("SetParams: LED");
              WS2812_Set_Color_1(p1, p2, p3, p4);
             result = true;
              break;
            }
    case CMD_MATRIX_MOD:{ //Serial.println("SetParams: Matrix Mode");
              Emotion_SetMode(p1);
             result = true;
             break;
            }
    case CMD_VIDEO:{ //Serial.println("SetParams: Video Flag");
              videoFlag = p1;
             result = true;
                break; 
            }
    case CMD_BUZZER:{ //Serial.println("SetParams: Buzzer");
              Buzzer_Variable(p1, p2);
              result = true;
               break;
            }
      case CMD_MOTOR:{ //Serial.println("SetParams: Motor");
               Car_SetMode(0);
               if (p1 == 0 && p3 == 0)
                Motor_Move(0, 0, 0, 0);//Stop the car
                 else //If the parameters are not equal to 0
                  Motor_Move(p1, p1, p3, p3);
                  result = true;
               break;
            }
    case CMD_SERVO:{ //Serial.println("SetParams: Servo");
                     if (p1 == 0)
                       Servo_1_Angle(p2);
                          else if (p1 == 1)
                              Servo_2_Angle(p2);
                        result = true;
                         break;
                     }
     case CMD_CAMERA:{//Serial.println("SetParams: Cam");
                        Servo_1_Angle(p1);
                        Servo_2_Angle(p2);
                        result = true;
                        break;
                      }
    case CMD_POWER:{ //Serial.println("SetParams: Batt Qry");
                         float battery_voltage = Get_Battery_Voltage();
                         nard.setVar(1,battery_voltage);
                        result = true;
                          break;
                     }
}
}

bool OnGetParams(const uint8_t index, int16_t* p1, int16_t* p2, int16_t* p3, int16_t* p4) {
  bool result = false;
  *p1=0;
  *p2=0;
  *p3=0;
  *p4=0;
}


void OnJpg(){
    SendJpg();
  }


void SendJpg() {      
  
//Serial.println("sending JPG..");  
bool videoFlagOrig = videoFlag;
      videoFlag = false;
camera_fb_t * fb = NULL;
  fb = esp_camera_fb_get();  
  if(!fb) {
  //  Serial.println("Camera capture failed");
    return;
  }
  if (!nard.logJpg(fb->buf, fb->len)){
    //Serial.println("failed to send jpg!");
  }
  esp_camera_fb_return(fb); 
  
  videoFlag = videoFlagOrig;
}







void loopTask_Camera(void *pvParameters) {
  while (1) {
    WiFiClient client = server_Camera.available();//listen for incoming clients
    if (client) {//if you get a client
      Serial.println("Camera_Server connected to a client.");
      if (client.connected()) {
        camera_fb_t * fb = NULL;
        while (client.connected()) {//loop while the client's connected
          if (videoFlag == 1) {
           if (millis()-lastCap>=capDelay){ 
             lastCap=millis();
            fb = esp_camera_fb_get();
            if (fb != NULL) {
              uint8_t slen[4];
              slen[0] = fb->len >> 0;
              slen[1] = fb->len >> 8;
              slen[2] = fb->len >> 16;
              slen[3] = fb->len >> 24;
              client.write(slen, 4);
              Serial.print("Camera sending:");
              Serial.println(fb->len);
              client.write(fb->buf, fb->len);
              esp_camera_fb_return(fb);
            } else
               Serial.println("Capture failed.");
             // delay(500);
          }
        }
        }
        //close the connection:
        client.stop();
       Serial.println("Camera Client Disconnected.");
        ESP.restart();
      }
    }
  }
}

