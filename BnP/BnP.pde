import processing.serial.*;
import processing.video.*;

Serial port;
Capture cam;
Motor m1, m2;
Sistem S;

void setup() 
{

  m1= new Motor( 40, 125);
  m2= new Motor( 40, 125);

  size(640, 480);

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
    S.centerOffMass();
    S.update();
    println(m1.ang + " " + m2.ang);
    point(mouseX, mouseY);
    port.write(0);
    m1.update();
    m2.update();

    noFill();
    line(0, height/2, width, height/2);
    line(width/2, 0, width/2, height);

    textSize(20);
    fill(255, 0, 0);
    textAlign(LEFT, TOP);
    text("Motori: ON: " + m1.on  + "\nPID:\nA " + S.pid.kp.x + "\nS " + S.pid.kd.x + "\nD " + S.pid.ki.x + "\nF " + S.pid.kp.y + "\nG " + S.pid.kd.y + "\nH " + S.pid.ki.y, 0, 0);
  }
}

boolean mouseOverRect(int x1, int y1, int x2, int y2) { 
  return ((S.cmass.x >= x1) && (S.cmass.x <= x2) && (S.cmass.y >= y1) && (S.cmass.y <= y2));
}

void keyPressed()
{
  if (key == 'q') {
    S.ei.mult(0);
    m1.turn();
    m2.turn();
  }
  if (key == 'e') exit();
}