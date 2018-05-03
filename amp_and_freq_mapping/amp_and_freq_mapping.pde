import ddf.minim.analysis.*;  //Shoud be imported in the main script
import ddf.minim.*;           //Shoud be imported in the main script

AudioProcessing mySound;

int previousAmp;
int previousFre;

int frequency;
int amplitude;

void setup()  {    
  mySound = new AudioProcessing();  
  size(500, 500);
}    

void draw()  {
  background(255, 255, 255);
  float fre = mySound.meanFrequency();
  float amp = mySound.meanAmplitude();
  float rtamp = mySound.rtAmplitude();
  float rtfreq = mySound.rtFrequency();
  println("Amp: " + amp + " Freq: " + fre );
  
  float rtamped = rtamp * 100;
  float amped = amp * 100;
  float rtfre_mapped = map(rtfreq, 0, 5000, 0, width);
  float rtamp_mapped = map(rtamped, 0, 1, 0, height);
  float fre_mapped = map(fre, 0, 5000, 0, width);
  float amp_mapped = map(amped, 0, 1, 0, height);
  
  amplitude = int(amp_mapped);
  frequency = int(fre_mapped);
  
  fill(0, 0, 0);
  text("Amplitude: " + amplitude, 10, 20);
  text("Frequency: " + frequency, 10, 40);
  
  float a = amplitude + lerp(amp, amplitude, .5);
  float f = frequency + lerp(fre, frequency, .5);
  
  fill(255, 0, 0);
  ellipse(width/2, height/2, f, a);
  
}
