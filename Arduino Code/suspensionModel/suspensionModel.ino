#include <Servo.h> //include required library

Servo myServo1; //suspension servo
Servo myServo2; //steering servo
String message, suspensionAngle, steeringAngle; //message & message substrings from Processing

void setup() { 
  Serial.begin(115200); //set arduino to 115200 baud 
}

void loop() {

  while (Serial.available()) { //while the serial port is available
    
    if (Serial.available() >= 0) { //if there is a message being received
      message = Serial.readStringUntil(' '); //read until a break in the message
      if (message.length() == 6) { //confirm length of the message which should be constant based on the Processing script (don't believe this is necessary)
        steeringAngle = message.substring(0,3); //take the first half as the steering angle
        suspensionAngle = message.substring(3,6); //take the second half as the suspension angle
      }

      //Serial.println(message); //see last function in Processing script for more detail here

      myServo1.attach(6); //indicate which pins the servos are attached to (I found that attaching the servos here instead of in void setup() helps to avoid unwanted motion when the script starts running) 
      myServo2.attach(7);
      myServo1.write(suspensionAngle.toInt()); //send the desired angles to the servos (after converting from a string to integer)
      myServo2.write(steeringAngle.toInt());
      
    }
    
  }

}
