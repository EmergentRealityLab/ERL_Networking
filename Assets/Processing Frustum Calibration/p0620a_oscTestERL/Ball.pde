class Ball{
  
  PVector loc, initLoc;
  float radius;
  color c;
  float xSeed, ySeed, zSeed, seedIncre, range;
  
  Ball(){
    initLoc = new PVector(random(-400,400), random(-400,400), random(-800,800));
    loc = new PVector(initLoc.x, initLoc.y, initLoc.z);
    radius = random(5,25);
    colorMode(HSB);
    c = color(random(255), random(255), 255);
    xSeed = random(100);
    ySeed = random(100);
    zSeed = random(100);
    range = random(100, 1000);
    seedIncre = random(0.002, 0.01);
  }
  
  void update(){
    float xOffset = (noise(xSeed)-0.5)*range;
    float yOffset = (noise(ySeed)-0.5)*range;
    float zOffset = (noise(zSeed)-0.5)*range;
    xSeed += seedIncre;
    ySeed += seedIncre;
    zSeed += seedIncre;
    loc.set(initLoc.x+xOffset,
            initLoc.y+yOffset,
            initLoc.z+zOffset);
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
