class Animator{
  /*
  The Animator should recieve input from AudioProcessing.
  It should use this input as paramaters for various animation types.
  the animate function should return a color (rgba or HSI) based on a x-y screen coordinate
  */
  float mov;
  
  public color Animate(float mov, int x, int y){
    color c;
    
    //switch case?
    //Hue Animation
    float r = 150+100*sin(mov + sqrt(x));
    float g = 150+100*sin(mov + sqrt(y));
    float b = 150+100*sin(mov + sqrt(x+y));
    c = color(r, g, b);
    return c;
  }
  
  public void getInputFromAudio(){
    
  }
  

}