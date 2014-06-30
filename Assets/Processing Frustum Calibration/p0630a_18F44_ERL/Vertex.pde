class Vertex{
  
  PVector loc;
  
  Vertex() {
    loc = new PVector(0, 0, 0);
  }
  
  
  void update(float x, float y, float z) {
    loc.set(x, y, z);
  }
  
  
  void update(Vertex v1, Vertex v2, float ratio) {
    
    float x = v1.loc.x * ratio + v2.loc.x * (1-ratio);
    float y = v1.loc.y * ratio + v2.loc.y * (1-ratio);
    float z = v1.loc.z * ratio + v2.loc.z * (1-ratio);
    
    loc.set(x,y,z);
  }
  
  
  void update(Vertex v1, Vertex v2, Vertex v3, float ratio, int lv, boolean reversed){
    float x0 = v3.loc.x * ratio + v2.loc.x * (1-ratio);
    float y0 = v3.loc.y * ratio + v2.loc.y * (1-ratio);
    float z0 = v3.loc.z * ratio + v2.loc.z * (1-ratio);
    
    float r = dist(v2.loc.x, v2.loc.y, v2.loc.z, v3.loc.x, v3.loc.y, v3.loc.z)*0.5;
    
    float xm = (v2.loc.x + v3.loc.x)*0.5;
    float ym = (v2.loc.y + v3.loc.y)*0.5;
    float zm = (v2.loc.z + v3.loc.z)*0.5;
    
    float xt = dist(x0, y0, z0, xm, ym, zm)-dist(xm, ym, zm, v2.loc.x, v2.loc.y, v2.loc.z);
    float magnitude = sqrt(sq(r)-sq(xt))/(lv+1);
    
    PVector vt1 = PVector.sub(v1.loc, v2.loc);
    PVector vt2 = PVector.sub(v3.loc, v2.loc);
    PVector vt3;
    
    if(reversed) vt3 = vt2.cross(vt1);
    else vt3 = vt1.cross(vt2);
    vt3.normalize();
    
    float x = x0 + vt3.x * magnitude;
    float y = y0 + vt3.y * magnitude;
    float z = z0 + vt3.z * magnitude;
    
    loc.set(x,y,z);
  }
  
  
  void update(Vertex [] vs){
    float totalX = 0;
    float totalY = 0;
    float totalZ = 0;
    
    for(int i=0; i<vs.length; i++){
      totalX += vs[i].loc.x;
      totalY += vs[i].loc.y;
      totalZ += vs[i].loc.z;
    }
    
    float x = totalX/vs.length;
    float y = totalY/vs.length;
    float z = totalZ/vs.length;
    
    loc.set(x, y, z);
  }
}
