/*
 * 
 * Fletcher Bach 2016
 * Running countour tracking on incoming camera capture
 * 
 */

import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;

PImage src, dst;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

int strokeColor = 210;

void setup() {
  size(1280, 720);
  background(0);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
  }
  // The camera can be initialized directly using an element
  // from the array returned by list():
  cam = new Capture(this, cameras[0]);
  // Or, the settings can be defined based on the text in the list
  //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

  // Start capturing the images from the camera
  cam.start();

  src = cam;
  delay(500);
}

void draw() {
  frameRate(10);
  //background(0);
  resetBackground(200);
  if (cam.available() == true) {
    cam.read();
  }

  //showCamData();  //this feature conflicts with saveframe if they're both in use
  saveThisFrame();
  opencv = new OpenCV(this, src);

  opencv.gray();
  opencv.threshold(70);
  dst = opencv.getOutput();

  contours = opencv.findContours();

  noFill();

  for (Contour contour : contours) {
    //strokeWeight(25);
    strokeWeight(1);
    //strokeWeight(20);
    //stroke(255);
    stroke(60, 120, 175);
    //stroke(strokeColor);
    contour.draw();

    //noStroke();
    //stroke(175, 50, 100);
    //    beginShape();
    //    for (PVector point : contour.getPolygonApproximation ().getPoints()) {
    //      vertex(point.x, point.y);
    //    }
    //    endShape();
  }
}

void showCamData() {
  if (mousePressed) {
    image(cam, 0, 0);
  }
}

void resetBackground(int col) {
  if (keyPressed) {
    background(col);
  }
}

void saveThisFrame(){
  if(mousePressed){
    saveFrame("screenshot###-####.png");
  }
}



