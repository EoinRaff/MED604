import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;
import controlP5.*;
import peasy.*;

static int participantNumber = 0;
char condition = 'A';
PrintWriter data;
String filename;

PMatrix3D currCameraMatrix;
PGraphics3D g3;

Minim minim;
AudioProcessing AP;
//ConditionB conditionB;
AudioPlayer player, playerA, playerB;

boolean GUI;
boolean recordData;
ControlP5 controller;

float m = 0;

float aM = 1.0;
float an1 = 1.0;
float an2 = 1.0;
float an3 = 1.0;

float bM = 1.0;
float bn1 = 1.0;
float bn2 = 1.0;
float bn3 = 1.0;

PeasyCam cam;
int total = 25;
int loggedTotal;
float r = 200;  

Shape TestShapeA, TestShapeB, OuterShapeA, OuterShapeB, InnerShapeA, InnerShapeB, spinningTopA, spinningTopB;

int index = 0;
int eventRecognized = 0;
float noiseIndex = 0;
float hu = 0;
float rot = 0;
float amp_m, frq_m, amp_rt, frq_rt;
float minAmp, maxAmp, minFrq, maxFrq;
float calibrationAmp = 0.20; //this value needs to be calibrated for each environment
//In this instance, it represents the sound of the train door, while recorded from Adam's Laptop using Samson microphone.

void setup() {
  noiseSeed(0);
  frameRate(60);
  size(900, 720, P3D);
  //size(96, 52, P3D);
  //fullScreen(P3D);

  g3 = (PGraphics3D)g;
  cam = new PeasyCam(this, 100);

  minim = new Minim(this);
  AP = new AudioProcessing();
  player = minim.loadFile("Audio/test.wav");
  playerA = minim.loadFile("Audio/soundscape_A.wav");
  playerB = minim.loadFile("Audio/soundscape_B.wav");

  InitializeGUI();
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
  minFrq = 999999;
  maxFrq = 0;

  recordData = false;
}

void draw() {
  MoveCamera();
  UpdateAudioParameters(condition);
  CalibrateValues();

  float col_rt = map(frq_rt, minFrq*0.9, maxFrq*1.1, 0, 255);
  float col_m = map(frq_m, minFrq*0.9, maxFrq*1.1, 0, 255);
  float update_m = map(frq_m, minFrq*0.9, maxFrq*1.1, 0.01, 1.0);

  colorMode(RGB);
  background(0);
  m = int(map(amp_m, 0, calibrationAmp, 0, 100));
  //loggedTotal = total;
  OuterShapeA.UpdateValues(m);
  OuterShapeB.UpdateValues(m);
  PVector[][] v = CalculateVertices(OuterShapeA, OuterShapeB, false);

  colorMode(HSB);
  strokeWeight(2);
  stroke(col_m);
  fill(255-col_m);

  stroke(hu%255, 255, 255);
  fill(255-(hu%255), 255, col_m);

  DrawShape(v);

  colorMode(RGB);
  pushMatrix();
  scale(0.2);
  translate(0, 0, -250);
  rotateX(-rot);
  rotateY(-rot*0.5);
  rotateZ(rot*2);
  strokeWeight(5);

  stroke(255 - col_rt);
  fill(col_rt);

  //total = 50;
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
  noiseIndex += 0.01;
  hu += update_m;

  if (recordData)
    data.println(millis()+","+eventRecognized+","+frq_rt +","+ col_rt+","+frq_m+","+col_m+","+amp_rt+","+amp_m+","+loggedTotal+","+frameRate);

  eventRecognized = 0;
  if(player != null){
    if(!player.isPlaying() && recordData){
      println("Audio File ended");
      EndTest();
    }
  }else {
    println("no working player");
  }
  //println(amp_m, amp_rt, frq_m, frq_rt);
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
    GUI = !GUI;
    break;
  case 'p': 
    data.close();
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
    //TODO: check if desired file is already loaded
    println("loading file");
    player = playerA;
    println("file loaded");
    filename = "participant_" +participantNumber + "_condition_" + condition+"_"+ currentTime+ "_data.txt";
    //TODO:check if this loops by default or not
  } else if (condition == 'B') {
    noiseIndex = 0;
    player = playerB;
    filename = "participant_" +participantNumber + "_condition_" + condition+"_"+ currentTime+ "_data.txt";
  } else if (condition == ' ') {
    //println("Calibrating");
    //maybe replace with calibration file
    player = minim.loadFile("Audio/soundscape_A.wav");
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
  println("Incrementing Participant Number");
  participantNumber ++;
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
    frq_rt = noise(noiseIndex);
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