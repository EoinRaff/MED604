class Cube {
  
  int xPos,yPos, boxS;
  public PShape cube;
  
  public Cube (int _yPos, int _xPos, PShape _cube) {
    this.xPos = _xPos;
    this.yPos = _yPos;
    this.cube = _cube;
  }
  
  void drawCube (color _col) {
    
    //box(_boxS);
    shape(cube);
    cube.setStroke(color(255));
    cube.setStrokeWeight(1);
    cube.setFill(color(_col));
  }
  
  

}