import ddf.minim.analysis.*;  //Shoud be imported in the main script
import ddf.minim.*;           //Shoud be imported in the main script


AudioProcessing mySound;

void setup()  {    
  mySound = new AudioProcessing();   
}    

void draw()  {
  float var = mySound.meanAmplitude();
  println(var);
}