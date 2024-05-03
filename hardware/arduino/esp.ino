#include <NewPing.h>
#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
#include <HardwareSerial.h>
// Provide the token generation process info.
#include <addons/TokenHelper.h>
// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "Oil_Skimmer"
#define WIFI_PASSWORD "oilskimmer"
// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino
/* 2. Define the API Key */
#define API_KEY "AIzaSyAzoGcjQhLNKA-ucNKiLlSZAKU2M9hZCEc"
/* 3. Define the RTDB URL */
#define DATABASE_URL "https://oilskimmer-5fc93-default-rtdb.firebaseio.com/"  //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "device@gmail.com"
#define USER_PASSWORD "12345678"
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
// Variable to save USER UID
String uid;
//Databse
String path;
//Funtion prototypes
void forward();
void backward();
void left();
void right();
void stop();
//Boat movement motor pins
#define motorPin1 27
#define motorPin2 26
#define motorPin3 25
#define motorPin4 33
const int motor1EN = 23;  // Enable pin for motor 1
const int motor2EN = 22;  // Enable pin for motor 2
const int freq = 30000;   // PWM frequency in Hz
const int resolution = 8;  // PWM resolution (8-bit)
const int motorSpeed = 180;

//Motor pins
#define filterMotor 13  //relay for the filter motor
#define pump 32         //relay for water pump
#define drain 14        //relay for the draining the water

//Ultrasonic
#define trigPin 2
#define echoPin 15
NewPing sonarS(trigPin, echoPin, 200); 
float oil  = 0;

FirebaseData stream;
void streamCallback(StreamData data) {
  Serial.println("NEW DATA!");

  String p = data.dataPath();
  Serial.println(p);
  printResult(data);
  FirebaseJson jVal = data.jsonObject();

  FirebaseJsonData direction;
  FirebaseJsonData isBelt;
  FirebaseJsonData isDumpOn;
  FirebaseJsonData isPumpOn;


  jVal.get(direction, "direction");
  jVal.get(isBelt, "isBelt");
  jVal.get(isDumpOn, "isDumpOn");
  jVal.get(isPumpOn, "isPumpOn");



  if (direction.success) {
    Serial.println("Success data direciton");
    String value = direction.to<String>();
    if (value == "f") {
      forward();
    }
    if (value == "b") {
      backward();
    }
    if (value == "l") {
      left();
    }
    if (value == "r") {
      right();
    }
    if (value == "s") {
      stop();
    }
  }

  if (isBelt.success) {
    Serial.println("Success data Belt");
    bool value = isBelt.to<bool>();
    if (value) {
      digitalWrite(filterMotor, LOW);
    } else {
      digitalWrite(filterMotor, HIGH);
    }
  }

  if (isDumpOn.success) {
    Serial.println("Success data Dump");
    bool value = isDumpOn.to<bool>();
    if (value) {
      digitalWrite(drain, LOW);
    } else {
      digitalWrite(drain, HIGH);
    }
  }

  if (isPumpOn.success) {
    Serial.println("Success data Pump");
    bool value = isPumpOn.to<bool>();
    if (value) {
      digitalWrite(pump, LOW);
    } else {
      digitalWrite(pump, HIGH);
    }
  }
}
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(motorPin1,OUTPUT);
  pinMode(motorPin2,OUTPUT);
  pinMode(motorPin3,OUTPUT);
  pinMode(motorPin4,OUTPUT);
  pinMode(motor1EN, OUTPUT);
  pinMode(motor2EN, OUTPUT);
  ledcSetup(0, freq, resolution);  // Channel 0 for motor 1
  ledcSetup(1, freq, resolution);  // Channel 0 for motor 1

  // Attach PWM channels to motor control pins
  ledcAttachPin(motor1EN, 0);  // Channel 0 for motor 1
  ledcAttachPin(motor2EN, 1);  // Channel 1 for motor 2
  ledcWrite(0, motorSpeed);   //Speed for the both motors (0-255)
  ledcWrite(1, motorSpeed);   //Speed for the both motors (0-255)



  pinMode(drain,OUTPUT);
  pinMode(pump,OUTPUT);
  pinMode(filterMotor,OUTPUT);



  //Turning of all motor (HIGH = OFF  and LOW = ON)
  digitalWrite(pump, HIGH);
  digitalWrite(drain, HIGH);
  digitalWrite(filterMotor, HIGH);




  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  //FIREBASE
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback;  // see addons/TokenHelper.h

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  path = "devices/" + uid + "/reading";

  //Stream setup
  if (!Firebase.beginStream(stream, "devices/" + uid + "/data"))
    Serial.printf("sream begin error, %s\n\n", stream.errorReason().c_str());

  Firebase.setStreamCallback(stream, streamCallback, streamTimeoutCallback);
}


void streamTimeoutCallback(bool timeout) {
  if (timeout)
    Serial.println("stream timed out, resuming...\n");

  if (!stream.httpConnected())
    Serial.printf("error code: %d, reason: %s\n\n", stream.httpCode(), stream.errorReason().c_str());
}


void updateData() {
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    FirebaseJson json;
    json.set("oil", oil);
    json.set(F("ts/.sv"), F("timestamp"));
    Serial.printf("Set data with timestamp... %s\n", Firebase.setJSON(fbdo, path.c_str(), json) ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());
    Serial.println("");
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  readDistance();
  updateData();
  
}

void readDistance() {
  // digitalWrite(trigPin, LOW);
  // delayMicroseconds(2);
  // // Sets the trigPin on HIGH state for 10 micro seconds
  // digitalWrite(trigPin, HIGH);
  // delayMicroseconds(10);
  // digitalWrite(trigPin, LOW);

  // long duration;
  // // Reads the echoPin, returns the sound wave travel time in microseconds
  // duration = pulseIn(echoPin, HIGH);
  // // Calculate the distance
  // dist = duration * SOUND_SPEED / 2;

   oil = sonarS.ping_cm();
   Serial.println(oil);
   delay(100);
}
void right() {
  digitalWrite(motorPin1, HIGH);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, HIGH);
  digitalWrite(motorPin4, LOW);
}
void left() {
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, HIGH);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, HIGH);
}

void forward() {
  digitalWrite(motorPin1, HIGH);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, HIGH);
}
void backward() {
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, HIGH);
  digitalWrite(motorPin3, HIGH);
  digitalWrite(motorPin4, LOW);
}

void stop() {
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, LOW);
}
