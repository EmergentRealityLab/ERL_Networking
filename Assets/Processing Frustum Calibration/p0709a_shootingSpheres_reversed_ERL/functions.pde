float coordsLength = 300;

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
  pg.stroke(255, 100);
  //Plane
  pg.beginShape();
  pg.vertex(coordsLength/2, 0, coordsLength/2);
  pg.vertex(coordsLength/2, 0, -coordsLength/2);
  pg.vertex(-coordsLength/2, 0, -coordsLength/2);
  pg.vertex(-coordsLength/2, 0, coordsLength/2);
  pg.endShape(CLOSE);
}

void drawScreen(PGraphics pg) {
  //Tunnel
  wallT.display(pg, wallTtT);
  wallB.display(pg, wallTtB);
  wallL.display(pg, wallTtL);
  wallR.display(pg, wallTtR);
  wallF.display(pg, wallTtF);
  /*pg.stroke(255);
  pg.fill(0);
  pg.strokeWeight(3);
  pg.beginShape(QUADS);
  for (int i=0; i<29; i++) {
    pg.vertex(-480, -540, -i*100);
    pg.vertex(480, -540, -i*100);
    pg.vertex(480, -540, -(i+1)*100);
    pg.vertex(-480, -540, -(i+1)*100);
    
    pg.vertex(480, -540, -i*100);
    pg.vertex(480, 0, -i*100);
    pg.vertex(480, 0, -(i+1)*100);
    pg.vertex(480, -540, -(i+1)*100);
    
    pg.vertex(480, 0, -i*100);
    pg.vertex(-480, 0, -i*100);
    pg.vertex(-480, 0, -(i+1)*100);
    pg.vertex(480, 0, -(i+1)*100);
    
    pg.vertex(-480, 0, -i*100);
    pg.vertex(-480, -540, -i*100);
    pg.vertex(-480, -540, -(i+1)*100);
    pg.vertex(-480, 0, -(i+1)*100);
  }
  pg.endShape();*/
  //Reference Box
  /*pg.pushMatrix();
  pg.translate(0, -270, 50);
  pg.fill(0);
  pg.box(100);
  pg.popMatrix();*/
}

static public void main(String args[]) {
  Frame frame = new Frame("testing");
  frame.setUndecorated(true);
  // The name "sketch_name" must match the name of your program
  //PApplet applet = new sketch_name();
  PApplet applet = new p0709a_shootingSpheres_reversed_ERL();
  frame.add(applet);
  applet.init();
  frame.setBounds(0, 0, 3840, 1080); 
  frame.setVisible(true);
}
