PImage bird1, bird2, bird3;

int animationState = 0;

int timer;

void setup() {
  size(800,800);

  bird1 = loadImage("bird1.png");
  bird2 = loadImage("bird2.png");
  bird3 = loadImage("bird3.png");

  imageMode(CENTER);
}

void draw() {
  
  println(animationState);
  
  background(#000000);
  drawBird();
}

void drawBird() {
  if(animationState == 0) {
    image(bird1,400,400);
  }
  else if(animationState == 1) {
    image(bird2,400,400);
  }
  else if(animationState == 2) {
    image(bird3,400,400);
  }
  
  if(millis() - timer > 1000) {
    if(animationState < 2) {
      animationState++;
    }
    else {
      animationState = 0;
    }
    timer = millis();
  }
}
