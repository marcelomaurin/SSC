/*
  Multiple Serial test

  Receives from the main serial port, sends to the others.
  Receives from serial port 1, sends to the main serial (Serial 0).

  This example works only with boards with more than one serial like Arduino Mega, Due, Zero etc.

  The circuit:
  - any serial device attached to Serial port 1
  - Serial Monitor open on Serial port 0

  created 30 Dec 2008
  modified 20 May 2012
  by Tom Igoe & Jed Roach
  modified 27 Nov 2015
  by Arturo Guadalupi

  This example code is in the public domain.
*/
#include <SoftwareSerial.h>
SoftwareSerial Serial1(2, 3);

void setup() {
  // initialize both serial ports:
  Serial.begin(2400);
  Serial1.begin(2400);
}

void loopback(){
    // read from port 1, send to port 0:
  if (Serial1.available()) {
    int inByte = Serial1.read();
    Serial.write(inByte);
  }

  // read from port 0, send to port 1:
  if (Serial.available()) {
    int inByte = Serial.read();
    if(inByte==3){Serial.println("ASC3");    
    Serial1.write(inByte);
  }
}


void loop() {
  loopback();
  
}
