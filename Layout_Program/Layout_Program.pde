//Create a new city layut design 7 rows, 12 columns
Layout waterloo = new Layout(7, 12);

//Screen size will be 800 by 600
void setup() {
  PFont f1 = createFont("Arial", 36);
  textFont(f1);
  size(800, 600);
  background(0, 255, 0);
}

//Draw the grid, its features, and the preStructure() function of the Layout
//(the preStructure() function will take care of whether to draw the lighter-shaded square)
void draw() {
  //Draw the squares for the legend
  //Default Colour/Walkable Area
  fill(0, 255, 0);
  square(50, 425, 60);
  
  //Store
  fill(255, 0, 0);
  square(50, 500, 60);
  
  //Bus Stop
  fill(255, 255, 0);
  square(300, 425, 60);
  
  //Road
  fill(127, 127, 127);
  square(300, 500, 60);
  
  //Building
  fill(0, 0, 0);
  square(550, 425, 60);
  
  //Display the text for the legend
  text("Default", 120, 461);
  text("Store", 120, 536);
  text("Bus Stop", 370, 461);
  text("Road", 370, 536);
  text("Building", 620, 461);
  
  waterloo.drawGrid();
  if(waterloo.buttonClicked == true) {
    waterloo.preStructure();
  }
}

//If the user clicks their mouse, and they are in "editing mode" for planning, and they clicked within the grid:
//Call the Layout's function that enters the user's input into the 2-D array
void mouseClicked() {
  if(waterloo.buttonClicked == true) {
    if(mouseX >= 100 && mouseX < 700 && mouseY >= 50 & mouseY < 400) {
      waterloo.putStructure();
    }
  }
}

//A function that allows the user to pause the planning process
void keyPressed() {
  if(key == 'p') {
    if(waterloo.buttonClicked == true)  waterloo.buttonClicked = false;
    else if(waterloo.buttonClicked == false && waterloo.structureType != 5)  waterloo.buttonClicked = true;
  }
  println(waterloo.cityLayout[0][0]);
  println(waterloo.cityLayout[0][1]);
  println(waterloo.cityLayout[1][0]);
  println(waterloo.cityLayout[5][2]);
}
