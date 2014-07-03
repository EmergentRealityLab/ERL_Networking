class CellEDF0 {

  PVector loc, vel, acc; // Location, Velocity, Acceleration

  float offsetX, offsetY; // Offset for 2D noise field
  float thres; // Threshold for repulsion

  int index, lv, maxLv;
  float factor, factorIncre, 
  rRangeF, rRangeFIncre, rRange, 
  rnRangeF, rnRangeFIncre, rnRange;

  CellEDF0 [] subCells;
  Vertex [] outers, mids, struts, quars;

  CellEDF0(int index, int lv, int maxLv) {
    this.index = index;
    this.lv = lv;
    this.maxLv = maxLv;

    loc = new PVector(random(-width/3, width/3), random(-height/3, height/3), random(-500, 500));
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);

    outers = new Vertex[6];
    mids = new Vertex[6];
    struts = new Vertex[6];
    quars = new Vertex[12];

    for (int i=0; i<outers.length; i++) {
      outers[i] = new Vertex();
      mids[i] = new Vertex();
      struts[i] = new Vertex();
    }

    for (int i=0; i<quars.length; i++) {
      quars[i] = new Vertex();
    }

    init();

    if (lv<maxLv) {
      lv++;
      subCells = new CellEDF0[7];
      for (int i=0;i<subCells.length;i++) {
        subCells[i] = new CellEDF0(i, lv, maxLv);
      }
    }
  }

  private void init() {
    offsetX = 0;//random(100);
    offsetY = 0;//random(100);
    factor = random(100);
    rRangeF = random(100);
    rnRangeF = random(100);
    factorIncre = 0.05; 
    rRangeFIncre = 0.05;
    rnRangeFIncre = 0.05;
    rRange = 45;
    rnRange = PI/3.0;
    thres = rRange*5;
  }

  void repel(CellEDF0 cc) { // Corresponding Cell
    PVector dir = new PVector(0, 0, 0);
    dir = PVector.sub(loc, cc.loc);
    if (dir.mag() < thres) {
      float force = 15/(dir.mag()+1);
      dir.normalize();
      dir.mult(force);
      acc.add(dir);
      cc.acc.sub(dir);
    }
  }

  void repel(CellCB91 cc) { // Corresponding Cell
    PVector dir = new PVector(0, 0, 0);
    dir = PVector.sub(loc, cc.loc);
    if (dir.mag() < thres) {
      float force = 50/(dir.mag()+1);
      dir.normalize();
      dir.mult(force);
      acc.add(dir);
    }
  }

  void update() {

    updateLoc();
    updateFrame();
    updateContent(outers, factor);
    factor += factorIncre;
  }

  private void updateLoc() {
    PVector dir = new PVector(0, 0, 0);
    float rdns = noise(loc.x*0.005+offsetX, loc.y*0.005+offsetY)*4*PI;// radians
    float mag = noise(loc.x*0.005+offsetX, loc.y*0.005+offsetY);// magnitude
    float zDir = noise(loc.x*0.01+frameCount*0.005+offsetX, loc.y*0.01+frameCount*0.005+offsetY)-0.5;
    dir.set(cos(rdns), sin(rdns), zDir);
    dir.mult(mag);
    acc.add(dir);
    vel.add(acc);
    vel.limit(1.5);
    loc.add(vel);
    acc.set(0, 0, 0);

    checkEdge();
  }
  
  private void checkEdge() {
    
    /*float sX = pg.screenX(loc.x, loc.y, loc.z)-pg.width/2;
    float sY = pg.screenY(loc.x, loc.y, loc.z)-pg.height/2;

    if (sX < -pg.width/2-2*rRange || sX > pg.width/2+2*rRange || sY < -pg.height/2-2*rRange || sY > pg.height/2+2*rRange) {
      float randNumber = random(4);
      if (randNumber < 1) {
        loc.set(-pg.width/2-rRange, random(-pg.height/2, pg.height/2), random(-1260));
      }
      else if (randNumber >= 1 && randNumber < 2) {
        loc.set(pg.width/2+rRange, random(-pg.height/2, pg.height/2), random(-1260));
      }
      else if (randNumber >= 2 && randNumber < 3) {
        loc.set(random(-pg.width/2, pg.width/2), -pg.height/2-rRange, random(-1260));
      }
      else {
        loc.set(random(-pg.width/2, pg.width/2), pg.height/2+rRange, random(-1260));
      }
      offsetX = 0;//random(100);
      offsetY = 0;//random(100);
    }*/
    if(loc.x<-width/2-2*rRange || loc.x>width/2+2*rRange || loc.y<-height/2-2*rRange || loc.y>height/2+2*rRange){
      /*float randNumber = random(4);
      if (randNumber < 1) {
        loc.set(-width/2-rRange, random(-height/2, height/2), random(-500));
      }
      else if (randNumber >= 1 && randNumber < 2) {
        loc.set(width/2+rRange, random(-height/2, height/2), random(-500));
      }
      else if (randNumber >= 2 && randNumber < 3) {
        loc.set(random(-width/2, width/2), -height/2-rRange, random(-500));
      }
      else {
        loc.set(random(-width/2, width/2), height/2+rRange, random(-500));
      }*/
      loc.set(random(-width/2, width/2), random(-height/2, height/2), random(-500,500));
      offsetX = 0;//random(100);
      offsetY = 0;//random(100);
    }
  }

  private void updateFrame() {
    for (int i=0; i<outers.length; i++) {
      float rnIncre = 2*PI/outers.length;
      float radius = rRange+(noise(rRangeF+i*0.2)-0.5)*rRange;
      float radian = rnIncre*i+(noise(rnRangeF+i*0.2)-0.5)*rnRange+noise(loc.x*0.005, loc.y*0.005)*2*PI;
      float x = cos(radian)*radius +loc.x;
      float y = sin(radian)*radius +loc.y;
      float z = (noise((x+frameCount)*0.01+offsetX, (y+frameCount)*0.01+offsetY)-0.5)*200 +loc.z;

      outers[i].update(x, y, z);
    }
    rRangeF += rRangeFIncre;
    rnRangeF += rnRangeFIncre;
  }

  private void updateContent(Vertex[] outers, float factor) {

    this.outers = outers;

    //Update mids
    for (int i=0;i<mids.length;i++) {
      int j = (i+1)% outers.length;
      mids[i].update(outers[i], outers[j], 0.5);
    }
    //Update quars
    for (int i=0;i<quars.length;i+=2) {
      int j = (i/2+1)% mids.length;
      quars[i].update(mids[i/2], outers[j], 0.5);
      quars[i+1].update(outers[j], mids[j], 0.5);
    }
    //Update struts
    for (int i=0;i<struts.length;i++) {
      int j = (i+3)%6;
      float strutRatio = 1-noise(factor)*0.75;
      struts[i].update(mids[i], mids[j], strutRatio, offsetX, offsetY);
      factor += 0.1;
    }

    if (lv<maxLv) {
      factor++;
      subCells[6].updateContent(struts, factor);
      factor += 0.1;
      for (int i=0; i<6; i++) {
        int j = (i+1)%6;
        int k = (i*2)%12;
        Vertex [] group = {
          mids[i], quars[k], quars[k+1], mids[j], struts[j], struts[i]
        };
        subCells[i].updateContent(group, factor);
        factor += 0.1;
      }
    }
  }

  void display(PGraphics pg) {
    displayFrame(pg);
    displayContent(pg);
  }

  private void displayFrame(PGraphics pg) {
    for (int i=0;i<outers.length;i++) {
      int j = (i+1)% outers.length;
      drawEdge(outers[i], outers[j], pg);
    }
  }

  private void displayContent(PGraphics pg) {
    for (int i=0;i<mids.length;i++) {
      drawEdge(mids[i], struts[i], pg);
    }
    for (int i=0;i<quars.length;i+=2) {
      drawEdge(quars[i], quars[i+1], pg);
    }
    for (int i=0;i<struts.length;i++) {
      int j = (i+1)% struts.length;
      drawEdge(struts[i], struts[j], pg);
    }
    if (lv<maxLv) {
      for (int i=0; i<subCells.length; i++) {
        subCells[i].displayContent(pg);
      }
    }
  }

  private void drawEdge(Vertex v1, Vertex v2, PGraphics pg) {
    float distToCam = abs((v1.loc.z+v2.loc.z)*0.5-camL.z);
    float alpha = map(distToCam, 216, 2700, 200, 0);
    float weight = map(distToCam, 216, 2700, 3, 0);
    pg.stroke(0, alpha);
    pg.strokeWeight(weight);
    pg.line(v1.loc.x, v1.loc.y, v1.loc.z, v2.loc.x, v2.loc.y, v2.loc.z);
  }
}
