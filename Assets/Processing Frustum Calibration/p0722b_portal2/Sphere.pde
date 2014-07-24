class Sphere {

  WavePlayer wpH, wpV;
  Gain gH, gV;
  Glide gGlideH, gGlideV, fGlideH, fGlideV;

  int cols, rows, life;
  PVector loc, locT, vel, acc;
  PVector [][] vs;
  float radius, radiusT, decay, rXOffset, rYOffset, rZOffset;
  float f, fIncre, fIncreT, radiusORange, radiusORangeT, fPhiOffset, fThetaOffset, fRadiusOffset;
  float diamT, diamB, diamL, diamR, diamTT, diamBT, diamLT, diamRT;

  color c;

  Sphere(float initX, float initY, float initZ, float radiusT, int rows, int cols, PVector initDir) {
    loc = new PVector(initX, initY, initZ);
    locT = new PVector(initX, initY, initZ);
    vel = new PVector(initDir.x, initDir.y, initDir.z);
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
    decay = random(0.9, 0.95);
    radiusORange = radiusT*5;
    radiusORangeT = 0;

    colorMode(HSB);
    c = color(random(255), random(255), 255);

    int randInt = floor(random(0, 4));

    //Initial sonification
    gGlideH = new Glide(ac, 0.0, 50);
    gGlideV = new Glide(ac, 0.0, 50);
    fGlideH = new Glide(ac, 20, 50);
    fGlideV = new Glide(ac, 20, 50);

    wpH = new WavePlayer(ac, fGlideH, Buffer.SINE);
    wpV = new WavePlayer(ac, fGlideV, Buffer.SINE);
    gH = new Gain(ac, 1, gGlideH);
    gV = new Gain(ac, 1, gGlideV);
    gH.addInput(wpH);
    gV.addInput(wpV);
  }

  void update() {

    if (life<60) {
      life++;
    }
    radiusORangeT = vel.mag()*5;

    fIncre = lerp(fIncre, fIncreT, 0.25);
    radiusORange = lerp(radiusORange, radiusORangeT, 0.25);
    radius = lerp(radius, radiusT, 0.25);

    diamT = lerp(diamT, diamTT, 0.25);
    diamB = lerp(diamB, diamBT, 0.25);
    diamL = lerp(diamL, diamLT, 0.25);
    diamR = lerp(diamR, diamRT, 0.25);

    gGlideH.setValue((diamT+diamB)/(radiusT*1.25+25));
    gGlideV.setValue((diamL+diamR)/(radiusT*1.25+25));

    checkEdge();
    updateLoc();

    fGlideH.setValue((480-abs(loc.x-0))/480.0*440);
    fGlideV.setValue((270-abs(loc.y+270))/270.0*440);

    updateVertices();
  }

  void setTarget(float tX, float tY, float tZ) {
    locT.set(tX, tY, tZ);
    PVector dir = PVector.sub(locT, loc);
    //float force = sqrt(dir.mag())*2/radiusT;
    float force = 0.5/(100-radiusT)+1;
    dir.normalize();
    dir.mult(force);
    acc.add(dir);
  }

  void repel(Sphere s) {
    PVector dir = PVector.sub(loc, s.loc);
    float thres = (radius+s.radius)*2;
    if (dir.x > -thres && dir.x < thres && dir.y > -thres && dir.y < thres) {
      float force = thres/((100-radius)*dir.mag()*0.1);
      //float force = (thres-dir.mag())/(sq(radius)*0.1);
      dir.normalize();
      dir.mult(force);
      acc.add(dir);
      s.acc.sub(dir);
    }
  }

  private void updateLoc() {

    vel.add(acc);
    float velMax = radius*0.5;
    if (vel.mag()>velMax && life == 60) {
      vel.normalize();
      vel.mult(velMax);
    }
    loc.add(vel);
    vel.mult(decay);
    acc.set(0, 0, 0);
  }

  private void checkEdge() {
    if (loc.z<0) {
      if (loc.x > 480+radiusT*2) {
        loc.x = -480-radiusT;
        PVector dir = new PVector(5, 0, 0);
        acc.add(dir);
      } else if (loc.x < -480-radiusT*2) {
        loc.x = 480+radiusT;
        PVector dir = new PVector(-5, 0, 0);
        acc.add(dir);
      }

      if (loc.y > 0+radiusT*2) {
        loc.y = -540-radiusT;
        PVector dir = new PVector(0, 5, 0);
        acc.add(dir);
      } else if (loc.y < -540-radiusT*2) {
        loc.y = 0+radiusT;
        PVector dir = new PVector(0, -5, 0);
        acc.add(dir);
      }

      if (loc.z < -1140+radiusT*1.5) {
        float force = (radiusT*1.5-(loc.z+1140))/(radiusT*1.5)*50;
        PVector dir = new PVector(0, 0, force);
        acc.add(dir);
      }

      if (loc.x > 480-radiusT*1.5 && loc.x<480+radiusT*1.5) {
        if (vel.mag()<3) {
          PVector dir = new PVector(radiusT*1.5-abs(480-loc.x), 0, 0);
          acc.add(dir);
        }
        diamRT = sqrt(sq(radiusT)-sq(constrain(480-loc.x, -radiusT, radiusT)))*1.25+25;
      } else if (loc.x < -480+radiusT*1.5 && loc.x>-480-radiusT*1.5) {
        if (vel.mag()<3) {
          PVector dir = new PVector(abs(-480-loc.x)-radiusT*1.5, 0, 0);
          acc.add(dir);
        }
        diamLT = sqrt(sq(radiusT)-sq(constrain(-480-loc.x, -radiusT, radiusT)))*1.25+25;
      } else {
        diamRT = 0;
        diamLT = 0;
      }

      if (loc.y > -radiusT*1.5 && loc.y< radiusT*1.5) {
        if (vel.mag()<3) {
          PVector dir = new PVector(0, radiusT*1.5-abs(0-loc.y), 0);
          acc.add(dir);
        }
        diamBT = sqrt(sq(radiusT)-sq(constrain(0-loc.y, -radiusT, radiusT)))*1.25+25;
      } else if (loc.y < -540+radiusT*1.5 && loc.y> -540-radiusT*1.5) {
        if (vel.mag()<3) {
          PVector dir = new PVector(0, abs(-540-loc.y)-radiusT*1.5, 0);
          acc.add(dir);
        }
        diamTT = sqrt(sq(radiusT)-sq(constrain(-540-loc.y, -radiusT, radiusT)))*1.25+25;
      } else {
        diamBT = 0;
        diamTT = 0;
      }
    } else {
      diamBT = 0;
      diamTT = 0;
    }
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
    pg.fill(255);
    //pg.noStroke();
    pg.stroke(0, 128);
    pg.strokeWeight(1);
    //pg.sphereDetail(10);

    pg.pushMatrix();
    pg.translate(loc.x, loc.y, loc.z);
    pg.rotateX(radians(rXOffset*frameCount));
    pg.rotateY(radians(rYOffset*frameCount));
    pg.rotateZ(radians(rZOffset*frameCount));
    //pg.sphere(radius);

    pg.beginShape(QUADS);
    for (int i=1; i<rows-2; i++) {
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

    pg.beginShape(TRIANGLES);
    for (int j=0; j<cols; j++) {
      int nextJ = (j+1)%cols;
      pg.vertex(vs[0][0].x, vs[0][0].y, vs[0][0].z);
      pg.vertex(vs[1][j].x, vs[1][j].y, vs[1][j].z);
      pg.vertex(vs[1][nextJ].x, vs[1][nextJ].y, vs[1][nextJ].z);

      pg.vertex(vs[rows-1][0].x, vs[rows-1][0].y, vs[rows-1][0].z);
      pg.vertex(vs[rows-2][j].x, vs[rows-2][j].y, vs[rows-2][j].z);
      pg.vertex(vs[rows-2][nextJ].x, vs[rows-2][nextJ].y, vs[rows-2][nextJ].z);
    }
    pg.endShape();

    pg.popMatrix();
  }
}

