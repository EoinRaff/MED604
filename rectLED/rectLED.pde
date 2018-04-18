int rows;
int columns;
public LED[][] screen;

void setup()
{
  size(960, 520);
  background(0);
  columns = 96;
  rows = 52;
  screen = new LED[columns][rows];
}

void draw()
{
  background(0);
  generateGrid();
}

void generateGrid() {
  float h = height/rows;
  float w = width/columns;
  for (int y = 0; y < rows; y ++) {
    for (int x = 0; x < columns; x++) {
      int c = 255;
      //int c = Animator(animationType, x, y)
      screen[x][y] = new LED(x*w, y*h, w, h);
      screen[x][y].display(c);
    }
  }
}