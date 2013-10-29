import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLoc;

void setup() {
  size(400, 400);
  frameRate(30);

  ocsP5 = new OscP5(this, 12000);
  remoteLoc = new NetAddress("127.0.0.1", 12000);
}

void draw() {
  background(255);
}

void oscEvent(OscMessage theOscMessage) {
  /*if (theOscMessage.checkAddrPattern("/xthsense/"+i+"/features")) {
    strength[i] = theOscMessage.get(0).floatValue();
    //println(strength);
  }*/
  println("### received an osc message. with address pattern "+ theOscMessage.addrPattern()+" typetag "+ theOscMessage.typetag());
}

