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
int total = 50;

void setup() {
  size(960, 520, P3D);
  cam = new PeasyCam(this, 500);
  vertices = new PVector[total + 1][total + 1];
}

void draw() {
  background(0);
  lights();
  float r = 200;  
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, 0, PI);

    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, 0, TWO_PI);

      //convert to cartesi  an coordinates.
      float x = r * sin(lat) * cos(lon);
      float y = r * sin(lat) * sin(lon);
      float z = r * cos(lat);

      vertices[i][j] = new PVector(x, y, z);
    }
  }

  for (int i = 0; i < total; i++) {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total + 1; j++) {
      PVector v1 = vertices[i][j];
      PVector v2 = vertices[i+1][j];
      stroke(255);
      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}