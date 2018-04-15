import ddf.minim.analysis.*;
import ddf.minim.*;

Minim         minim;
AudioInput    in;
FFT           fft;

float ampThreshold = 0.3;

FloatList frequencies;
int time = millis();
int measureTime = 5000;
float meanTotal;

void setup()
{
  size(512, 200, P3D);
  
  minim = new Minim(this);
  
  in = minim.getLineIn();
  fft = new FFT( in.bufferSize(), in.sampleRate() );
  //fft.linAverages(11);
  
  frequencies = new FloatList();
}

void draw()
{
  background(0);
  stroke(255);
  
  fft.forward( in.mix );
  
  for(int i = 0; i < fft.specSize(); i++) {
    line( i, height, i, height - fft.getBand(i)*8 );
    
    if ( fft.getBand(i) > ampThreshold ) {
    frequencies.append( int(fft.indexToFreq(i)) );
    }
  }
  
  text("The average frequency over the last " + measureTime/1000 + " seconds, was " + meanTotal + " Hz", 70, height/2);

  if( millis() > time + measureTime ) {
    meanTotal = freqAverage(frequencies);
    for(int i = 0; i < frequencies.size(); i++) {
      println( "Amp: " + ampThreshold + " Band: " + fft.freqToIndex(frequencies.get(i)) + " Freq: " + frequencies.get(i) + " Mean: " + meanTotal );
    }
    time = millis();
    frequencies.clear();
  }

}

float freqAverage(FloatList freqz) {
  if (freqz.size() > 1) {
  float mean = 0;
  for (int i = 0; i < freqz.size(); i++) {
    mean += freqz.get(i);
  }
  mean = mean/freqz.size();
  return mean;
  }
  else return meanTotal;
}

void keyPressed()
{
  if ( key == 'm' || key == 'M' ) {
    if ( in.isMonitoring() ) {
      in.disableMonitoring();
    }
    else {
      in.enableMonitoring();
    }
  }
}

void stop() {
  in.close();
  minim.stop();  
  super.stop();
}
