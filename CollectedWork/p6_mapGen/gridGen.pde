class gridGen {
  
  Animator Animation = new Animator();
 
  
  public void cubeShader () {
    
    if (!noStro) {
      stroke (stroke);
    } else {
      noStroke();
    }
    
    /////// Placing the the Geometric a center possition ///////
    translate(-planeW * boxD,-planeH * boxD );
    
    for (int i = 1; i < planeD; i++) { /////////////// #1 Phase
    
       Animation.AnimationZ(boxW,boxH,boxD,boxS,i); 
      
      pushMatrix(); 
      
      Animation.AnimationY (boxW,boxH,boxD,boxS,i);
      
      for (int j = 1; j < planeW; j++) { /////////////// #2 Phase:  
       
        Animation.AnimationX(boxW,boxH,boxD,boxS,j,i);
        fill(colorFill (buttonColSelct,j,i));

        
        
        pushMatrix();
          for (int q = 0; q < planeH; q++) { /////////////// # 3 Phase: Stacking blocks
          
            translate (0,boxD+boxD,0);
            
            pushMatrix(); //// Rows

              pushMatrix(); // Local space
               rotateX(boxXRotation);
               rotateY(boxYRotation);
               rotateZ(boxZRotation);

                if (ellipseSelect == 1) {
                   sphere(boxD);
                } else {
                   box(boxW,boxH,boxD);
                }
            
              popMatrix(); 
            
            popMatrix(); 
            
          }
          
        popMatrix(); 
  
      }
      popMatrix(); 
    }
    
  }
  
  
color colorFill (int _select, int _xPos, int _yPos) {
    color col = color (0,0,0);
    
    switch (_select) {
      // Uniform Color 
      case 0 :
        col = uniformCol;
        break;
        
     // HueFlow
      case 1 :
        col = color (150 + 100 * sin(movement + sqrt(_xPos)),150 + 100 * sin(movement1 + sqrt(_yPos)), 150 + 100 * sin(movement2 + sqrt(_xPos+_yPos)));
        break;
        
      // MidnightDrive
      case 2 :
        col = color (200 * sin(movement + (log(_yPos))),100,200);
        break;
        
      case 3 :
        col = color (lerp(_xPos + _yPos , gradientR / planeH * planeW, powR), lerp(_xPos + _yPos , gradientG / planeH * planeW, powG), lerp(_xPos + _yPos , gradientB / planeH * planeW, powB));
        break;
        
      default: 
        col = uniformCol;
        
        break;
    } 
    return col;
    
  } 
}


        