
/* This is a class for ALL the sound processing. 
 It got four methods, one for real-time amplitude, one for real-time frequency,
 one for amplitude over time and one for frequency over time */

class AudioProcessing { 
  
  Minim         minim;
  AudioInput    in;
  FFT           fft;
 
  FloatList amplitudes;       // Create a list of floats to store amplitudes
  FloatList frequencies;      // Create a list of floats to store frequencies 

  float scale = 5.0;          // Declare a scaling factor
  float smoothFactor = 0.25;  // Declare a smooth factor
  float sum;                  // Used for smoothing
  float meanamp;              // Deifne the mean variable of amplitude
  float meanfreq;             // Define the mean variable of frequency
  float ampThreshold = 0.3;

  int counter = 1;            // Used to keep count and restart the sampling of amplitudes
  int timeBetween = 5000;     // Decide the time between means
  int time = millis();        // Count time between means
  int time_amp = millis();

  AudioProcessing() {         // Class constructor
    minim = new Minim(this);
    in = minim.getLineIn();
    fft = new FFT( in.bufferSize(), in.sampleRate() );
    amplitudes = new FloatList();
    frequencies = new FloatList();
  }

  float rtAmplitude() {
    sum = (((in.left.level()+in.right.level())/2) - sum) * smoothFactor;
    return sum;
  }

  float meanAmplitude() {
    sum += (((in.left.level()+in.right.level())/2) - sum) * smoothFactor;   // Smooth the data by smoothing factor - in.left/right.level returns the current amplitude in that channel

    amplitudes.append(sum);                         // Add the current amplitude to the list                       // Get the elapsed time

    if (millis() > time_amp + timeBetween) {
      meanamp = calcAverageAmp(amplitudes);            // Call the calcAverageAmp method to calculate the mean over the last X seconds
      time_amp = millis();
      amplitudes.clear();                           // Clear the list to only get mean over the latest 5 seconds
    } 
    return meanamp;
  }

  float rtFrequency() {
    fft.forward( in.mix );
    
    for (int i = 0; i < fft.specSize(); i++) {

      if ( fft.getBand(i) > ampThreshold ) {
        frequencies.append( int(fft.indexToFreq(i)) );
      }
    }
    meanfreq = calcAverageFreq(frequencies);
    return meanfreq;
  }

  float meanFrequency() {
    fft.forward( in.mix );
    
    for (int i = 0; i < fft.specSize(); i++) {

      if ( fft.getBand(i) > ampThreshold ) {
        frequencies.append( int(fft.indexToFreq(i)) );
      }
    }

    if (millis() > time + timeBetween) {
      meanfreq = calcAverageFreq(frequencies);
      time = millis();
      frequencies.clear();
    }
    return meanfreq;
  }

  float calcAverageAmp(FloatList input) {        // Method to calculate the mean of the last 5 seconds of amplitudes
    float out = 0.0f;

    for (int i = 0; i < input.size(); i++) {
      out += input.get(i);                      // Get the sum of all the amplitudes
    }
    out = out/input.size();                     // calculate the mean
    return out;
  }


  float calcAverageFreq(FloatList input) {
    if (input.size() > 1) {
      float out = 0;
      for (int i = 0; i < input.size(); i++) {
        out += input.get(i);
      }
      out = out/input.size();
      return out;
    } 
    else return meanfreq;
  }
  
  void stop() {
  in.close();
  minim.stop();  
  }
  
}
