import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;
import peasy.*;

static int participantNumber = 0;
char condition = 'A';
PrintWriter data;
String filename;

Minim minim;
AudioProcessing AP;
AudioPlayer player, playerA, playerB;

boolean recordData;

float m = 0;

PeasyCam cam;
int lod = 25;
int loggedTotal;
float r = 200;  

Shape TestShapeA, TestShapeB, OuterShapeA, OuterShapeB, InnerShapeA, InnerShapeB, spinningTopA, spinningTopB;

Shape star5A;
Shape star5B;

int index = 0;
int eventRecognized = 0;
float noiseIndex = 0;
float hu = 0;
float rot = 0;
float orbit = 0;
float amp_m, frq_m, amp_rt, frq_rt;
float minAmp, maxAmp, minFrq, maxFrq;
float calibrationAmp = 0.20; //this value needs to be calibrated for each environment
//In this instance, it represents the sound of the train door, while recorded from Adam's Laptop using Samson microphone.

void setup() {
  println("Performing Initial Setup");
  println("Generating Perlin Noise Seed");
  noiseSeed(0);
  println("Locking framerate @ 60fps");
  frameRate(60);
  //size(900, 720, P3D);
  //size(96, 52, P3D);
  fullScreen(P3D, 2);

  println("Preparing Camera");
  cam = new PeasyCam(this, 150);
  println("Preparing Minim");
  minim = new Minim(this);
  println("Initializing Audio Processing script");
  AP = new AudioProcessing(minim);
  println("Loading Audio Files");
  playerA = minim.loadFile("Audio/soundscape_A.wav");
  playerB = minim.loadFile("Audio/soundscape_B.wav");

  // Create Shapes
  println("Creating Initial Shape Parameters");


  star5A  = new Shape(5, 0.38, 1.12, 0.47);
  star5B  = new Shape(10, 0.71, 0.79, 1.12);

  Shape speakerA  = new Shape(4.0, 0.3, 0.3, 0.3);
  Shape speakerB  = new Shape(0.18, 1, 1, 0.5);


  Shape lemonA  = new Shape(18.9, 1.0, 1.0, 0.5);
  Shape lemonB  = new Shape(3.0, 0.3, 0.3, 0.85);

  OuterShapeA = new Shape(10.0, 0.79, 0.64, 1.24);
  OuterShapeB = new Shape(10.0, 2.0, 2.0, 2.0);

  InnerShapeA = new Shape(3.99, 0.56, 0.59, 1.59);
  InnerShapeB= new Shape(3.29, 1.31, 1.66, 0.96);
  
  InnerShapeA = lemonA;
  InnerShapeB = lemonB;

  println("Initializing Values for Ampitude and Frequency Calibration");
  minAmp = 999999;
  maxAmp = 0;
  minFrq = 999999;
  maxFrq = 0;

  recordData = false;
  println("Ready!");
  PrintInstructions();
}

