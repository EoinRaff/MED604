/* This Sketch measures the amplitude of the input from the mic and calculates the mean every X seconds */

import ddf.minim.*;

Minim         minim;
AudioInput    in;

FloatList amplitudes;       // Create a list of floats to store amplitudes

float scale = 5.0;          // Declare a scaling factor
float smoothFactor = 0.25;  // Declare a smooth factor
float sum;                  // Used for smoothing
float mean;                 // Deifne the mean variable 

int counter = 1;            // Used to keep count and restart the sampling of amplitudes
int timeBetween = 5000;     // Decide the time between means
int timeElapsed;            // Count time between means

void setup() 
{
  size(800, 800);
  
  amplitudes = new FloatList();

  minim = new Minim(this);
  in = minim.getLineIn();
}      

void draw() 
{
  background(255, 0, 0);
  noStroke();
  fill(0, 0, 200);

  sum += (in.left.level() - sum) * smoothFactor;   // Smooth the rms data by smoothing factor - rms.analyze returns the current amplitude

  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a scale factor
  float rmsScaled = sum * (height/2) * scale;
 
  amplitudes.append(rmsScaled);                       // Add the current amplitude to the list
  
  ellipse(width/2, height/2, rmsScaled, rmsScaled);   // Draw an ellipse based on the current amplitude

  timeElapsed = millis();                             // Get the elapsed time
  
  if (timeElapsed > counter*timeBetween)              // If 5 more seconds have passed calculate the mean
  {
    mean = calcAverageAmp(amplitudes);          // Call the calcAverageAmp method to calculate the mean over the last 5 seconds
    println(mean);                                    // Print the mean
    counter++;                                        // Add counter to start next 5 seconds
    amplitudes.clear();                               // Clear the list to only get mean over the latest 5 seconds
  }
  rect(20, 20, mean*10, mean*10);                     // Draw a rect showing the last mean
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