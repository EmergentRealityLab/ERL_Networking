import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLoc;

void setup() {
  size(400, 400);
  frameRate(30);

  oscP5 = new OscP5(this, 6666);
  remoteLoc = new NetAddress("129.161.12.174", 6666);
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

