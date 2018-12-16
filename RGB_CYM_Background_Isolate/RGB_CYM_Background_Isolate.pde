/*
Pixels are broken down into their RGB values.
RGB values are then exagerated, set to 0 if they're bellow a certain point
and 255 if they are above.
Background color is set to darker than other examples to contrast the bright
positive RGB colors
*/

import processing.video.*;
import java.util.Random;

Capture cam;
int width = 1280;
int height = 720;
int countWidth;
boolean grow;
float max = 255/2;
Timer timer;
color randomColor = color(0,0,0);
int[] randomAlignment = {0,1,2};

void setup() {
  size(1280, 720);
  frameRate(12);
  String[] cameras = Capture.list();
  int countWidth = 3;
  boolean grow = true;
  
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

color chooseRandomColor() {
  return color(random(0,100),random(0,100),random(0,100));
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

void colorAdjustRgb(Capture cam, int i, int j) {
  color c = cam.get(i,j);
  float red = red(c);
  if (red < max) red = 0;
  else red = 255;
  float green = green(c);
  if (green < max) green = 0;
  else green = 255;
  float blue = blue(c);
  if (blue < max) blue = 0;
  else blue = 255;
  color retCol = color(red,green,blue);
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
    randomColor = chooseRandomColor();
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
