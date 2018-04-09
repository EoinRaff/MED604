class GUISetup {
  // GUI Lib
    Accordion accordion;
    CheckBox ratioCol;

                         ///////////////////////////// Connecting functions /////////////////////////////
  
  void GUIContent (ControlP5 GUICanvas, String _sliderGridW, String _sliderGridH, String _boxSize, 
    String _boxRotX, String _boxRotY,String _boxRotZ, String _Stroke, String _boxW,String _boxH, String _boxD,
    String animationZ_zRotation) {
      
    cp5 = GUICanvas;
    
                               ///////////////////////////// Tap colors /////////////////////////////
                        
    color boxRotationColor = color(255, 204, 0);
    color boxSizeColor = color(255, 0, 204);
    color boxStrokeColor = color(255, 0, 0);
    color boxDimColor = color(0, 250, 0);
    
                        ///////////////////////////// Initializing the dropdowns /////////////////////////////
    
    Group g1 = cp5.addGroup("Grid Specifications:")
                .setBackgroundColor(color(0, 64))
                .setBackgroundHeight(300)
                ;
                
    Group g2 = cp5.addGroup("Pixel Design:")
                .setBackgroundColor(color(0, 64))
                .setBackgroundHeight(150)
                ;

    Group g3 = cp5.addGroup("Animation: ")
                .setBackgroundColor(color(0, 64))
                .setBackgroundHeight(150)
                ;                

                           ///////////////////////////// Group 1: Grid Specification /////////////////////////////
      ///// Grid 
       cp5.addSlider(_sliderGridW)
         .setPosition(10,10)
         .setSize(200,20)
         .setRange(1,100)
         .setValue(10)
         .moveTo(g1)
       ;
       
       cp5.addSlider(_sliderGridH)
         .setPosition(10,30)
         .setSize(200,20)
         .setRange(1,100)
         .setValue(10)
         .moveTo(g1)
       ;
       
       /////
       
       // Box Size 
       cp5.addSlider(_boxSize)
         .setPosition(10,70)
         .setSize(200,20)
         .setRange(1,500)
         .setValue(30)
         .setColorActive(boxSizeColor)
         .setColorForeground(boxSizeColor)
         .moveTo(g1)
       ;
       
       /////
       
       // Box Size 
       cp5.addSlider(_boxRotX)
         .setPosition(10,100)
         .setSize(200,20)
         .setRange(0,360)
         .setValue(0)
         .setColorActive(boxRotationColor) 
         .setColorForeground(boxRotationColor)
         .moveTo(g1)
       ;
     
       cp5.addSlider(_boxRotY)
         .setPosition(10,120)
         .setSize(200,20)
         .setRange(0,360)
         .setValue(0)
         .setColorActive(boxRotationColor)
         .setColorForeground(boxRotationColor)
         .moveTo(g1)
       ;
     
       cp5.addSlider(_boxRotZ)
         .setPosition(10,140)
         .setSize(200,20)
         .setRange(0,360)
         .setValue(0)
         .setColorActive(boxRotationColor)
         .setColorForeground(boxRotationColor)
         .moveTo(g1)
       ;
       
       /////
       
       
       // Dimension control
       cp5.addCheckBox("checkBox")
         .setPosition(10, 170)
         .setColorForeground(color(120))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setSize(20, 20)
         .setItemsPerRow(3)
         .setSpacingColumn(30)
         .setSpacingRow(20)
         .addItem("Dimension Control (Disables Pitch Off)", 0)
         .moveTo(g1)
       ;
       
       // Specific Box Dimension
       cp5.addSlider(_boxW)
         .setPosition(10,200)
         .setSize(200,20)
         .setRange(0,500)
         .setValue(10)
         .setColorActive(boxDimColor)
         .setColorForeground(boxDimColor)
         .moveTo(g1)
       ;
       
       cp5.addSlider(_boxH)
         .setPosition(10,220)
         .setSize(200,20)
         .setRange(0,500)
         .setValue(10)
         .setColorActive(boxDimColor)
         .setColorForeground(boxDimColor)
         .moveTo(g1)
       ;
       
       cp5.addSlider(_boxD)
         .setPosition(10,240)
         .setSize(200,20)
         .setRange(0,500)
         .setValue(10)
         .setColorActive(boxDimColor)
         .setColorForeground(boxDimColor)
         .moveTo(g1)
       ;
       
        /////
       
                       ///////////////////////////// Group 2: Pixel Design /////////////////////////////
                       
      // Shape Selection               
      cp5.addButton("ellipse", 1, 50, 10, 80, 20).moveTo(g2);
      cp5.addButton("box", 0 , 140, 10, 80, 20).moveTo(g2);
      /////
      
      // Stroke
      cp5.addSlider(_Stroke)
         .setPosition(10,40)
         .setSize(200,20)
         .setRange(0,255)
         .setValue(0)
         .setColorActive(boxStrokeColor)
         .setColorForeground(boxStrokeColor)
         .moveTo(g2)
       ;
       
       cp5.addButton("uniform", 0, 10, 70, 80, 20).moveTo(g2);
       cp5.addButton("hue_Flow", 1, 100, 70, 80, 20).moveTo(g2);
       cp5.addButton("midnight_Drive", 2, 190, 70, 80, 20).moveTo(g2);
       
       
     
                       ///////////////////////////// Group 3: Animation /////////////////////////////  
                       
                       
                       
        cp5.addButton("deactivate", 0, 50, 10, 80, 20).moveTo(g3);    
        cp5.addButton("activate", 1, 140, 10, 80, 20).moveTo(g3);
        
        cp5.addSlider(animationZ_zRotation)
         .setPosition(10,40)
         .setSize(200,20)
         .setRange(0,360)
         .setValue(0)
         .setColorActive(boxStrokeColor)
         .setColorForeground(boxStrokeColor)
         .moveTo(g3)
       ;               
                       
                       
                     ///////////////////////////// Placing the tab ////////////////////////////
 
       accordion = cp5.addAccordion("acc")
                 .setPosition(10,10)
                 .setWidth(310)
                 .addItem(g1)
                 .addItem(g2)
                 .addItem(g3)
               
                 ;
     
                   ///////////////////////////// Tab attributes ////////////////////////////
     
     
    cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.open(0,1,2);}}, 'o');
    cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.open(0,1,2);}}, 'o');
    cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.close(0,1,2);}}, 'c');
    cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.setWidth(300);}}, '1');
    cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.setPosition(0,0);accordion.setItemHeight(190);}}, '2'); 
    cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.setCollapseMode(ControlP5.ALL);}}, '3');
    cp5.mapKeyFor(new ControlKey() {public void keyEvent() {accordion.setCollapseMode(ControlP5.SINGLE);}}, '4');
    cp5.mapKeyFor(new ControlKey() {public void keyEvent() {cp5.remove("myGroup1");}}, '0');
    
    accordion.open(2);
    
    accordion.setCollapseMode(Accordion.MULTI);
     
    cp5.setAutoDraw(false);
    
  }

                 ///////////////////////////// Drawing tabs on screen ////////////////////////////
  
  void gui() {
    hint(DISABLE_DEPTH_TEST);
    cam.beginHUD();
    cp5.draw();
    cam.endHUD();
    hint(ENABLE_DEPTH_TEST);
  }
}