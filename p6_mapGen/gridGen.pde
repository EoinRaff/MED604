class gridGen {
  
  Animator Animation = new Animator();
  PVector zTransformation = new PVector(0,0,0);
  PVector xTransformation = new PVector(0,0,0);
  
  public void cubeShader () {
    
    
    
    
    if (!noStro) {
      stroke (stroke);
    } else {
      noStroke();
    }
    for (int i = 1; i < planeH; i++) {
      GlobalYpos = i;
      
      //zTransformation = Animation.AnimationZ(0,0,0,boxS);
      
      //if (dimCntrl)
       // translate(0,0, boxD); // Default Settig
      //else 
       //translate(0,0, boxS);
       
       Animation.AnimationZ(boxW,boxH,boxD,boxS,i);
       
       //translate (zTransformation.x,zTransformation.y,zTransformation.z);
       
      //translate(0, lerp(i, planeH,0.1) , lerp(i, planeH,0.0) + 40 * sin(movement1 + sqrt(i)));
      //rotateX(90); // Octapus
      //rotateY(180); 
    
      pushMatrix(); /////////////// #1: To insure the nex section in the row is not affected by the prevous (This enables the grid)
      //if (dimCntrl)
         //translate(0,boxH, 0);
      //rotateX(10);
      //rotateY(10);
      
      Animation.AnimationY (boxW,boxH,boxD,boxS);
      
      for (int j = 1; j < planeW; j++) {
        GlobalXpos = j;
        
        //xTransformation = Animation.AnimationX(0,boxS,0,0);
        
        
        Animation.AnimationX(boxW,boxH,boxD,boxS,j);
        fill(colorFill (buttonColSelct,j,i));
        
        //if (dimCntrl)
        //translate(boxW, 0, 0); // Default setting
        //else
        //translate(boxS, 0, 0);
        
         //translate (xTransformation.x,xTransformation.y,xTransformation.z);
        
        //translate(boxS + 10 * sin(movement1 + sqrt(j)),0, 40 * sin(movement1 + sqrt(j)));
        
        pushMatrix(); ////// #3 Local space rotation
        rotateX(boxXRotation);
        rotateY(boxYRotation);
        rotateZ(boxZRotation);
        box(boxW,boxH,boxD);
        popMatrix(); ////// #3 
        
        
      }
    
      popMatrix(); /////////////// #1: 
   
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
        col = color (200 * sin(movement + (log(_ypos))),100,200); // Driving down the avn (Better)
        break;
        
      default: 
        col = color (255,0,255);
        break;
    } 
    return col;
    
  } 
}




// Trash (Keep for to be safe)

//fill(150 + 100 * sin(movement + sqrt(i)),150 + 100 * sin(movement1 + sqrt(j)), 150 + 100 * sin(movement2 + sqrt(i+j))); // Hue spin
        //fill(200 * sin(movement + (sqrt(i))),100,200); // Driving down the avn
         //fill(200 * sin(movement + (log(i))),100,200); // Driving down the avn (Better)
        //fill(100 + 200 * sin(movement - (sqrt(j))), 100 + 100 * sin(movement - ( sqrt(i))),150 + 100 * sin(movement - (sqrt(j*i)))); // Chaos
        