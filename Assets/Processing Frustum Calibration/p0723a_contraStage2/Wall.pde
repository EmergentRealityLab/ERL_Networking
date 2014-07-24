class Wall {

  int cols, rows;
  PVector [][] vs;
  PVector [][] initLoc;
  PVector [][] range;
  String direction;
  color c;

  float f, fIncre, xRange, yRange, zRange, xRangeOffset, yRangeOffset, zRangeOffset;

  Wall(int cols, int rows, String direction, float startX, float startY, float startZ, float cellSize, color c) {
    this.cols = cols;
    this.rows = rows;
    this.direction = direction;
    this.c = c;

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

  void display(PGraphics pg) {
    pg.stroke(0, 128);
    pg.strokeWeight(1);
    //pg.noStroke();
    pg.fill(c);
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
