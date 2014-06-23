void drawCoords(PGraphics pg) {
  pg.noFill();
  pg.colorMode(RGB);
  pg.strokeWeight(3);
  pg.stroke(0, 0, 255);
  pg.line(0, 0, 0, coordsLength, 0, 0);//Axis X
  pg.stroke(0, 255, 0);
  pg.line(0, 0, 0, 0, coordsLength, 0);//Axis Y
  pg.stroke(255, 0, 0);
  pg.line(0, 0, 0, 0, 0, coordsLength);//Axis Z
  pg.stroke(0, 100);
  //Plane
  pg.beginShape();
  pg.vertex(coordsLength/2, 0, coordsLength/2);
  pg.vertex(coordsLength/2, 0, -coordsLength/2);
  pg.vertex(-coordsLength/2, 0, -coordsLength/2);
  pg.vertex(-coordsLength/2, 0, coordsLength/2);
  pg.endShape(CLOSE);
}

static public void main(String args[]) {
  Frame frame = new Frame("testing");
  frame.setUndecorated(true);
  // The name "sketch_name" must match the name of your program
  //PApplet applet = new sketch_name();
  PApplet applet = new p0620a_oscTestERL();
  frame.add(applet);
  applet.init();
  frame.setBounds(0, 0, 3840, 1080); 
  frame.setVisible(true);
}