void draw() {
  MoveCamera();
  UpdateAudioParameters(condition);
  CalibrateValues();

  float col_rt = map(frq_rt, minFrq*0.9, maxFrq*1.1, 0, 255);
  float col_m = map(frq_m, minFrq*0.9, maxFrq*1.1, 0, 255);
  float update_m = map(frq_m, minFrq*0.9, maxFrq*1.1, 0.01, 1.0);
  float orbitSpeed = map(amp_rt, 0, maxAmp, 0.001, 0.01);
  float rotationSpeed = map(frq_rt, minFrq*0.9, maxFrq*1.1, 0.001, 0.05);

  background(0);
  lights();
  
  colorMode(HSB);
  strokeWeight(2);

  //OuterShape
  stroke(hu%255, 255, 255);
  fill(255-(hu%255), 255, col_m);
  m = map(amp_m, 0, maxAmp, 0, 10);
  OuterShapeA.UpdateValues(m);
  OuterShapeB.UpdateValues(m);
  star5A.UpdateValues(m);
  star5A.UpdateValues(m);
  //m = map(amp_rt, 0, maxAmp, 0, 5);
  //InnerShapeA.UpdateValues(m);
  //InnerShapeB.UpdateValues(m);

  lod = 25;
  PVector[][] v = CalculateVertices(OuterShapeA, OuterShapeB, false);
  PVector[][] v2 = CalculateVertices(star5A, star5B, false);

  DrawShape(v);

  //Center Shape
  pushMatrix();
  scale(0.2);
  translate(0, 0, -250);
  fill(255-(hu%255), 255, 200);
  DrawShape(v2);

  //Orbiting Shapes:
  lod = 10;
  colorMode(RGB);
  fill(col_m,col_m,255-col_m);
  stroke(255-col_m,255-col_m,col_m);
  strokeWeight(5);

  pushMatrix();
  //orbit
  rotateX(orbit);
  translate(0, 0, 250);
  //local rotation
  rotateX(rot);
  rotateY(rot);
  rotateZ(rot);
  scale(0.25);
  DrawShape(CalculateVertices(InnerShapeA, InnerShapeB, true));
  popMatrix();

  pushMatrix();
  //orbit
  rotateX(orbit);
  rotateY(orbit);
  translate(0, 0, -250);
  //local rotation
  rotateX(rot);
  rotateY(rot);
  rotateZ(rot);
  scale(0.25);
  DrawShape(CalculateVertices(InnerShapeA, InnerShapeB, true));
  popMatrix();

  pushMatrix();
  //orbit
  rotateY(orbit);
  translate(0, 250, 0);
  //local rotation
  rotateX(rot);
  rotateY(rot);
  rotateZ(rot);
  scale(0.25);
  DrawShape(CalculateVertices(InnerShapeA, InnerShapeB, true));
  popMatrix();

  pushMatrix();
  //orbit
  rotateX(-orbit);
  translate(0, -250, 0);
  //local rotation
  rotateX(rot);
  rotateY(rot);
  rotateZ(rot);
  scale(0.25);
  DrawShape(CalculateVertices(InnerShapeA, InnerShapeB, true));
  popMatrix();

  pushMatrix();
  //orbit
  rotateX(-orbit);
  rotateY(-orbit);
  translate(250, 0, 0);
  //local rotation
  rotateX(rot);
  rotateY(rot);
  rotateZ(rot);
  scale(0.25);
  DrawShape(CalculateVertices(InnerShapeA, InnerShapeB, true));
  popMatrix();

  pushMatrix();
  //orbit
  rotateY(-orbit);
  translate(-250, 0, 0);
  //local rotation
  rotateX(rot);
  rotateY(rot);
  rotateZ(rot);
  scale(0.25);
  DrawShape(CalculateVertices(InnerShapeA, InnerShapeB, true));
  popMatrix();


  popMatrix();

  rot += rotationSpeed;
  orbit += orbitSpeed;
  noiseIndex += 0.01;
  hu += update_m;

  if (recordData)
    data.println(millis()+","+eventRecognized+","+frq_rt +","+ col_rt+","+frq_m+","+col_m+","+amp_rt+","+amp_m+","+loggedTotal+","+frameRate);

  eventRecognized = 0;

  if (player != null) {
    if (!player.isPlaying() && recordData) {
      println("Audio File ended");
      EndTest();
    }
  } else {
    //println("no working player");
  }
}


void keyPressed() {
  switch(key) {
  case 'a':
    println("Starting Test");
    StartTest('A');
    break;
  case 'b':
    println("Starting Test");
    StartTest('B');
    break;
  case 'e':
    println("Ending Test");
    EndTest();
    break;
  case 'g':
    //GUI = !GUI;
    break;
  case 'p': 
    println("Incrementing Participant Number");
    participantNumber ++;
    println("Ready to Test Participant number " + participantNumber);
  case 'r':
    //recordData = true;
    break;
  case ' ':
    println("Event Noted");
    eventRecognized = 1; 
    break;
  default:
    break;
  }
}


