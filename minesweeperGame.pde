PImage img;
PImage bomb;
int cols;
int state;
int rows;
int nMines;
int mLeft;
int s ;
int fRevealed;
float dx;
float dy;
boolean skip;
Mines[][] mines;
int START_STATE =0;
int PLAY_STATE = 1;
int GAMEOVER_STATE =2;
int INSTRUCTION_STATE = 3;
int WIN_STATE;



void setup() {
  state = START_STATE;
  textAlign(CENTER, CENTER);
  size(700, 750);
  img = loadImage("Flag.png");
  bomb = loadImage("Mine.png");
}


void draw() {
  background(100);

  if (state == START_STATE)

  {
    fill(0, 190, 150, 200);
    textSize(25);
    text("Ready to play ? Select the N*N rows and columns.", width/2, height/2-50 );
    noFill();
    stroke(255);
    rect(width/2-180, height/2+40, 80, 40);
    text("[10]", width/2-140, height/2+55 );
    rect(width/2-20, height/2+40, 80, 40);
    text("[20]", width/2+20, height/2+55 );
    rect(width/2-90, height/2+105, 180, 40);
    text("[Instructions]", width/2, height/2+125 );
    rect(width/2+120, height/2+40, 80, 40);
    text("[30]", width/2+150, height/2+55 );
  } else if ( state == PLAY_STATE)

  {
    dx = width/cols;
    dy = (height )/rows;
    drawLine();
    drawMines();
  } else if ( state==INSTRUCTION_STATE)
  {
    textSize(15);
    text("Welcome to the Minesweeper game.The idea of game is to  clear a rectangular", width/2, height/2);
    text("board containing hidden mines or bombs without detonating them with the help", width/2, height/2+20);  
    text("from clues about the number of neighboring mines in each field.", width/2, height/2+40); 
    textSize(20);
    text("Press Any Key to get back to the menu screen.", width/2, height/2+80);
  } else if ( state==GAMEOVER_STATE)
  {

    drawLine();
    drawMines();  
    textSize(30);
    fill(255, 0, 0);
    text("Game Over!", width/2, height/2);
  } else if ( state==WIN_STATE)
  {

    drawLine();
    drawMines();  
    win();
  }
}


void position() {
  int a = nMines;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      mines[i][j] = new Mines();
    }
  }

  int[] minePositions = new int[a];
  for (int i = 0; i < a; i++) {
    minePositions[i] = -1;
  }

  for (int i = 0; i < a; i++) {
    float x = random(cols * rows);
    skip = false;

    for (int j = 0; j < a; j++) {
      if (minePositions[j] == x) {    
        i--;
        skip = true;
        break;
      }
    }

    if (skip) continue;

    minePositions[i] = (int)x;
  }

  for (int i = 0; i < a; i++) {
    int v = minePositions[i];
    int c = (int)(v%cols);
    int r = (int)(v/rows);

    if (c > 0 && r > 0) mines[c - 1][r - 1].countMine();
    if (r > 0) mines[c][r - 1].countMine();
    if (c < cols - 1 && r > 0) mines[c + 1][r - 1].countMine();

    if (c > 0) mines[c - 1][r].countMine();
    mines[c][r].setMine();
    if (c < cols - 1) mines[c + 1][r].countMine();

    if (c > 0 && r < rows - 1) mines[c - 1][r + 1].countMine();
    if (r < rows - 1) mines[c][r + 1].countMine();
    if (c < cols - 1 && r < rows- 1) mines[c + 1][r + 1].countMine();
  }
}


void reset() {
  loop();
  setup();
}


// Draw line in between the grid 
void drawLine() {
  fill(0);
  for (int i = 0; i < width; i += dx) {
    line(i, s, i, height);
  }

  for (int i = s; i < height; i += dy) {
    line(0, i, width, i);
  }
}

void drawSymbol(int c, int r, int s) {
  if (s == -2) {
    fill(0);
    image(img, dx/3 + r*dx, s + dy/3 + c*dy, dx/2, dy/2);
    return;
  } else if (s == -1) {
    fill(200);
    noStroke();
    rect(dx/5 + r*dx-4, dy/4-5 + c*dy, (dx*3)/4, (dy*3/4));
    stroke(0);
    return;
  } else if (s == 0) {
    fill(0);
    image(bomb, dx/2 + r*dx-5, s + dy/2 + c*dy-10, dx/2, dy/2);
    return;
  }

  fill(0);
  textSize((height / rows)/3 );
  text(s, dx/4 + r*dx, s+25 + (c+1) * dy);
}


