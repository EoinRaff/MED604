class Animator {
  /*
  The Animator should recieve input from AudioProcessing.
   It should use this input as paramaters for various animation types.
   the animate function should return a color (rgba or HSI) based on a x-y screen coordinate
   */
  float mov;
  float amp;
  float rows, cols; 
  float r, g, b, a; 
  float hue, saturation, brightness;
  float baseColorModifier;
  AudioProcessing AP;

  public Animator(float cols, float rows, AudioProcessing AP)
  {
    this.rows = rows;
    this.cols = cols;
    this.AP = AP;
  }

  public color Animate(String animationType, int x, int y) {
    color c;
    switch(animationType) {
    case "Hue Flow":
      c= HueFlow(x, y);
      break;
    case "Natural":
      c = Natural(x, y);
      break;
    case "Test":
      c = Test(x, y);
      break;
    default:
      c = 0;
      break;
    }

    return c;
  }

  public void UpdateVariables() {
    mov += amp_m;
    amp_m = AP.meanAmplitude();
    amp_rt = AP.rtAmplitude();

    frq_m = AP.meanFrequency();
    frq_rt = AP.rtFrequency();
    
    //baseColorModifier = map(amp_rt, 0, 0.1, 20, 250); 
    baseColorModifier = map(frq_m, 40, 10000, 50, 200);
    println("FRQ = " + frq_m + "\tAMP = " + amp_m + "\tHue = " + baseColorModifier);
     
  }

  color HueFlow(float x, float y) {
    r = 150+100*sin(mov + sqrt(x));
    g = 150+100*sin(mov + sqrt(y));
    b = 150+100*sin(mov + sqrt(x+y));
    return color(r, g, b);
  }
  color Natural(float x, float y) {
    colorMode(HSB);
    hue = baseColorModifier;// + (30 * sin(mov));
    saturation = 125 + 75 * sin(x*mov);// * cos(x*y));
    brightness = 255;
    return color(hue, saturation, brightness);
  }
  color Urban(float x, float y) {
    return color(0);
  }
  color Test(float x, float y) {
    return color(((x*amp_m) + (y*amp_rt))%255);
  }
}