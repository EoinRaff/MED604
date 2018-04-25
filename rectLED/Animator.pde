class Animator {
  /*
  The Animator should recieve input from AudioProcessing.
   It should use this input as paramaters for various animation types.
   the animate function should return a color (rgba or HSI) based on a x-y screen coordinate
   */
  float mov;
  float amp;
  float r, g, b, a, h, s, i;
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

  public void UpdateParameters(float mov, float amp) {
    this.mov = mov;
    this.amp = amp;
  }

  color HueFlow(float x, float y) {
    r = 150+100*sin(mov + sqrt(x));
    g = 150+100*sin(mov + sqrt(y));
    b = 150+100*sin(mov + sqrt(x+y));
    return color(r, g, b);
  }
  color Natural(float x, float y) {
    colorMode(HSB);
    h = 70 + (30 * sin(mov));
    println(sin(mov));
    s = 125 + 75 * sin(mov * cos(x*y));
    i = 255;
    return color(h, s, i);
  }
  color Urban(float x, float y){
    return color(0);
  }
  color Test(float x, float y){
    return color((x+y)%255);
  }
}