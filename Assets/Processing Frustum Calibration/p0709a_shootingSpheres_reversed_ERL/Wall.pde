class Wall {

  int cols, rows;
  PVector [][] vs;
  PVector [][] initLoc;
  PVector [][] range;
  String direction;

  float f, fIncre, xRange, yRange, zRange, xRangeOffset, yRangeOffset, zRangeOffset;

  Wall(int cols, int rows, String direction, float startX, float startY, float startZ, float cellSize) {
    this.cols = cols;
    this.rows = rows;
    this.direction = direction;

    vs = new PVector[rows][cols];
    initLoc = new PVector[rows][cols];
    range = new PVector[rows][cols];

    if (direction.equals("H")) {
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          vs[i][j] = new PVector(startX+i*cellSize, startY, startZ-j*cellSize);
          initLoc[i][j] = new PVector(startX+i*cellSize, startY, startZ-j*cellSize);
          range[i][j] = new PVector(0, 0, 0);
        }
      }
    } else if (direction.equals("V")) {
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          vs[i][j] = new PVector(startX, startY+i*cellSize, startZ-j*cellSize);
          initLoc[i][j] = new PVector(startX, startY+i*cellSize, startZ-j*cellSize);
          range[i][j] = new PVector(0, 0, 0);
        }
      }
    } else if (direction.equals("D")) {
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          vs[i][j] = new PVector(startX+j*cellSize, startY+i*cellSize, startZ);
          initLoc[i][j] = new PVector(startX+j*cellSize, startY+i*cellSize, startZ);
          range[i][j] = new PVector(0, 0, 0);
        }
      }
    }

    f = random(100);
    xRangeOffset = random(100);
    yRangeOffset = random(100);
    zRangeOffset = random(100);
    fIncre = 0.01;
  }

  void update(ArrayList spheres, PGraphics pg, String dir) {
    if (direction.equals("H")) {
      //Horizontal Wall vertices morphing
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          float xRangeT = 0, yRangeT = 0, zRangeT = 0, xOffset = 0, yOffset = 0, zOffset = 0;
          for (int k=0; k<spheres.size (); k++) {
            Sphere eachS = (Sphere)spheres.get(k);
            float distance = dist(eachS.loc.x, eachS.loc.y, eachS.loc.z, initLoc[i][j].x, initLoc[i][j].y, initLoc[i][j].z);
            if (distance<eachS.radiusT*2) {
              xRangeT += distance;
              yRangeT += (eachS.loc.y-initLoc[i][j].y)*(eachS.radiusT*2-distance)*0.05;
              zRangeT += distance;
            }
          }
          range[i][j].x = lerp(range[i][j].x, xRangeT, 0.25);
          range[i][j].y = lerp(range[i][j].y, yRangeT, 0.25);
          range[i][j].z = lerp(range[i][j].z, zRangeT, 0.25);

          xOffset = (noise(i*0.05+f+xRangeOffset, j*0.05+f+xRangeOffset)-0.5)*range[i][j].x;
          yOffset = noise(i*0.05+f+yRangeOffset, j*0.05+f+yRangeOffset)*range[i][j].y;
          zOffset = (noise(i*0.05+f+zRangeOffset, j*0.05+f+zRangeOffset)-0.5)*range[i][j].z;

          if (i == 0 || i == rows-1 || j == 0 || j == cols-1) {
            vs[i][j].set(initLoc[i][j].x, initLoc[i][j].y, initLoc[i][j].z);
          }else{
            vs[i][j].set(initLoc[i][j].x+xOffset, initLoc[i][j].y+yOffset, initLoc[i][j].z+zOffset);
          }
        }
      }
      //Draw the horizontal texture
      pg.imageMode(CENTER);
      pg.noStroke();
      pg.fill(0);
      for (int k=0; k<spheres.size (); k++) {
        Sphere eachS = (Sphere)spheres.get(k);
        float mappedX = -eachS.loc.z*0.5;
        float mappedY = (eachS.loc.x+480)*0.5;
        float diameter = 0;
        if (dir.equals("TOP")) diameter = eachS.diamT;
        else if (dir.equals("BOTTOM")) diameter = eachS.diamB;
        pg.image(portal, mappedX, mappedY, diameter*2.5, diameter*2.5);
        pg.ellipse(mappedX, mappedY, diameter, diameter);
      }
    } else if (direction.equals("V")) {
      //Vertical Wall vertices morphing
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          float xRangeT = 0, yRangeT = 0, zRangeT = 0, xOffset = 0, yOffset = 0, zOffset = 0;
          for (int k=0; k<spheres.size (); k++) {
            Sphere eachS = (Sphere)spheres.get(k);
            float distance = dist(eachS.loc.x, eachS.loc.y, eachS.loc.z, initLoc[i][j].x, initLoc[i][j].y, initLoc[i][j].z);
            if (distance<eachS.radiusT*2) {
              xRangeT += (eachS.loc.x-initLoc[i][j].x)*(eachS.radiusT*2-distance)*0.05;
              yRangeT += distance;
              zRangeT += distance;
            }
          }
          range[i][j].x = lerp(range[i][j].x, xRangeT, 0.25);
          range[i][j].y = lerp(range[i][j].y, yRangeT, 0.25);
          range[i][j].z = lerp(range[i][j].z, zRangeT, 0.25);

          xOffset = noise(i*0.05+f+xRangeOffset, j*0.05+f+xRangeOffset)*range[i][j].x;
          yOffset = (noise(i*0.05+f+yRangeOffset, j*0.05+f+yRangeOffset)-0.5)*range[i][j].y;
          zOffset = (noise(i*0.05+f+zRangeOffset, j*0.05+f+zRangeOffset)-0.5)*range[i][j].z;

          if (i == 0 || i == rows-1 || j == 0 || j == cols-1) {
            vs[i][j].set(initLoc[i][j].x, initLoc[i][j].y, initLoc[i][j].z);
          }else{
            vs[i][j].set(initLoc[i][j].x+xOffset, initLoc[i][j].y+yOffset, initLoc[i][j].z+zOffset);
          }
        }
      }
      //Draw the vertical texture
      pg.imageMode(CENTER);
      pg.noStroke();
      pg.fill(0);
      for (int k=0; k<spheres.size (); k++) {
        Sphere eachS = (Sphere)spheres.get(k);
        float mappedX = -eachS.loc.z*0.5;
        float mappedY = (eachS.loc.y+540)*0.5;
        float diameter = 0;
        if (dir.equals("LEFT")) diameter = eachS.diamL;
        else if (dir.equals("RIGHT")) diameter = eachS.diamR;
        pg.image(portal, mappedX, mappedY, diameter*2.5, diameter*2.5);
        pg.ellipse(mappedX, mappedY, diameter, diameter);
      }
    } else if (direction.equals("D")) {
      //Far Wall vertices morphing
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          float xRangeT = 0, yRangeT = 0, zRangeT = 0, xOffset = 0, yOffset = 0, zOffset = 0;
          for (int k=0; k<spheres.size (); k++) {
            Sphere eachS = (Sphere)spheres.get(k);
            float distance = dist(eachS.loc.x, eachS.loc.y, eachS.loc.z, initLoc[i][j].x, initLoc[i][j].y, initLoc[i][j].z);
            if (distance<eachS.radiusT*2) {
              xRangeT += distance;
              yRangeT += distance;
              zRangeT += (initLoc[i][j].z-eachS.loc.z)*(eachS.radiusT*2-distance)*0.05;
            }
          }
          range[i][j].x = lerp(range[i][j].x, xRangeT, 0.25);
          range[i][j].y = lerp(range[i][j].y, yRangeT, 0.25);
          range[i][j].z = lerp(range[i][j].z, zRangeT, 0.25);

          xOffset = (noise(i*0.05+f+xRangeOffset, j*0.05+f+xRangeOffset)-0.5)*range[i][j].x;
          yOffset = (noise(i*0.05+f+yRangeOffset, j*0.05+f+yRangeOffset)-0.5)*range[i][j].y;
          zOffset = noise(i*0.05+f+zRangeOffset, j*0.05+f+zRangeOffset)*range[i][j].z;

          if (i == 0 || i == rows-1 || j == 0 || j == cols-1) {
            vs[i][j].set(initLoc[i][j].x, initLoc[i][j].y, initLoc[i][j].z);
          }else{
            vs[i][j].set(initLoc[i][j].x+xOffset, initLoc[i][j].y+yOffset, initLoc[i][j].z+zOffset);
          }
        }
      }
    }
    f += fIncre;
  }

  void display(PGraphics pg, PGraphics tTpg) {
    pg.stroke(0, 128);
    pg.strokeWeight(1);
    //pg.noStroke();
    pg.fill(255);
    pg.beginShape(QUADS);
    pg.texture(tTpg);
    for (int i=0; i<rows-1; i++) {
      for (int j=0; j<cols-1; j++) {
        pg.vertex(vs[i][j].x, vs[i][j].y, vs[i][j].z, float(j)/float(cols)*tTpg.width, float(i)/float(rows)*tTpg.height);
        pg.vertex(vs[i][j+1].x, vs[i][j+1].y, vs[i][j+1].z, float(j+1)/float(cols)*tTpg.width, float(i)/float(rows)*tTpg.height);
        pg.vertex(vs[i+1][j+1].x, vs[i+1][j+1].y, vs[i+1][j+1].z, float(j+1)/float(cols)*tTpg.width, float(i+1)/float(rows)*tTpg.height);
        pg.vertex(vs[i+1][j].x, vs[i+1][j].y, vs[i+1][j].z, float(j)/float(cols)*tTpg.width, float(i+1)/float(rows)*tTpg.height);
      }
    }
    pg.endShape();
  }
}

