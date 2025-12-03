// Need G4P library
import g4p_controls.*;

//Creating a layout
Layout layout;
float rowSpacing;
float colSpacing;

String screenType;

float carSize;

Person[] population;
int personWidth = 20;
color[] skinTones = {
  color(45, 34, 40),
  color(60, 46, 40),
  color(75, 57, 50),
  color(90, 69, 60),
  color(105, 80, 70),
  color(120, 92, 80),
  color(135, 103, 90),
  color(150, 114, 100),
  color(165, 126, 110),
  color(180, 138, 120),
  color(195, 149, 130),
  color(210, 161, 140),
  color(225, 172, 150),
  color(240, 184, 160),
  color(255, 195, 170),
  color(255, 206, 180)
};


int rows =7;
int cols = 12;
//Screen size will be 800 by 600
void setup() {
  size(800,600);
  layout = new Layout(rows, cols); 
  createGUI();
  
  screenType = "building";
  
  rowSpacing = height / layout.numCityRows;
  colSpacing = width / layout.numCityCols;
  carSize = height / float(rows) - 20;
  
  
  //IF I AM CORRECT THIS DOES NOT NEED TO BE CALLED HERE ANYMORE, IF SOMEONE CAN CONFIRM DELETE EVERYTHING COMMENTED
  //population = new Person[50];
  //for (int i = 0; i < population.length; i++) {
  //  boolean validPlacement = false;
  //  PVector p = new PVector(0, 0);
  //  while (validPlacement == false) {
  //    p = new PVector(int(random(0, width)), int(random(0, height)));
  //    validPlacement = validPersonPlacement(p);
  //  }
    
  //  float angle = random(0, TWO_PI);
  //  float speed = random(1, 5);
  //  PVector v = new PVector(speed*cos(angle), speed*sin(angle));
  //  population[i] = new Person(p, v, speed, 10, 10);
  //}
  
  PFont f1 = createFont("Arial", 36);
  textFont(f1);
  background(0, 255, 0);
  
  
  
}

//Draw the grid, its features, and the preStructure() function of the Layout
//(the preStructure() function will take care of whether to draw the lighter-shaded square)
void draw() {

  layout.drawGrid();
  if(layout.buttonClicked == true) {
    layout.preStructure();
  }


  if (screenType.equals("display")) {
    for(Person p: population) {
      p.drawMe();
      p.move();
    }
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
