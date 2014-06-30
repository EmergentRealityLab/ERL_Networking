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

void updateFrame() {
  for (int i=0; i<frame.length; i++) {
    float radius = radiusRange+(noise(radiusSeed+i*0.1)-0.5)*radiusRange*0.5;
    float degrees =  i*60+(noise(degreesSeed+i*0.1)-0.5)*degreeRange*0.5;
    
    float x = cos(radians(degrees)) * radius;
    float y = sin(radians(degrees)) * radius;
    float z = (noise(x*0.01, y*0.01)-0.5) * zRange;
    
    frame[i].update(x, y, z);
  }
  
  radiusSeed += radiusSeedIncre;
  degreesSeed += degreesSeedIncre;
}

static public void main(String args[]) {
  Frame frame = new Frame("testing");
  frame.setUndecorated(true);
  // The name "sketch_name" must match the name of your program
  //PApplet applet = new sketch_name();
  PApplet applet = new p0630a_18F44_ERL();
  frame.add(applet);
  applet.init();
  frame.setBounds(0, 0, 3840, 1080); 
  frame.setVisible(true);
}

