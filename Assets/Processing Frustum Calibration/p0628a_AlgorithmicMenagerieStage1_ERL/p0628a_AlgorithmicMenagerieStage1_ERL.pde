import java.awt.Frame;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
ControlPanel cp;

PGraphics left, right;

String data = "";

float coordsLength = 300;

PVector camL, camR, camFacingL, camFacingR, camOffset;
float theta, phi;

float frustumH = 48;
float frustumV = frustumH*1080.0/1920.0;
float frustumD = 54;
float eyeOffset = 2;

Grid grid;

int amt1 = 100;
int amt2 = 10;

CellEDF0 [] Cedf0s = new CellEDF0[amt1];
CellCB91 [] Ccb91s = new CellCB91[amt2];


void setup() {
  size(3840, 1080, P3D);
  smooth(8);
  frameRate(30);

  //Initialize PGraphics objects
  left = createGraphics(1920, 1080, P3D);
  right = createGraphics(1920, 1080, P3D);

  //Initialize OSC and Control Panel
  oscP5 = new OscP5(this, 6666);
  cp = new ControlPanel(this);

  //Initialize camera
  camL = new PVector(-eyeOffset, -height/8, height/2);
  camR = new PVector(eyeOffset, -height/8, height/2);
  camFacingL = new PVector(0, 0, 0);
  camFacingR = new PVector(0, 0, 0);
  camOffset = new PVector(0, 0, 0);

  theta = radians(90);
  phi = radians(270);

  grid = new Grid(10, 9, 16, 180);

  for (int i=0; i< amt1; i++) {
    Cedf0s[i] = new CellEDF0(0, 0, 1);
  }
  for (int i=0; i< amt2; i++) {
    Ccb91s[i] = new CellCB91(0, 0, 2);
  }
}

void draw() {

  if (onPress && !cp.visible) {
    theta = radians(90+(height/2-mouseY)*0.2);
    phi = radians(270+(mouseX-width/2)*0.2);
  }

  camOffset.set(100*sin(theta)*cos(phi), 100*cos(theta), 100*sin(theta)*sin(phi));
  grid.update();

  for (int i=0; i<amt1; i++) {
    for (int j=i+1; j<amt1; j++) {
      Cedf0s[i].repel(Cedf0s[j]);
    }
    for (int k=0; k<amt2; k++) {
      Cedf0s[i].repel(Ccb91s[k]);
    }
    Cedf0s[i].update();
  }

  for (int i=0; i<amt2; i++) {
    for (int j=i+1; j<amt2; j++) {
      Ccb91s[i].repel(Ccb91s[j]);
    }
    for (int k=0; k<amt1; k++) {
      Ccb91s[i].repel(Cedf0s[k]);
    }
    Ccb91s[i].update();
  }


  background(0);

  left.beginDraw();
  left.smooth(8);
  left.sphereDetail(20);
  left.background(0);
  left.pushMatrix();
  left.translate(left.width*.5, left.height*.5);
  camFacingL = PVector.add(camL, camOffset);
  left.camera(camL.x, camL.y, camL.z, camFacingL.x, camFacingL.y, camFacingL.z, 0, 1, 0);
  camR.x = camL.x + eyeOffset*2;
  camR.y = camL.y;
  camR.z = camL.z;
  drawCoords(left);
  left.ambientLight(100, 100, 100);
  left.directionalLight(255, 255, 255, 0.5, 0.5, -1);  
  left.lightFalloff(1, 0, 0);
  left.lightSpecular(0, 0, 0);
  left.frustum(-frustumH+eyeOffset, frustumH+eyeOffset, -frustumV, frustumV, frustumD, frustumD*100);
  grid.display(left);
  for (int i=0; i<amt1; i++) {
    Cedf0s[i].display(left);
  }
  for (int i=0; i<amt2; i++) {
    Ccb91s[i].display(left);
  }
  left.popMatrix();
  left.endDraw();

  right.beginDraw();
  right.smooth(8);
  right.sphereDetail(20);
  right.background(0);
  right.pushMatrix();
  right.translate(right.width*.5, right.height*.5);
  camFacingR = PVector.add(camR, camOffset);
  right.camera(camR.x, camR.y, camR.z, camFacingR.x, camFacingR.y, camFacingR.z, 0, 1, 0);
  drawCoords(right);
  right.ambientLight(100, 100, 100);  
  right.directionalLight(255, 255, 255, 0.5, 0.5, -1);
  right.lightFalloff(1, 0, 0);
  right.lightSpecular(0, 0, 0);
  right.frustum(-frustumH-eyeOffset, frustumH-eyeOffset, -frustumV, frustumV, frustumD, frustumD*100);
  grid.display(right);
  for (int i=0; i<amt1; i++) {
    Cedf0s[i].display(right);
  }
  for (int i=0; i<amt2; i++) {
    Ccb91s[i].display(right);
  }
  right.popMatrix();
  right.endDraw();


  image(left, 0, 0);
  image(right, 1920, 0);
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
      camL.x = float(fs[0])* cp.vMtpX + cp.vOftX - eyeOffset;
      camL.y = float(fs[2])* cp.vMtpY + cp.vOftY;
      camL.z = float(fs[1])* cp.vMtpZ + cp.vOftZ;

      /*float rx = float(fs[3])* cp.vMtpRX + cp.vOftRX;
       float ry = float(fs[4])* cp.vMtpRY + cp.vOftRY;
       float rz = float(fs[5])* cp.vMtpRZ + cp.vOftRZ;
       data = "x: " + x + "   y: " + y + "   z: " + z + "   rx: " + rx + "   ry: " + ry + "   rz: " + rz;
       if(frameCount%30 == 0) println(data);*/
    }
  }
  //println("### received an osc message. with address pattern "+ theOscMessage.addrPattern()+" typetag "+ theOscMessage.typetag());
}

