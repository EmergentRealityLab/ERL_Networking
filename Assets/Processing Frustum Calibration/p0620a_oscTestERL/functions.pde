void drawCoords() {
  noFill();
  colorMode(RGB);
  strokeWeight(3);
  stroke(0, 0, 255);
  line(0, 0, 0, coordsLength, 0, 0);//Axis X
  stroke(0, 255, 0);
  line(0, 0, 0, 0, coordsLength, 0);//Axis Y
  stroke(255, 0, 0);
  line(0, 0, 0, 0, 0, coordsLength);//Axis Z
  stroke(255, 100);
  //Plane
  beginShape();
  vertex(coordsLength/2, 0, coordsLength/2);
  vertex(coordsLength/2, 0, -coordsLength/2);
  vertex(-coordsLength/2, 0, -coordsLength/2);
  vertex(-coordsLength/2, 0, coordsLength/2);
  endShape(CLOSE);
}
