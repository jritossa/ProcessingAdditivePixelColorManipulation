/*
Isolates RGB values greater than the specified max value.
Values are then compared to one another and pixel color is set to
a CMY or RGB value as appropriate. 
*/
import processing.video.*;

Capture cam;
int width = 1280;
int height = 720;
int countWidth;
boolean grow;
float max = 150;

void setup() {
  size(1280, 720);
  frameRate(12);
  String[] cameras = Capture.list();
  int countWidth = 3;
  boolean grow = true;

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using and
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}

void colorAdjustRgb(Capture cam, int i, int j) {
  color c = cam.get(i,j);
  float red = red(c);
  if (red < max) red = 0;
  float green = green(c);
  if (green < max) green = 0;
  float blue = blue(c);
  if (blue < max) blue = 0;
  color retCol;
  retCol = color(red,green,blue);
  cam.set(i,j,retCol);
}

void draw() {
  if (keyPressed == true) saveFrame("screenshot"+int(random(1000))+".png");
  if (cam.available() == true) cam.read();
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      colorAdjustRgb(cam,i,j);
    }
  }
  image(cam,0,0);
}
