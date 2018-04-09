import ddf.minim.*;

Minim minim;
AudioInput in;

float vol;

int cols, rows;
int scl = 10;
int w = 920;
int h = 560;
int min = -1;
int max = 1;
float flying = 0;
float[][] terrain;

void setup() {
  vol=0;

  //size(920, 560, P3D);
  fullScreen(P3D, 1);
  cols = w/scl;
  rows = h/scl;
  terrain = new float[cols][rows];

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
}

void draw() {
  // this doesnt really work
  /*  vol = 0;
   ArrayList<Float> bufferQueue = new ArrayList();
   int bufferSize = 10;
   if(bufferQueue.size() >= bufferSize)
   {
   bufferQueue.remove(0);
   }
   bufferQueue.add(in.left.get(1));
   
   for (int i = 0; i < bufferSize-1; i++){
   if(bufferQueue.get(i) != null)
   vol += bufferQueue.get(i);
   }
   */

  /*
  create a queue of length bufferSize.
   When queue is full, remove first element and add new element to end
   Vol is a sum of the values of queue.
   */

  println(vol);

  flying -= 0.05;
  float yOff = flying;
  for (int y = 0; y < rows; y++) {
    float xOff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xOff, yOff), 0, 1, min, max);
      xOff += 0.2;
    }
    yOff += 0.2;
  }

  background(0);
  stroke(255);
  noFill();

  translate(width/2, height/2);
  rotateX(PI/3);


  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vol = in.left.get(y); //this is the amplitude
      vertex(x*scl, y*scl, terrain[x][y]*vol*100);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]*vol*100);
    }
    endShape();
  }
  //vol += 1;
}