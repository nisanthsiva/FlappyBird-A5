/*
 Nisanth Sivakumar
 NISANTH_SIVAKUMAR_A5.pde
 June 5, 2023
 ICS3U1 - Assignment 5
 
 An interactive physics engine based on the game "Flappy Bird".
 Score increases after passing pipes.
 Game speed increases as score increases.
 Spacebar to fly.
 */

// PImages for bird, background, and menu logo
PImage bird1, bird2, bird3;
PImage bg;
PImage logo;

// PVectors for bird
PVector BirdPosition = new PVector(800/2, 400);
PVector BirdVelocity = new PVector(0, 0);
PVector BirdAcceleration = new PVector(0, 0);

// Dimensions for bird
int birdWidth = 59, birdHeight = 40;

// Animation and game state variables
int animationState = 0;
int gameState = 0; // 0 = menu, 1 = instructions, 2 = game, 3 = endgame

// Time control variable
int animationTimer;
int spaceTimer;

// Boolean switch variable for spacebar
boolean spacePressed = false;

// Pipe variables
int numOfPipes = 3;
int[] pipeXPos = new int[numOfPipes];
int[] pipeHeight = new int[numOfPipes]; // Top of the bottom pipe,
boolean[] pipeScored = new boolean[numOfPipes];
float pipeSpeed = 4;
int pipeGap = 200; // Gap between the top and bottom parts of the pipes
int pipeWidth = 50;

// Score variable
int playerScore = 0;

// Background movement variables
int bgX = 0;
float bgSpeed = 4;

// Used to improve collision detection with bird
int collisionOffset = 10;

// Variable for highscore
int[] highscore = new int[1];

void setup() {
  size(800, 800);

  // Loads PImages for bird
  bird1 = loadImage("bird1.png");
  bird2 = loadImage("bird2.png");
  bird3 = loadImage("bird3.png");

  // Resizes the images
  bird1.resize(birdWidth, birdHeight);
  bird2.resize(birdWidth, birdHeight);
  bird3.resize(birdWidth, birdHeight);

  // Loads PImages for background and the menu logo
  bg = loadImage("background.jpg");
  logo = loadImage("logo.png");

  // Calls the initalize method to reset necessary variables
  init();

  // Changes the alignment modes of images and text
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
}

