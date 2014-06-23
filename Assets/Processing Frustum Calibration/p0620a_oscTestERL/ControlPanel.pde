import controlP5.*;

class ControlPanel {

  ControlP5 cp5;
  boolean visible;

  Numberbox mtp_X, mtp_Y, mtp_Z, mtp_RX, mtp_RY, mtp_RZ;//Multiplier
  Numberbox oft_X, oft_Y, oft_Z, oft_RX, oft_RY, oft_RZ;//Offset

  float vMtpX, vMtpY, vMtpZ, vMtpRX, vMtpRY, vMtpRZ;
  float vOftX, vOftY, vOftZ, vOftRX, vOftRY, vOftRZ;

  ControlPanel(PApplet pa) {

    cp5 = new ControlP5(pa);
    
    vMtpX = 50;
    vMtpY = -50;
    vMtpZ = -50;
    vMtpRX = 1;
    vMtpRY = 1;
    vMtpRZ = 1;
    vOftX = 0;
    vOftY = 0;//height*0.125;
    vOftZ = height*0.25;
    vOftRX = 0;
    vOftRZ = 0;
    vOftRY = 0;

    mtp_X = cp5.addNumberbox("mtp_X")
      .plugTo(this, "vMtpX")
        .setPosition(100, 50)
          .setValue(vMtpX);

    mtp_Y = cp5.addNumberbox("mtp_Y")
      .plugTo(this, "vMtpY")
        .setPosition(100, 150)
          .setValue(vMtpY);

    mtp_Z = cp5.addNumberbox("mtp_Z")
      .plugTo(this, "vMtpZ")
        .setPosition(100, 250)
          .setValue(vMtpZ);

    mtp_RX = cp5.addNumberbox("mtp_RX")
      .plugTo(this, "vMtpRX")
        .setPosition(100, 350)
          .setValue(vMtpRX);

    mtp_RY = cp5.addNumberbox("mtp_RY")
      .plugTo(this, "vMtpRY")
        .setPosition(100, 450)
          .setValue(vMtpRY);

    mtp_RZ = cp5.addNumberbox("mtp_RZ")
      .plugTo(this, "vMtpRZ")
        .setPosition(100, 550)
          .setValue(vMtpRZ);
        
    oft_X = cp5.addNumberbox("oft_X")
      .plugTo(this, "vOftX")
        .setPosition(300, 50)
          .setValue(vOftX);
        
        
    oft_Y = cp5.addNumberbox("oft_Y")
      .plugTo(this, "vOftY")
        .setPosition(300, 150)
          .setValue(vOftY);
    
    oft_Z = cp5.addNumberbox("oft_Z")
      .plugTo(this, "vOftZ")
        .setPosition(300, 250)
          .setValue(vOftZ);
        
    oft_RX = cp5.addNumberbox("oft_RX")
      .plugTo(this, "vOftRX")
        .setPosition(300, 350)
          .setValue(vOftRX);
        
    oft_RY = cp5.addNumberbox("oft_RY")
      .plugTo(this, "vOftRY")
        .setPosition(300, 450)
          .setValue(vOftRY);
    
    oft_RZ = cp5.addNumberbox("oft_RZ")
      .plugTo(this, "vOftRZ")
        .setPosition(300, 550)
          .setValue(vOftRZ);

    autoFormatMtp(mtp_X); 
    autoFormatMtp(mtp_Y); 
    autoFormatMtp(mtp_Z);
    autoFormatMtp(mtp_RX); 
    autoFormatMtp(mtp_RY); 
    autoFormatMtp(mtp_RZ);
    
    autoFormatOft(oft_X);
    autoFormatOft(oft_Y);
    autoFormatOft(oft_Z);
    autoFormatOft(oft_RX);
    autoFormatOft(oft_RY);
    autoFormatOft(oft_RZ);
  }

  void switchVisibility() {
    visible = !visible;
  }
  
  void printOutData(){
    println("\n");
    String mtpData = "mtp_X: " + vMtpX + "\n"
                   + "mtp_Y: " + vMtpY + "\n"
                   + "mtp_Z: " + vMtpZ + "\n"
                   + "mtp_RX: " + vMtpRX + "\n"
                   + "mtp_RY: " + vMtpRY + "\n"
                   + "mtp_RZ: " + vMtpRZ;
    println(mtpData);
    println("\n");
    String oftData = "oft_X: " + vOftX + "\n"
                   + "oft_Y: " + vOftY + "\n"
                   + "oft_Z: " + vOftZ + "\n"
                   + "oft_RX: " + vOftRX + "\n"
                   + "oft_RY: " + vOftRY + "\n"
                   + "oft_RZ: " + vOftRZ;
    println(oftData);
  }
  
  void display() {
    if (!visible) cp5.hide();
    else cp5.show();
  }

  private void autoFormatMtp(Numberbox mtp) {
    mtp.setSize(40, 40)
      .setMultiplier(0.05)
        .setScrollSensitivity(1.1)
          .setColorLabel(0);
  }

  private void autoFormatOft(Numberbox oft) {
    oft.setSize(40, 40)
      .setMultiplier(0.5)
        .setScrollSensitivity(1.1)
          .setColorLabel(0);
  }
}

