// Lib importing 
import peasy.*; // Cam
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import controlP5.*; // GUI

ControlP5 cp5;
PeasyCam cam;

// GUI 
  GUISetup GUI;

// Geometric shaope Generator
   gridGen cubeGrid;


// GUI Variables:
  int v1; // Buttons
  int oct; // Sliders

// Geometric Variables:
  int planeW, planeH;
  int GlobalXpos,GlobalYpos;
  int boxXRotation,boxYRotation,boxZRotation;
  int animaZ_zRot;
  int stroke;
  boolean noStro;
  int buttonColSelct;
  int boxS, boxH, boxW, boxD;
  boolean dimCntrl;
  float movement,movement1,movement2;
  int amp;
  

// Camera Variables:
  int camOffset;
  float fov, camZ;

  int no2Con = 0;
// Don´t know if I use these  //
  Cube [][] tileGrid;
  Cube testCube;


void setup () {
  size (920, 560, P3D); // Demension of the LED screen in the light lab (width: 920, Height 560. )
  
  //colorMode(HSB, 100);

  fov = PI / 3; // Default val for perspective ()
  camZ = (height / 2.0) / tan(fov / 2.0); // Default val for perspective ()
  
 //cp5 = new ControlP5(this);
//  cp5.addButton("button", 10, 0, 0, 80, 20).setId(1);
//  cp5.addButton("buttonValue", 4, 100, 90, 80, 20).setId(2);
//  cp5.addSlider("slider")
 //    .setPosition(100,305)
 //    .setSize(200,20)
  //   .setRange(0,360)
   //  .setValue(128)
    // ;
  //cp5.setAutoDraw(false);
  
  
  

  camOffset = 150;
  
  movement = 0;
  movement1 = 0;
  movement2 = 0;
  
  amp = 255;
  
  boxH = 100;
  
  tileGrid = new Cube [planeH][planeW];
  
  for (int i = 0; i < planeH; i++) {
    for (int j = 0; j < planeW; j++ ) {
      
        tileGrid [i][j]  = new Cube (i,j, createShape(BOX,boxS));
      
    }
  } 
  
  cam = new PeasyCam(this, 600);
  
  GUI = new GUISetup();
  GUI.GUIContent (new ControlP5(this), "grid_hidth","grid_height", "dot_Pitch","box_XRotation","box_YRotation",
    "box_ZRotation","box_Stroke", "box_Width","box_Height","box_Dimension", "animationZ_zRotation");
  
  cubeGrid = new gridGen();
  
  
 
}

void draw ()  {
  //print(v1);
  
  background(70);
  movement -= 0.1;
  movement1 -= 0.15;
  movement2 -= 0.17;
  
  
  
  
    // Camera setup
 // camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0); //(eyeX,eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ) 
  //perspective(fov, width/height, camZ/10.0, camZ * 10.0); // (fovy, aspect, near clip, far clip)

  //translate(0, 0, 0); // Default Settig
  
 
  //GenGrid () ;
//  gui();

  cubeGrid.cubeShader();
  GUI.gui();
  
  
  
}
  /*
  public void GenGrid () {
  
    for (int i = 1; i < planeH; i++) {
    
    //translate(0,0, boxS); // Default Settig
    translate(0, lerp(i, planeH,0.1) , lerp(i, planeH,0.0) + 40 * sin(movement1 + sqrt(i)));
    //rotateX(oct); // Octapus
    
    pushMatrix(); /////////////// #1: To insure the nex section in the row is not affected by the prevous (This enables the grid)
    //rotateX(10);
    //rotateY(10);
    for (int j = 1; j < planeW; j++) {
      fill(150 + 100 * sin(movement + sqrt(i)),150 + 100 * sin(movement1 + sqrt(j)), 150 + 100 * sin(movement2 + sqrt(i+j))); // Hue spin
      //fill(200 * sin(movement + (sqrt(i))),100,200); // Driving down the avn
      // fill(200 * sin(movement + (log(i))),100,200); // Driving down the avn (Better)
      //fill(100 + 200 * sin(movement - (sqrt(j))), 100 + 100 * sin(movement - ( sqrt(i))),150 + 100 * sin(movement - (sqrt(j*i)))); // Chaos
      
      
      //translate(boxS, 0, 0); // Default setting
      translate(boxS + 10 * sin(movement1 + sqrt(j)),0, 40 * sin(movement1 + sqrt(j)));
      
      box(boxS);
    }
    
    popMatrix(); /////////////// #1: 
   
  }
}
*/




