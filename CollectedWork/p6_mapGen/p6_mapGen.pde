// Lib importing 
import peasy.*; // Cam
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import controlP5.*; // GUI

import processing.sound.*;

ControlP5 cp5;
PeasyCam cam;


// GUI 
  GUISetup GUI;

// Geometric shaope Generator
   gridGen cubeGrid;
   

// Geometric Variables:
  int planeW, planeD, planeH;
  int boxXRotation,boxYRotation,boxZRotation;
  float animaZ_zRot, animaZ_xRot, animaZ_yRot,animaX_xRot,animaX_yRot,animaX_zRot;
  int stroke;
  boolean noStro;
  int ellipseSelect;
  int buttonColSelct;
  int boxS, boxH, boxW, boxD;
  boolean dimCntrl;
  float movement,movement1,movement2;
  
  float gradientR,gradientG,gradientB;
  float powR,powG,powB;
  
  int animationType, activateAni;
  
  color uniformCol;
  
// Camera Variables:
  int camOffset;
  float fov, camZ;
  
// Sound Processing 
  float mean;
  float rmsScaled;

void setup () {
  size (920, 560, P3D); // Demension of the LED screen in the light lab (width: 920, Height 560. )
  //size (1420, 900, P3D);
   
  frameRate(60);
  
  //colorMode(HSB, 100);

  ///////// Camera Setup /////////
    cam = new PeasyCam(this, 700);
    cam.setYawRotationMode();
    cam.setActive(false); // Deactivate the mouse interaction
  
   movement = 0;
   movement1 = 0;
   movement2 = 0;
  
  ///////// GUI Setup /////////
    GUI = new GUISetup();
    GUI.GUIContent (new ControlP5(this), "grid_hidth","grid_height", "dot_Pitch","box_XRotation","box_YRotation",
    "box_ZRotation","stroke_", "box_Width","box_Height","box_Dimension", "animationZ_zRotation");
  
  ///////// Cube Grid /////////
    cubeGrid = new gridGen();
  
  ///////// Sound Processing /////////
    SoundProcessing.amplitudes = new FloatList();
    SoundProcessing.in = new AudioIn(this, 0); // Create the Input stream
    SoundProcessing.in.play();
    
    SoundProcessing.rms = new Amplitude(this); // Create and patch the rms tracker
    SoundProcessing.rms.input(SoundProcessing.in);
  
}

void draw ()  {
  
  background(50);
  // println(frameRate);

  // Transfer function attributes
  movement -= 0.1;
  movement1 -= 0.15;
  movement2 -= 0.17;
  
  /////// SoundProcessing /////// Thomas part working
  
    SoundProcessing.sum += (SoundProcessing.rms.analyze() - SoundProcessing.sum) * SoundProcessing.smoothFactor;   // Smooth the rms data by smoothing factor - rms.analyze returns the current amplitude
 
    // rms.analyze() return a value between 0 and 1. It's
    // scaled to height/2 and then multiplied by a scale factor
    rmsScaled = SoundProcessing.sum * (height/2) * SoundProcessing.scale;
  
    SoundProcessing.amplitudes.append(rmsScaled);  // Add the current amplitude to the list
  
    SoundProcessing.timeElapsed = millis();  // Get the elapsed time
    mean = SoundProcessing.meanCalcAmp ();
  
   
  /////// Instantiating elements ///////
    cubeGrid.cubeShader();
    GUI.gui();
    

}
  
                              ///////////////////////////// GUI Functions ///////////////////////////////
                              
  void grid_width(float _w) {
    planeW = int(_w);
  }
  
  void grid_dimension(float _h) {
    planeD = int(_h);
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
  
  void stroke_(float _col) {
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

  void ellipse (float select) {
        ellipseSelect = int(select);
      }
    
  void box (float select) {
        ellipseSelect = int(select);
      }
  
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
    
    void gradient (int theValue) {
      buttonColSelct = theValue; 
    
    }
    
    void gradientR_level (float _deg) {
      gradientR = _deg;
   }
     void gradientR_pow (float _deg) {
      powR = _deg;
   }
   
   void gradientG_level (float _deg) {
      gradientG = _deg;
   }
     void gradientG_pow (float _deg) {
      powG = _deg;
   }
   
   void gradientB_level (float _deg) {
      gradientB = _deg;
   }
     void gradientB_pow (float _deg) {
      powB = _deg;
   }    
   ///////
  
  // Animation Rotation   
  void animationZ_xRotation (float _deg) {
      animaZ_xRot = int(_deg);
   }
   
   void animationZ_yRotation (float _deg) {
      animaZ_yRot = int(_deg);
   }
   
    void animationZ_zRotation (float _deg) {
      animaZ_zRot = int(_deg);
    }
   
   
   void animationX_xRotation (float _deg) {
      animaX_xRot = int(_deg);
    }
    
  void animationX_yRotation (float _deg) {
      animaX_xRot = int(_deg);
   }
   
   void animationX_zRotation (float _deg) {
      animaX_zRot = int(_deg);
   }
   
   ///////
  
  
  // Animation Activators
  void deactivate (int theValue) {
      activateAni = theValue;
    
    }
    
    void activate (int theValue) {
      activateAni = theValue;
    
    }
    
    //////
    
    // Animation selectors
    
    void octopus (int theValue) {
      animationType = theValue; 
    
    }
    
    void portal (int theValue) {
      animationType = theValue; 
    
    }
    
    void pulse (int theValue) {
      animationType = theValue; 
    
    }
    
    void nova (int theValue) {
      animationType = theValue; 
    
    }
    
    //////
    
    
    
    