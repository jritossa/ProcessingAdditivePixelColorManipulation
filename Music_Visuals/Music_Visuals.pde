/*
Simlar to the randomised RGB CYM isolator, this program creates silohettes of 
darker colors against RGB/CYM vertical lines. 
It changes between the two based on the amplitude ot the audio input.
If I were to continue down this color-video-sound route, I would create it such
that the colors would swap only when a bass note hits so that it can coordinate 
better with the music. 
We could change the color with the bass and the width with the precussion.
We could also incorporate changing background colors (black -> random).
*/

import org.multiply.processing.*;
import processing.video.*;
import java.util.Random;
import processing.sound.*;

Capture cam;
int countWidth;
Timer timer;
boolean rgb = true;
Amplitude amp;
FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
int max = 150;

void setup() {
  size(1280,720);
  frameRate(12);
  String[] cameras = Capture.list();
  countWidth = 64;
  
  timer = new Timer(10);
  timer.start();
 
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  fft = new FFT(this, bands);
  in.start();
  amp.input(in);
  fft.input(in);
  
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
    if (red > max) {
      cRed = color(red, 0, 0);
    }
    cam.set(i, j, cRed);
}

void makeGreen(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float green = green(c);
    color cRed = color(0,0,0);
    if (green > max) {
      cRed = color(0, green, 0);
    }
    cam.set(i, j, cRed);
}

void makeBlue(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = blue(c);
    color cRed = color(0,0,0);
    if (blue > max) {
      cRed = color(0, 0, blue);
    }
    cam.set(i, j, cRed);
}

void makeCyan(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = blue(c);
    float green = green(c);
    color cRed = color(0,0,0);
    if (blue > max || green > max) {
      cRed = color(0, green, blue);
    }
    cam.set(i, j, cRed);
}

void makeYellow(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float green = green(c);
    float red  = red(c);
    color cRed = color(0,0,0);
    if (green > max || red > max) {
      cRed = color(red, green, 0);
    }
    cam.set(i, j, cRed);
}

void makeMagenta(Capture cam,int i,int j) {
    color c = cam.get(i, j);
    float blue = blue(c);
    float red = red(c);
    color cRed = color(0,0,0);
    if (blue > max || red > max) {
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
  if (int(random(0,100)%2) == 1) { rgb = false;}
  else rgb = true;
  /*if (rgb) {
       rgb = false;
     }
     else {
       rgb = true;
    }*/
}

void draw() {
  if (keyPressed == true) saveFrame("screenshot"+int(random(1000))+".png");
  if (cam.available() == true) {
    cam.read();
  }
  println(amp.analyze());
  if (timer.isFinished()) {
   if (amp.analyze() > 0.3) {
     countWidth = int(random(15,width/3));
     swapRgb();
   }
  }
  
  if (rgb) drawRgb();
  else drawCym();
  image(cam, 0, 0);
}
