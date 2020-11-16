import oscP5.*; //import required libraries
import processing.serial.*;

Serial arduinoPort; //set arduinoPort as serial connection
OscP5 oscP5; //set oscP5 as OSC connection

float xVal, yVal, suspensionAngle, steeringAngle;

void setup() {
  oscP5 = new OscP5(this, 8000); //start oscP5 and listen for incoming messages at port 8000
  arduinoPort = new Serial(this, Serial.list()[8], 115200); //set arduino to 115200 baud and find the correct serial port # (this depends on where your arduino is plugged in and may require some trial and error - #8 in my case)
}

void draw() { //found the script would not run properly without this function
  //
}

void oscEvent(OscMessage msg) { //this runs whenever there is a new OSC message
  
  String addr = msg.addrPattern();  //creates a string out of the OSC message
  
  if (addr.equals("/accxyz")) { //checks if OSC message is of the correct type (accelerometer data)
    
    xVal = msg.get(0).floatValue();  //x acceleration
    if ((xVal >= -0.5) && (xVal <= 0.5)) { //-0.5 & 0.5 are the bounds I set based on how far I'd like to be able to tilt my phone and still control the model 
      suspensionAngle = int(180*xVal + 90); //converts x acceleration to the desired servo angle - a simple linear relationship
    }
    
    yVal = msg.get(1).floatValue();  //y acceleration
    if ((yVal >= -0.3) && (yVal <= 0.3)) { //-0.3 & 0.3 are the bounds I set based on how far I'd like to be able to tilt my phone and still control the model
      steeringAngle = int(100*yVal + 95); //converts y acceleration to the desired servo angle - a simple linear relationship
    }
    
  }
  
  String message = (nf(suspensionAngle, 3, 0) + " " + nf(steeringAngle, 3, 0)); //creates a string composed of both desired servo angles
  arduinoPort.write(message); //sends above message to the arduinoPort declared in void setup()
  //println(message); //can use to test the message you are sending
  
}

//the following function can be used to test what message/data/string the arduino is receiving
//since Processing ocupies the serial port, the serial monitor cannot be used to display messages from the arduino script
//instead, you have to embed Serial.println(message) in the arduino script and whatever "message" is can be read and displayed in processing using the following function

/*void serialEvent(Serial arduinoPort) { 
  String message = arduinoPort.readStringUntil('\n');
  if (message != null) {
    println(message);
  }
}*/
