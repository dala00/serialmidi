import processing.serial.*;
import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus
Serial port;
int[] val = new int[3];
int valno = 0;

void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, -1, "loopMIDI Port"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
    String portName = Serial.list()[0];
    port=new Serial(this, portName, 31250);
}

void draw() {
  while (port.available() > 0) {
    int inByte = port.read();
    println(inByte);
    if (valno == 0) {
      if (inByte >= 128) {
        val[0] = inByte;
        valno++;
      }
    } else {
      val[valno++] = inByte;
      if (valno == 3) {
        valno = 0;
        if (val[0] == 128) {
          println(val);
          myBus.sendNoteOff(0, val[1], val[2]);
        } else if (val[0] == 144) {
          println(val);
          myBus.sendNoteOn(0, val[1], val[2]);
        }
      }
    }
  }
}
/*
void serialEvent(Serial p)
{
  for (int i = 0; i < 3; i++) {
    int inByte = port.read();
    val[i] = inByte;
    if (i == 0 && inByte < 128) {
      i = 3;
    }
  }
  if (val[0] == 128) {
    println(val);
    myBus.sendNoteOff(0, val[1], val[2]);
  } else if (val[0] == 144) {
    println(val);
    myBus.sendNoteOn(0, val[1], val[2]);
  }
}
*/
