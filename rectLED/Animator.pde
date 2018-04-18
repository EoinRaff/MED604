class Animator {
  /*
  The Animator should recieve input from AudioProcessing.
   It should use this input as paramaters for various animation types.
   the animate function should return a color (rgba or HSI) based on a x-y screen coordinate
   */
  float mov;

  public color Animate(String animationType, int x, int y) {
    color c;
    switch(animationType) {
    case "Hue Flow":
      c= HueFlow(x, y);
      break;
    default:
      c = 0;
      break;
    }

    return c;
  }

  public void UpdateParameters(float mov) {
    this.mov = mov;
  }

  color HueFlow(float x, float y) {
    float r = 150+100*sin(mov + sqrt(x));
    float g = 150+100*sin(mov + sqrt(y));
    float b = 150+100*sin(mov + sqrt(x+y));
    return color(r, g, b);
  }
}