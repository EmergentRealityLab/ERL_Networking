class CellCB91 {

  PVector loc, vel, acc; // Location, Velocity, Acceleration

  float offsetX, offsetY; // Offset for 2D noise field
  float thres; // Threshold for repulsion

  int index, lv, maxLv;
  float factor, factorIncre, 
  rRangeF, rRangeFIncre, rRange, 
  rnRangeF, rnRangeFIncre, rnRange;

  CellCB91 [] subCells;
  Vertex [] outers, mids, struts, quars, strutMids;

  CellCB91(int index, int lv, int maxLv) {
    this.index = index;
    this.lv = lv;
    this.maxLv = maxLv;

    loc = new PVector(random(-width/3, width/3), random(-height/3, height/3), random(-500, 500));
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);

    outers = new Vertex[6];
    mids = new Vertex[6];
    struts  = new Vertex[6];
    quars  = new Vertex[12];
    strutMids  = new Vertex[3];

    for (int i=0; i<outers.length; i++) {
      outers[i] = new Vertex();
      mids[i] = new Vertex();
      struts[i] = new Vertex();
    }
    for (int i=0; i<quars.length; i++) {
      quars[i] = new Vertex();
    }
    for (int i=0; i<strutMids.length; i++) {
      strutMids[i] = new Vertex();
    }

    init();

    if (lv<maxLv) {
      lv++;
      subCells = new CellCB91[7];
      for (int i=0;i<subCells.length;i++) {
        subCells[i] = new CellCB91(i, lv, maxLv);
      }
    }
  }

  private void init() {
    offsetX = random(100);
    offsetY = random(100);
    factor = random(100);
    rRangeF = random(100);
    rnRangeF = random(100);
    factorIncre = 0.01; 
    rRangeFIncre = 0.01;
    rnRangeFIncre = 0.01;
    rRange = 180;
    rnRange = PI/3.0;
    thres = rRange*5;
  }

  void repel(CellCB91 cc) { // Corresponding Cell
    PVector dir = new PVector(0, 0, 0);
    dir = PVector.sub(loc, cc.loc);
    if (dir.mag() < thres) {
      float force = 100/(dir.mag()+1);
      dir.normalize();
      dir.mult(force);
      acc.add(dir);
      cc.acc.sub(dir);
    }
  }

  void repel(CellEDF0 cc) { // Corresponding Cell
    PVector dir = new PVector(0, 0, 0);
    dir = PVector.sub(loc, cc.loc);
    if (dir.mag() < thres) {
      float force = 50/(dir.mag()+1);
      dir.normalize();
      dir.mult(force);
      cc.acc.sub(dir);
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
    float zDir = (noise(loc.x*0.01+frameCount*0.005+offsetX, loc.y*0.01+frameCount*0.005+offsetY)-0.5)*2;
    dir.set(cos(rdns), sin(rdns), zDir);
    dir.mult(mag);
    acc.add(dir);
    vel.add(acc);
    vel.limit(0.75);
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
      offsetX = random(100);
      offsetY = random(100);
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
      offsetX = random(100);
      offsetY = random(100);
    }
  }

  private void updateFrame() {
    for (int i=0; i<outers.length; i++) {
      float rnIncre = 2*PI/outers.length;
      float radius = rRange+(noise(rRangeF+i*0.2)-0.5)*rRange;
      float radian = rnIncre*i+(noise(rnRangeF+i*0.2)-0.5)*rnRange+noise(loc.x*0.002, loc.y*0.002)*2*PI;
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
    for (int i=0;i<quars.length;i++) {
      int j = (i/2+1)%outers.length;
      int k = ((i+1)/2)%mids.length;
      quars[i].update(outers[j], mids[k], 0.75);
    }

    //Update struts
    for (int i=0;i<struts.length;i++) {
      int j = (i%2+i)%mids.length;
      int k = (j+3+i%2)%outers.length;
      float strutRatio = noise(factor)*0.5;
      struts[i].update(outers[k], mids[j], strutRatio, offsetX, offsetY);
      factor += 0.1;
    }

    //Update strutMids
    for (int i=0;i<strutMids.length;i++) {
      int j = i*2;
      int k = (i*2+1)%struts.length;
      strutMids[i].update(struts[j], struts[k], 0.5);
    }

    //Recursion
    if (lv<maxLv) {
      factor ++;
      subCells[6].updateContent(struts, factor);
      factor += 0.05;

      for (int i=0;i<6;i++) {
        factor += 0.05;
        int outerQuarIndex1 = i*2;
        int outerQuarIndex2 = (i*2+1)%quars.length;
        int outerMidIndex1 = i;
        int outerMidIndex2 = (i+1)%mids.length;
        int strutMidIndex = i/2;
        if (i%2 == 0) {
          Vertex [] group = {
            quars[outerQuarIndex1], quars[outerQuarIndex2], mids[outerMidIndex2], strutMids[strutMidIndex], struts[i], mids[outerMidIndex1]
          };
          subCells[i].updateContent(group, factor);
        }
        else {
          Vertex [] group = {
            quars[outerQuarIndex1], quars[outerQuarIndex2], mids[outerMidIndex2], struts[i], strutMids[strutMidIndex], mids[outerMidIndex1]
          };
          subCells[i].updateContent(group, factor);
        }
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
    for (int i=0;i<struts.length;i++) {
      int j = (i+1)% struts.length;
      drawEdge(struts[i], struts[j], pg);
    }

    for (int i=0;i<quars.length;i++) {
      int j = (i+1)% quars.length;
      drawEdge(quars[i], quars[j], pg);
    }

    for (int i=0;i<struts.length;i++) {
      int j = (i%2+i)%mids.length;
      drawEdge(struts[i], mids[j], pg);
    }

    for (int i=0;i<strutMids.length;i++) {
      int j = (i*2+1)%mids.length;
      drawEdge(strutMids[i], mids[j], pg);
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

