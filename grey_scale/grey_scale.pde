/*
Creates grey scale vertical lines for each of the RGB values.
Acts as a linear representation of intensities across the spectrum.
*/

import processing.video.*;

Capture cam;
int width = 1280;
int height = 720;
int countWidth= 3;
boolean grow;

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


void blueScale(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = blue(c);
    color cBlue = color(blue, blue, blue);
    cam.set(i, j, cBlue);
}
void greenScale(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = green(c);
    color cBlue = color(blue, blue, blue);
    cam.set(i, j, cBlue);
}
void redScale(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = red(c);
    color cBlue = color(blue, blue, blue);
    cam.set(i, j, cBlue);
}

void draw() {
  if (keyPressed == true) saveFrame("screenshot"+int(random(1000))+".png");
  if (cam.available() == true) {
    cam.read();
  }
  if (grow) {
    if (countWidth + 3 >= width) grow = false;
    else countWidth += 3;
  }
  else {
    if (countWidth -3 < 0) grow = true;
    else countWidth -= 3;
  }
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      countWidth = 255;
      if (i%countWidth < countWidth/4) {
        blueScale(cam,i,j);
      }
      else if (i%countWidth < 2*countWidth/4) {
        greenScale(cam,i,j);
      }
      else if (i%countWidth < 3*countWidth/4) {
        redScale(cam,i,j);
      }
      else {
        color c = cam.get(i,j);
        cam.set(i,j,c);
      }
    }
  }
      
  image(cam, 0, 0);
}
