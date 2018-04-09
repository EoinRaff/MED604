class Cloud
{
  float x;
  float y;
  float size;
  float timeInitialized;
  //animation parameters
  float attack, decay, sustain, release;
  float moveSpeed;
  String[] animationState = {"attack", "decay", "sustain", "release"};
  String currentState;
  String direction;

  float maxSpeed = 10;
  float minSpeed = 3;
  float acceleration = 0.1;
  float growRate;

  boolean canBeDestroyed;

  public Cloud(float x, float y, float amplitude, float frequency, String direction)
  {
    this.x = x;
    this.y = y;
    this.size = amplitude;
    this.moveSpeed = frequency;
    this.direction = direction;
    
    this.timeInitialized = millis();
    attack = 1000;
    decay = 500;
    sustain = 1000;
    release = 3000;

    canBeDestroyed = false;
  }
  public void display()
  {
    noStroke();
    fill(255);
    ellipse(x, y, size, size);
    ellipse(x + size/2, y, size, size);
    ellipse(x + size, y, size, size);

    ellipse(x + size/4, y-size/2, size, size);
    ellipse(x + 3*size/4, y-size/2, size, size);
  }
  public void updateADSR()
  {
    float currentTime = millis();

    if (currentTime > timeInitialized + attack + decay + sustain + release)
    {
      //destroy cloud
      //      canBeDestroyed = true;
    } else if ( currentTime > timeInitialized + attack + decay + sustain)
    {
      currentState = "release";
    } else if ( currentTime > timeInitialized + attack + decay)
    {
      currentState = "sustain";
    } else if ( currentTime > timeInitialized + attack)
    {
      currentState = "decay";
    } else
    {
      currentState = "attack";
    }

    switch(currentState)
    {
    case "attack":
      moveSpeed += acceleration;
      growRate = 0.5;
      break;

    case "decay":
      moveSpeed -= acceleration*0.5;
      growRate = -0.2;
      break;

    case "sustain":
      growRate = 0;
      break;

    case "release":
      moveSpeed -= acceleration;
      growRate = - 0.5;
      break;

    default:
      break;
    }
    
    if (moveSpeed > maxSpeed)
      moveSpeed = maxSpeed;
    if (moveSpeed < 0)
      moveSpeed = minSpeed;
    if (size < 0)
      //size = 0;
      canBeDestroyed = true;
  }

  public void move()
  {    
    if (direction == "right" || direction == "r")
    {
      this.x+= moveSpeed;
    } else if (direction == "left" || direction == "l")
    {
      this.x -= moveSpeed;
    } else
    {
      println("unrecognized direction");
    }
  }

  public void changeSize()
  {
    this.size += growRate;
  }
}