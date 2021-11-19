#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <EEPROM.h>

#define MAX_SRV_CLIENTS 4

WiFiServer server(333);
WiFiClient serverClients[MAX_SRV_CLIENTS];
bool station = false;

struct
{
  char ssid[64];
  char pass[64];
} settings;
  
void setup()
{
  Serial.begin(9600);  
  EEPROM.begin(128);
  EEPROM.get(0, settings);

  if (strlen(settings.ssid) != 0)
  {
    WiFi.disconnect(true);
    WiFi.mode(WIFI_STA);   
    WiFi.begin(settings.ssid, settings.pass);

    station = true;
    int tries = 0;
    
    Serial.print("Connecting");
    while (WiFi.status() != WL_CONNECTED) 
    {      
      delay(500);
      Serial.print(".");

      if (++tries == 20)
      {
        station = false;
        break;
      }
    }
    Serial.println();
  }
  
  if (!station)
  {
    WiFi.mode(WIFI_AP);
    WiFi.softAP("remoteXpress", "12345678");
    Serial.println(WiFi.softAPIP());
  }
  else
  {
    Serial.println("Connected as station");
    Serial.println(WiFi.localIP());
  }

  server.begin();
}

void loop()
{  
  uint8_t i;
  if (server.hasClient())
  {
    for (i = 0; i < MAX_SRV_CLIENTS; i++)
    {
      if (!serverClients[i] || !serverClients[i].connected())
      {
        if (serverClients[i]) serverClients[i].stop();
        serverClients[i] = server.available();
        continue;
      }
    }
    
    // no free spot
    WiFiClient serverClient = server.available();
    serverClient.stop();
  }
  
  for (i = 0; i < MAX_SRV_CLIENTS; i++)
  {
    if (serverClients[i] && serverClients[i].connected())
    {
      if (serverClients[i].available())
      {
        String data = "";        
        while (serverClients[i].available())
        {
          auto v = serverClients[i].read();
          Serial.write(v);
          data.concat((char)v);
        }
        
        if (data.startsWith("WIFI"))
        {
          int first = data.indexOf(' ');
          int last  = data.lastIndexOf(' ');
          
          String ssid = data.substring(first + 1, last);
          String pass = data.substring(last  + 1);
          ssid.toCharArray(settings.ssid, 64);
          pass.toCharArray(settings.pass, 64);
          
          EEPROM.put(0, settings);
          EEPROM.commit();
        }
      }
    }
  }
  
  if (Serial.available())
  {
    size_t len = Serial.available();
    uint8_t sbuf[len];
    Serial.readBytes(sbuf, len);
    
    for (i = 0; i < MAX_SRV_CLIENTS; i++)
    {
      if (serverClients[i] && serverClients[i].connected())
      {
        serverClients[i].write(sbuf, len);
        delay(1);
      }
    }
  }

  delay(10);
}