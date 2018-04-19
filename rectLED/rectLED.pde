import ddf.minim.analysis.*;  //Shoud be imported in the main script
import ddf.minim.*;           //Shoud be imported in the main script

int rows;
int columns;
LED[][] screen;
Animator anim;
AudioProcessing AP;

float mov = 0; //mov and similar variables should later be replaces with Amp and Frq and so on.
float amp = 0;
float amp_m, amp_rt, frq_m, frq_rt;
void setup()
{
  size(960, 520); //Development
  //size(96, 52); //LED lab
  background(0);
  columns = 96;
  rows = 52;
  
  screen = new LED[columns][rows];
  AP = new AudioProcessing(1000);
  anim = new Animator(columns, rows, AP);
}

void draw()
{
  background(0);
  generateGrid();
  anim.UpdateVariables();
}

void generateGrid() {
  float h = height/rows;
  float w = width/columns;
  for (int y = 0; y < rows; y ++) {
    for (int x = 0; x < columns; x++) {
      color c = anim.Animate("Natural", x, y);
      screen[x][y] = new LED(x*w, y*h, w, h);
      screen[x][y].display(c);
    }
  }
}