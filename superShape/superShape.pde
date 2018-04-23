import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

/*
Based on Tutorials by Daniel Shiffman:
 
 Part 1: https://www.youtube.com/watch?v=RkuBWEkBrZA
 Part 2:   https://www.youtube.com/watch?v=akM4wMZIBWg
 */

PeasyCam cam;
PVector[][] vertices;
int total = 100;
float r = 200;  

Shape s1a = new Shape(5.0, 0.1, 1.7, 1.7, 1.0, 1.0);
Shape s1b = new Shape(1.0, 0.2, 0.5, 0.5, 1.0, 1.0);


void setup() {
  size(960, 520, P3D);
  cam = new PeasyCam(this, 500);
  vertices = new PVector[total + 1][total + 1];
}


void draw() {
  background(0);
  lights();
  CalculateVertices();
  noStroke();
  fill(50, 200, 75);
  DrawShape();
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


void CalculateVertices() {
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, s1b);

    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, s1a);

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