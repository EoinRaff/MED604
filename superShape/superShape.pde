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

boolean GUI;
ControlP5 controller;
color CL = #00FF1B;
int ON_OF = 0;
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
int total = 100;
float r = 100;  

Shape TestShapeA; 
Shape TestShapeB; 

Shape s0a = new Shape(0.0, 0.1, 1.7, 1.7, 1.0, 1.0);
Shape s0b = new Shape(0.0, 0.2, 0.5, 0.5, 1.0, 1.0);

Shape s1a = new Shape(5.0, 0.1, 1.7, 1.7, 1.0, 1.0);
Shape s1b = new Shape(1.0, 0.2, 0.5, 0.5, 1.0, 1.0);

Shape s2a = new Shape(5.2, 0.04, 1.7, 1.7, 1.0, 1.0);
Shape s2b = new Shape(0.001, 1.0, 1.0, 1.0, 1.0, 1.0);


void setup() {
  size(900, 720, P3D);
  //fullScreen(P3D);
  g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 300);
  vertices = new PVector[total + 1][total + 1];
  
  GUI = true;

  controller = new ControlP5(this);

  controller.addSlider("aM", 0, 100, 5, 20, 10, 10, height-100); 
  controller.addSlider("an1", 0, 2, 0.3, 50, 10, 10, 100); 
  controller.addSlider("an2", 0, 2, 0.3, 80, 10, 10, 100); 
  controller.addSlider("an3", 0, 2, 0.3, 110, 10, 10, 100); 

  controller.addSlider("bM", 0, 100, 5, width-20, 10, 10, height-100); 
  controller.addSlider("bn1", 0, 2, 1.0, width-50, 10, 10, 100); 
  controller.addSlider("bn2", 0, 2, 1.0, width-80, 10, 10, 100); 
  controller.addSlider("bn3", 0, 2, 1.0, width-110, 10, 10, 100); 

  controller.addSlider("r", 0, 200, 100, 20, height-20, 500, 10);

  controller.setAutoDraw(false);

  TestShapeA = new Shape(aM, an1, an2, an3, 1.0, 1.0);
  TestShapeB = new Shape(bM, bn1, bn2, bn3, 1.0, 1.0);
}


void draw() {
  background(0);
  
  TestShapeA.UpdateValues(aM, an1, an2, an3);
  TestShapeB.UpdateValues(bM, bn1, bn2, bn3);
  
  lights();
  //CalculateVertices(new Shape(aM, an1, an2, an3, 1.0, 1.0), new Shape(bM, bn1, bn2, bn3, 1.0, 1.0));
  //CalculateVertices(s1a, s1b);
  CalculateVertices(TestShapeA, TestShapeB);
  noStroke();
  fill(255);
  DrawShape();
  gui();
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


void CalculateVertices(Shape s1, Shape s2) {
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, s2);

    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, s1);

      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 *cos(lat);
      float z = r * r2 * sin(lat);

      vertices[i][j] = new PVector(x, y, z);
    }
  }
}


void DrawShape() {
  for (int i = 0; i < total; i++) {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total + 1; j++) {
      PVector v1 = vertices[i][j];
      PVector v2 = vertices[i+1][j];
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