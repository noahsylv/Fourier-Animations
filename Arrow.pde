
class Arrow {

  float magnitude;
  float angle;
  float interval;
  
  Arrow(float m, float theta, float speed) {
    magnitude = m;
    angle = theta;
    interval = speed;
  }
  
  void tick() {
    angle += interval;
  }
  
  PVector vec() {
    return new PVector(magnitude * cos(angle), magnitude * sin(angle));
  }
  
  


}
