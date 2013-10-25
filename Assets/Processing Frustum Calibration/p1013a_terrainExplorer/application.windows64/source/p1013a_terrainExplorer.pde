PVector cam, camT, camOffset, camOffsetT, camFacing;
float theta, phi, zNear, zFar;

int coordsLength = 300;

int camPjCol, camPjRow;

Terrain tr;
boolean inTl;

void setup() {
  size(1920, 1080, P3D);
  smooth(8);
  frameRate(30);
  background(255);
  
  tr = new Terrain(20, 20, 100, 0.1, 1250, "texture.jpg");//int cols, int rows, float cellSize, float noiseIncreRatio, float yRange, String path

  cam = new PVector(0, -height/8, height/2);
  camT = new PVector(0, -height/8, height/2);
  camOffset = new PVector(0, 0, 0);
  camOffsetT = new PVector(0, 0, 0);
  camFacing = new PVector(0, 0, 0);

  zNear = cam.z*0.1;
  zFar = cam.z*10;
}

void draw() {

  theta = radians(90+(height/2-mouseY)*0.2);
  phi = radians(270+(mouseX-width/2)*0.2);

  camOffsetT.set(100*sin(theta)*cos(phi), 100*cos(theta), 100*sin(theta)*sin(phi));
  cam.set(lerp(cam.x, camT.x, 0.25), lerp(cam.y, camT.y, 1), lerp(cam.z, camT.z, 0.25));
  camOffset.set(lerp(camOffset.x, camOffsetT.x, 0.25), lerp(camOffset.y, camOffsetT.y, 0.25), lerp(camOffset.z, camOffsetT.z, 0.25));
  camFacing = PVector.add(cam, camOffset);

  camPjCol = floor((cam.x+tr.cellSize*tr.cols*0.5)/tr.cellSize);
  camPjRow = floor((cam.z+tr.cellSize*tr.rows*0.5)/tr.cellSize);
  
  //println("camPjCol: "+camPjCol+", camPjRow: "+camPjRow);
  
  background(255);
  translate(width/2, height/2);
  camera(cam.x, cam.y, cam.z, camFacing.x, camFacing.y, camFacing.z, 0, 1, 0);
  lights();
  float left = 100;
  //frustum(-left, left, -left*float(height)/float(width), left*float(height)/float(width), zNear, zFar);
  drawCoords();
  updateAltitude();
  tr.display(camPjCol, camPjRow);
}

void drawCoords() {
  noFill();
  strokeWeight(5);
  stroke(0, 0, 255);
  line(0, 0, 0, coordsLength, 0, 0);//Axis X
  stroke(0, 255, 0);
  line(0, 0, 0, 0, -coordsLength, 0);//Axis Y
  stroke(255, 0, 0);
  line(0, 0, 0, 0, 0, coordsLength);//Axis Z
}

void updateAltitude(){
  float distToTl = dist(cam.x, cam.z, tr.vertices[camPjRow][camPjCol].x, tr.vertices[camPjRow][camPjCol].z);
  float distToBr = dist(cam.x, cam.z, tr.vertices[camPjRow+1][camPjCol+1].x, tr.vertices[camPjRow+1][camPjCol+1].z);
  float [] ratio;
  if(distToTl<distToBr){
    inTl = true;
    ratio = getRatio(tr.vertices[camPjRow+1][camPjCol].x, tr.vertices[camPjRow+1][camPjCol].z, 
                              tr.vertices[camPjRow][camPjCol].x, tr.vertices[camPjRow][camPjCol].z,
                              tr.vertices[camPjRow][camPjCol+1].x, tr.vertices[camPjRow][camPjCol+1].z,
                              cam.x, cam.z);
    camT.y = (ratio[0]*tr.vertices[camPjRow+1][camPjCol].y + ratio[1]*tr.vertices[camPjRow][camPjCol].y + ratio[2]*tr.vertices[camPjRow][camPjCol+1].y)-height/8;
  }
  else {
    inTl = false;
    ratio = getRatio(tr.vertices[camPjRow][camPjCol+1].x, tr.vertices[camPjRow][camPjCol+1].z, 
                              tr.vertices[camPjRow+1][camPjCol+1].x, tr.vertices[camPjRow+1][camPjCol+1].z,
                              tr.vertices[camPjRow+1][camPjCol].x, tr.vertices[camPjRow+1][camPjCol].z,
                              cam.x, cam.z);
    camT.y = (ratio[0]*tr.vertices[camPjRow][camPjCol+1].y + ratio[1]*tr.vertices[camPjRow+1][camPjCol+1].y + ratio[2]*tr.vertices[camPjRow+1][camPjCol].y)-height/8;
  }
}

float [] getRatio(float x1, float z1, float x2, float z2, float x3, float z3, float xAvg, float zAvg){
  float [] result = new float[3];
  
  float t1 = x2-x1;
  float t2 = x3-x1;
  float t3 = xAvg-x1;
  
  float t4 = z2-z1;
  float t5 = z3-z1;
  float t6 = zAvg-z1;
  
  result[2] = (t6*t1-t3*t4)/(t5*t1-t2*t4);
  result[1] = (t3*t5-t2*t6)/(t1*t5-t2*t4);
  result[0] = 1-result[2]-result[1];
  
  //println("result[2]: "+result[2]+", result[1]: "+result[1]);
  
  return result;
}
