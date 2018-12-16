/*
This program again creates vertical lines that isolate certain colors.
It randomly chooses between splitting into RGB and CMY.
Furthermore, it isolates colors that are greater than a certain brightness,
thus creating silohettes and reverse silohettes against the colored brighter areas.
*/

import org.multiply.processing.*;
import processing.video.*;
import java.util.Random;

Capture cam;
int width = 1280;
int height = 720;
int countWidth;
Timer timer;
boolean rgb = true;


void setup() {
  size(1280, 720);
  frameRate(12);
  String[] cameras = Capture.list();
  timer = new Timer(int(random(5000)));
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

void makeRed(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float red = red(c);
    color cRed = color(0,0,0);
    if (red > 175) {
      cRed = color(red, 0, 0);
    }
    cam.set(i, j, cRed);
}

void makeGreen(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float green = green(c);
    color cRed = color(0,0,0);
    if (green > 175) {
      cRed = color(0, green, 0);
    }
    cam.set(i, j, cRed);
}

void makeBlue(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = blue(c);
    color cRed = color(0,0,0);
    if (blue > 175) {
      cRed = color(0, 0, blue);
    }
    cam.set(i, j, cRed);
}

void makeCyan(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = blue(c);
    float green = green(c);
    color cRed = color(0,0,0);
    if (blue > 175 || green > 175) {
      cRed = color(0, green, blue);
    }
    cam.set(i, j, cRed);
}

void makeYellow(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float green = green(c);
    float red  = red(c);
    color cRed = color(0,0,0);
    if (green > 175 || red > 175) {
      cRed = color(red, green, 0);
    }
    cam.set(i, j, cRed);
}

void makeMagenta(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = blue(c);
    float red = red(c);
    color cRed = color(0,0,0);
    if (blue > 175 || red > 175) {
      cRed = color(red, 0, blue);
    }
    cam.set(i, j, cRed);
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

void drawRgb() {
  for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        countWidth = 64;
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
}
void drawCym() {
  for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        countWidth = 64;
        if (i%countWidth < countWidth/3) {
          makeCyan(cam,i,j);
        }
        else if (i%countWidth < 2*countWidth/3) {
          makeYellow(cam,i,j);
        }
        else {
          makeMagenta(cam,i,j);
        }
      }
    }
}

void swapRgb() {
  if (rgb) {
       rgb = false;
     }
     else {
       rgb = true;
    }
}

void draw() {
  if (keyPressed == true) saveFrame("screenshot"+int(random(1000))+".png");
  if (cam.available() == true) {
    cam.read();
  }
  
  if (timer.isFinished()) {
   timer = new Timer(int(random(5000)));
   timer.start();
   swapRgb();
  }
  if (rgb) drawRgb();
  else drawCym();
  image(cam, 0, 0);
}