void StartTest(char _condition) {
  condition = _condition;
  recordData = true;
  String currentTime = "date_" + day()+ "_" +month()+ "_time_" + hour()+ "_" + minute();
  if (condition == 'A') {
    println("loading file " + condition);
    player = playerA;
    println("file loaded");
    filename = "participant_" +participantNumber + "_condition_" + condition+"_"+ currentTime+ "_data.txt";
  } else if (condition == 'B') {
    noiseIndex = 0;
    player = playerB;
    filename = "participant_" +participantNumber + "_condition_" + condition+"_"+ currentTime+ "_data.txt";
  } else if (condition == ' ') {
    //println("Calibrating");
    //maybe replace with calibration file
    //player = minim.loadFile("Audio/soundscape_A.wav");
    //filename=("calibrataion_data.txt");
  } else {
    //error
  }
  println("Participant Number " + participantNumber + ", Condition " + condition);
  filename = "participant_" +participantNumber + "_condition_" + condition+"_"+ currentTime+ "_data.txt";
  data = createWriter("Data/"+filename);
  data.println("elapsedTime,eventRecognized,frq_rt, col_rt, frq_m, col_m, amp_rt, amp_m, total, framerate;");
  println("Playing AudioFile");
  player.play();
  //logging of data occurs every frame in Draw()
}

void EndTest() { 
  if (player.isPlaying()) {
    player.pause();
    player.rewind();
  }
  println("Saving Data to file: " + filename);
  data.flush();
  data.close();  
  recordData = false;
  println("Test Finished. Ready for Next Test.");
  PrintInstructions();
}

void UpdateAudioParameters(char _condition) {
  if (_condition == 'A' || _condition == ' ') {
    //Reactive to Mic Input
    amp_m = AP.meanAmplitude();
    amp_rt = AP.rtAmplitude();
    frq_m = AP.meanFrequency();
    frq_rt = AP.rtFrequency();
  } else if (_condition =='B') {
    //reactive to AudioFile data
    amp_m = noise(noiseIndex)*0.01;
    amp_rt = noise(noiseIndex)*0.01;
    frq_m = map(noise(noiseIndex), 0, 1, minFrq, maxFrq);
    frq_rt = map(noise(noiseIndex), 0, 1, minFrq, maxFrq);
  } else {
    //error
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


PVector[][] CalculateVertices(Shape s1, Shape s2, boolean RT) {
  PVector[][] vertices = new PVector[lod + 1][lod + 1];
  for (int i = 0; i < lod+1; i++) {
    float lat = map(i, 0, lod, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, s2);
    for (int j = 0; j < lod+1; j++) {
      float lon = map(j, 0, lod, -PI, PI);
      float r1 = supershape(lon, s1);
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 *cos(lat);
      float z = r * r2 * sin(lat);
      float offset = 0;
      if (RT) {
        //remove this boolean if we want to remove offset
        //offset = random(-100, 100)*amp_rt;
      }
      vertices[i][j] = new PVector(x+ offset, y+ offset, z + offset);
    }
  }
  return vertices;
}


void DrawShape(PVector[][] v) {
  for (int i = 0; i < lod; i++) {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < lod + 1; j++) {
      PVector v1 = v[i][j];
      PVector v2 = v[i+1][j];
      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}

void MoveCamera() {
  float angle = 10;
  cam.rotateX(cos(angle)*0.0005);
  cam.rotateZ(cos(angle)*0.001);
}


void CalibrateValues() {
  if (amp_rt > maxAmp) {
    maxAmp = amp_rt;
  }
  if (amp_rt < minAmp) {
    minAmp = amp_rt;
  }
  if (frq_rt > maxFrq) {
    maxFrq = frq_rt;
  }
  if (frq_rt < minFrq) {
    minFrq = frq_rt;
  }
}

void PrintInstructions() {
  println("----------------------------------------------------------------------");
  println("Press <a> to begin condition A. Press <b> to begin condition B.");
  println("Press <p> to prepare for next participant. \nPress <e> to end test early.");
  println("----------------------------------------------------------------------");
}