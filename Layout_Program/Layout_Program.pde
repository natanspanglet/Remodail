// Need G4P library
import g4p_controls.*;

//Creating a layout
Layout layout;

int rows =7;
int cols = 12;
//Screen size will be 800 by 600
void setup() {
  size(800,600);
  createGUI();
  layout = new Layout(rows, cols); 
  PFont f1 = createFont("Arial", 36);
  textFont(f1);
  background(0, 255, 0);
  
}

//Draw the grid, its features, and the preStructure() function of the Layout
//(the preStructure() function will take care of whether to draw the lighter-shaded square)
void draw() {
  println(rows, cols);  
  layout.drawGrid();
  if(layout.buttonClicked == true) {
    layout.preStructure();
  }
}

//If the user clicks their mouse, and they are in "editing mode" for planning, and they clicked within the grid:
//Call the Layout's function that enters the user's input into the 2-D array
void mouseClicked() {
  if (mouseX >= layout.leftBound && mouseX < layout.rightBound && mouseY >= layout.upBound   && mouseY < layout.lowBound) {
    layout.colIndex = int((mouseX - layout.leftBound) / layout.cellWidth);
    layout.rowIndex = int((mouseY - layout.upBound) / layout.cellHeight);

    layout.putStructure();
}
}

//A function that allows the user to pause the planning process
void keyPressed() {
  if(key == 'p') {
    if(layout.buttonClicked == true)  layout.buttonClicked = false;
    else if(layout.buttonClicked == false && layout.structureType != 5)  layout.buttonClicked = true;
  }
  println(layout.cityLayout[0][0]);
  println(layout.cityLayout[0][1]);
  println(layout.cityLayout[1][0]);
  println(layout.cityLayout[5][2]);
}
