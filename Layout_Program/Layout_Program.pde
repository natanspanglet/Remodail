// Need G4P library
import g4p_controls.*;
import java.util.ConcurrentModificationException;

//Creating a layout
Layout layout;
float rowSpacing;
float colSpacing;
int rows = 7;
int cols = 12;
int storeProductPriceRowNum = 0;
float storeRevenue = 0;

String screenType; // building, display, advertising

Weather weather;
boolean weatherChosen = true;
int weatherRowNum = 0;

Person[] population;
int populationNumber;
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

Time[] theTimes = new Time[1];
String[] mostHolidays;

int[] zeroToThree = {0, 1, 2, 3};
IntList shuffleIndexes = new IntList(zeroToThree);
int[][] adjDirection = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
int[][] visionDirection = {{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}};

AdvertisementLayout adLayout;
boolean adButtonClicked = false;
String placeAdType = "none";
int adRowIdx, adColIdx;

//Screen size will be 800 by 600
void setup() {
  size(800,600);
  layout = new Layout(rows, cols); 
  createGUI();
  //population = new Person[populationNumber];
  
  //Makes sure the display pops up after submit button 
  displayControl.setVisible(false);
  advertisingControl.setVisible(false);
  populationNum.setEnabled(true);
  timeWindow.setVisible(false);
 
  weather = new Weather("sunny");
  // can u see ts
  
  populationNumber = 20;
  
  screenType = "building";
  
  adLayout = new AdvertisementLayout(layout.numCityRows, layout.numCityCols);
  
  mostHolidays = loadStrings("holidayData.txt");

  rowSpacing = height / layout.numCityRows;
  colSpacing = width / layout.numCityCols;

  PFont f1 = createFont("Arial", 36);
  textFont(f1);
  background(50, 196, 109);
  theTimes[0] = new Time("9:00", 1, 1, 2025);
  generatePopulation();
}

//Draw the grid, its features, and the preStructure() function of the Layout
//(the preStructure() function will take care of whether to draw the lighter-shaded square)
void draw() {
  layout.drawGrid();
  adLayout.drawGrid();
  if(screenType.equals("building") && layout.buttonClicked == true) {
    layout.preStructure();
  }
  
  // Drawing everything on the display screen
  if (screenType.equals("display")) {
    // Displaying the time
    if (theTimes[0] != null){
      theTimes[0].display();
      theTimes[0].update();
    }
    
    // Displaying the population
    if (population != null) {
      for(Person p: population) {
        if (p.visible == true) {
          p.drawMe();
          p.move();
        }
      }
    }
    
    // Displaying the weather
    if (weatherChosen){
      weather.update();
    }
    
    fill(0);
    String storeRevenueText = "Your Store Revenue: $" + storeRevenue;

    text(storeRevenueText, 600, 500);
  }
}

//If the user clicks their mouse, and they are in "editing mode" for planning, and they clicked within the grid:
//Call the Layout's function that enters the user's input into the 2-D array
void mouseClicked() {
  if (screenType.equals("building")) {
    if (layout.buttonClicked == true && mouseX >= layout.leftBound && mouseX < layout.rightBound && mouseY >= layout.upBound   && mouseY < layout.lowBound) {
      layout.colIndex = int((mouseX - layout.leftBound) / layout.cellWidth);
      layout.rowIndex = int((mouseY - layout.upBound) / layout.cellHeight);
  
      layout.putStructure();
    }
  
  } else if (screenType.equals("advertising")) {
    if (adLayout.adButtonClicked == true) {
      adLayout.adRowIdx = yPositionToIndex(mouseY);
      adLayout.adColIdx = xPositionToIndex(mouseX);

      adLayout.putAdvertisement();
    }
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
