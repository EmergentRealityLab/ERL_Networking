import oscP5.*;
import netP5.*;

OscP5 oscP5;
ControlPanel cp;

String data = "";

float coordsLength = 300;

PVector cam, camOffset, camFacing;
float theta, phi;

Ball [] balls;

void setup() {
  size(1920, 1080, P3D);
  smooth(8);
  frameRate(30);

  //Initialize OSC and Control Panel
  oscP5 = new OscP5(this, 6666);
  cp = new ControlPanel(this);

  //Initialize camera
  cam = new PVector(0, -height/8, height/2);
  camOffset = new PVector(0, 0, 0);
  camFacing = new PVector(0, 0, 0);
  
  theta = radians(90);
  phi = radians(270);
  
  //Initialize balls
  balls = new Ball[40];
  for(int i=0; i<balls.length; i++){
    balls[i] = new Ball();
  }
}

void draw() {

  if (onPress && !cp.visible) {
    theta = radians(90+(height/2-mouseY)*0.2);
    phi = radians(270+(mouseX-width/2)*0.2);
  }

  camOffset.set(100*sin(theta)*cos(phi), 100*cos(theta), 100*sin(theta)*sin(phi));
  camFacing = PVector.add(cam, camOffset);

  background(0);
  pushMatrix();
  translate(width*.5, height*.5);
  camera(cam.x, cam.y, cam.z, camFacing.x, camFacing.y, camFacing.z, 0, 1, 0);
  drawCoords();
  
  ambientLight(0, 0, 0); 
  directionalLight(255, 255, 255, 0, 0, -1); 
  lightFalloff(1, 0, 0);
  lightSpecular(0, 0, 0);
  
  for(int i=0; i<balls.length; i++){
    balls[i].display();
  }
  popMatrix();
  noLights();
  cp.display();
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/visor")) {
    String s1 = theOscMessage.get(0).stringValue();
    //String s2 = theOscMessage.get(1).stringValue();
    //String s3 = theOscMessage.get(2).stringValue();
    //println("s1: " + s1);
    //println("s2: " + s2);
    //println("s3: " + s3);
    String [] fs = splitTokens(s1, " ");
    if (frameCount>0) {
      float x = float(fs[0])* cp.vMtpX + cp.vOftX;
      float y = float(fs[2])* cp.vMtpY + cp.vOftY;
      float z = float(fs[1])* cp.vMtpZ + cp.vOftZ;
      cam.x = x;
      cam.y = y;
      cam.z = z;
      /*float rx = float(fs[3])* cp.vMtpRX + cp.vOftRX;
       float ry = float(fs[4])* cp.vMtpRY + cp.vOftRY;
       float rz = float(fs[5])* cp.vMtpRZ + cp.vOftRZ;
       data = "x: " + x + "   y: " + y + "   z: " + z + "   rx: " + rx + "   ry: " + ry + "   rz: " + rz;
       if(frameCount%30 == 0) println(data);*/
    }
  }
  //println("### received an osc message. with address pattern "+ theOscMessage.addrPattern()+" typetag "+ theOscMessage.typetag());
}

