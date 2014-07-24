class StaticBoxObj {
  
  PVector [] vs;
  int [] strokeMode, fillMode;
  float w, h, d;
  color c1, c2;
  
  StaticBoxObj(PVector startPos, float w, float h, float d){
    
    this.w = w;
    this.h = h;
    this.d = d;
    
    vs = new PVector[8];
    vs[0] = startPos;
    vs[1] = new PVector(startPos.x+w, startPos.y, startPos.z);
    vs[2] = new PVector(startPos.x+w, startPos.y+h, startPos.z);
    vs[3] = new PVector(startPos.x, startPos.y+h, startPos.z);
    vs[4] = new PVector(startPos.x, startPos.y, startPos.z-d);
    vs[5] = new PVector(startPos.x+w, startPos.y, startPos.z-d);
    vs[6] = new PVector(startPos.x+w, startPos.y+h, startPos.z-d);
    vs[7] = new PVector(startPos.x, startPos.y+h, startPos.z-d);
    
    strokeMode = new int[12];
    fillMode = new int[6];
  }
  
  void setColors(color c1, color c2){
    this.c1 = c1;
    this.c2 = c2;
  }
  
  void setStrokeMode(int [] sMode, int [] fMode){
    for(int i=0; i<strokeMode.length; i++){
      strokeMode[i] = sMode[i];
    }
    for(int i=0; i<fillMode.length; i++){
      fillMode[i] = fMode[i];
    }
  }
  
  void display(PGraphics pg){
    pg.noStroke();
    pg.beginShape(QUAD);
    if(fillMode[0] == 0) pg.fill(c1);
    else pg.fill(c2);
    pg.vertex(vs[0].x, vs[0].y, vs[0].z);
    pg.vertex(vs[1].x, vs[1].y, vs[1].z);
    pg.vertex(vs[2].x, vs[2].y, vs[2].z);
    pg.vertex(vs[3].x, vs[3].y, vs[3].z);
    
    if(fillMode[1] == 0) pg.fill(c1);
    else pg.fill(c2);
    pg.vertex(vs[0].x, vs[0].y, vs[0].z);
    pg.vertex(vs[1].x, vs[1].y, vs[1].z);
    pg.vertex(vs[5].x, vs[5].y, vs[5].z);
    pg.vertex(vs[4].x, vs[4].y, vs[4].z);
    
    if(fillMode[2] == 0) pg.fill(c1);
    else pg.fill(c2);
    pg.vertex(vs[1].x, vs[1].y, vs[1].z);
    pg.vertex(vs[2].x, vs[2].y, vs[2].z);
    pg.vertex(vs[6].x, vs[6].y, vs[6].z);
    pg.vertex(vs[5].x, vs[5].y, vs[5].z);
    
    if(fillMode[3] == 0) pg.fill(c1);
    else pg.fill(c2);
    pg.vertex(vs[2].x, vs[2].y, vs[2].z);
    pg.vertex(vs[3].x, vs[3].y, vs[3].z);
    pg.vertex(vs[7].x, vs[7].y, vs[7].z);
    pg.vertex(vs[6].x, vs[6].y, vs[6].z);
    
    if(fillMode[4] == 0) pg.fill(c1);
    else pg.fill(c2);
    pg.vertex(vs[3].x, vs[3].y, vs[3].z);
    pg.vertex(vs[0].x, vs[0].y, vs[0].z);
    pg.vertex(vs[4].x, vs[4].y, vs[4].z);
    pg.vertex(vs[7].x, vs[7].y, vs[7].z);
    
    if(fillMode[5] == 0) pg.fill(c1);
    else pg.fill(c2);
    pg.vertex(vs[4].x, vs[4].y, vs[4].z);
    pg.vertex(vs[5].x, vs[5].y, vs[5].z);
    pg.vertex(vs[6].x, vs[6].y, vs[6].z);
    pg.vertex(vs[7].x, vs[7].y, vs[7].z);
    pg.endShape();
    
    pg.strokeWeight(4);
    for(int i=0; i<strokeMode.length; i++){
      if(i<4){
        int j=(i+1)%4;
        if(strokeMode[i] == 1){
          pg.stroke(0);
          pg.line(vs[i].x, vs[i].y, vs[i].z, vs[j].x, vs[j].y, vs[j].z);
        }else if(strokeMode[i] == 2){
          pg.stroke(255);
          pg.line(vs[i].x, vs[i].y, vs[i].z, vs[j].x, vs[j].y, vs[j].z);
        }
      }
      else if(i>=4 && i<8){
        int j=i-4;
        if(strokeMode[i] == 1){
          pg.stroke(0);
          pg.line(vs[i].x, vs[i].y, vs[i].z, vs[j].x, vs[j].y, vs[j].z);
        }else if(strokeMode[i] == 2){
          pg.stroke(255);
          pg.line(vs[i].x, vs[i].y, vs[i].z, vs[j].x, vs[j].y, vs[j].z);
        }
      }
      else{
        int j=i-8;
        int k=i-4;
        int l=(j+1)%4+4;
        if(strokeMode[i] == 1){
          stroke(0);
          line(vs[k].x, vs[k].y, vs[k].z, vs[l].x, vs[l].y, vs[l].z);
        }else if(strokeMode[i] == 2){
          stroke(255);
          line(vs[k].x, vs[k].y, vs[k].z, vs[l].x, vs[l].y, vs[l].z);
        }
      }
    }
  }
}
