ArrayList<PVector> trail;
ArrayList<Arrow> arrows;
int num = 10; 
float baseSpeed = PI / 1080;
int trailLimit = 1000;
int PASSES = 5;
boolean drawArrows = false;
boolean showDrawing = false;
String mode = "R";
ArrayList<PVector> drawing;
String importedDrawing = "drawing.png";
int drawingOffset = -300;


void setup() {
  size(900, 900);
  trail = new ArrayList<PVector>();
  arrows = new ArrayList<Arrow>();
  drawing = new ArrayList<PVector>();
  if (mode.equals("R")) {
    randomize();
  }
}

void drawPoints(ArrayList<PVector> list) {
  strokeWeight(1);
  for (PVector p : list) {
    point(p.x, p.y);
  }
}

Complex toComplex(PVector pt) {
  return new Complex(-(width/2 - pt.x) / (width/2), (height/2 - pt.y) / (height/2));
}

PVector toPoint(Complex c) {
  return new PVector((float) (width / 2 * c.re + width/2), (float) (-height / 2 * c.im + height/2));
}

ArrayList<PVector> mapToPoint(ArrayList<Complex> list) {
  ArrayList<PVector> out = new ArrayList<PVector>();
  for (Complex c : list) {
    out.add(toPoint(c));
  }
  return out;
}

ArrayList<Complex> mapToComplex(ArrayList<PVector> list) {
  ArrayList<Complex> out = new ArrayList<Complex>();
  for (PVector pt : list) {
    out.add(toComplex(pt));
  }
  return out;
}

PVector integrate(int freq, ArrayList<PVector> pts) {
  ArrayList<Complex> func = mapToComplex(pts);
  Complex sum = new Complex(0);
  Complex step = new Complex(1.0 / func.size());
  for (int i = 0; i < func.size(); i++) {
    Complex c = func.get(i);
    Complex eulerOne = new Complex(-freq * 2 * PI).times(new Complex(0, 1));
    Complex eulerTwo = step.times(new Complex(i+1));
    Complex euler = (eulerTwo.times(eulerOne)).exp();
    sum = sum.plus(c.times(step).times(euler));
  }
  PVector result = toPoint(sum);
  result.x -= width/2.0;
  result.y -= height/2.0;
  return result;
}


void solveArrows() {
  arrows.clear();
  for (int i = 0; i < num / 2 + 1; i++) {
    PVector vec = integrate(i, drawing);
    arrows.add(new Arrow(vec.mag(), vec.heading(), i  * baseSpeed));
    if (i != 0) {
      if (num % 2 != 0 || num / 2 != i) {
        vec = integrate(-i, drawing);
        arrows.add(new Arrow(vec.mag(), vec.heading(), -i  * baseSpeed));
      }
    }
  }
}


void keyPressed() {
  if (key == ' ') {
    drawArrows = !drawArrows;
  } else if (key == 'd') {
    if (mode == "D") {  
      mode = "S";
    } else {
      mode = "D";
      background(0);
    }
  } else if (key == 'r') {
    mode = "R";
    beginAgain();
    randomize();
  } else if (key == 'e') {
    beginAgain();
  } else if (key == '1') {
    num += 5;
    println(num);
  } else if (key == '`') {
    num -= 5;
    println(num);
  } else if (key == 'a') {
    showDrawing = !showDrawing;
  } else if (key == 'f') {
    drawing = reverseList(drawing);
    beginAgain();
  } else if (key == 'c') {
    drawing.clear();
    background(0);
  } else if (key == '.') {
    trailLimit += 100;
  } else if (key == 'i') {
    drawing = convert(importedDrawing, 1000, drawingOffset, 0);
  } else if (key == 'q') {
    num--;
    println(num);
  } else if (key == 'w') {
    num++;
    println(num);
  }
}

void beginAgain() {
  trail.clear();
  solveArrows();
  mode = "S";
}

ArrayList<PVector> reverseList(ArrayList<PVector> list) {
  ArrayList<PVector> out = new ArrayList<PVector>();
  for (int i = list.size() - 1; i >= 0; i--) {
    out.add(drawing.get(i));
  }
  return out;
}

void mouseDragged() {
  if (mode.equals("D")) {
    drawing.add(new PVector(mouseX, mouseY));
  }
}

void mouseClicked() {
  if (mode.equals("D")) {
    PVector curr = new PVector(mouseX, mouseY);
    if (drawing.size() > 0) {
      PVector last = drawing.get(drawing.size() - 1);
      float d = dist(last.x, last.y, curr.x, curr.y);
      for (int i = 0; i < d; i++) {
        float s = (i+1.0) / d;
        drawing.add(new PVector(last.x + (curr.x - last.x)  * s, last.y + (curr.y - last.y)  * s));
      }
    } 
    drawing.add(curr);
  }
}


void randomize() {
  arrows.clear();
  for (int i = 0; i < num / 2 + 1; i++) {
    arrows.add(new Arrow(15 + random(width/20), (random(.5) - 1) * PI / random(8), i * baseSpeed));
    if (i != 0) {
      if (num % 2 != 0 || num / 2 != i) {
        arrows.add(new Arrow(15 + random(width/20), (random(.5) - 1) * PI / random(8), -i * baseSpeed));
      }
    }
  }
}

void tick() {
  for (Arrow arrow : arrows) {
    arrow.tick();
  }
}

void drawArrow(Arrow arrow) {
  if (drawArrows) {
    strokeWeight(.7);
    stroke(255, 255, 255, 200);
    fill(255, 255, 255, 200);
    float m = arrow.magnitude * .9;
    float offsetAngle = PI / 30;
    float thetaOne = offsetAngle + arrow.angle;
    float thetaTwo = -offsetAngle + arrow.angle;
    float x = arrow.vec().x;
    float y = arrow.vec().y;
    line(0, 0, x, y);
    beginShape();
    vertex(x, y);
    vertex(m * cos(thetaOne), m * sin(thetaOne));
    vertex(m * cos(thetaTwo), m * sin(thetaTwo));
    vertex(x, y);
    endShape(CLOSE);
    stroke(255, 255, 255, 255);
  }
}


void drawTrail() {
  strokeWeight(1);
  stroke(200, 200, 0);
  for (int i = 0; i < trail.size(); i++) {
    PVector p1 = trail.get(i);
    PVector p2 = trail.get(min(i+1, trail.size() - 1));
    line(p1.x, p1.y, p2.x, p2.y);
  }
  stroke(255);
}

void draw() {
  if (!mode.equals("D")) {
    for (int pass = 0; pass < PASSES; pass++) {
      background(0);
      stroke(255);
      strokeWeight(2);
      tick();
      PVector endPoint = new PVector(0, 0);
      pushMatrix();
      translate(width / 2, height / 2);
      endPoint.x += width/2;
      endPoint.y += height/2;
      for (Arrow arrow : arrows) {
        PVector changes = arrow.vec();
        drawArrow(arrow);
        translate(changes.x, changes.y);
        endPoint.x += changes.x;
        endPoint.y += changes.y;
      }
      strokeWeight(5);
      point(0, 0);
      popMatrix();
      if (trail.size() > trailLimit) {
        trail.remove(0);
      }
      trail.add(endPoint);
      drawTrail();
      if (showDrawing) {
        drawPoints(drawing);
      }
    }
  } else {
    drawPoints(drawing);
  }
}
