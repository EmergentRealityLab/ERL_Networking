import java.awt.Frame;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
ControlPanel cp;

PGraphics left, right; //Left and right eye images

String data = ""; //Incoming OSC data

//Camera parameters
PVector camL, camR, camFacingL, camFacingR, camOffset;
float theta, phi;

//Frustum parameters
float fLeft, fRight, fTop, fBottom, fNear, fFar;
float eyeOffset = 5;

//Contents
Wall wallT, wallB, wallL, wallR, wallF; //Four walls

String sharedPath = "F:/Personal/Project/2014/p0723a_contraStage2/data/";

ArrayList<StaticPlaneObj> staticPlaneObjs;
ArrayList<StaticBoxObj> staticBoxObjs;
ArrayList<LaserShock> laserShocks;

StaticPlaneObj rockL, rockR, rockT, rockB, floor, subStage01, sideWallL, sideWallR;
StaticBoxObj boxLFT, boxLFB, boxLBT, boxLBB, boxRFT, boxRFB, boxRBT, boxRBB;
StaticBoxObj [] topBoxes;
StaticBoxObj [][] topStrips, shockBoxes;
LaserShock laserT, laserB;

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

  theta = radians(90);
  phi = radians(270);

  //Initialize contents
  wallT = new Wall(20, 11, "H", -300, -480, 0, 60, color(0));
  wallB = new Wall(20, 11, "H", -300, -60, 0, 60, color(255));
  wallL = new Wall(20, 8, "V", -300, -480, 0, 60, color(128, 128, 128));
  wallR = new Wall(20, 8, "V", 300, -480, 0, 60, color(128, 128, 128));
  wallF = new Wall(11, 8, "D", -300, -480, -1140, 60, color(127, 27, 13));

  staticPlaneObjs = new ArrayList<StaticPlaneObj>();
  staticBoxObjs = new ArrayList<StaticBoxObj>();
  laserShocks = new ArrayList<LaserShock>();

  rockL = new StaticPlaneObj(sharedPath+"rockL.jpg", new PVector(-480, -540, 0), new PVector(-300, -540, 0), new PVector(-300, 0, 0), new PVector(-480, 0, 0));
  rockR = new StaticPlaneObj(sharedPath+"rockR.jpg", new PVector(300, -540, 0), new PVector(480, -540, 0), new PVector(480, 0, 0), new PVector(300, 0, 0));
  rockT = new StaticPlaneObj(sharedPath+"rockT.jpg", new PVector(-300, -540, 0), new PVector(300, -540, 0), new PVector(300, -480, 0), new PVector(-300, -480, 0));
  rockB = new StaticPlaneObj(sharedPath+"rockB.jpg", new PVector(-300, -60, 0), new PVector(300, -60, 0), new PVector(300, 0, 0), new PVector(-300, 0, 0));
  floor = new StaticPlaneObj(sharedPath+"floor.jpg", new PVector(-300, -60, -1140), new PVector(300, -60, -1140), new PVector(300, -60, 0), new PVector(-300, -60, 0));
  subStage01 = new StaticPlaneObj(sharedPath+"subStage01.jpg", new PVector(-300, -480, -1140), new PVector(300, -480, -1140), new PVector(300, -60, -1140), new PVector(-300, -60, -1140));
  sideWallL = new StaticPlaneObj(sharedPath+"sideWall.jpg", new PVector(-300, -480, 0), new PVector(-300, -480, -1140), new PVector(-300, -60, -1140), new PVector(-300, -60, 0));
  sideWallR = new StaticPlaneObj(sharedPath+"sideWall.jpg", new PVector(300, -480, 0), new PVector(300, -480, -1140), new PVector(300, -60, -1140), new PVector(300, -60, 0));

  boxLFT = new StaticBoxObj(new PVector(-300, -480, 0), 10, 60, 560);
  boxLFT.setStrokeMode(new int[] {
    2, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1
  }
  , new int[] {
    0, 0, 0, 1, 0, 0
  }
  );
  boxLFT.setColors(color(128), color(0));
  boxLFB = new StaticBoxObj(new PVector(-300, -120, 0), 10, 60, 560);
  boxLFB.setStrokeMode(new int[] {
    2, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1
  }
  , new int[] {
    0, 1, 0, 0, 0, 0
  }
  );
  boxLFB.setColors(color(128), color(0));
  boxLBT = new StaticBoxObj(new PVector(-300, -480, -570), 10, 60, 560);
  boxLBT.setStrokeMode(new int[] {
    1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1
  }
  , new int[] {
    0, 0, 0, 1, 0, 0
  }
  );
  boxLBT.setColors(color(128), color(0));
  boxLBB = new StaticBoxObj(new PVector(-300, -120, -570), 10, 60, 560);
  boxLBB.setStrokeMode(new int[] {
    2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1
  }
  , new int[] {
    0, 1, 0, 0, 0, 0
  }
  );
  boxLBB.setColors(color(128), color(0));
  boxRFT = new StaticBoxObj(new PVector(290, -480, 0), 10, 60, 560);
  boxRFT.setStrokeMode(new int[] {
    2, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1
  }
  , new int[] {
    0, 0, 0, 1, 0, 0
  }
  );
  boxRFT.setColors(color(128), color(0));
  boxRFB = new StaticBoxObj(new PVector(290, -120, 0), 10, 60, 560);
  boxRFB.setStrokeMode(new int[] {
    2, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1
  }
  , new int[] {
    0, 1, 0, 0, 0, 0
  }
  );
  boxRFB.setColors(color(128), color(0));
  boxRBT = new StaticBoxObj(new PVector(290, -480, -570), 10, 60, 560);
  boxRBT.setStrokeMode(new int[] {
    1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1
  }
  , new int[] {
    0, 0, 0, 1, 0, 0
  }
  );
  boxRBT.setColors(color(128), color(0));
  boxRBB = new StaticBoxObj(new PVector(290, -120, -570), 10, 60, 560);
  boxRBB.setStrokeMode(new int[] {
    2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1
  }
  , new int[] {
    0, 1, 0, 0, 0, 0
  }
  );
  boxRBB.setColors(color(128), color(0));

  topBoxes = new StaticBoxObj[5];
  for (int i=0; i<topBoxes.length; i++) {
    topBoxes[i] = new StaticBoxObj(new PVector(-30, -480, -60-i*240), 60, 20, 120);
    topBoxes[i].setStrokeMode(new int[] {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    }
    , new int[] {
      0, 0, 0, 0, 0, 0
    }
    );
    topBoxes[i].setColors(color(255), color(255));
  }

  topStrips = new StaticBoxObj[3][10];
  for (int i=0; i<3; i++) {
    for (int j=0; j<10; j++) {
      topStrips[i][j] = new StaticBoxObj(new PVector(-250+50*j, -480, -120-i*480), 50, 10, 10);
      topStrips[i][j].setStrokeMode(new int[] {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
      , new int[] {
        0, 0, 0, 0, 0, 0
      }
      );
      topStrips[i][j].setColors(color(255), color(255));
    }
  }

  shockBoxes = new StaticBoxObj[2][2];
  for (int i=0; i<2; i++) {
    for (int j=0; j<2; j++) {
      shockBoxes[i][j] = new StaticBoxObj(new PVector(-300+550*j, -150+50*i, -40), 50, 20, 30);
      if (j%2==0) {
        shockBoxes[i][j].setStrokeMode(new int[] {
          2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
        }
        , new int[] {
          0, 1, 1, 0, 0, 0
        }
        );
      }else {
        shockBoxes[i][j].setStrokeMode(new int[] {
          2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
        }
        , new int[] {
          0, 1, 0, 0, 1, 0
        }
        );
      }
      shockBoxes[i][j].setColors(color(128), color(0));
    }
  }
  
  laserT = new LaserShock(new PVector(-250, -140, -55), new PVector(250, -140, -55), 10);
  laserB = new LaserShock(new PVector(-250, -90, -55), new PVector(250, -90, -55), 10);

  staticPlaneObjs.add(rockL);
  staticPlaneObjs.add(rockR);
  staticPlaneObjs.add(rockT);
  staticPlaneObjs.add(rockB);
  staticPlaneObjs.add(floor);
  staticPlaneObjs.add(subStage01);
  staticPlaneObjs.add(sideWallL);
  staticPlaneObjs.add(sideWallR);

  staticBoxObjs.add(boxLFT);
  staticBoxObjs.add(boxLFB);
  staticBoxObjs.add(boxLBT);
  staticBoxObjs.add(boxLBB);
  staticBoxObjs.add(boxRFT);
  staticBoxObjs.add(boxRFB);
  staticBoxObjs.add(boxRBT);
  staticBoxObjs.add(boxRBB);
  for (int i=0; i<topBoxes.length; i++) {
    staticBoxObjs.add(topBoxes[i]);
  }
  for (int i=0; i<3; i++) {
    for (int j=0; j<10; j++) {
      staticBoxObjs.add(topStrips[i][j]);
    }
  }
  for (int i=0; i<2; i++) {
    for (int j=0; j<2; j++) {
      staticBoxObjs.add(shockBoxes[i][j]);
    }
  }
  
  laserShocks.add(laserT);
  laserShocks.add(laserB);
}

