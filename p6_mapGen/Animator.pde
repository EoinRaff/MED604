class Animator {
  /*
  public PVector AnimationZ (int _select, int _xPos, int _yPos, int _zPos) {
    PVector transformation = new PVector(_xPos, _yPos, _zPos);
    PVector octopus = new PVector(_xPos, _yPos, _zPos);
  
      switch (_select) {
        case (0) :
          transformation = new PVector(_xPos, _yPos, _zPos);
         case (1) :
          transformation = 
      }
      
      
      return transformation;
  }
  
  public PVector AnimationX (int _select, int _xPos, int _yPos, int _zPos) {
    PVector transformation = new PVector(_xPos, _yPos, _zPos);
    PVector octopus = new PVector(_xPos, _yPos, _zPos);
  
      switch (_select) {
        case (0) :
        return transformation;
  
      }
      return transformation;
  }
  
  */
  
  
  public void AnimationZ (int _boxW, int _boxH, int _boxD, int _boxS, int _i) {
    
    /*
    if (dimCntrl) {
      translate(0, 0,_boxD);
    } else {
      translate(0, 0,_boxS); // Default setting
    }
    */
    
    translate(0, lerp(_i, planeH,0.1) , lerp(_i, planeH,0.0) + 40 * sin(movement1 + sqrt(_i)));
    
    rotateX(animaZ_zRot);
    rotateY(0);
    rotateZ(0);
    
    
      
      
  }
  
  public void AnimationY (int _boxW, int _boxH, int _boxD,int _boxS) {

    if (dimCntrl)
      translate(0,_boxH, 0);
      
  }
  
  public void AnimationX (int _boxW, int _boxH, int _boxD,int _boxS, int _j) {


    if (dimCntrl)
       translate(_boxW, 0, 0); 
    else
       translate(boxS, 0, 0); // Default setting
       
       
    translate(boxS + 10 * sin(movement1 + sqrt(_j)),0, 40 * sin(movement1 + sqrt(_j)));
    
    rotateX(0);
    rotateY(0);
    rotateZ(0);
      
  }
}
 