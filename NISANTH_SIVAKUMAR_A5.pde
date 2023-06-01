// Add pipe PImage
// Get rid of autoformat

PImage bird1, bird2, bird3;
PImage bg;
PImage logo;

PVector BirdPosition = new PVector(800/2, 400);
PVector BirdVelocity = new PVector(0, 0);
PVector BirdAcceleration = new PVector(0, 0); // Starts accelerating after original movement
//PVector birdAcceleration = new PVector(0,4.9); //Makes the bird fall immeditaly when starting
//int birdWidth = 69, birdHeight = 50;
int birdWidth = 59, birdHeight = 40;

int animationState = 0;
int gameState = 0; // 0 = menu, 1 = instructions, 2 = game, 3 = endgame

int animationTimer;
int spaceTimer;
boolean spacePressed = false;

int numOfPipes = 3;
int[] pipeXPos = new int[numOfPipes];
int[] pipeHeight = new int[numOfPipes]; // top of the bottom pipe,
boolean[] pipeScored = new boolean[numOfPipes];
float pipeSpeed = 4;
int pipeGap = 200; // gap between the top and bottom parts of the pipes
int pipeWidth = 50;

int playerScore = 0;

int bgX = 0;
float bgSpeed = 4;

int collisionOffset = 10;

int[] highscore = new int[1];

void setup() {
  size(800, 800);

  //bird1 = loadImage("https://raw.githubusercontent.com/nisanthsiva/FlappyBird/main/bird1.png?token=GHSAT0AAAAAACDI7HSUEKXULSL3NNQXN4RMZDV547Q");
  bird1 = loadImage("bird1.png");
  bird2 = loadImage("bird2.png");
  bird3 = loadImage("bird3.png");
  
  bird1.resize(birdWidth,birdHeight);
  bird2.resize(birdWidth,birdHeight);
  bird3.resize(birdWidth,birdHeight);

  bg = loadImage("background.jpg");
  //bg = loadImage("https://raw.githubusercontent.com/nisanthsiva/FlappyBird/main/background.jpg?token=GHSAT0AAAAAACDKQMXDTWWQRAIAKMXHHZYWZDXHIFQ");
  
  logo = loadImage("logo.png");

  init();

  imageMode(CENTER);
  textAlign(CENTER,CENTER);
}