void draw() {
  //Change viewing orientation when using mouse
  if (onPress && !cp.visible) {
    theta += radians((pmouseY-mouseY)*0.25);
    phi += radians((mouseX-pmouseX)*0.25);
  }
  camOffset.set(100*sin(theta)*cos(phi), 100*cos(theta), 100*sin(theta)*sin(phi));
  
  for(int i=0; i<laserShocks.size(); i++){
    LaserShock eachObj = laserShocks.get(i);
    eachObj.update();
  }
  
  //Draw contents to left and right eye images
  background(0);

  left.beginDraw();
  left.smooth(8);
  left.background(255);
  left.pushMatrix();
  left.translate(left.width*.5, left.height*.5);
  camFacingL = PVector.add(camL, camOffset);
  left.camera(camL.x, camL.y, camL.z, camFacingL.x, camFacingL.y, camFacingL.z, 0, 1, 0);
  camR.x = camL.x + eyeOffset*2;
  camR.y = camL.y;
  camR.z = camL.z;

  fNear = camL.z*0.1;//47.4
  fFar = camL.z*100;//4740
  fLeft = -(480+camL.x)*0.1;
  fRight = (480-camL.x)*0.1;
  fTop = (540+camL.y)*0.1;
  fBottom = camL.y*0.1;

  left.frustum(fLeft, fRight, fBottom, fTop, fNear, fFar);
  //drawCoords(left);
  drawScreen(left);
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

      /*float rx = float(fs[3])* cp.vMtpRX + cp.vOftRX;
       float ry = float(fs[4])* cp.vMtpRY + cp.vOftRY;
       float rz = float(fs[5])* cp.vMtpRZ + cp.vOftRZ;
       data = "x: " + x + "   y: " + y + "   z: " + z + "   rx: " + rx + "   ry: " + ry + "   rz: " + rz;
       if(frameCount%30 == 0) println(data);*/
    }
  }
  //println("### received an osc message. with address pattern "+ theOscMessage.addrPattern()+" typetag "+ theOscMessage.typetag());
}

