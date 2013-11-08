import controlP5.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLoc;
String data = "";

ControlP5 cp5;

Numberbox multiplierX, multiplierY, multiplierZ, 
multiplierRX, multiplierRY, multiplierRZ, 
offsetX, offsetY, offsetZ, 
offsetRX, offsetRY, offsetRZ;

float mltX = 1, mltY = 1, mltZ = 1, mltRX = 1, mltRY = 1, mltRZ = 1, ofsX = 0, ofsY = 0, ofsZ = 0, ofsRX = 0, ofsRY = 0, ofsRZ = 0;

void setup() {
  size(1280, 720);
  frameRate(30);

  oscP5 = new OscP5(this, 6666);
  remoteLoc = new NetAddress("129.161.12.174", 6666);

  cp5 = new ControlP5(this);

  multiplierX = cp5.addNumberbox("multiplierX")
    .plugTo(this, "mltX")
      .setPosition(100, 160);

  multiplierY = cp5.addNumberbox("multiplierY")
    .plugTo(this, "mltY")
      .setPosition(100, 208);

  multiplierZ = cp5.addNumberbox("multiplierZ")
    .plugTo(this, "mltZ")
      .setPosition(100, 256);

  multiplierRX = cp5.addNumberbox("multiplierRX")
    .plugTo(this, "mltRX")
      .setPosition(100, 304);

  multiplierRY = cp5.addNumberbox("multiplierRY")
    .plugTo(this, "mltRY")
      .setPosition(100, 352);

  multiplierRZ = cp5.addNumberbox("multiplierRZ")
    .plugTo(this, "mltRZ")
      .setPosition(100, 400);

  offsetX = cp5.addNumberbox("offsetX")
    .plugTo(this, "ofsX")
      .setPosition(220, 160);

  offsetY = cp5.addNumberbox("offsetY")
    .plugTo(this, "ofsY")
      .setPosition(220, 208);

  offsetZ = cp5.addNumberbox("offsetZ")
    .plugTo(this, "ofsZ")
      .setPosition(220, 256);

  offsetRX = cp5.addNumberbox("offsetRX")
    .plugTo(this, "ofsRX")
      .setPosition(220, 304);

  offsetRY = cp5.addNumberbox("offsetRY")
    .plugTo(this, "ofsRY")
      .setPosition(220, 352);

  offsetRZ = cp5.addNumberbox("offsetRZ")
    .plugTo(this, "ofsRZ")
      .setPosition(220, 400);

  autoFormatMultiplier(multiplierX);
  autoFormatMultiplier(multiplierY);
  autoFormatMultiplier(multiplierZ);
  autoFormatMultiplier(multiplierRX);
  autoFormatMultiplier(multiplierRY);
  autoFormatMultiplier(multiplierRZ);

  autoFormatOffset(offsetX);
  autoFormatOffset(offsetY);
  autoFormatOffset(offsetZ);
  autoFormatOffset(offsetRX);
  autoFormatOffset(offsetRY);
  autoFormatOffset(offsetRZ);
}

void draw() {
  background(255);
  fill(0);
  textSize(48);
  textAlign(LEFT, CENTER);
  text(data, width/2, height/2);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/visor")) {
    //String s1 = theOscMessage.get(0).stringValue();
    //String s2 = theOscMessage.get(1).stringValue();
    String s3 = theOscMessage.get(2).stringValue();
    //strength[i] = theOscMessage.get(0).floatValue();
    //println("s1: " + s1);
    //println("s2: " + s2);\
    String [] fs = splitTokens(s3, " ");
    float x = float(fs[0])* mltX + ofsX;
    float y = float(fs[1])* mltY + ofsY;
    float z = float(fs[2])* mltZ + ofsZ;
    float rx = float(fs[3])* mltRX + ofsRX;
    float ry = float(fs[4])* mltRY + ofsRY;
    float rz = float(fs[5])* mltRZ + ofsRZ;
    data = "x: " + x + "\n"+ "y: " + y + "\n"+  "z: " + z + "\n"+ "rx: " + rx + "\n"+ "ry: " + ry + "\n"+ "rz: " + rz;
  }
  //println("### received an osc message. with address pattern "+ theOscMessage.addrPattern()+" typetag "+ theOscMessage.typetag());
}

void keyPressed() {
  if (key == 'r') {
    String multiplier = "mltX: " + mltX + "\n"+ "mltY: " + mltY + "\n"+  "mltZ: " + mltZ + "\n"+ "mltRX: " + mltRX + "\n"+ "mltRY: " + mltRY + "\n"+ "mltRZ: " + mltRZ;
    println(multiplier);
    println("\n");
    String offset = "ofsX: " + ofsX + "\n"+ "ofsY: " + ofsY + "\n"+  "ofsZ: " + ofsZ + "\n"+ "ofsRX: " + ofsRX + "\n"+ "ofsRY: " + ofsRY + "\n"+ "ofsRZ: " + ofsRZ;
    println(offset);
  }
}

void autoFormatMultiplier(Numberbox target) {
  target.setSize(100, 44)
    .setMultiplier(0.05)
      .setScrollSensitivity(1.1)
        .setValue(1);
}

void autoFormatOffset(Numberbox target) {
  target.setSize(100, 44)
    .setMultiplier(0.5)
      .setScrollSensitivity(1.1)
        .setValue(0);
}

