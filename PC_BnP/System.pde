class Sistem
{
  PID pid;

  PVector dest, e, ei, ed, cmass, cornerTL, cornerBR;
  Capture cam;
  int calibration, threshold;
  float hueThreshold, n;
  Boolean binarization, circle;

  Sistem()
  {
    pid= new PID(0.5, 4, 0.01, 0.5, 4, 0.001);
    e = new PVector();
    ei = new PVector();
    ed = new PVector();
    dest = new PVector(width/2, height/2);
    cmass = new PVector();
    cornerTL = new PVector(0, 0);
    cornerBR = new PVector(width, height);
    calibration = 0;
    binarization = false;
    circle = false;
    threshold = 140;
    hueThreshold = 15;
    n = 0;
  }

  void setCam(Capture cam)
  {
    this.cam = cam;
  }

  void readCam() {
    if (cam != null)
      cam.read();
  }

  void binarization()
  { 
    if (calibration == 2 && binarization) {
      if (cam != null) {
        cam.loadPixels();
        for (int i = 1; i<cam.pixels.length; i++) if (inside(i)) cam.pixels[i] = color(((saturation(cam.pixels[i]) > threshold) && ((hue(cam.pixels[i]) > hueThreshold-20) && (hue(cam.pixels[i]) < hueThreshold)))? 0:255);

        cam.updatePixels();
      } else {
        e.set(0, 0);
        ei.set(0, 0);
        ed.set(0, 0);
      }
    }
  }

  void centerOffMass()
  {
    if (calibration == 2 && binarization) {
      PVector sum = new PVector();
      cam.loadPixels();

      for (int i = 1; i<cam.pixels.length; i++) if (brightness(cam.pixels[i])<128 && inside(i)) {
        sum.x += i%width;
        sum.y += i/width;
        sum.z += 1;
      }

      /*if (sum.z == 0) cmass = new PVector(dest.x, dest.y); 
       else {
       cmass.x = sum.x/sum.z;
       cmass.y = sum.y/sum.z;
       }*/
      if (sum.z != 0) {
        cmass.x = sum.x/sum.z;
        cmass.y = sum.y/sum.z;
      }

      fill(255, 0, 0);
      ellipseMode(CENTER);
      ellipse(cmass.x, cmass.y, 5, 5);
    }
  }


  void update()
  {
    ed=PVector.sub(PVector.sub(cmass, dest), e); 
    e=PVector.sub(cmass, dest);
    ei.add(e);

    if (circle) {
      n+=0.005;
      dest.x = (cornerTL.x+cornerBR.x)/2+70*sin(n);
      dest.y = (cornerTL.y+cornerBR.y)/2+70*cos(n);
    }

    if (keyPressed) {
      float inc = 1.1;
      if (key=='a') pid.kp.x *= inc;
      if (key=='y') pid.kp.x /= inc;
      if (key=='s') pid.ki.x *= inc;
      if (key=='x') pid.ki.x /= inc;
      if (key=='d') pid.kd.x *= inc;
      if (key=='c') pid.kd.x /= inc;
      if (key=='f') pid.kp.y *= inc;
      if (key=='v') pid.kp.y /= inc;
      if (key=='g') pid.ki.y *= inc;
      if (key=='b') pid.ki.y /= inc;
      if (key=='h') pid.kd.y *= inc;
      if (key=='n') pid.kd.y /= inc;
      if (key=='j') threshold += 5;
      if (key=='m') threshold -= 5;
      if (key=='q') calibration = 0;
      if (key=='w') binarization = !binarization;
      if (key=='t') calibration = 3;
      if (key=='z') {
        circle = !circle;
        n = 0;
      }

      keyPressed = false;
      pid.kp.y = pid.kp.x;
      pid.ki.y = pid.ki.x;
      pid.kd.y = pid.kd.x;
    }

    if (mousePressed) {
      switch(calibration) {
      case 0: 
        cornerTL = new PVector(mouseX, mouseY);
        calibration = 1;
        mousePressed = false;
        break;
      case 1:
        cornerBR = new PVector(mouseX, mouseY);
        calibration = 2;
        dest = new PVector((cornerTL.x+cornerBR.x)/2, (cornerTL.y+cornerBR.y)/2);
        mousePressed = false;
        break;
      case 2:
        dest = new PVector(mouseX, mouseY);
        mousePressed = false;
        break;
      case 3: 
        cam.loadPixels();
        hueThreshold = hue(cam.pixels[mouseX+mouseY*width])+10;
        cam.updatePixels();
        mousePressed = false;
        calibration = 2;
        break;
      }
    }

    pid.update(m1, m2, this);
  }

  boolean inside(int i) {
    if (i % width < cornerBR.x && i % width > cornerTL.x && i / width < cornerBR.y && i / width > cornerTL.y) return true;
    else return false;
  }
}