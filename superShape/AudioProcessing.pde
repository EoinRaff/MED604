/* This is a class for ALL the sound processing. 
 It got four methods, one for real-time amplitude, one for real-time frequency,
 one for amplitude over time and one for frequency over time */

class AudioProcessing { 

  Minim         minim;
  AudioInput    in;
  FFT           fft;

  FloatList amplitudes;       // Create a list of floats to store amplitudes
  FloatList frequencies;      // Create a list of floats to store frequencies
  FloatList freq_over_time;

  float scale = 5.0;          // Declare a scaling factor
  float smoothFactor = 0.25;  // Declare a smooth factor
  float sum;                  // Used for smoothing
  float meanamp;              // Deifne the mean variable of amplitude
  float meanfreq;             // Define the mean variable of frequency
  float ampThreshold = 0.7;

  int counter = 1;            // Used to keep count and restart the sampling of amplitudes
  int timeBetween = 5000;     // Decide the time between means
  int time = millis();        // Count time between means
  int time_amp = millis();

  int bufferSize = 420; //approx 7 seconds at 60 fps

  AudioProcessing() {         // Class constructor
    minim = new Minim(this);
    in = minim.getLineIn();
    fft = new FFT( in.bufferSize(), in.sampleRate() );
    amplitudes = new FloatList();

    frequencies = new FloatList();
    freq_over_time = new FloatList();
    for (int i = 0; i < bufferSize; i++) {
      amplitudes.append(random(0, 1));
      frequencies.append(random(0, 1));
      freq_over_time.append(random(0, 1));
    }
  }

  float rtAmplitude() {
    sum = (((in.left.level()+in.right.level())/2) - sum) * smoothFactor;
    return sum;
  }

  float meanAmplitude() {
    sum += (((in.left.level()+in.right.level())/2) - sum) * smoothFactor;   // Smooth the data by smoothing factor - in.left/right.level returns the current amplitude in that channel
    amplitudes.append(sum);                         // Add the current amplitude to the list                       // Get the elapsed time
    amplitudes.remove(0);
    return calcAverageAmp(amplitudes);            // Call the calcAverageAmp method to calculate the mean over the last X seconds
  }

  float rtFrequency() {
    fft.forward( in.mix );

    for (int i = 0; i < fft.specSize(); i++) {
      if ( fft.getBand(i) > ampThreshold ) {
        frequencies.append( int(fft.indexToFreq(i)) );
        frequencies.remove(0);
      }
    }
    return calcAverageFreq(frequencies);
  }

  float meanFrequency() {
    fft.forward( in.mix );
    for (int i = 0; i < fft.specSize(); i++) {
      if ( fft.getBand(i) > ampThreshold ) {
        frequencies.append( int(fft.indexToFreq(i)) );
        frequencies.remove(0);
      }
    }
    freq_over_time.remove(0);
    freq_over_time.append(calcAverageFreq(frequencies));

    return calcAverageFreq(freq_over_time);
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
    } else return 0;
  }

  void stop() {
    in.close();
    minim.stop();
  }
}