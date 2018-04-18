int rows;
int columns;
LED[][] screen;
Animator anim;
float mov = 0;

void setup()
{
  size(960, 520);
  background(0);
  columns = 96;
  rows = 52;
  screen = new LED[columns][rows];
  anim = new Animator();
}

void draw()
{
  background(0);
  generateGrid();
  mov += 0.05;
}

void generateGrid() {
  float h = height/rows;
  float w = width/columns;
  for (int y = 0; y < rows; y ++) {
    for (int x = 0; x < columns; x++) {
      int c = anim.Animate(mov,x,y);
      //int c = Animator.Animate(animationType, x, y)
      screen[x][y] = new LED(x*w, y*h, w, h);
      screen[x][y].display(c);
    }
  }
}