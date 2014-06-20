void keyPressed(){
  if(key == 'w'){
    cam.x+=10*sin(theta)*cos(phi);
    cam.z+=10*sin(theta)*sin(phi);
  }
  else if(key == 's'){
    cam.x-=10*sin(theta)*cos(phi);
    cam.z-=10*sin(theta)*sin(phi);
  }
  else if(key == 'a'){
    cam.x+=10*sin(theta)*cos(phi-PI/2);
    cam.z+=10*sin(theta)*sin(phi-PI/2);
  }
  else if(key == 'd'){
    cam.x+=10*sin(theta)*cos(phi+PI/2);
    cam.z+=10*sin(theta)*sin(phi+PI/2);
  }
  
  else if (key == 'r') {
    cp.printOutData();
  }
  
  else if(key == 'c'){
    cp.switchVisibility();
  }
}
