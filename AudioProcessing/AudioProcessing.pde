
/* This is a class for ALL the sound processing. 
 It got four methods, one for real-time amplitude, one for real-time frequency,
 one for amplitude over time and one for frequency over time */
  
class AudioProcessing { 

  import ddf.minim.analysis.*;  
  import ddf.minim.*;           

  public Minim         minim;
  public AudioInput    in;
  public FFT           fft;

  public FloatList amplitudes;       // Create a list of floats to store amplitudes
  public FloatList frequencies;      // Create a list of floats to store frequencies 

  float scale = 5.0;          // Declare a scaling factor
  float smoothFactor = 0.25;  // Declare a smooth factor
  float sum;                  // Used for smoothing
  float mean;                 // Deifne the mean variable 
  float ampThreshold = 0.3;

  int counter = 1;            // Used to keep count and restart the sampling of amplitudes
  int timeBetween = 5000;     // Decide the time between means
  int timeElapsed;            // Count time between means

  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT( in.bufferSize(), in.sampleRate() );
  amplitudes = new FloatList();
  frequencies = new FloatList();


  public float rtAmplitude()
  {
    sum = (((in.left.level()+in.right.level())/2) - sum) * smoothFactor;
    return sum;
  }

  public float meanAmplitude()
  {
    sum += (((in.left.level()+in.right.level())/2) - sum) * smoothFactor;   // Smooth the data by smoothing factor - in.left/right.level returns the current amplitude in that channel

    amplitudes.append(sum);                         // Add the current amplitude to the list

    timeElapsed = millis();                             // Get the elapsed time

    if (timeElapsed > counter*timeBetween)          // If X more seconds have passed calculate the mean
    {
      mean = calcAverageAmp(amplitudes);            // Call the calcAverageAmp method to calculate the mean over the last X seconds
      counter++;                                    // Add counter to start next X seconds
      amplitudes.clear();                           // Clear the list to only get mean over the latest 5 seconds
      return mean;
    }
  }

  public float rtFrequency()
  {
    fft.forward( in.mix );

    for (int i = 0; i < fft.specSize(); i++) {
      line( i, height, i, height - fft.getBand(i) * 8);

      if ( fft.getBand(i) > ampThreshold ) {
        frequencies.append( int(fft.indexToFreq(i)) );
      }
    }
    meanTotal = freqAverage(frequencies);
    return meanTotal;
  }

  public float meanFrequency()
  {
    fft.forward( in.mix );

    for (int i = 0; i < fft.specSize(); i++) {
      line( i, height, i, height - fft.getBand(i) * 8);

      if ( fft.getBand(i) > ampThreshold ) {
        frequencies.append( int(fft.indexToFreq(i)) );
      }
    }

    timeElapsed = millis();                             // Get the elapsed time

    if (timeElapsed > counter * timeBetween) {
      meanTotal = freqAverage(frequencies);
      counter++;
      frequencies.clear();
      return meanTotal;
    }
  }


  float calcAverageAmp(FloatList in)         // Method to calculate the mean of the last 5 seconds of amplitudes
  {
    float out = 0.0f;

    for (int i = 0; i < in.size(); i++)
    {
      out += in.get(i);                      // Get the sum of all the amplitudes
    }

    out = out/in.size();                     // calculate the mean

    return out;
  }


  float calcAverageFreq(FloatList in) 
  {
    float out = 0;

    if (in.size() > 1) 
    {
      float out = 0;

      for (int i = 0; i < in.size(); i++) 
      {
        out += in.get(i);
      }

      out = out/in.size();

      return out;
    } else 
    {
      return out;
    }
  }
}