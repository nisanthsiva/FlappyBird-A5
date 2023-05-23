PImage bird1, bird2, bird3;

PVector BirdPosition = new PVector(800/2,400);
PVector BirdVelocity = new PVector(0,0);
PVector BirdAcceleration = new PVector(0,0); // Starts accelerating after original movement
//PVector birdAcceleration = new PVector(0,4.9);  //Makes the bird fall immeditaly when starting
int birdWidth = 69, birdHeight = 50;

int animationState = 0;

int timer;
int spaceTimer;
boolean spacePressed = false;

int[] pipeXPos = new int[3];
int[] pipeHeight = new int[3]; // top of the bottom pipe, set distance to bottom of top pipe
int pipeSpeed = 5;
int pipeGap = 175;
int pipeWidth = 50;

void setup() {
  size(800,800);
  
  bird1 = loadImage("bird1.png");
  bird2 = loadImage("bird2.png");
  bird3 = loadImage("bird3.png");

  for(int i = 0; i < 3; i++) {
    pipeXPos[i] = i*300 + 500;
  }
  for(int i = 0; i < 3; i++) {
    pipeHeight[i] = i*100 + 100;
  }

  imageMode(CENTER);  
}

void draw() {
  println(pipeHeight);
  
  background(#000000);
  drawBird();
  moveBird();
  drawPipes();
  movePipes();
  spawnNewPipes();
  
  // Test for changing the rotation angle of the bird based on velocity/acceleration
  //translate(400,400);
  //rotate(radians(45));
  //rect(0,0,50,50);
}

void drawBird() {
  if(animationState == 0) {
    image(bird1,BirdPosition.x,BirdPosition.y);
  }
  else if(animationState == 1) {
    image(bird2,BirdPosition.x,BirdPosition.y);
  }
  else if(animationState == 2) {
    image(bird3,BirdPosition.x,BirdPosition.y);
  }
  else if(animationState == 3) {
    image(bird2,BirdPosition.x,BirdPosition.y);
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
  BirdPosition.add(BirdVelocity);
  BirdVelocity.add(BirdAcceleration);
  if(spacePressed) {
    BirdVelocity.y = -20;
    BirdAcceleration.y = 4.9;
  }
  if(BirdPosition.y + birdHeight/2 > 600) {
    BirdVelocity.y = 0;
    BirdAcceleration.y = 0;
    BirdPosition.y = 600 - birdHeight/2;
  }
}

void drawPipes() {
  fill(#03FF3F);
  for(int i = 0; i < 3; i++) {
    rect(pipeXPos[i],height-pipeHeight[i],pipeWidth,height-pipeHeight[i]); // fix height of bottom pipe
    //rect(pipeXPos[i],height-pipeHeight[i],pipeWidth,1000);
    rect(pipeXPos[i],0,pipeWidth,height-pipeHeight[i]-pipeGap);
  }
}

void movePipes() {
  for(int i = 0; i < 3; i++) {
    pipeXPos[i] -= pipeSpeed;
  }
}

void spawnNewPipes() {
  for(int i = 0; i < 3; i++) {
    if(pipeXPos[i]+pipeWidth <= 0) {
      pipeXPos[i] = width+pipeWidth;
      pipeHeight[i] = int(random(100,700));
    }
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
