static class SoundProcessing {
  static public Amplitude rms; // Define the root mean square of the amplitude 
  static public AudioIn in; // Define the input
  
  static public FloatList amplitudes;       // Create a list of floats to store amplitudes

  static public float scale = 5.0;          // Declare a scaling factor
  static public float smoothFactor = 0.25;  // Declare a smooth factor
  static public float sum;                  // Used for smoothing
  static public float mean;                 // Deifne the mean variable 

  static public int counter = 1;            // Used to keep count and restart the sampling of amplitudes
  static public int timeBetween = 5000;     // Decide the time between means
  static public int timeElapsed;      
  
  
  
 public static float meanCalcAmp () {
   
   if (timeElapsed > counter*timeBetween)        // If 5 more seconds have passed calculate the mean
   {
    mean = calcAverageAmp(amplitudes);          // Call the calcAverageAmp method to calculate the mean over the last 5 seconds
    println(mean);                                    // Print the mean
    counter++;                                        // Add counter to start next 5 seconds
    amplitudes.clear();                               // Clear the list to only get mean over the latest 5 seconds
    }
    return mean;
    
  }
}
  
static float calcAverageAmp(FloatList in)         // Method to calculate the mean of the last 5 seconds of amplitudes
{
  float out = 0.0f;
  
  for (int i = 0; i < in.size(); i++)
  {
    out += in.get(i);                      // Get the sum of all the amplitudes       
  }
  
  out = out/in.size();                     // calculate the mean
  
  return out;
}
  
  