void draw() {
  // Calls the approriate method based on the gameState variable
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
  // Call the method to have the scrolling background
  movingBackground();

  // Draws the main menu features
  image(logo, 400, 200);
  fill(#FFFFFF);
  rectMode(CENTER);
  rect(400, 550, 100, 30);
  rectMode(CORNER);
  fill(#000000);
  textSize(24);
  text("Press Space to Start", 400, 480);
  textSize(12);
  text("How To Play", 400, 550);

  // Draws the bird at the menu, with animations
  drawBird(400, 400);

  // Starts the game if space bar is pressed
  if (spacePressed) {
    init();
    gameState = 2;
  }
}

void instructions() {
  // Draws the instructions menu
  background(#000000);
  fill(#FFFFFF);
  textSize(32);
  text("How To Play", 400, 200);
  textSize(24);
  text("You are controlling the bird", 400, 300);
  text("Use the spacebar to fly", 400, 350);
  text("Fly between the gaps in the pipes", 400, 400);
  text("Your score is increased each time your pass a pipe", 400, 450);
  text("The game gets faster over time", 400, 500);
  text("Game ends if you hit a pipe", 400, 550);
  textSize(12);
  rectMode(CENTER);
  rect(400, 600, 120, 30);
  rectMode(CORNER);
  fill(#000000);
  text("Return to Main Menu", 400, 600);
}

void game() {
  // Contains method calls for actual game play
  movingBackground();
  moveBird();
  drawPipes();
  movePipes();
  spawnNewPipes();
  checkBirdCollision();
  score();
  drawScores();

  // Changes the rotation angle of the bird based on velocity
  translate(BirdPosition.x, BirdPosition.y);
  rotate(radians(BirdVelocity.y));
  drawBird(0, 0);
}

void gameover() {
  // Saves player's score to highscore file if it is higher than current highscore
  if (playerScore > highscore[0]) {
    highscore[0] = playerScore;
    saveStrings("highscore.txt", str(highscore));
  }

  init(); // Resets necessary variables

  // Draws game over screen
  background(#000000);
  fill(#FFFFFF);
  text("Game Over", 400, 300);

  fill(#FFFFFF);
  rectMode(CENTER);
  rect(400, 400, 100, 30);
  rect(400, 500, 120, 30);
  rectMode(CORNER);

  fill(#000000);
  text("Play Again", 400, 400);
  text("Return to Main Menu", 400, 500);
}

void init() {
  // Method to reset necessary variables when resetting/starting the game
  BirdPosition = new PVector(800/2, 400);
  BirdVelocity = new PVector(0, 0);
  BirdAcceleration = new PVector(0, 0);
  playerScore = 0;
  pipeSpeed = 4;
  bgSpeed = 4;

  // Method call to reset the position and heights of the pipes
  resetPipes();
}

void movingBackground() {
  // Draws the scrolling background feature
  imageMode(CORNER);
  image(bg, bgX, 0);
  image(bg, bgX+bg.width, 0);
  bgX -= bgSpeed;
  // Resets the background image's position when it goes off the screen
  if (bgX < -bg.width) {
    bgX = 0;
  }
  imageMode(CENTER);
}

void resetPipes() {
  // Method to reset the position and heights of the pipes
  for (int i = 0; i < numOfPipes; i++) {
    pipeXPos[i] = i*400 + 800;
  }
  for (int i = 0; i < numOfPipes; i++) {
    pipeHeight[i] = i*100 + 100;
  }
  for (int i = 0; i < numOfPipes; i++) {
    pipeScored[i] = false;
  }
}

void drawBird(int x, int y) {
  // Draws the bird based on the animation states variable
  if (animationState == 0) {
    image(bird1, x, y);
  } 
  else if (animationState == 1) {
    image(bird2, x, y);
  } 
  else if (animationState == 2) {
    image(bird3, x, y);
  } 
  else if (animationState == 3) {
    image(bird2, x, y);
  }

  // Timer system to change animation state every 0.25s
  if (millis() - animationTimer > 250) {
    if (animationState < 3) {
      animationState++;
    } 
    else {
      animationState = 0;
    }
    animationTimer = millis();
  }
}

void moveBird() {
  // Updates the birds position by changing velocity based on acceleration
  BirdVelocity.add(BirdAcceleration);
  BirdPosition.add(BirdVelocity);

  // Changes birds upward velocity if space bar is pressed
  if (spacePressed) {
    BirdVelocity.y = -12;
    BirdAcceleration.y = 2.45;
  }

  // Prevents bird from going below bottom edge of the screen
  if (BirdPosition.y + birdHeight/2 > 800) {
    BirdVelocity.y = 0;
    BirdAcceleration.y = 0;
    BirdPosition.y = 800 - birdHeight/2;
  }

  // Prevents bird from going above the top edge of the screen
  if (BirdPosition.y - birdHeight/2 < 0) {
    BirdVelocity.y = 0;
    BirdPosition.y = 0 + birdHeight/2;
  }
}

void drawPipes() {
  // Draws the pipes
  fill(#03FF3F);
  for (int i = 0; i < numOfPipes; i++) {
    rect(pipeXPos[i], height-pipeHeight[i], pipeWidth, pipeHeight[i]); // bottom half of pipe
    rect(pipeXPos[i], 0, pipeWidth, height-pipeHeight[i]-pipeGap); // top half of pipe
  }
}

void movePipes() {
  // Moves the pipes by changing the horizontal positions
  for (int i = 0; i < numOfPipes; i++) {
    pipeXPos[i] -= pipeSpeed;
  }
}

void spawnNewPipes() {
  // Increments through each of the pipes
  for (int i = 0; i < numOfPipes; i++) {
    // Checks if the pipe goes off the left side of the screen
    if (pipeXPos[i]+pipeWidth <= 0) {
      // Moves the pipe slightly past the right side of the screen
      pipeXPos[i] = width+400;
      // Sets the pipe to have a random height between 200 and 700
      pipeHeight[i] = int(random(200, 700));
      // Sets the boolean used for scoring to false
      pipeScored[i] = false;
    }
  }
}

void checkBirdCollision() {
  // Increments through the pipes
  for (int i = 0; i < numOfPipes; i++) {
    // Checks if the bird is colliding with the pipes using x and y positions
    if (abs(pipeXPos[i]-BirdPosition.x+birdWidth/2) < birdWidth && (BirdPosition.y + birdHeight/2 > height-pipeHeight[i] + collisionOffset || BirdPosition.y - birdHeight/2 < height-pipeHeight[i]-pipeGap  - collisionOffset)) {
      // end game state
      gameState = 3;
    }
  }
}

void score() {
  // Increments through the pipes
  for (int i = 0; i < numOfPipes; i++) {
    // Checks if the pipe is past the halfway point of the screen, and if it has not already been scored
    if (pipeXPos[i] <= width/2 && !pipeScored[i]) {
      // Increases the player's score
      playerScore++;
      // Updates the boolean variable used for scoring
      pipeScored[i] = true;
      // Increases the speed of the pipe and the background
      pipeSpeed += 0.05;
      bgSpeed += 0.05;
    }
  }
}

void drawScores() {
  // Gets the currenct highscore from the text file
  highscore = int(loadStrings("highscore.txt"));

  // Draws the current score and the highscore at the top of the screen
  fill(#FFFFFF);
  textSize(24);
  text("Score: " + playerScore, 50, 50);
  text("High Score: " + highscore[0], 700, 50);
  textSize(12);
}

void keyPressed() {
  // If the space bar is pressed, update the boolean variable
  if (keyCode == 32) {
    spacePressed = true;
  }
}

void keyReleased() {
  // If the space bar is released, update the boolean variable
  if (keyCode == 32) {
    spacePressed = false;
  }
}

void mousePressed() {
  if (gameState == 0 && mouseX > 350 && mouseX < 450 && mouseY > 535 && mouseY < 565) { // "How to Play"
    gameState = 1; // instructions
  }
  if (gameState == 1 && mouseX > 340 && mouseX < 460 && mouseY > 585 && mouseY < 615) { // "Return to Main Menu"
    gameState = 0; // main menu
  }
  if (gameState == 3 && mouseX > 350 && mouseX < 450 && mouseY > 385 && mouseY < 415) { // "Play Again"
    init();
    gameState = 2; // game
  }
  if (gameState == 3 && mouseX > 340 && mouseX < 460 && mouseY > 485 && mouseY < 515) { // "Return to Main Menu"
    gameState = 0; // main menu
  }
}
