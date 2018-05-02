import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import controlP5.*;

import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.opengl.*;



/*
Based on Tutorials by Daniel Shiffman:
 
 Part 1: https://www.youtube.com/watch?v=RkuBWEkBrZA
 Part 2:   https://www.youtube.com/watch?v=akM4wMZIBWg
 */

PMatrix3D currCameraMatrix;
PGraphics3D g3;

AudioProcessing AP;

boolean GUI;
ControlP5 controller;

float aM = 1.0;
float an1 = 1.0;
float an2 = 1.0;
float an3 = 1.0;

float bM = 1.0;
float bn1 = 1.0;
float bn2 = 1.0;
float bn3 = 1.0;

PeasyCam cam;
PVector[][] vertices;
int total;// = 10;
float r = 200;  

Shape TestShapeA; 
Shape TestShapeB;

Shape ShapeA; 
Shape ShapeB; 

Shape[][] _shapes = new Shape[7][2];

ArrayList<Shape> ShapesA = new ArrayList<Shape>();
ArrayList<Shape> ShapesB = new ArrayList<Shape>();
int index = 0;

float hu = 0;
float amp_m, frq_m, amp_rt, frq_rt;

float angle = 0;

void setup() {
  frameRate(60);
  //size(900, 720, P3D);
  fullScreen(P3D);
  g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 100);
  //vertices = new PVector[total + 1][total + 1];

  AP = new AudioProcessing();

  InitializeGUI();

  TestShapeA = new Shape(aM, an1, an2, an3, 1.0, 1.0);
  TestShapeB = new Shape(bM, bn1, bn2, bn3, 1.0, 1.0);
}

void draw() {
  MoveCamera();

  UpdateAudioParameters();

  colorMode(HSB);

  strokeWeight(2);
  stroke((hu*6)%255, 255, 255);
  noFill();
  float H, S, B;
  H = map(frq_rt, 400, 7000, 0, 255);
  S = map(frq_m, 400, 7000, 0, 255);
  B = 255;
  background(H, 255, B);

  hu += 0.1;

  total = int(map(amp_m, 0, 1, 10, 100));

  vertices = new PVector[total + 1][total + 1];

  //Update Values is needed to make a reactive SuperShape
  //i.e. one which will change based on M, n1, n2, n3 values.
  //These could be manipulated via GUI or AP
  TestShapeA.UpdateValues(aM, an1, an2, an3);
  TestShapeB.UpdateValues(bM, bn1, bn2, bn3);

  DrawShape(CalculateVertices(TestShapeA, TestShapeB));

  if (GUI) {
    gui();
  }
}
void UpdateAudioParameters() {
  amp_m = AP.meanAmplitude();
  amp_rt = AP.rtAmplitude();
  frq_m = AP.meanFrequency();
  frq_rt = AP.rtFrequency();
}

float supershape(float theta, Shape S) {
  float t1 = abs((1/S.a) * cos(S.m *theta / 4));
  t1 = pow(t1, S.n2);
  float t2 = abs((1/S.b) * sin(S.m * theta / 4));
  t2 = pow(t2, S.n3);
  float t3 = t1 + t2;
  float r = pow(t3, -1/S.n1);
  return r;
}


PVector[][] CalculateVertices(Shape s1, Shape s2) {
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, s2);

    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, s1);

      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 *cos(lat);
      float z = r * r2 * sin(lat);

      float offset = random(-50, 50)*amp_rt;
      vertices[i][j] = new PVector(x+ offset, y+ offset, z + offset);
    }
  }
  return vertices;
}


void DrawShape(PVector[][] v) {
  for (int i = 0; i < total; i++) {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total + 1; j++) {
      PVector v1 = v[i][j];
      PVector v2 = v[i+1][j];
      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}

void gui() {
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  controller.draw();
  g3.camera = currCameraMatrix;
}
void keyPressed() {
  switch(key) {
  case 'g':
    //toggle GUI visibility
    GUI = !GUI;
    break;
  case 'a':
    println("added shape to Array");
    ShapesA.add(TestShapeA);
    ShapesB.add(TestShapeB);
    ShapeA = ShapesA.get(0);
    ShapeB = ShapesB.get(0);
    break;
  case 'p':
    println(ShapesA, ShapesB);
    break;
  case 'n':
    //loop through array and change visible shape
    //if (ShapesA.get(0) !=null) {
    //  ShapeA = ShapesA.get(index);
    //  ShapeB = ShapesB.get(index);
    //  index++;
    //}
    //if (index >= ShapesA.size()) {
    //  index = 0;
    //}
    index++;
    if (index >= _shapes.length) {
      index = 0;
    }
    println("next shape: " + index);

    break;
  default:
    break;
  }
}

void InitializeGUI() {
  GUI = false;
  controller = new ControlP5(this);
  controller.addSlider("aM", 0, 100, 5, 20, 10, 10, height-100); 
  controller.addSlider("an1", 0, 2, 0.3, 50, 10, 10, 100); 
  controller.addSlider("an2", 0, 2, 0.3, 80, 10, 10, 100); 
  controller.addSlider("an3", 0, 2, 0.3, 110, 10, 10, 100); 
  controller.addSlider("bM", 0, 100, 5, width-20, 10, 10, height-100); 
  controller.addSlider("bn1", 0, 2, 1.0, width-50, 10, 10, 100); 
  controller.addSlider("bn2", 0, 2, 1.0, width-80, 10, 10, 100); 
  controller.addSlider("bn3", 0, 2, 1.0, width-110, 10, 10, 100); 
  controller.addSlider("r", 0, 200, 200, 20, height-20, 500, 10);
  controller.setAutoDraw(false);
}
void MoveCamera() {
  angle = 0.1;
  cam.rotateX(cos(angle)*0.0005);
  //cam.rotateY(cos(angle)*0.01);
  cam.rotateZ(cos(angle)*0.001);
}