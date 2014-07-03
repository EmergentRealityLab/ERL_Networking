class Grid {
  int lyrs, rows, cols;
  float cellSize;
  float zMin, zMax;
  float factor, rRange, fIncre, fOffset, pFO, tFO;
  PVector [][][] vertices;
  PVector coordOffset;
  ArrayList <PVector> vtxList;

  Grid(int lyrs, int rows, int cols, float cellSize) {
    this.lyrs = lyrs;
    this.rows = rows;
    this.cols = cols;
    this.cellSize = cellSize;

    factor = random(100);
    fOffset = 0.05;
    pFO = random(100);
    tFO = random(100);
    fIncre = 0.005;

    vertices = new PVector[lyrs][rows][cols];
    vtxList = new ArrayList <PVector> ();

    coordOffset = new PVector(-(float(cols)*0.5-0.5)*cellSize, 
    -(float(rows)*0.5-0.5)*cellSize, 
    -(float(lyrs)*0.5-0.5)*cellSize);

    zMin = coordOffset.z;
    zMax = (lyrs-1)*cellSize + coordOffset.z;

    init();
  }

  private void init() {
    for (int i=0; i<lyrs; i++) {
      for (int j=0; j<rows; j++) {
        for (int k=0; k<cols; k++) {
          float x = k*cellSize + coordOffset.x;
          float y = j*cellSize + coordOffset.y;
          float z = i*cellSize + coordOffset.z;
          vertices[i][j][k] = new PVector(x, y, z);
          vtxList.add(vertices[i][j][k]);
        }
      }
    }
  }

  void update() {
    for (int i=0; i<lyrs; i++) {    
      rRange = (i+1)*5;
      for (int j=0; j<rows; j++) {
        for (int k=0; k<cols; k++) {
          float phi = noise((k+pFO)*fOffset+factor, (j+pFO)*fOffset+factor, (i+pFO)*fOffset+factor)*720;
          float theta = noise((k+tFO)*fOffset+factor, (j+tFO)*fOffset+factor, (i+tFO)*fOffset+factor)*720;
          float radius = noise(k*fOffset+factor, j*fOffset+factor, i*fOffset+factor)*rRange;
          float offsetX = radius*sin(radians(theta))*cos(radians(phi));
          float offsetY = radius*cos(radians(theta));
          float offsetZ = radius*sin(radians(theta))*sin(radians(phi));

          float x = k*cellSize + coordOffset.x + offsetX;
          float y = j*cellSize + coordOffset.y + offsetY;
          float z = i*cellSize + coordOffset.z + offsetZ;
          vertices[i][j][k].set(x, y, z);
        }
      }
    }
    factor += fIncre;
  }

  void display(PGraphics pg) {
    displayVertices(pg);
    displayEdges(pg);
  }

  private void displayVertices(PGraphics pg) {
    for (int i=0; i<vtxList.size (); i++) {
      PVector vertex = vtxList.get(i);
      float distToCam = abs(vertex.z-camL.z);
      float alpha = map(distToCam, 216, 2700, 255, 0);
      float weight = map(distToCam, 216, 2700, 5, 0);
      pg.stroke(0, alpha);
      pg.strokeWeight(weight);
      pg.point(vertex.x, vertex.y, vertex.z);
    }
  }

  private void displayEdges(PGraphics pg) {
    for (int i=0; i<lyrs; i++) {
      for (int j=0; j<rows; j++) {
        for (int k=0; k<cols; k++) {
          if (i+1<lyrs) drawEdge(vertices[i][j][k], vertices[i+1][j][k], pg);
          if (j+1<rows) drawEdge(vertices[i][j][k], vertices[i][j+1][k], pg);
          if (k+1<cols) drawEdge(vertices[i][j][k], vertices[i][j][k+1], pg);
        }
      }
    }
  }

  private void drawEdge(PVector v1, PVector v2, PGraphics pg) {
    float distToCam = abs((v1.z+v2.z)*0.5-camL.z);
    float alpha = map(distToCam, 216, 2700, 100, 0);
    float weight = map(distToCam, 216, 2700, 2, 0);
    pg.stroke(0, alpha);
    pg.strokeWeight(weight);
    pg.line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
  }
}

