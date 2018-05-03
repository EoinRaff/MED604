import ddf.minim.analysis.*;  //Shoud be imported in the main script
import ddf.minim.*;           //Shoud be imported in the main script

AudioProcessing mySound;


void setup()  {    
  mySound = new AudioProcessing();  
  size(500, 500);
  background(255, 255, 255);
}    

void draw()  {
  background(255);
  float fre = mySound.meanFrequency();
  float amp = mySound.meanAmplitude();
  float frert = mySound.rtFrequency();
  println("Amp: " + amp + " Freq: " + fre + " Frequency real time " + frert);
  fill(0);
  text("Frequency Real time " + frert, 10, 20);
  text("Frequency mean " + fre, 10, 40);
}
