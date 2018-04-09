class gridGen {
  
  Animator Animation = new Animator();
 
  
  public void cubeShader () {
    
    if (!noStro) {
      stroke (stroke);
    } else {
      noStroke();
    }
    
    for (int i = 1; i < planeH; i++) {
    
       Animation.AnimationZ(boxW,boxH,boxD,boxS,i); /////////////// #1 Phase
       
      pushMatrix(); /////////////// #2 Phase: To insure the nex section in the row is not affected by the prevous (This enables the grid)
      
      Animation.AnimationY (boxW,boxH,boxD,boxS);
      
      for (int j = 1; j < planeW; j++) { /////////////// #3 Phase:     
        Animation.AnimationX(boxW,boxH,boxD,boxS,j);
        fill(colorFill (buttonColSelct,j,i));

        pushMatrix(); //// Local space rotation
        
        rotateX(boxXRotation);
        rotateY(boxYRotation);
        rotateZ(boxZRotation);
        
        if (ellipseSelect == 1) {
            sphere(boxD);
        } else {
            box(boxW,boxH,boxD);
        }
        
        popMatrix(); 
      }
      popMatrix(); 
    }
  }
  
color colorFill (int _select, int _xPos, int _ypos) {
    color col = color (0,0,0);
    
    switch (_select) {
      // Uniform Color 
      case 0 :
        col = color (200,13,42);
        break;
        
     // HueFlow
      case 1 :
        col = color (150 + 100 * sin(movement + sqrt(_xPos)),150 + 100 * sin(movement1 + sqrt(_ypos)), 150 + 100 * sin(movement2 + sqrt(_xPos+_ypos)));
        break;
        
      // MidnightDrive
      case 2 :
        col = color (200 * sin(movement + (log(_ypos))),100,200);
        break;
        
      default: 
        col = color (255,0,255);
        break;
    } 
    return col;
    
  } 
}


        