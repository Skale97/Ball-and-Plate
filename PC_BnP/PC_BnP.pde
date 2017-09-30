import processing.serial.*;
import processing.video.*;

Serial port;
Capture cam;
Motor m1, m2;
Sistem S;

void setup() 
{

  m1= new Motor( 70, 126);
  m2= new Motor( 70, 126);

  size(640, 480);
  frameRate(30);

  cam = new Capture(this, "name=Eye 110,size=640x480,fps=35");
  cam.start();

  S = new Sistem();

  S.setCam(cam);

  port = new Serial(this, "COM5", 57600);
  m1.setPort(port);
  m2.setPort(port);

  fill(255, 0, 0);
}

void draw() {
  if (cam.available() == true) {  
    S.readCam();
    S.binarization();
    image(S.cam, 0, 0);
    if (m1.on) println(m1.ang + "    " + m2.ang);
    S.centerOffMass();
    S.update();
    point(mouseX, mouseY);
    port.write(0);
    m1.update();
    m2.update();

    noFill();
    line(0, S.dest.y, width, S.dest.y);
    line(S.dest.x, 0, S.dest.x, height);
    rectMode(CORNERS);
    if (S.calibration == 2) rect(S.cornerTL.x, S.cornerTL.y, S.cornerBR.x, S.cornerBR.y);

    textSize(14);
    fill(255, 0, 0);
    textAlign(LEFT, TOP);
    text("Circle: " + S.circle + "\nCalibration: " + S.calibration + "\nMotori: ON: " + m1.on  + "\nBinarization: ON: " + S.binarization  + "\nThreshold: " + S.threshold + "\nHue: " + S.hueThreshold + "\nPID:\nA " + S.pid.kp.x + "\nS " + S.pid.kd.x + "\nD " + S.pid.ki.x + "\nF " + S.pid.kp.y + "\nG " + S.pid.kd.y + "\nH " + S.pid.ki.y, 0, 0);
  }
}

boolean mouseOverRect(int x1, int y1, int x2, int y2) { 
  return ((S.cmass.x >= x1) && (S.cmass.x <= x2) && (S.cmass.y >= y1) && (S.cmass.y <= y2));
}

void keyPressed()
{
  if (key == 'e') {
    S.ei.mult(0);
    m1.turn();
    m2.turn();
  }
  if (key == 'r') exit();
}