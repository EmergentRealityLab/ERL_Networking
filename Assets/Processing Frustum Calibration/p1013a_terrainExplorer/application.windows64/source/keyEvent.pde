void keyPressed(){
  if(key == 'w'){
    camT.x+=10*sin(theta)*cos(phi);
    camT.z+=10*sin(theta)*sin(phi);
  }
  else if(key == 's'){
    camT.x-=10*sin(theta)*cos(phi);
    camT.z-=10*sin(theta)*sin(phi);
  }
  else if(key == 'a'){
    camT.x+=10*sin(theta)*cos(phi-PI/2);
    camT.z+=10*sin(theta)*sin(phi-PI/2);
  }
  else if(key == 'd'){
    camT.x+=10*sin(theta)*cos(phi+PI/2);
    camT.z+=10*sin(theta)*sin(phi+PI/2);
  }
  else if(key == 'r'){
    
  }
  camT.x = constrain(camT.x, -tr.cols*0.5*tr.cellSize, (tr.cols*0.5-1)*tr.cellSize);
  camT.z = constrain(camT.z, -tr.rows*0.5*tr.cellSize, (tr.rows*0.5-1)*tr.cellSize);
}
