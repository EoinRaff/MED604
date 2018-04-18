import ddf.minim.analysis.*;  //Shoud be imported in the main script
import ddf.minim.*;           //Shoud be imported in the main script

AudioProcessing mySound;


void setup()  {    
  mySound = new AudioProcessing();  
  size(500, 500);
  background(255, 255, 255);
}    

void draw()  {
  float fre = mySound.meanFrequency();
  float amp = mySound.meanAmplitude();
  println("Amp: " + amp + " Freq: " + fre );
}
