#include <Servo.h>

Servo x, y;
unsigned short incomingByte;

int pos = 0;
void setup() {
  x.attach(2);
  y.attach(6);
  Serial.begin(57600);
}

void loop() {
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    if (incomingByte == 0) {
      while (Serial.available() <= 1);
      incomingByte = Serial.read();
      x.writeMicroseconds(map(incomingByte, 0, 255, 550, 1950));
      incomingByte = Serial.read();
      y.writeMicroseconds(map(incomingByte, 0, 255, 550, 1950));
    }
  }
}