void mousePressed() {


  if ( state== START_STATE)
  {
   

    
    if (mouseX>170 && mouseX<250 && mouseY>415 && mouseY<450)
    { 
      reset();
      rows=10;
      cols=10;
      nMines =10;
      mines = new Mines[rows][cols];
      position();
      loop();
      state= PLAY_STATE;
    }

    if (mouseX>325 && mouseX<410 && mouseY>415 && mouseY<460)
    {
      reset();
      rows=20;
      cols=20;
      nMines =20;
      mines = new Mines[rows][cols];
      position();
      state= PLAY_STATE;
    }


    if (mouseX>465 && mouseX<545 && mouseY>415 && mouseY<450)
    { 
      reset();
      rows=30;
      cols=30;
      nMines =30;
      mines = new Mines[rows][cols];
      position();
      loop();
      state= PLAY_STATE;
    }

    if (mouseX>260 && mouseX<440 && mouseY>483 && mouseY<522)
    {
      state= INSTRUCTION_STATE;
    }
  }


  if (state == PLAY_STATE && mouseButton == LEFT) {
    reveal(mouseX, mouseY);

    if (state == PLAY_STATE && mouseX > width/2 - 25 && mouseX < width/2 + 25 && mouseY > 10 && mouseY < 60) {
      reset();
    }
  } else if (mouseButton == RIGHT) {
    Mark(mouseX, mouseY);
  }
}


void drawMines() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (mines[i][j].Marked()) {
        drawSymbol(i, j, -2);
      } else if (mines[i][j].Hidden()) {
        drawSymbol(i, j, -1);
      } else if (mines[i][j].Mined()) {
        drawSymbol(i, j, 0);
      } else if (mines[i][j].MineCount() != 0) {
        drawSymbol(i, j, mines[i][j].MineCount());
      }
    }
  }
}



void reveal(float x, float y) {
  float a = y - s;

  float i = x/dx;
  float j = a/dy;
  int i1 = (int)(i);
  int j1 = (int)(j);

  if (i < 0 || a < 0 || i >= cols || j >= rows ) {
    return;
  }

  if (!mines[j1][i1].Hidden()) {
    return;
  }

  if (mines[j1][i1].Marked()) {
    mLeft++;
  }

  mines[j1][i1].reveal();
  fRevealed++;

  if (fRevealed == cols*rows - nMines) {      
    state=WIN_STATE;
  }

  if (mines[j1][i1].Mined()) {

    state = GAMEOVER_STATE;
  }

  if (mines[j1][i1].MineCount() == 0 && !mines[j1][i1].Mined()) {
    reveal(x + dx, y - dy);
    reveal(x, y - dy);
    reveal(x - dx, y - dy);
    reveal(x - dx, y);
    reveal(x + dx, y);
    reveal(x + dx, y + dy);
    reveal(x, y + dy);
    reveal(x - dx, y + dy);
  }
}

void Mark(float x, float y) {
  float yRel = y - s;

  Float iF = x/dx;
  Float jF = yRel/dy;
  int i = parseInt(iF);
  int j = parseInt(jF);

  if (i < 0 || yRel < 0 || i >= cols || j >= rows) {
    return;
  }

  if (mines[j][i].Hidden()) {
    if (mines[j][i].Marked()) {
      mines[j][i].Mark();
      mLeft++;
    } else {
      mines[j][i].Mark();
      mLeft--;
    }
  }
}

void gameOver() {
  noLoop();
  draw();
  textSize(40);
  fill(255, 0, 0);
  text("Game Over!", width/2, height/2);
}

void win() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (mines[i][j].Hidden() && !mines[i][j].Marked()) {
        mines[i][j].Mark();
      }
    }
  }
  mLeft=0;
  noLoop();
  draw();
  textSize(20);
  fill(255, 0, 0);
  text("Congratulatons.You Won!", height/2, width/2);
}






void keyPressed()
{
  if (state==INSTRUCTION_STATE)
  {
    state= START_STATE;
  }

  if (state==GAMEOVER_STATE)
  {  
    reset();  
    state= START_STATE;
  }

  if (state==WIN_STATE)
  {  
    reset();  
    state= START_STATE;
  }
}
