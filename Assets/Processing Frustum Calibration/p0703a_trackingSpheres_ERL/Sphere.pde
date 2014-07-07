class Sphere {

  int cols, rows;
  PVector loc, locT, vel, acc;
  PVector [][] vs;
  float radius, radiusT, decay, rXOffset, rYOffset, rZOffset;

  float f, fIncre, fIncreT, radiusORange, radiusORangeT, fPhiOffset, fThetaOffset, fRadiusOffset;

  color c;

  Sphere(float initX, float initY, float initZ, float radiusT, int rows, int cols) {
    loc = new PVector(initX, initY, initZ);
    locT = new PVector(initX, initY, initZ);
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);
    this.radiusT = radiusT;
    radius = radiusT*0.5;

    this.rows = rows;
    this.cols = cols;
    vs = new PVector[rows][cols];
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        vs[i][j] = new PVector(0, 0, 0);
      }
    }

    rXOffset = random(-1, 1);
    rYOffset = random(-1, 1);
    rZOffset = random(-1, 1);

    f = random(100);
    fIncre = 0.01;
    fIncreT = 0.03;
    fPhiOffset = random(100);
    fThetaOffset = random(100);
    fRadiusOffset = random(100);
    decay = random(0.75, 0.9);
    radiusORange = radiusT*5;
    radiusORangeT = 0;

    colorMode(HSB);
    c = color(random(255), random(255), 255);
  }

  void update() {
    
    radiusORangeT = vel.mag()*5;
    
    fIncre = lerp(fIncre, fIncreT, 0.1);
    radiusORange = lerp(radiusORange, radiusORangeT, 0.1);
    radius = lerp(radius, radiusT, 0.1);

    updateLoc();
    updateVertices();
  }

  void setTarget(float tX, float tY, float tZ) {
    locT.set(tX, tY, tZ);
    PVector dir = PVector.sub(locT, loc);
    float force = sqrt(dir.mag())*2/radiusT;
    dir.normalize();
    dir.mult(force);
    acc.add(dir);
  }

  void repel(Sphere s) {
    PVector dir = PVector.sub(loc, s.loc);
    float thres = (radius+s.radius)*4;
    if (dir.x > -thres && dir.x < thres && dir.y > -thres && dir.y < thres) {
      float force = (thres-dir.mag())/radius;
      dir.normalize();
      dir.mult(force);
      acc.add(dir);
      s.acc.sub(dir);
    }
  }

  private void updateLoc() {
    vel.add(acc);
    float velMax = radius;
    if (vel.mag()>velMax) {
      vel.normalize();
      vel.mult(velMax);
    }
    loc.add(vel);
    vel.mult(decay);
    acc.set(0, 0, 0);
  }

  private void updateVertices() {
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {

        float phiO = noise(i*0.05+f+fPhiOffset, j*0.05+f+fPhiOffset)*2*PI;
        float thetaO = noise(i*0.05+f+fThetaOffset, j*0.05+f+fThetaOffset)*2*PI;
        float radiusO = noise(i*0.05+f+fThetaOffset, j*0.05+f+fThetaOffset)*radiusORange;

        float xO = radiusO*sin(thetaO)*cos(phiO);
        float yO = radiusO*cos(thetaO);
        float zO = radiusO*sin(thetaO)*sin(phiO);

        float x = radius*sin(i*PI/float(rows-1))*cos(2*j*PI/float(cols))+xO;
        float y = radius*sin(i*PI/float(rows-1))*sin(2*j*PI/float(cols))+yO;
        float z = radius*cos(i*PI/float(rows-1))+zO;
        vs[i][j].set(x, y, z);
      }
    }
    f += fIncre;
  }

  void display(PGraphics pg) {
    pg.fill(0);
    //pg.noStroke();
    pg.stroke(255);
    pg.strokeWeight(2);
    //pg.sphereDetail(10);

    pg.pushMatrix();
    pg.translate(loc.x, loc.y, loc.z);
    pg.rotateX(radians(rXOffset*frameCount));
    pg.rotateY(radians(rYOffset*frameCount));
    pg.rotateZ(radians(rZOffset*frameCount));
    //pg.sphere(radius);

    pg.beginShape(QUADS);
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        int nextJ = (j+1)%cols;
        int nextI = (i+1)%rows;
        pg.vertex(vs[i][j].x, vs[i][j].y, vs[i][j].z);
        pg.vertex(vs[i][nextJ].x, vs[i][nextJ].y, vs[i][nextJ].z);
        pg.vertex(vs[nextI][nextJ].x, vs[nextI][nextJ].y, vs[nextI][nextJ].z);
        //pg.vertex(vs[i][j].x, vs[i][j].y, vs[i][j].z);
        pg.vertex(vs[nextI][j].x, vs[nextI][j].y, vs[nextI][j].z);
        //pg.vertex(vs[nextI][nextJ].x, vs[nextI][nextJ].y, vs[nextI][nextJ].z);
      }
    }
    pg.endShape();

    pg.popMatrix();
  }
}

