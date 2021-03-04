import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20, NUM_COLS = 20;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(600, 600);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setMines();
}
public void keyPressed() {
  if(key == 'r' || key == 'R') {
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r, c);
      }
    }
    setMines();
  }
}

public void setMines()
{
  for (int i = 0; i < NUM_ROWS * 2; i++) {
    int row = (int)(Math.random() * NUM_ROWS);
    int col = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  for (int i = 0; i < mines.size(); i++) {
    if (mines.get(i).isFlagged() == false) {
      return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].setClicked(true);
      if (!mines.contains(buttons[r][c])) {
        buttons[r][c].setLabel("L");
      }
    }
  }
}
public void displayWinningMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!mines.contains(buttons[r][c])) {
        buttons[r][c].setClicked(true);
        buttons[r][c].setLabel("W");
      }
    }
  }
}
public boolean isValid(int r, int c)
{
  return (r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row - 1; r <= row + 1; r++) {
    for (int c = col - 1; c <= col + 1; c++) {
      if (isValid(r, c) && mines.contains(buttons[r][c])) {
        numMines++;
      }
    }
  }
  if (mines.contains(buttons[row][col])) {
    numMines--;
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 600.0/NUM_COLS;
    height = 600.0/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed() 
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      flagged = !flagged;
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      this.setLabel(countMines(myRow, myCol));
    } else {
      for (int r = myRow - 1; r <= myRow + 1; r++) {
        for (int c = myCol - 1; c <= myCol + 1; c++) {
          if (isValid(r, c) && !buttons[r][c].isClicked()) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(15);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0, 200);
    else if (clicked)
      fill(136);
    else 
    fill(179);

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked() {
    return clicked;
  }
  public void setClicked(boolean click) {
    clicked = click;
  }
}
