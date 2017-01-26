import processing.serial.*;

Serial port;
color lineColor;
float x, y;
int t;
MPoint[] points;

class MPoint {
  float x, y;
  MPoint(float _x, float _y) {
    x = _x;
    y = _y;
  }
  
  MPoint() {
    x = 0; y = 0;
  }
  
  String toString() {
    return "(" + x + "),(" + y + ")"; 
  } 
  
}


void setup() {
  size(600, 800);
  noStroke();
  frameRate(180);
  smooth();
  lineColor = color(128);
  x = -10; 
  y = 400;
  t = 0;
  g = createGraphics(width, height);

  points = new MPoint[int(width / 10)];
  addPoint(0);
  port = new Serial(this, "COM3", 9600);
  port.bufferUntil('\r');
  background(255);
}

void serialEvent(Serial p) {
  String inStr = p.readStringUntil('\r');
  if (inStr != null) {
    inStr = inStr.substring(1).trim();
    addPoint(float(inStr));
  }
}


void draw() {
  stroke(lineColor);
  delay(100);
}

void addPoint(float val) {
  x += 10;
  
  points[t] = new MPoint(x, val);
  if (t > 1) {
    if (t == points.length - 1) {
      moveArray();
      x = 10 * (points.length - 1);
    }
    background(255);
    fill(0, 102, 153, 80);
    textSize(24);
    text(val, 0, 550);
    drawGraph(t);
  }

  t += t < points.length - 1 ? 1 : 0;
}


void moveArray() {
  for (int i = 1; i < points.length; i++) {
    points[i - 1] = points[i];
    points[i - 1].x -= 10;
  }
  points[points.length-1] = null;
}

void drawGraph(int t) {
  stroke(lineColor);
  for (int i = 1; i < t; i++) {    
    float prevY = y - points[i-1].y;
    float currY = y - points[i].y;
    line(points[i-1].x, prevY, points[i].x, currY);
  }
}