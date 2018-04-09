/*
Implementation of clouds and related behaviour for P6 project.
 
 Clouds should spawn when input is detected. 
 For final version this should be audio input.
 For initial implementation, mouseClick should be fine.
 
 Clouds lifecycle should follow ADSR pattern. 
 
 */

ArrayList<Cloud> clouds = new ArrayList<Cloud>();

float charge;
String[] dirArray = {"l", "r"};
String dir;
int index = 0;

void setup()
{
  //size(920, 560);
  fullScreen();
}

void draw()
{
  background(0);

  //access every active cloud
  for (int i = clouds.size() - 1; i >= 0; i--)
  {
    println("Number of Clouds: " + clouds.size());
    Cloud cloud = clouds.get(i);

    cloud.display();
    cloud.updateADSR();
    cloud.move();
    cloud.changeSize();

    if (cloud.canBeDestroyed) {
      clouds.remove(cloud);
    }
  }
  
}

void mouseClicked()
{
  //begin "charging" cloud.
  charge = millis();
  index ++;
  dir = dirArray[index%2];
  
  
}

void mouseReleased()
{
  //spawn cloud with Attack value based on how long mouse has been held
  charge = (millis() - charge) * 0.01;
  if (charge > 50)
    charge = 50;
  println(charge);
  
  clouds.add(new Cloud(mouseX, mouseY, charge, charge*0.1, dir));
}