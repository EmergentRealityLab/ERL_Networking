class Vertex {

  PVector loc;

  Vertex() {
    loc = new PVector(0, 0, 0);
  }

  void update(float x, float y, float z) {
    z = constrain(z,-500,500);
    loc.set(x, y, z);
  }

  void update(Vertex v1, Vertex v2, float ratio, float offsetX, float offsetY) {
    
    float x = v1.loc.x * ratio + v2.loc.x * (1-ratio);
    float y = v1.loc.y * ratio + v2.loc.y * (1-ratio);
    float z = (noise((x+frameCount)*0.01+offsetX, (y+frameCount)*0.01+offsetY)-0.5)*200 + v1.loc.z * ratio + v2.loc.z * (1-ratio);
    z = constrain(z,-500,500);
    
    loc.set(x,y,z);
  }
  
  void update(Vertex v1, Vertex v2, float ratio) {
    
    float x = v1.loc.x * ratio + v2.loc.x * (1-ratio);
    float y = v1.loc.y * ratio + v2.loc.y * (1-ratio);
    float z = v1.loc.z * ratio + v2.loc.z * (1-ratio);
    z = constrain(z,-500,500);
    
    loc.set(x,y,z);
  }
}

