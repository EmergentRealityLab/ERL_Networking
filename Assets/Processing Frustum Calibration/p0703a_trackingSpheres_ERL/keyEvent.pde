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
    float radius = random(5,20);
    int detailsLv = constrain(int(sqrt(radius))*2, 3, 14);;
    Sphere addedS = new Sphere(camL.x+random(-25,25),camL.y+random(-25,25),camL.z+random(-25,25), radius, detailsLv, detailsLv);
    spheres.add(addedS);
  }
}
