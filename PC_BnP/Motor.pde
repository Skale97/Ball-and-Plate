class Motor 
{
  boolean on;
  int ang, maxang, center;
  Serial port;

  Motor(int maxang_, int center_) 
  {
    ang = center_;
    on = false;

    setStartPos(maxang_, center_);
  }

  void setStartPos(int maxang_, int center_) {
    maxang = maxang_;
    center = center_;
  }

  void setPort(Serial port)
  {
    this.port = port;
  }

  void update()
  {
    if (port != null) {
      if (!on ) ang = center;
      port.write(ang>center+maxang?center+maxang:ang<center-maxang?center-maxang:ang);
    }
  }

  void turn() {
    on = !on;
  }
}