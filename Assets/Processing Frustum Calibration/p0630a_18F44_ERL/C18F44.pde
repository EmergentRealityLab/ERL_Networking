class C18F44 {

  C18F44 [] children;

  int index, lv, maxLv;
  boolean reversed;

  Vertex [] outers, mids, quars, struts;
  Vertex strutCenter;

  C18F44(int index, int lv, int maxLv, boolean reversed) {

    this.index = index;
    this.lv = lv;
    this.reversed = reversed;
    this.maxLv = maxLv;

    outers = new Vertex[6];
    mids = new Vertex[6];
    quars = new Vertex[12];
    struts = new Vertex[6];
    strutCenter = new Vertex();

    for (int i=0; i<outers.length; i++) {
      outers[i] = new Vertex();
      mids[i] = new Vertex();
      struts[i] = new Vertex();
    }
    for (int i=0; i<quars.length; i++) {
      quars[i] = new Vertex();
    }

    if (lv < maxLv) {
      lv++;
      children = new C18F44[7];
      for (int i=0; i<children.length; i++) {
        children[i] = new C18F44(i, lv, maxLv, reversed);
      }
    }
  }

  void update(Vertex [] outers, float seed) {

    this.outers = outers;

    //update midss ------------------------------
    for (int i=0; i<mids.length; i++) {
      int j = (i+1)%mids.length;
      mids[i].update(outers[i], outers[j], 0.5);
    }

    //update quars ------------------------------
    for (int i=0; i<quars.length; i+=2) {
      int j= (i/2+1)%mids.length;
      quars[i].update(mids[i/2], outers[j], 0.5);
      quars[i+1].update(outers[j], mids[j], 0.5);
    }

    //Update struts ------------------------------
    for (int i=0; i<struts.length; i++) {
      int j = (i+3)%6;
      float factor = noise(seed)/(lv+1);
      struts[i].update(outers[i], mids[i], mids[j], factor, lv, reversed);
      seed += 0.03;
    }
    
    strutCenter.update(struts);
    
    if(lv < maxLv){
      seed += 1;
      children[6].update(struts, seed);
      for(int i=0; i<6; i++){
        seed += 0.1;
        int j = (i+1)%6;
        int k = (i*2)%12;
        Vertex [] vs = {
          mids[i], quars[k], quars[k+1], mids[j], struts[j], struts[i]
        };
        children[i].update(vs, seed);
      }
    }
  }
  
  void displayMesh(PGraphics pg){
    pg.strokeWeight(2);
    pg.stroke(0);
    pg.fill(255);
    if(lv == maxLv){
      pg.beginShape(TRIANGLES);
      for (int i=0;i<struts.length;i++) {
        int j = (i+1)%struts.length;
        pg.vertex(struts[i].loc.x, struts[i].loc.y, struts[i].loc.z);
        pg.vertex(struts[j].loc.x, struts[j].loc.y, struts[j].loc.z);
        pg.vertex(strutCenter.loc.x, strutCenter.loc.y, strutCenter.loc.z);
      }
      pg.endShape();
      
      pg.beginShape(TRIANGLES);
      for (int i=0;i<quars.length;i+=2) {
        int j = (i/2+1)%outers.length;
        pg.vertex(outers[j].loc.x, outers[j].loc.y, outers[j].loc.z);
        pg.vertex(quars[i].loc.x, quars[i].loc.y, quars[i].loc.z);
        pg.vertex(quars[i+1].loc.x, quars[i+1].loc.y, quars[i+1].loc.z);
      }
      pg.endShape();
      
      pg.beginShape(TRIANGLES);
      for (int i=0;i<quars.length;i+=2) {
        int j = (i/2)%mids.length;
        int k = (i/2+1)%mids.length;
        int l = (i+1)%quars.length;

        pg.vertex(quars[i].loc.x, quars[i].loc.y, quars[i].loc.z);
        pg.vertex(quars[l].loc.x, quars[l].loc.y, quars[l].loc.z);
        pg.vertex(struts[j].loc.x, struts[j].loc.y, struts[j].loc.z);

        pg.vertex(quars[l].loc.x, quars[l].loc.y, quars[l].loc.z);
        pg.vertex(struts[j].loc.x, struts[j].loc.y, struts[j].loc.z);
        pg.vertex(struts[k].loc.x, struts[k].loc.y, struts[k].loc.z);

        pg.vertex(quars[i].loc.x, quars[i].loc.y, quars[i].loc.z);
        pg.vertex(mids[j].loc.x, mids[j].loc.y, mids[j].loc.z);
        pg.vertex(struts[j].loc.x, struts[j].loc.y, struts[j].loc.z);

        pg.vertex(quars[l].loc.x, quars[l].loc.y, quars[l].loc.z);
        pg.vertex(mids[k].loc.x, mids[k].loc.y, mids[k].loc.z);
        pg.vertex(struts[k].loc.x, struts[k].loc.y, struts[k].loc.z);
      }
      pg.endShape();
    }
    if (lv < maxLv) {
      for (int i=0;i<children.length;i++) {
        children[i].displayMesh(pg);
      }
    }
  }
}

