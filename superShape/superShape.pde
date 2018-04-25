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
boolean DisplayArray;
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
int total = 100;
float r = 100;  

Shape TestShapeA; 
Shape TestShapeB;

Shape ShapeA; 
Shape ShapeB; 

Shape flowerA = new Shape(10.0, 0.79, 0.64, 1.24);
Shape flowerB = new Shape(10.0, 2.0, 2.0, 2.0);

Shape star5A  = new Shape(4.89, 0.38, 1.12, 0.47);
Shape star5b  = new Shape(9.09, 0.71, 0.79, 1.12);

Shape spinningTopA  = new Shape(0.59, 2.0, 2.0, 2.0);
Shape spinningTopB  = new Shape(3.99, 0.58, 1.24, 0.96);

Shape xWingA  = new Shape(10.0, 0.5, 0.06, 0.53);
Shape xWingB  = new Shape(7.89, 1.69, 1.24, 0.96);

Shape speakerA  = new Shape(4.0, 0.3, 0.3, 0.3);
Shape speakerB  = new Shape(18.0, 1.0, 1.0, 0.5);

Shape lemonA  = new Shape(18.0, 1.0, 1.0, 0.5);
Shape lemonB  = new Shape(3.0, 0.3, 0.3, 0.85);

Shape AdamA = new Shape(3.99, 0.56, 0.59, 1.59);
Shape AdamB = new Shape(3.29, 1.31, 1.66, 0.96);

ArrayList<Shape> ShapesA = new ArrayList<Shape>();
ArrayList<Shape> ShapesB = new ArrayList<Shape>();
int index = 0;

void setup() {
  size(900, 720, P3D);
  //fullScreen(P3D);
  g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 300);
  vertices = new PVector[total + 1][total + 1];

  GUI = true;
  DisplayArray= false;

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

void keyPressed() {
  switch(key) {
  case 'g':
    //toggle GUI visibility
    GUI = !GUI;
    DisplayArray = !DisplayArray;
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
    println("next shape: " + index);
    if (ShapesA.get(0) !=null) {
      ShapeA = ShapesA.get(index);
      ShapeB = ShapesB.get(index);
      index++;
    }
    if (index >= ShapesA.size()) {
      index = 0;
    }
    break;
  default:
    break;
  }
}

void draw() {
  background(0);

  TestShapeA.UpdateValues(aM, an1, an2, an3);
  TestShapeB.UpdateValues(bM, bn1, bn2, bn3);

  lights();
  //CalculateVertices(new Shape(aM, an1, an2, an3, 1.0, 1.0), new Shape(bM, bn1, bn2, bn3, 1.0, 1.0));
  //CalculateVertices(s1a, s1b);
  if (DisplayArray) {
    CalculateVertices(ShapeA, ShapeB);
  } else {
    CalculateVertices(TestShapeA, TestShapeB);
  }
  noStroke();
  fill(255);
  DrawShape();
  if (GUI) {
    gui();
  }
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