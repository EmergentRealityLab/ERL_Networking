import beads.*;
import org.jaudiolibs.beads.*;
import java.awt.Frame;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
ControlPanel cp;

PGraphics left, right; //Left and right eye images

String data = ""; //Incoming OSC data

//Camera parameters
PVector camL, camR, camFacingL, camFacingR, camOffset, camLDir;
float theta, phi;

//Frustum parameters
float fLeft, fRight, fTop, fBottom, fNear, fFar;
float eyeOffset = 5;

//Contents
ArrayList<Sphere> spheres; //Spheres
Wall wallT, wallB, wallL, wallR, wallF; //Four walls
PGraphics wallTtT, wallTtB, wallTtL, wallTtR, wallTtF;//Four walls textures
PImage portal, bg;

//Sonification
AudioContext ac;
Gain masterG;

void setup() {
  size(1920, 1080, P3D);
  smooth(8);
  frameRate(30);

  //Initialize PGraphics objects
  left = createGraphics(1920, 1080, P3D);
  right = createGraphics(1920, 1080, P3D);

  //Initialize OSC and Control Panel
  oscP5 = new OscP5(this, 6666);
  cp = new ControlPanel(this);

  //Initialize camera
  camL = new PVector(-eyeOffset, -height/4, 474);
  camR = new PVector(eyeOffset, -height/4, 474);
  camFacingL = new PVector(0, 0, 0);
  camFacingR = new PVector(0, 0, 0);
  camOffset = new PVector(0, 0, 0);
  camLDir = new PVector(0, 0);

  theta = radians(90);
  phi = radians(270);

  //Initialize contents
  spheres = new ArrayList<Sphere>();
  wallT = new Wall(20, 17, "H", -480, -540, 0, 60);
  wallB = new Wall(20, 17, "H", -480, 0, 0, 60);
  wallL = new Wall(20, 10, "V", -480, -540, 0, 60);
  wallR = new Wall(20, 10, "V", 480, -540, 0, 60);
  wallF = new Wall(17, 10, "D", -480, -540, -1140, 60);

  wallTtT = createGraphics(570, 480, P2D);
  wallTtB = createGraphics(570, 480, P2D);
  wallTtL = createGraphics(570, 270, P2D);
  wallTtR = createGraphics(570, 270, P2D);
  wallTtF = createGraphics(480, 270, P2D);

  portal = loadImage("E:/UnityProjects/ERL_Networking/Assets/Processing Frustum Calibration/p0709a_shootingSpheres_reversed_ERL/data/portal.png");
  bg = loadImage("E:/UnityProjects/ERL_Networking/Assets/Processing Frustum Calibration/p0709a_shootingSpheres_reversed_ERL/data/bg.jpg");

  //Initialize sonification
  ac = new AudioContext();
  masterG = new Gain(ac, 1, 1.0);

  ac.out.addInput(masterG);
  ac.start();
}

