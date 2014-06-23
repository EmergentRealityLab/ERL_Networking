class Ball{
  
  PVector loc;
  float radius;
  color c;
  
  Ball(){
    loc = new PVector(random(-400,400), random(-400,400), random(-250,250));
    radius = random(10,50);
    colorMode(HSB);
    c = color(random(255), random(255), 255);
  }
  
  void display(PGraphics pg){
    pg.pushMatrix();
    pg.translate(loc.x, loc.y, loc.z);
    pg.noStroke();
    pg.fill(c);
    pg.sphere(radius);
    pg.popMatrix();
  }
}
