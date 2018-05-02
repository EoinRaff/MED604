import ddf.minim.*;
import ddf.minim.analysis.*;

import controlP5.*;

import peasy.*;


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
int total;
float r = 200;  

Shape TestShapeA, TestShapeB, OuterShapeA, OuterShapeB, InnerShapeA, InnerShapeB, spinningTopA, spinningTopB;

int index = 0;

float hu = 0;
float rot = 0;
float amp_m, frq_m, amp_rt, frq_rt;
float minAmp, maxAmp;
float calibrationAmp = 0.20; //this value needs to be calibrated for each environment
//In this instance, it represents the sound of the train door, while recorded from Adam's Laptop using Samson microphone.

void setup() {
  frameRate(60);

  //size(900, 720, P3D);
  fullScreen(P3D);

  g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 100);

  AP = new AudioProcessing();

  //InitializeGUI();
  // Create Shapes
  TestShapeA = new Shape(aM, an1, an2, an3, 1.0, 1.0);
  TestShapeB = new Shape(bM, bn1, bn2, bn3, 1.0, 1.0);

  OuterShapeA = new Shape(10.0, 0.79, 0.64, 1.24);
  OuterShapeB = new Shape(10.0, 2.0, 2.0, 2.0);

  InnerShapeA = new Shape(3.99, 0.56, 0.59, 1.59);
  InnerShapeB= new Shape(3.29, 1.31, 1.66, 0.96);

  spinningTopA  = new Shape(0.59, 2.0, 2.0, 2.0);
  spinningTopB  = new Shape(3.99, 0.58, 1.24, 0.96);

  minAmp = 999999;
  maxAmp = 0;
}

void draw() {
  MoveCamera();
  UpdateAudioParameters();

  //CalibrateAmplitude();

  float col_rt = map(frq_rt, 0, 10, 0, 255);
  float col_m = map(frq_m, 400, 10000, 0, 255);
  //console.clear();
  println("RT: " + frq_rt + "log: " + log(frq_rt) + "Col: " + col_rt);
  println("M: " + frq_m + "log: " + log(frq_m) + "Col: " + col_m);


  colorMode(RGB);
  background(0);
  total = int(map(amp_m, 0, calibrationAmp, 10, 100));
  PVector[][] v = CalculateVertices(OuterShapeA, OuterShapeB, false);

  colorMode(HSB);
  strokeWeight(2);
  stroke((hu*10)%255, 255, 255);
  noFill();
  DrawShape(v);

  colorMode(RGB);
  pushMatrix();
  scale(0.2);
  translate(0, 0, -250);
  rotateX(-rot);
  rotateY(-rot*0.5);
  rotateZ(rot*2);
  stroke(255);
  strokeWeight(5);
  //fill(col_rt);
  fill(20);
  total = 50;
  DrawShape(CalculateVertices(InnerShapeA, InnerShapeB, true));
  popMatrix();


  if (GUI) {
    //Update Values is needed to make a reactive SuperShape
    //i.e. one which will change based on M, n1, n2, n3 values.
    //These could be manipulated via GUI or AP

    //TestShapeA.UpdateValues(aM, an1, an2, an3);
    //TestShapeB.UpdateValues(bM, bn1, bn2, bn3);

    gui();
  }

  rot += 0.001;
  hu += 0.1;
}


void keyPressed() {
  switch(key) {
  case 'g':
    GUI = !GUI;
    break;
  default:
    break;
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


PVector[][] CalculateVertices(Shape s1, Shape s2, boolean RT) {

  PVector[][] vertices = new PVector[total + 1][total + 1];

  for (int i = 0; i < total+1; i++) {

    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, s2);

    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, s1);

      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 *cos(lat);
      float z = r * r2 * sin(lat);

      float offset = 0;
      if (RT) {
        offset = random(-100, 100)*amp_rt;
      }
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
  float angle = 10;
  cam.rotateX(cos(angle)*0.0005);
  //cam.rotateY(cos(angle)*0.01);
  cam.rotateZ(cos(angle)*0.001);
}


void CalibrateAmplitude() {
  if (amp_rt > maxAmp) {
    maxAmp = amp_rt;
  }
  if (amp_rt < minAmp) {
    minAmp = amp_rt;
  }
  println("Max : " + maxAmp + ", Min: " + minAmp);
}