void draw() {
  //Change viewing orientation when using mouse
  if (onPress && !cp.visible) {
    theta += radians((pmouseY-mouseY)*0.25);
    phi += radians((mouseX-pmouseX)*0.25);
  }
  camOffset.set(100*sin(theta)*cos(phi), 100*cos(theta), 100*sin(theta)*sin(phi));

  //Update contents
  for (int i=0; i<spheres.size (); i++) {
    Sphere eachS = spheres.get(i);
    eachS.setTarget(0, -270, -474);//0, -270, -474
    for (int j=i+1; j<spheres.size (); j++) {
      Sphere anotherS = spheres.get(j);
      eachS.repel(anotherS);
    }
    eachS.update();
  }

  wallTtT.beginDraw();
  wallTtT.background(255);
  wallT.update(spheres, wallTtT, "TOP");
  wallTtT.endDraw();

  wallTtB.beginDraw();
  wallTtB.background(255);
  wallB.update(spheres, wallTtB, "BOTTOM");
  wallTtB.endDraw();

  wallTtL.beginDraw();
  wallTtL.background(255);
  wallL.update(spheres, wallTtL, "LEFT");
  wallTtL.endDraw();

  wallTtR.beginDraw();
  wallTtR.background(255);
  wallR.update(spheres, wallTtR, "RIGHT");
  wallTtR.endDraw();

  wallTtF.beginDraw();
  wallTtF.background(255);
  wallF.update(spheres, wallTtF, "FAR");
  wallTtF.endDraw();

  //Draw contents to left and right eye images
  background(0);

  left.beginDraw();
  left.smooth(8);
  left.background(255);
  //left.hint(DISABLE_DEPTH_TEST);
  //left.image(bg, 0, 0);
  //left.hint(ENABLE_DEPTH_TEST);
  left.pushMatrix();
  left.translate(left.width*.5, left.height*.5);
  camFacingL = PVector.add(camL, camOffset);
  left.camera(camL.x, camL.y, camL.z, camFacingL.x, camFacingL.y, camFacingL.z, 0, 1, 0);
  camR.x = camL.x + eyeOffset*2;
  camR.y = camL.y;
  camR.z = camL.z;
  left.ambientLight(0, 0, 0);
  left.directionalLight(255, 255, 255, 0, 0.5, -1);
  left.pointLight(255, 255, 255, 0, 0, 0);
  left.pointLight(255, 255, 255, 0, -540, 0);
  left.lightFalloff(1, 0, 0);
  left.lightSpecular(0, 0, 0);

  fNear = camL.z*0.1;//47.4
  fFar = camL.z*100;//4740
  fLeft = -(480+camL.x)*0.1;
  fRight = (480-camL.x)*0.1;
  fTop = (540+camL.y)*0.1;
  fBottom = camL.y*0.1;

  left.frustum(fLeft, fRight, fBottom, fTop, fNear, fFar);
  //drawCoords(left);
  drawScreen(left);
  for (int i=0; i<spheres.size (); i++) {
    Sphere eachS = spheres.get(i);
    eachS.display(left);
  }
  left.popMatrix();
  left.endDraw();

  /*right.beginDraw();
  right.smooth(8);
  right.background(255);
  right.pushMatrix();
  right.translate(right.width*.5, right.height*.5);
  camFacingR = PVector.add(camR, camOffset);
  right.camera(camR.x, camR.y, camR.z, camFacingR.x, camFacingR.y, camFacingR.z, 0, 1, 0);
  right.ambientLight(0, 0, 0);
  right.directionalLight(255, 255, 255, 0, 0.5, -1);
  right.pointLight(255, 255, 255, 0, 0, 0);
  right.pointLight(255, 255, 255, 0, -540, 0);
  right.lightFalloff(1, 0, 0);
  right.lightSpecular(0, 0, 0);

  fNear = camR.z*0.1;//47.4
  fFar = camR.z*100;//4740
  fLeft = -(480+camR.x)*0.1;
  fRight = (480-camR.x)*0.1;
  fTop = (540+camR.y)*0.1;
  fBottom = camR.y*0.1;

  right.frustum(fLeft, fRight, fBottom, fTop, fNear, fFar);
  //drawCoords(right);
  drawScreen(right);
  for (int i=0; i<spheres.size (); i++) {
    Sphere eachS = spheres.get(i);
    eachS.display(right);
  }
  right.popMatrix();
  right.endDraw();*/

  image(left, 0, 0);
  //image(left, 1920, 0);

  //Show control panel when it is activated
  cp.display();

  //saveFrame("F:/Personal/Project/2014/p0709a_shootingSpheres_reversed_ERL/seq/seq-######.jpg");
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

      /*float rx = float(fs[3]);
       float ry = float(fs[4]);
       float rz = float(fs[5]);*/
      camLDir.x = -float(fs[3])+270;
      camLDir.y = float(fs[4])+90;

      //println("RX: "+camLDir.x+", RY: "+camLDir.y);
      //float rx = float(fs[3])* cp.vMtpRX + cp.vOftRX;
      //float ry = float(fs[4])* cp.vMtpRY + cp.vOftRY;
      //float rz = float(fs[5])* cp.vMtpRZ + cp.vOftRZ;
      //data = "x: " + x + "   y: " + y + "   z: " + z + "   rx: " + rx + "   ry: " + ry + "   rz: " + rz;
    }
  } else if (theOscMessage.checkAddrPattern("/spawn")) {
    float radius = random(5, 100);
    int detailsLv = constrain(int(sqrt(radius)*1.5), 3, 15);
    PVector dir = new PVector(100*sin(radians(camLDir.y))*cos(radians(camLDir.x)), 100*cos(radians(camLDir.y)), 100*sin(radians(camLDir.y))*sin(radians(camLDir.x)));
    dir.normalize();
    dir.mult(100);
    Sphere addedS = new Sphere(camL.x+random(-25, 25), camL.y+random(-25, 25), camL.z+random(-25, 25), radius, detailsLv, detailsLv, dir);
    spheres.add(addedS);

    masterG.addInput(addedS.gH);
    masterG.addInput(addedS.gV);
  }
  //println("### received an osc message. with address pattern "+ theOscMessage.addrPattern()+" typetag "+ theOscMessage.typetag());
}

