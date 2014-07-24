void keyPressed(){
  if(key == 'w'){
    camL.x+=10*sin(theta)*cos(phi);
    camL.z+=10*sin(theta)*sin(phi);
    camR.x+=10*sin(theta)*cos(phi);
    camR.z+=10*sin(theta)*sin(phi);
  }
  else if(key == 's'){
    camL.x-=10*sin(theta)*cos(phi);
    camL.z-=10*sin(theta)*sin(phi);
    camR.x-=10*sin(theta)*cos(phi);
    camR.z-=10*sin(theta)*sin(phi);
  }
  else if(key == 'a'){
    camL.x+=10*sin(theta)*cos(phi-PI/2);
    camL.z+=10*sin(theta)*sin(phi-PI/2);
    camR.x+=10*sin(theta)*cos(phi-PI/2);
    camR.z+=10*sin(theta)*sin(phi-PI/2);
  }
  else if(key == 'd'){
    camL.x+=10*sin(theta)*cos(phi+PI/2);
    camL.z+=10*sin(theta)*sin(phi+PI/2);
    camR.x+=10*sin(theta)*cos(phi+PI/2);
    camR.z+=10*sin(theta)*sin(phi+PI/2);
  }
  
  else if (key == 'r') {
    cp.printOutData();
  }
  
  else if(key == 'c'){
    cp.switchVisibility();
  }
  
  else if(key == ' '){
    /*float radius = random(5,100);
    int detailsLv = constrain(int(sqrt(radius)*1.5), 3, 15);
    PVector dir = new PVector(100*sin(radians(camLDir.y))*cos(radians(camLDir.x)), 100*cos(radians(camLDir.y)), 100*sin(radians(camLDir.y))*sin(radians(camLDir.x)));
    dir.normalize();
    dir.mult(100);
    Sphere addedS = new Sphere(camL.x+random(-25,25),camL.y+random(-25,25),camL.z+random(-25,25), radius, detailsLv, detailsLv, dir);
    spheres.add(addedS);
    
    masterG.addInput(addedS.gH);
    masterG.addInput(addedS.gV);*/
  }
}
