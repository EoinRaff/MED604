class Animator {

                              ///////////////////////////// 1. Phase of the grid ///////////////////////////////
  
  public void AnimationZ (int _boxW, int _boxH, int _boxD, int _boxS, int _i) {
    
    switch (activateAni){ ///////// #1 switch 
      case 0:
        if (dimCntrl) {
          translate(0, 0,_boxD);
        } else {
          translate(0, 0,_boxS); // Default setting
       }
       break;
      case 1:
        switch (animationType){ ///////// #2 switch 
         case 0:
            translate(0, lerp(_i, planeH,0.1) , lerp(_i, planeH,0.0) + 40 * sin(movement1 + sqrt(_i))); // Oct animation
            break;
            
         case 1:
            translate(sin(_i), sin(_i) , sin(movement1 + sqrt(_i))); // #2 Pulse animation
            break;
            
         case 2:
             translate(sin(movement1 + log(_i)), sin( movement1 + log(_i)) , sin(movement1 + sqrt(_i))); // #3 Portal animation 
             break;
             
         case 3:
             translate(lerp(_i, planeH,0.0) + 40 * sin(movement1 + sqrt(_i)), lerp(_i, planeH,0.0) + 40 * sin(movement1 + sqrt(_i)) , lerp(_i, planeH,0.0) + 40 * sin(movement1 + sqrt(_i))); // #4 Nova
             break;
         
           } ///////// #2 switch
      break;
    } ///////// #1 switch
      
   
    
    rotateX(animaZ_xRot);
    rotateY(animaZ_yRot);
    rotateZ(animaZ_zRot);
      
  }
  
                              ///////////////////////////// 2. Phase of the grid ///////////////////////////////
  
  public void AnimationY (int _boxW, int _boxH, int _boxD,int _boxS, int _i) {

    if (dimCntrl)
      translate(0,_boxH, 0);
     
      
  }
  
                               ///////////////////////////// 3. Phase of the grid ///////////////////////////////
  
  public void AnimationX (int _boxW, int _boxH, int _boxD,int _boxS, int _j, int _i) {
    
    
    switch (activateAni){ ///////// #1 switch
      case 0:
        if (dimCntrl) {
         translate(_boxW, 0, 0); 
        } else {
       translate(boxS, 0, 0); // Default setting
        }
        break;
      case 1:
       switch (animationType){ ///////// #2 switch 
         case 0:
            translate(boxS + 10 * sin(movement1 + sqrt(_j)),0, 40 * sin(movement1 + sqrt(_j))); // #1 Oct animation 
            break;
            
         case 1:
             translate(boxS + 10 * cos(movement1 + _j),0, 40 * cos(movement1 + _j)); // #2 Pulse animation 
            break;
            
         case 2:
             translate(sin(movement1 + log(_j)), sin( movement1 + log(_j)) , sin(movement1 + sqrt(_i+_j)));  // #2 Portal animation 
             break;
             
         case 3:
              translate( lerp(_j, planeH,0.1) + 40 * sin(movement1 + sqrt(_j + _i)), lerp(_j, planeH,0.1)+ 40 * sin(movement1 + sqrt(_j + _i)) , lerp(_j, planeH,0.0) + 40 * sin(movement1 + sqrt(_j + _i))); // #4 nova 
             break;
         
          } ///////// #2 switch 
       break;
    } ///////// #1 switch

    rotateX(animaX_xRot);
    rotateY(animaX_yRot);
    rotateZ(animaX_zRot);
      
  }
}
 