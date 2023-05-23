PImage bird1, bird2, bird3;

PVector birdPosition = new PVector(800/2,400);
PVector birdVelocity = new PVector(0,0);
PVector birdAcceleration = new PVector(0,0); // Starts accelerating after original movement
//PVector birdAcceleration = new PVector(0,4.9); 
//Makes the bird fall immeditaly when starting

int birdWidth = 69, birdHeight = 50;

int animationState = 0;

int timer;
int spaceTimer;

boolean spacePressed = false;

void setup() {
  size(800,800);
  
  bird1 = loadImage("bird1.png");
  bird2 = loadImage("bird2.png");
  bird3 = loadImage("bird3.png");

  imageMode(CENTER);  
  rectMode(CENTER);
}

void draw() {
  background(#000000);
  drawBird();
  moveBird();
  
  // Test for changing the rotation angle of the bird based on velocity/acceleration
  translate(400,400);
  rotate(radians(45));
  rect(0,0,50,50);
}

void drawBird() {
  if(animationState == 0) {
    image(bird1,birdPosition.x,birdPosition.y);
  }
  else if(animationState == 1) {
    image(bird2,birdPosition.x,birdPosition.y);
  }
  else if(animationState == 2) {
    image(bird3,birdPosition.x,birdPosition.y);
  }
  else if(animationState == 3) {
    image(bird2,birdPosition.x,birdPosition.y);
  }
  
  if(millis() - timer > 500) {
    if(animationState < 3) {
      animationState++;
    }
    else {
      animationState = 0;
    }
    timer = millis();
  }
}

void moveBird() {
  birdPosition.add(birdVelocity);
  birdVelocity.add(birdAcceleration);
  if(spacePressed) {
    birdVelocity.y = -20;
    birdAcceleration.y = 4.9;
  }
  if(birdPosition.y + birdHeight/2 > 600) {
    birdVelocity.y = 0;
    birdAcceleration.y = 0;
    birdPosition.y = 600 - birdHeight/2;
  }
}

void keyPressed() {
  if(keyCode == 32) {
    spacePressed = true;
  }
}

void keyReleased() {
  if(keyCode == 32) {
    spacePressed = false;
  }
}
