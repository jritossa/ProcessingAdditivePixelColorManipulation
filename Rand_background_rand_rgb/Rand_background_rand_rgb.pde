/*
Seperates pixels into two subsets: 
  1) Pixels with color intensity > max
  2) Pixels with color intensity < max
For subset 1 RGB additive filters are placed on them that change randomly
For subset 2 all pixels are uniformly set to one of CMY, acting as a background.
These colors randomly change every 2.5 seconds
*/

import processing.video.*;
import java.util.Random;

Capture cam;
int width = 1280;
int height = 720;
int countWidth;
boolean grow;
float max = 150;
Timer timer;
color randomColor = color(0,0,0);
int[] randomAlignment = {2,0,1};

void setup() {
  size(1280, 720);
  frameRate(12);
  String[] cameras = Capture.list();
  
  timer = new Timer(2500);
  timer.start();

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

color chooseRandomColorCym() {
  int rand = int(random(0,4));
  if (rand%3 == 0) return color(255,255,0);
  else if (rand%3 == 1) return color(255,0,255);
  else if (rand%3 == 2) return color(0,255,255);
  else return color(0,0,0);
}

color randomColorAlignment(float red, float green, float blue) {
  int redPos = randomAlignment[0];
  int greenPos = randomAlignment[1];
  int bluePos = randomAlignment[2];
  int[] colorParams = new int[3];
  colorParams[redPos] = int(red);
  colorParams[greenPos] = int(green);
  colorParams[bluePos] = int(blue);
  return color(colorParams[0], colorParams[1],colorParams[2]);
}

void randomAlignmentAllocation() {
  int rand = int(random(1000));
  if (rand%6 == 0) {
    randomAlignment[0] = 0;
    randomAlignment[1] = 1;
    randomAlignment[2] = 2;
  }
  if (rand%6 == 1) {
    randomAlignment[0] = 0;
    randomAlignment[1] = 2;
    randomAlignment[2] = 1;
  }
  if (rand%6 == 2) {
    randomAlignment[0] = 1;
    randomAlignment[1] = 0;
    randomAlignment[2] = 2;
  }
  if (rand%6 == 3) {
    randomAlignment[0] = 1;
    randomAlignment[1] = 2;
    randomAlignment[2] = 0;
  }
  if (rand%6 == 4) {
    randomAlignment[0] = 2;
    randomAlignment[1] = 1;
    randomAlignment[2] = 0;
  }
  if (rand%6 == 5) {
    randomAlignment[0] = 2;
    randomAlignment[1] = 0;
    randomAlignment[2] = 1;
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
  color retCol = randomColorAlignment(red,blue,green);
  if (retCol == color(0,0,0)) retCol = randomColor;
  cam.set(i,j,retCol);
}
/***** TIMER CLASS *****/
class Timer {
  int totalTime;
  int savedTime;
   Timer(int tempTotalTime) {
     totalTime = tempTotalTime;
   }
   
   void start() {
     savedTime = millis();
   }
   
   boolean isFinished() {
     int passedTime = millis() - savedTime;
     if (passedTime > totalTime) {
       return true;
     }
     else return false;
   }
   
   void printTime() {
     println("Timer: " + (millis() - savedTime));
   }
}

void draw() {
  if (keyPressed == true) saveFrame("screenshot"+int(random(1000))+".png");
  if (timer.isFinished()) {
    randomColor = chooseRandomColorCym();
    randomAlignmentAllocation();
    timer = new Timer(2500);
    timer.start();
  }
  if (cam.available() == true) cam.read();
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      colorAdjustRgb(cam,i,j);
    }
  }
  image(cam,0,0);
}
