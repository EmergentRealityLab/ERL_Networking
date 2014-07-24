class LaserShock{
  
  PVector startPos, endPos;
  PVector [] vs;
  float range;
  float xOffset;
  
  LaserShock(PVector startPos, PVector endPos, float range){
    this.startPos = startPos;
    this.endPos = endPos;
    this.range = range;
    
    vs = new PVector[100];
    for(int i=0; i<vs.length; i++){
      vs[i] = new PVector(0, 0, 0);
    }
    
    xOffset = abs(startPos.x-endPos.x)/float(vs.length);
  }
  
  void update(){
    for(int i=0; i<vs.length; i++){
      if(i==0 || i==vs.length-1){
        vs[i].set(startPos.x+i*xOffset, startPos.y, startPos.z);
      }
      else{
        vs[i].set(startPos.x+random(-range*0.25,range*0.25)+i*xOffset, startPos.y+random(-range,range), startPos.z+random(-range,range));
      }
    }
  }
  
  void display(PGraphics pg){
    pg.noFill();
    pg.beginShape();
    for(int i=0; i<vs.length; i++){
      pg.strokeWeight(random(2,5));
      pg.stroke(255,random(255));
      pg.vertex(vs[i].x, vs[i].y, vs[i].z);
    }
    pg.endShape();
  }
}
