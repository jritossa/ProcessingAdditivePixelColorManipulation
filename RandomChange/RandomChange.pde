/* 
Where we left off last time.
A 4x4 grid that randomizes the filter component of each section.
Options are additive RGB, CYM, subtractive RGB, CYM, original image and negative.
*/

import org.multiply.processing.*;

import processing.video.*;
import java.util.Random;

Capture cam;
int width = 1280;
int height = 720;
int time;
int pannels;
int[] colorArray;
int currentTime = 0;
Timer timer;

/********** SETUP ***********/

void setup() {
  size(1280, 720);
  frameRate(12);
  
  
  pannels = int(random(4));
  time = int(random(5000));
  timer = new Timer(time);
  timer.start();
  colorArray = new int[(1+pannels)*(1+pannels)];
  for (int k = 0; k < (1+pannels)*(1+pannels); k++) {
    colorArray[k] = int(random(14));
  }

  String[] cameras = Capture.list();

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

/********** COLOR OPTIONS **********/

color[] returnCMYAdd(color col) {
  float r = red(col);
  float g = green(col);
  float b = blue(col);
  color[] ret = new color[3];
  color cyan = color(0,g,b);
  color magenta = color(r,0,b);
  color yellow = color(r, g,0);
  ret[0] = cyan;
  ret[1] = magenta;
  ret[2] = yellow;
  return ret;
}

color[] returnCMYSub(color col) {
  float r = red(col);
  float g = green(col);
  float b = blue(col);
  color[] ret = new color[3];
  float c = (255-r);
  float m = (255-g);
  float y = (255-b);
  color cyan = color(r,m,y);
  color magenta = color(c,g,y);
  color yellow = color(c, m,b);
  ret[0] = cyan;
  ret[1] = magenta;
  ret[2] = yellow;
  return ret;
}

void cyanAdd(Capture cam, int i, int j) {
  color c = cam.get(i,j);
    color[] cmy = returnCMYAdd(c);
    cam.set(i,j,cmy[0]);
}

void magentaAdd(Capture cam, int i, int j) {
  color c  = cam.get(i, j);
  color[] cmy = returnCMYAdd(c);
  cam.set(i,j,cmy[1]);
}
  
 void yellowAdd(Capture cam, int i, int j) {
  color c = cam.get(i, j);
  color[] cmy = returnCMYAdd(c);
  cam.set(i,j,cmy[2]);
}

void cyanSub(Capture cam, int i, int j) {
  color c = cam.get(i, j);
  color[] cmy = returnCMYSub(c);
  cam.set(i,j,cmy[0]);
}

void magentaSub(Capture cam, int i, int j) {
  color c = cam.get(i, j);
  color[] cmy = returnCMYSub(c);
  cam.set(i,j,cmy[1]);
}

void yellowSub(Capture cam, int i, int j) {
  color c = cam.get(i, j);
  color[] cmy = returnCMYSub(c);
  cam.set(i,j,cmy[2]);
}

void redAdd(Capture cam, int i, int j) {
  color c = cam.get(i, j);
  float red = red(c);
  color cRed = color(red, 0, 0);
  cam.set(i, j, cRed);
}

void greenAdd(Capture cam, int i, int j) {
  color c = cam.get(i,j);
  float green = green(c);
  color cGreen = color(0,green,0);
  cam.set(i,j,cGreen);
}

void blueAdd(Capture cam, int i, int j) {
  color c = cam.get(i,j);
  float blue = blue(c);
  color cBlue = color(0,0,blue);
  cam.set(i,j,cBlue);
}

void redSub(Capture cam, int i, int j) {
  color c = cam.get(i, j);
  float green = green(c);
  float blue = blue(c);
  float red = 255-red(c);
  color cRed = color(red*.75, green, blue);
  cam.set(i, j, cRed);
}

void greenSub(Capture cam, int i, int j) {
  color c = cam.get(i,j);
  float blue = blue(c);
  float red = red(c);
  float green = 255-green(c);
  color cGreen = color(red,green*.75,blue);
  cam.set(i,j,cGreen);
}

void blueSub(Capture cam, int i, int j) {
  color c = cam.get(i,j);
  float green = green(c);
  float red = red(c);
  float blue = 255-blue(c);
  color cBlue = color(red,green,blue*.75);
  cam.set(i,j,cBlue);
}


void negative(Capture cam, int i, int j) {
  color c = cam.get(i,j);
  float red = 255-red(c);
  float green = 255-green(c);
  float blue = 255-blue(c);
  color cBlue = color(red,green,blue);
  cam.set(i,j,cBlue);
}

void original(Capture cam, int i, int j) {
  color c = cam.get(i,j);
  color cBlue = color(red(c),green(c),blue(c));
  cam.set(i,j,cBlue);
}

/******* RANDOM FUNCTIONS ******/

void chooseRandomColor(Capture cam, int n, int i, int j) {
  if (n == 0) {
    cyanAdd(cam, i, j);
  }
  if (n == 1) {
    magentaAdd(cam, i, j);
    
  }
  if (n == 2) {
    yellowAdd(cam, i, j);
    
  }
  if (n == 3) {
    cyanSub(cam, i, j);
  }
  if (n == 4) {
    magentaSub(cam, i, j);
    
  }
  if (n == 5) {
    yellowSub(cam, i, j);
    
  }
  if (n == 6) {
    redAdd(cam, i, j);
  }
  if (n == 7) {
    greenAdd(cam, i, j);
  }
  if (n == 8) {
    blueAdd(cam, i, j);
  }
  if (n == 9) {
    redSub(cam, i, j); 
  }
  if (n == 10) {
    greenSub(cam, i, j);
  }
  if (n == 11) {
    blueSub(cam, i, j);
  }
  if (n == 12) {
    negative(cam, i, j);
    
  }
  if (n == 13) {
    original(cam, i, j);
  }
}

void chooseRandom(int[] colorArray, int chosen, int i, int j) {
  // 1x1
  if (chosen == 0) 
    if ((0 <= i && i < width) && 0 <= j && j < height) 
      chooseRandomColor(cam, colorArray[0], i, j);
      
  //2x2
  else if (chosen == 1) {
    if ((0 <= i && i < width/2) && 0 <= j && j < height/2) 
      chooseRandomColor(cam, colorArray[0], i, j);
    if ((width/2 <= i && i < width) && 0 <= j && j < height/2) 
      chooseRandomColor(cam, colorArray[1], i, j);
      
      
    else if ((0 <= i && i < width/2) && height/2 <= j && j < height) 
      chooseRandomColor(cam, colorArray[2], i, j);
    else if ((width/2 <= i && i < width) && height/2 <= j && j < height) 
      chooseRandomColor(cam, colorArray[3], i, j);
  }
  
  //3x3
   else if (chosen == 2) {
    if ((0 <= i && i < width/3) && 0 <= j && j < height/3) 
      chooseRandomColor(cam, colorArray[0], i, j);
    else if ((0 <= i && i < width/3) && height/3 <= j && j < 2*height/3) 
      chooseRandomColor(cam, colorArray[1], i, j);
    else if ((0 <= i && i < width/3) && height/2 <= j && j < height) 
      chooseRandomColor(cam, colorArray[2], i, j);
      
      
    else if ((width/3 <= i && i < 2*width/3) && 0 <= j && j < height/3) 
      chooseRandomColor(cam, colorArray[3], i, j);
    else if ((width/3 <= i && i < 2*width/3) && height/3 <= j && j < 2*height/3) 
      chooseRandomColor(cam, colorArray[4], i, j);
    else if ((width/3 <= i && i < 2*width/3) && height/2 <= j && j < height) 
      chooseRandomColor(cam, colorArray[5], i, j);
      
      
    else if ((2*width/3 <= i && i < width) && 0 <= j && j < height/3) 
      chooseRandomColor(cam, colorArray[6], i, j);
    else if ((2*width/3 <= i && i < width) && height/3 <= j && j < 2*height/3) 
      chooseRandomColor(cam, colorArray[7], i, j);
    else if ((2*width/3 <= i && i < width) && height/2 <= j && j < height) 
      chooseRandomColor(cam, colorArray[8], i, j);
   }
    
  // 4x4
  if (chosen == 3) {
    if ((0*width/4 <= i && i < 1*width/4) && 
    0*height/4 <= j && j < 1*height/4) 
      chooseRandomColor(cam, colorArray[0], i, j);
    if ((1*width/4 <= i && i < 2*width/4) && 
    0*height/4 <= j && j < 1*height/4) 
      chooseRandomColor(cam, colorArray[1], i, j);
    if ((2*width/4 <= i && i < 3*width/4) && 
    0*height/4 <= j && j < 1*height/4) 
      chooseRandomColor(cam, colorArray[2], i, j);
    if ((3*width/4 <= i && i < 4*width/4) && 
    0*height/4 <= j && j < 1*height/4) 
      chooseRandomColor(cam, colorArray[3], i, j);
      
      
    if ((0*width/4 <= i && i < 1*width/4) && 
    1*height/4 <= j && j < 2*height/4) 
      chooseRandomColor(cam, colorArray[4], i, j);
    if ((1*width/4 <= i && i < 2*width/4) && 
    1*height/4 <= j && j < 2*height/4) 
      chooseRandomColor(cam, colorArray[5], i, j);
    if ((2*width/4 <= i && i < 3*width/4) && 
    1*height/4 <= j && j < 2*height/4) 
      chooseRandomColor(cam, colorArray[6], i, j);
    if ((3*width/4 <= i && i < 4*width/4) && 
    1*height/4 <= j && j < 2*height/4) 
      chooseRandomColor(cam, colorArray[7], i, j);
      
      
    if ((0*width/4 <= i && i < 1*width/4) && 
    2*height/4 <= j && j < 3*height/4) 
      chooseRandomColor(cam, colorArray[8], i, j);
    if ((1*width/4 <= i && i < 2*width/4) && 
    2*height/4 <= j && j < 3*height/4) 
      chooseRandomColor(cam, colorArray[9], i, j);
    if ((2*width/4 <= i && i < 3*width/4) && 
    2*height/4 <= j && j < 3*height/4) 
      chooseRandomColor(cam, colorArray[10], i, j);
    if ((3*width/4 <= i && i < 4*width/4) && 
    2*height/4 <= j && j < 3*height/4) 
      chooseRandomColor(cam, colorArray[11], i, j);
      
      
    if ((0*width/4 <= i && i < 1*width/4) && 
    3*height/4 <= j && j < 4*height/4) 
      chooseRandomColor(cam, colorArray[12], i, j);
    if ((1*width/4 <= i && i < 2*width/4) && 
    3*height/4 <= j && j < 4*height/4) 
      chooseRandomColor(cam, colorArray[13], i, j);
    if ((2*width/4 <= i && i < 3*width/4) && 
    3*height/4 <= j && j < 4*height/4) 
      chooseRandomColor(cam, colorArray[14], i, j);
    if ((3*width/4 <= i && i < 4*width/4) && 
    3*height/4 <= j && j < 4*height/4) 
      chooseRandomColor(cam, colorArray[15], i, j);
  }
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

/****** MAIN FUNCTION *****/

void draw() {
  if (keyPressed == true) saveFrame("screenshot"+int(random(1000))+".png");
  if (cam.available() == true) {
    cam.read();
  }
  println("Pannels: " + pannels);
  timer.printTime();
  println();
  
  if (timer.isFinished()) {
    pannels = 3;
    time = int(random(5000,15000));
    timer = new Timer(time);
    timer.start();
    colorArray = new int[(1+pannels)*(1+pannels)];
    for (int k = 0; k < (1+pannels)*(1+pannels); k++) {
      colorArray[k] = int(random(0,14));
      println(colorArray[k]);
    }
  }
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        chooseRandom(colorArray, 3,i,j);
      }
    }
  image(cam, 0, 0);
}
