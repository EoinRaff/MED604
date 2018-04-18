class LED{
  float x, y;
  float w, h;
  public LED(float x,float y,float w,float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  public void display(color c){
    noStroke();
    fill(c);
    rect(x, y, w, h);
  }
  
}