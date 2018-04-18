int rows;
int columns;

void setup()
{
  size(960, 520);
  background(0);
  columns = 96;
  rows = 52;
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
    fill(255);
    for (int x = 0; x < columns; x++) {
      rect(x*w, y*h, w, h);
    }
  }
}