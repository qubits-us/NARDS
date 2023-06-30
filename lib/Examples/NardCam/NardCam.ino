#include <WiFi.h>
#include <esp_camera.h>
#include "Nards.h"

// Pin definition for CAMERA_MODEL_AI_THINKER
#define PWDN_GPIO_NUM 32
#define RESET_GPIO_NUM -1
#define XCLK_GPIO_NUM 0
#define SIOD_GPIO_NUM 26
#define SIOC_GPIO_NUM 27

#define Y9_GPIO_NUM 35
#define Y8_GPIO_NUM 34
#define Y7_GPIO_NUM 39
#define Y6_GPIO_NUM 36
#define Y5_GPIO_NUM 21
#define Y4_GPIO_NUM 19
#define Y3_GPIO_NUM 18
#define Y2_GPIO_NUM 5
#define VSYNC_GPIO_NUM 25
#define HREF_GPIO_NUM 23
#define PCLK_GPIO_NUM 22

camera_config_t config;


const char *ssid = "*******";
const char *password = "***********";

char *host = "192.168.0.51";  // IP of nards server
int port = 12000;             // server port
//cam server vars
unsigned long lastCap = 0;
int capDelay = 100;
int videoFlag = 1;

WiFiServer server_Camera(12100);
Nard nard;
void OnJpg(void);




void setup(void) {

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
  nard.onImage(OnJpg);
  nard.setReg("NardCam\0", 21, 0, 0);

  if (nard.begin(host, port)) {
    Serial.println("Nard connected..");
  }

  server_Camera.begin(12100);  //Turn on the camera server

  disableCore0WDT();  //Turn off the watchdog function in kernel 0
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
    //if we have additional ram
    Serial.println("Using PSRAM..");
  config.frame_size = FRAMESIZE_UXGA;
  config.jpeg_quality = 10;
  config.fb_count = 2;
} else {
  //no extra ram, lower res and 1 frame buffer
  Serial.println("PSRAM not found..");
  config.frame_size = FRAMESIZE_CIF;
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

  //listen for live viewers..
  WiFiClient client = server_Camera.available();
  if (client) {  //if you get a client
    Serial.println("Camera_Server connected to a client.");
    if (client.connected()) {  //we are connected..
      camera_fb_t *fb = NULL;
      while (client.connected()) {  //loop while the client's connected
        if (videoFlag == 1) {
          if (millis() - lastCap >= capDelay) {
            lastCap = millis();
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
        nard.poll();
      }
      //close the connection:
      client.stop();
      Serial.println("Camera Client Disconnected.");
      ESP.restart();
    }
  }
}



void OnJpg() {
  SendJpg();
}



void SendJpg() {

  Serial.println("sending JPG..");
  camera_fb_t *fb = NULL;
  fb = esp_camera_fb_get();
  if (!fb) {
    Serial.println("Camera capture failed");
    return;
  }
  if (!nard.setJpg(fb->buf, fb->len)) {
    Serial.println("failed to send jpg!");
  }
  esp_camera_fb_return(fb);
  Serial.println("JPG send complete..");
}
