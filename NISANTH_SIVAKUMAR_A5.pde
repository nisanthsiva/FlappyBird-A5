// Space bar press only registered for <1s
// Get rid of autoformat
// init() method
// Score increasing detection

PImage bird1, bird2, bird3;

PVector BirdPosition = new PVector(800/2, 400);
PVector BirdVelocity = new PVector(0, 0);
PVector BirdAcceleration = new PVector(0, 0); // Starts accelerating after original movement
//PVector birdAcceleration = new PVector(0,4.9); //Makes the bird fall immeditaly when starting
int birdWidth = 69, birdHeight = 50;

int animationState = 0;
int gameState = 0; // 0 = menu, 1 = instructions, 2 = game, 3 = endgame

int animationTimer;
int spaceTimer;
boolean spacePressed = false;

int[] pipeXPos = new int[3];
int[] pipeHeight = new int[3]; // top of the bottom pipe,
int pipeSpeed = 4;
int pipeGap = 175; // gap between the top and bottom parts of the pipes
int pipeWidth = 50;

int playerScore = 0;

void setup() {
  size(800, 800);

  bird1 = loadImage("bird1.png");
  bird2 = loadImage("bird2.png");
  bird3 = loadImage("bird3.png");

  init();

  imageMode(CENTER);
  textAlign(CENTER);
}

void draw() {
  background(#000000);
  if (gameState == 0) {
    mainMenu();
  } 
  else if (gameState == 1) {
    instructions();
  } 
  else if (gameState == 2) {
    game();
  } 
  else if (gameState == 3) {
    gameover();
  }
}

void mainMenu() {
  background(#000000);
  // Add logo

  // Buttons to start game / instructions
  fill(#FFFFFF);
  rect(350, 385, 100, 30);
  rect(350, 485, 100, 30);
  fill(#000000);
  text("Start", 400, 400);
  text("How To Play", 400, 500);
}

void instructions() {
  background(#000000);
  // Add "How to play"
  fill(#FFFFFF);
  rect(340,585,120,30);
  fill(#000000);
  text("Return to Main Menu",400,600);
}

void game() {
  drawBird();
  moveBird();
  drawPipes();
  movePipes();
  spawnNewPipes();
  checkBirdCollision();
  score();
  drawScore();

  // Test for changing the rotation angle of the bird based on velocity/acceleration
  //translate(400,400);
  //rotate(radians(45));
}

void gameover() {
  background(#000000);
  text("Game Over", 400, 400);
  
  fill(#FFFFFF);
  rect(350,385,100,30);
  rect(340,485,120,30);
  
  fill(#000000);
  text("Play Again",400,400);
  text("Return to Main Menu",400,500);
}

void init() {
  playerScore = 0;
  BirdPosition.y = 400;
  
  resetPipes();
}

void resetPipes() {
  for (int i = 0; i < 3; i++) {
    pipeXPos[i] = i*300 + 800;
  }
  for (int i = 0; i < 3; i++) {
    pipeHeight[i] = i*100 + 100;
  }
}

void drawBird() {
  if (animationState == 0) {
    image(bird1, BirdPosition.x, BirdPosition.y);
  } else if (animationState == 1) {
    image(bird2, BirdPosition.x, BirdPosition.y);
  } else if (animationState == 2) {
    image(bird3, BirdPosition.x, BirdPosition.y);
  } else if (animationState == 3) {
    image(bird2, BirdPosition.x, BirdPosition.y);
  }

  if (millis() - animationTimer > 500) {
    if (animationState < 3) {
      animationState++;
    } else {
      animationState = 0;
    }
    animationTimer = millis();
  }
}

void moveBird() {  
  BirdVelocity.add(BirdAcceleration);
  BirdPosition.add(BirdVelocity);
  //BirdPosition.add(BirdVelocity);
  //BirdVelocity.add(BirdAcceleration);
  if (spacePressed) {
    BirdVelocity.y = -12;
    //BirdVelocity.y = -10;
    BirdAcceleration.y = 2.45;
    //BirdAcceleration.y = 9.8; 
  }
  if (BirdPosition.y + birdHeight/2 > 800) {
    BirdVelocity.y = 0;
    BirdAcceleration.y = 0;
    BirdPosition.y = 800 - birdHeight/2;
  }
}

void drawPipes() {
  fill(#03FF3F);
  for (int i = 0; i < 3; i++) {
    rect(pipeXPos[i], height-pipeHeight[i], pipeWidth, pipeHeight[i]); // bottom half of pipe
    rect(pipeXPos[i], 0, pipeWidth, height-pipeHeight[i]-pipeGap); // top half of pipe
  }
}

void movePipes() {
  for (int i = 0; i < 3; i++) {
    pipeXPos[i] -= pipeSpeed;
  }
}

void spawnNewPipes() {
  for (int i = 0; i < 3; i++) {
    if (pipeXPos[i]+pipeWidth <= 0) {
      pipeXPos[i] = width+pipeWidth;
      pipeHeight[i] = int(random(100, 700));
    }
  }
}

void checkBirdCollision() {
  for (int i = 0; i < 3; i++) {
    //if(abs(pipeXPos[i]-BirdPosition.x+birdWidth/2) < 65 &&
    if (abs(pipeXPos[i]-BirdPosition.x+birdWidth/2) < birdWidth && 
      (BirdPosition.y + birdHeight/2 > height-pipeHeight[i] || BirdPosition.y - birdHeight/2 < height-pipeHeight[i]-pipeGap)) {
      gameState = 3;                                                       // ^ Change to + for better detection
      init();
    }
  }
}

void score() {
  for(int i = 0; i < 3; i++) {
    if(BirdPosition.x - birdWidth >= pipeXPos[i]+pipeWidth) {
      playerScore++;
    }
  }
}

void drawScore() {
  println(playerScore);
}

void keyPressed() {
  if (keyCode == 32) {
    spacePressed = true;
  }
}

void keyReleased() {
  if (keyCode == 32) {
    spacePressed = false;
  }
}

void mousePressed() {
  if (gameState == 0 && mouseX > 350 && mouseX < 450 && mouseY > 385 && mouseY < 415) { // "Start"
    init();
    gameState = 2;
  }
  if (gameState == 0 && mouseX > 350 && mouseX < 450 && mouseY > 485 && mouseY < 515) { // "How to Play"
    gameState = 1;
  }
  if(gameState == 1 && mouseX > 340 && mouseX < 460 && mouseY > 585 && mouseY < 615) { // "Return to Main Menu"
    gameState = 0;
  }
  if(gameState == 3 && mouseX > 350 && mouseX < 450 && mouseY > 385 && mouseY < 415) { // "Play Again"
    init();
    gameState = 2;
  }
  if(gameState == 3 && mouseX > 340 && mouseX < 460 && mouseY > 485 && mouseY < 515) { // "Return to Main Menu"
    gameState = 0;
  }
}
