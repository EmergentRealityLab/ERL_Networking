class Wall {

  int cols, rows;
  PVector [][] vs;
  PVector [][] initLoc;
  PVector [][] range;
  boolean horizontal;
  
  float f, fIncre, xRange, yRange, zRange, xRangeOffset, yRangeOffset, zRangeOffset;

  Wall(int cols, int rows, boolean horizontal, float startX, float startY, float startZ, float cellSize) {
    this.cols = cols;
    this.rows = rows;
    this.horizontal = horizontal;
    
    vs = new PVector[rows][cols];
    initLoc = new PVector[rows][cols];
    range = new PVector[rows][cols];

    if (horizontal) {
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          vs[i][j] = new PVector(startX+i*cellSize, startY, startZ-j*cellSize);
          initLoc[i][j] = new PVector(startX+i*cellSize, startY, startZ-j*cellSize);
          range[i][j] = new PVector(0,0,0);
        }
      }
    }
    else {
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          vs[i][j] = new PVector(startX, startY+i*cellSize, startZ-j*cellSize);
          initLoc[i][j] = new PVector(startX, startY+i*cellSize, startZ-j*cellSize);
          range[i][j] = new PVector(0,0,0);
        }
      }
    }
    
    f = random(100);
    xRangeOffset = random(100);
    yRangeOffset = random(100);
    zRangeOffset = random(100);
    fIncre = 0.01;
  }
  
  void update(ArrayList spheres){
    if (horizontal) {
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          float xRangeT = 0;
          float yRangeT = 0;
          float zRangeT = 0;
          float xOffset = 0;
          float yOffset = 0;
          float zOffset = 0;
          for(int k=0; k<spheres.size();k++){
            Sphere eachS = (Sphere)spheres.get(k);
            float distance = dist(eachS.loc.x, eachS.loc.y, eachS.loc.z, initLoc[i][j].x, initLoc[i][j].y, initLoc[i][j].z);
            if(distance<eachS.radiusT*2){
              xRangeT += distance;
              yRangeT += (eachS.loc.y-initLoc[i][j].y)*(eachS.radiusT*2-distance)*0.05;
              zRangeT += distance;
            }
          }
          range[i][j].x = lerp(range[i][j].x, xRangeT, 0.25);
          range[i][j].y = lerp(range[i][j].y, yRangeT, 0.25);
          range[i][j].z = lerp(range[i][j].z, zRangeT, 0.25);
          
          xOffset = (noise(i*0.05+f+xRangeOffset,j*0.05+f+xRangeOffset)-0.5)*range[i][j].x;
          yOffset = noise(i*0.05+f+yRangeOffset,j*0.05+f+yRangeOffset)*range[i][j].y;
          zOffset = (noise(i*0.05+f+zRangeOffset,j*0.05+f+zRangeOffset)-0.5)*range[i][j].z;
          
          vs[i][j].set(
            initLoc[i][j].x+xOffset,
            initLoc[i][j].y+yOffset,
            initLoc[i][j].z+zOffset
          );
          //vs[i][j] = new PVector(startX+i*cellSize, startY, startZ-j*cellSize);
          //initLoc[i][j] = new PVector(startX+i*cellSize, startY, startZ-j*cellSize);
        }
      }
    }
    else{
      for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
          float xRangeT = 0;
          float yRangeT = 0;
          float zRangeT = 0;
          float xOffset = 0;
          float yOffset = 0;
          float zOffset = 0;
          for(int k=0; k<spheres.size();k++){
            Sphere eachS = (Sphere)spheres.get(k);
            float distance = dist(eachS.loc.x, eachS.loc.y, eachS.loc.z, initLoc[i][j].x, initLoc[i][j].y, initLoc[i][j].z);
            if(distance<eachS.radiusT*2){
              xRangeT += (eachS.loc.x-initLoc[i][j].x)*(eachS.radiusT*2-distance)*0.05;
              yRangeT += distance;
              zRangeT += distance;
            }
          }
          range[i][j].x = lerp(range[i][j].x, xRangeT, 0.25);
          range[i][j].y = lerp(range[i][j].y, yRangeT, 0.25);
          range[i][j].z = lerp(range[i][j].z, zRangeT, 0.25);
          
          xOffset = noise(i*0.05+f+xRangeOffset,j*0.05+f+xRangeOffset)*range[i][j].x;
          yOffset = (noise(i*0.05+f+yRangeOffset,j*0.05+f+yRangeOffset)-0.5)*range[i][j].y;
          zOffset = (noise(i*0.05+f+zRangeOffset,j*0.05+f+zRangeOffset)-0.5)*range[i][j].z;
          
          vs[i][j].set(
            initLoc[i][j].x+xOffset,
            initLoc[i][j].y+yOffset,
            initLoc[i][j].z+zOffset
          );
        }
      }
    }
    f += fIncre;
  }

  void display(PGraphics pg) {
    pg.stroke(255, 128);
    pg.fill(0);
    pg.strokeWeight(1);
    pg.beginShape(QUADS);
    for (int i=0; i<rows-1; i++) {
      for (int j=0; j<cols-1; j++) {
        pg.vertex(vs[i][j].x, vs[i][j].y, vs[i][j].z);
        pg.vertex(vs[i][j+1].x, vs[i][j+1].y, vs[i][j+1].z);
        pg.vertex(vs[i+1][j+1].x, vs[i+1][j+1].y, vs[i+1][j+1].z);
        pg.vertex(vs[i+1][j].x, vs[i+1][j].y, vs[i+1][j].z);
      }
    }
    pg.endShape();
  }
}

