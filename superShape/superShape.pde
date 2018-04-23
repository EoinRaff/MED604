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

void setup() {
  size(960, 520, P3D);
  cam = new PeasyCam(this, 500);
  vertices = new PVector[total + 1][total + 1];
}

float supershape(float theta, float m, float n1, float n2, float n3, float a, float b) {
  float t1 = abs((1/a) * cos(m *theta / 4));
  t1 = pow(t1, n2);
  float t2 = abs((1/b) * sin(m * theta / 4));
  t2 = pow(t2, n3);
  float t3 = t1 + t2;
  float r = pow(t3, -1/n1);
  return r;
}
void CalculateVertices(){
    for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, 1, 0.3, 0.5, 0.5, 1, 1);

    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, 5, 0.1, 1.7, 1.7, 1, 1);

      //why is there r1 and r2.
      /*
      two 2d supershapes with their own radii.
       */
      //convert to cartesi  an coordinates.
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 *cos(lat);
      float z = r * r2 * sin(lat);

      vertices[i][j] = new PVector(x, y, z);
    }
  }
}
void DrawShape(){
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
void draw() {
  background(0);
  lights();
  CalculateVertices();
  noStroke();
  fill(50, 200, 75);
  DrawShape();
}