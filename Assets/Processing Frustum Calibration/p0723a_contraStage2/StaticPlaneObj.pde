class StaticPlaneObj {

  PImage texture;
  PVector [] vs;
  boolean showStroke;

  StaticPlaneObj(String path, PVector v1, PVector v2, PVector v3, PVector v4) {
    texture = loadImage(path);
    vs = new PVector[4];
    vs[0] = v1;
    vs[1] = v2;
    vs[2] = v3;
    vs[3] = v4;
  }

  void display(PGraphics pg) {
    if(!showStroke){
      pg.noStroke();
    }
    else{
      pg.stroke(0);
      pg.strokeWeight(5);
    }
    pg.beginShape();
    pg.texture(texture);
    pg.textureWrap(REPEAT);
    pg.vertex(vs[0].x, vs[0].y, vs[0].z, 0, 0);
    pg.vertex(vs[1].x, vs[1].y, vs[1].z, texture.width, 0);
    pg.vertex(vs[2].x, vs[2].y, vs[2].z, texture.width, texture.height);
    pg.vertex(vs[3].x, vs[3].y, vs[3].z, 0, texture.height);
    pg.endShape();
  }
}