//void button(float theValue) {
    //oct += theValue;
 //   println("a button event. "+theValue);
  //}
  
  //void controlEvent(ControlEvent theEvent) {
   // println(theEvent.getController().getId());
  //}

  void grid_hidth(float _w) {
    planeW = int(_w);
  }
  
  void grid_height(float _h) {
    planeH = int(_h);
  }
  
  // Box cosmetics
  
  void dot_Pitch(float _s) {
    boxS = int(_s);
  }
  
  void box_XRotation(float _deg) {
    boxXRotation = int(_deg);
  }
  
  void box_YRotation(float _deg) {
    boxYRotation = int(_deg);
  }
  
  void box_ZRotation(float _deg) {
    boxXRotation = int(_deg);
  }
  
  void box_Stroke(float _col) {
    if (_col != 0) {
      noStro = false;
      stroke = int(_col);
    } else {
      noStro = true;
    }
  }
  
  void box_Width(float _w) {
   
      boxW = int(_w);
    
  }
  
  void box_Height(float _h) {
    
      boxH = int(_h);
  }
  
  void box_Dimension(float _D) {
 
      boxD = int(_D);
  }
  
  void checkBox(float[] a) {
    if (a[0] == 1) {

      dimCntrl = true;
    }
     else {
      dimCntrl = false;
     }
     
}

//void _colorFill(float[] a) {
  //println(GUI.checkbox.getItem()[0]);
  //println(a);
  //}
  
  
  // Color selection Buttons
    void midnight_Drive (int theValue) {
      buttonColSelct = theValue; 
    
    }
  
    void hue_Flow (int theValue) {
      buttonColSelct = theValue; 
    
    }
  
     void uniform (int theValue) {
      buttonColSelct = theValue; 
    
    }
  
  
  void animationZ_zRotation (float _deg) {
      animaZ_zRot = int(_deg);
    }
  
  


/*

void colorFill(float[] a) {
  
  
  println(a);
}

  public color colorFill (String _selct, int _xPos, int _yPos) {
      color col = color (0,0,0);
    
      switch (_selct) {
      
        case "UniformColor":
          col = color (200,13,42);
          break;
     
        case "HueFlow" :
          col = color (150 + 100 * sin(movement + sqrt(_xPos)),150 + 100 * sin(movement1 + sqrt(_yPos)), 150 + 100 * sin(movement2 + sqrt(_xPos+_yPos)));
          break;
      
        case "MidnightDrive" :
          col = color (200 * sin(movement + (log(_yPos))),100,200); // Driving down the avn (Better)
          break;
        
        default: 
          col = color (255,0,255);
          break;
      } 
    
   
      return col;
    
  }
  */


 



//void gui() {
//  hint(DISABLE_DEPTH_TEST);
//  cam.beginHUD();
//  cp5.draw();
//  cam.endHUD();
//  hint(ENABLE_DEPTH_TEST);
//}

//void button(float theValue) {
 // oct += theValue;
  //println("a button event. "+theValue);
//}

//void controlEvent(ControlEvent theEvent) {
  //println(theEvent.getController().getId());
//}

//void slider(float theColor) {
 // oct = color(theColor);
 // println("a slider event. setting background to "+theColor);
//}


 /*
  for (int i = 0; i < planeH; i++) {
    //translate(0,amp * sin(movement + i), boxS); // Generate wave
    translate(0,0, boxS);
    
    // Color shadow 
    float clapColor = map (200 * sin(movement + i), -200, 200, 150, 255);
    fill (clapColor,clapColor, 0);
     
     //println("y: " + noiseCoordY [int (map(i,0,planeH,0,10))]);
     
    pushMatrix();
    for (int j = 0; j < planeW; j++ ) {
      //println("x: " + noiseCoordX [int (map(j,0,planeW,0,10))]);
      translate(boxS, 0 , 0 );
      
      //println(noiseCoordX [int (map(j,0,planeW,0,10))]);
    
          //println("Inside x: " + noiseCoordX [int (map(j,0,planeW,0,10))]);
          //println("Inside y: " + noiseCoordY [int (map(i,0,planeH,0,10))]);
        
          //translate(0, map(noise(i ,j), 0 , 1, -boxH, boxH + 10), 0 );
          box(boxS, boxH, boxS);
        
 
        box(boxS);
      }
      popMatrix();
      
  
      
      //translate (0, i * 10, -100);
      //stroke(255);
      //noFill();
     // box (boxSize);
     
     
    }
    */
    
  