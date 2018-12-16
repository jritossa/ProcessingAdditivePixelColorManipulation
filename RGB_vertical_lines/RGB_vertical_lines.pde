/*
This program creates vertical lines at specified widths that show the RGB 
componenets of the image.
*/

import processing.video.*;

Capture cam;
int width = 1280;
int height = 720;
int countWidth;
boolean grow;
int value = 0;

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

void makeRed(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float red = red(c);
    color cRed = color(red, 0, 0);
    cam.set(i, j, cRed);
}

void makeGreen(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float green = green(c);
    color cRed = color(0, green, 0);
    cam.set(i, j, cRed);
}

void makeBlue(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = blue(c);
    color cRed = color(0, 0, blue);
    cam.set(i, j, cRed);
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
      countWidth = 127;
      if (i%countWidth < countWidth/3) {
        makeRed(cam,i,j);
      }
      else if (i%countWidth < 2*countWidth/3) {
        makeGreen(cam,i,j);
      }
      else {
        makeBlue(cam,i,j);
      }
    }
  }
      
  image(cam, 0, 0);
}