void draw() {
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
  //background(#000000);
  background(#17F9FF);
  image(logo,400,200);

  // Buttons to start game / instructions
  fill(#FFFFFF);
  rectMode(CENTER);
  rect(400, 400, 100, 30);
  rect(400, 500, 100, 30);
  rectMode(CORNER);
  fill(#000000);
  text("Start", 400, 400);
  text("How To Play", 400, 500);
}

void instructions() {
  background(#000000);
  fill(#FFFFFF);
  textSize(24);
  text("Game ends if you hit a pipe",400,400);
  text("Fly between the gaps in the pipes",400,450);
  text("Spacebar to fly",400,500);
  textSize(12);
  rectMode(CENTER);
  rect(400,600,120,30);
  rectMode(CORNER);
  fill(#000000);
  text("Return to Main Menu",400,600);
}

void game() {
  movingBackground();
  //drawBird();
  moveBird();
  drawPipes();
  movePipes();
  spawnNewPipes();
  checkBirdCollision();
  score();
  drawScores();

  // Changing the rotation angle of the bird based on velocity
  translate(BirdPosition.x,BirdPosition.y);
  rotate(radians(BirdVelocity.y));
  drawBird(0,0);
}

void gameover() {
  if(playerScore > highscore[0]) {
    highscore[0] = playerScore;
    saveStrings("highscore.txt",str(highscore));
  }
  init();
  background(#000000);
  fill(#FFFFFF);
  text("Game Over", 400, 300);
  
  fill(#FFFFFF);
  rectMode(CENTER);
  rect(400,400,100,30);
  rect(400,500,120,30);
  rectMode(CORNER);
  
  fill(#000000);
  text("Play Again",400,400);
  text("Return to Main Menu",400,500);
}

void init() {
  playerScore = 0;
  BirdPosition.y = 400;
  pipeSpeed = 4;
  bgSpeed = 4;
  
  resetPipes();
}

void movingBackground() {
  imageMode(CORNER);
  image(bg,bgX,0);
  image(bg,bgX+bg.width,0);
  bgX -= bgSpeed;
  if(bgX < -bg.width) {
    bgX = 0;
  }
  imageMode(CENTER);
}

void resetPipes() {
  for (int i = 0; i < numOfPipes; i++) {
    pipeXPos[i] = i*400 + 800;
  }
  for (int i = 0; i < numOfPipes; i++) {
    pipeHeight[i] = i*100 + 100;
  }
  for(int i = 0; i < numOfPipes; i++) {
    pipeScored[i] = false;
  }
}

//void drawBird() {
//  if (animationState == 0) {
//    image(bird1, BirdPosition.x, BirdPosition.y);
//  } else if (animationState == 1) {
//    image(bird2, BirdPosition.x, BirdPosition.y);
//  } else if (animationState == 2) {
//    image(bird3, BirdPosition.x, BirdPosition.y);
//  } else if (animationState == 3) {
//    image(bird2, BirdPosition.x, BirdPosition.y);
//  }

//  if (millis() - animationTimer > 250) {
//    if (animationState < 3) {
//      animationState++;
//    } else {
//      animationState = 0;
//    }
//    animationTimer = millis();
//  }
//}

void drawBird(int x, int y) {
  if (animationState == 0) {
    image(bird1, x, y);
  } else if (animationState == 1) {
    image(bird2, x, y);
  } else if (animationState == 2) {
    image(bird3, x, y);
  } else if (animationState == 3) {
    image(bird2, x, y);
  }

  if (millis() - animationTimer > 250) {
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
  if (BirdPosition.y - birdHeight/2 < 0) {
    BirdVelocity.y = 0;
    BirdPosition.y = 0 + birdHeight/2;
    }
}

void drawPipes() {
  fill(#03FF3F);
  for (int i = 0; i < numOfPipes; i++) {
    rect(pipeXPos[i], height-pipeHeight[i], pipeWidth, pipeHeight[i]); // bottom half of pipe
    rect(pipeXPos[i], 0, pipeWidth, height-pipeHeight[i]-pipeGap); // top half of pipe
  }
}

void movePipes() {
  for (int i = 0; i < numOfPipes; i++) {
    pipeXPos[i] -= pipeSpeed;
  }
}

void spawnNewPipes() {
  for (int i = 0; i < numOfPipes; i++) {
    if (pipeXPos[i]+pipeWidth <= 0) {
      pipeXPos[i] = width+400;
      pipeHeight[i] = int(random(200, 700));
      pipeScored[i] = false;
    }
  }
}

void checkBirdCollision() {
  for (int i = 0; i < numOfPipes; i++) {
    //if(abs(pipeXPos[i]-BirdPosition.x+birdWidth/2) < 65 &&
    if (abs(pipeXPos[i]-BirdPosition.x+birdWidth/2) < birdWidth && 
      (BirdPosition.y + birdHeight/2 > height-pipeHeight[i] + collisionOffset || BirdPosition.y - birdHeight/2 < height-pipeHeight[i]-pipeGap  - collisionOffset)) {
      gameState = 3;                                                     
      //init();
    }
  }
}

void score() {
  for(int i = 0; i < numOfPipes; i++) {
    if(pipeXPos[i] <= width/2 && !pipeScored[i]) {
      playerScore++;
      pipeScored[i] = true;
      pipeSpeed += 0.05;
      bgSpeed += 0.05;
    }
  }
}

void drawScores() {
  highscore = int(loadStrings("highscore.txt"));
  fill(#FFFFFF);
  textSize(24);
  text("Score: " + playerScore,50,50);
  text("High Score: " + highscore[0],700,50);
  textSize(12);
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
