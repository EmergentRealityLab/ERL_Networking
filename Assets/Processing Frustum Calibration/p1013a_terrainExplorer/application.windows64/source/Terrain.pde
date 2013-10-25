class Terrain {
  PImage texture;
  PVector [][] vertices;
  int cols, rows;
  float cellSize;

  Terrain(int cols, int rows, float cellSize, float noiseIncreRatio, float yRange, String path) {
    this.cols = cols;
    this.rows = rows;
    this.cellSize = cellSize;
    texture = loadImage(path);

    vertices = new PVector[rows][cols];
    for (int i=0;i<rows;i++) {
      for (int j=0;j<cols;j++) {

        float x = (j-cols*0.5)*cellSize;
        float y = (noise(i*noiseIncreRatio, j*noiseIncreRatio)-0.5)*yRange;
        float z = (i-rows*0.5)*cellSize;

        vertices[i][j] = new PVector(x, y, z);
      }
    }
  }

  void display(int camPjCol, int camPjRow) {
    fill(255);
    beginShape(TRIANGLES);
    for (int i=0;i<rows-1;i++) {
      for (int j=0;j<cols-1;j++) {
        texture(texture);
        if (i==camPjRow && j==camPjCol && inTl) {
          stroke(0, 255, 0);
          strokeWeight(5);
        }
        else {
          stroke(0);
          strokeWeight(0);
        }
        drawVertex(vertices[i+1][j], j, i+1);
        drawVertex(vertices[i][j], j, i);
        drawVertex(vertices[i][j+1], j+1, i);
        
        if (i==camPjRow && j==camPjCol && !inTl) {
          stroke(0, 255, 0);
          strokeWeight(5);
        }
        else {
          stroke(0);
          strokeWeight(0);
        }
        drawVertex(vertices[i][j+1], j+1, i);
        drawVertex(vertices[i+1][j+1], j+1, i+1);
        drawVertex(vertices[i+1][j], j, i+1);
      }
    }
    endShape();
  }

  private void drawVertex(PVector vertex, int colIndex, int rowIndex) {
    vertex(vertex.x, vertex.y, vertex.z, float(colIndex)/cols*texture.width, float(rowIndex)/rows*texture.height);
  }
}

