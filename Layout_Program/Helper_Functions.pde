// This function converts an x-position on the screen into its designated column in the cityLayour 2D array.
int xPositionToIndex(float x) {
  int colIdx = int(x / colSpacing);
  if (colIdx >= layout.numCityCols) {
    colIdx = layout.numCityCols - 1;
  }
  return colIdx;
}

// This function converts a y-position on the screen into its designated row in the cityLayour 2D array.
int yPositionToIndex(float y) {
  int rowIdx = int(y / rowSpacing);
  if (rowIdx >= layout.numCityRows) {
    rowIdx = layout.numCityRows - 1;
  }
  return rowIdx;
}

// This function checks if an object's position coordinates are validly in a walkable area
boolean validPlacement(PVector p, int check) {
  /*
  PVector p refers to the position vector of the specific object.
  int check refers to where the object should be located. E.g Person must be on grass, cars must be on roads.
  */
  
  int colIdxL = xPositionToIndex(p.x); // Left side of object
  int rowIdxT = yPositionToIndex(p.y); // Top side of object
  int colIdxR = xPositionToIndex(p.x + personWidth); // Right side of object
  int rowIdxB = yPositionToIndex(p.y + personWidth); // Bottom side of object
  
  // Checks if all of the 4 corners of an object are within a valid area. Also checks if the actual x and y position are within the bounds of the screen.
  if (layout.cityLayout[rowIdxT][colIdxL] == check && layout.cityLayout[rowIdxT][colIdxR] == check && layout.cityLayout[rowIdxB][colIdxL] == check && layout.cityLayout[rowIdxB][colIdxR] == check && p.x >= 0 && p.x + personWidth <= width && p.y >= 0 && p.y + personWidth <= height) {
    return true;
  } else {
    return false;
  }
}

// A simple roundAny function used in calculation of the store's revenue.
float roundAny(float x, int d) {
  x =  round(x * pow(10, d));
  return x / pow(10, d);
}

// Helper function to generate a new population each time the slider is changed
void generatePopulation() {
  
  // Creating a new person array no matter what when generating a new population
  population = new Person[populationNumber];
  
  for (int i = 0; i < population.length; i++) {
    
    boolean personValidPlacement = false; // Used to make sure that the new randomly assigned position vector of the person is in a valid location (i.e on grass)
    PVector p = new PVector(0, 0); // Position vector used for the new person

    while (personValidPlacement == false) {
      p = new PVector(int(random(0, width)), int(random(0, height))); // Random location on the screen
      personValidPlacement = validPlacement(p, 0); // Making sure that it's on grass. If it returns true, the loop will stop.
    }
    
    float angle = random(0, TWO_PI); // Initial heading of the person.
    float speed = random(1.2, 3.5); // How fast the person can walk.
    PVector v = new PVector(speed*cos(angle), speed*sin(angle)); // The person's velocity
    population[i] = new Person(p, v, speed, int(random(100, 1000000)),angle);
  }
}

void changePopulationVisiblity(int chance) {
  for (Person p: population) {
     if (random(0, 100) <= chance) {
       p.visible = false;
     }
   }
}

// Function used to shuffle the direction array when pathfinding to the store. Used to add randomness in how the people go to the store.
int[][] shuffleAdjDirectionArray() {
  shuffleIndexes.shuffle(); // .shuffle() shuffles the array into some random order, allowing for the order of the adjacent directions to be visualized.
  int[][] shuffledAdjDirections = new int[4][2]; // The adjDirection array is also 4 elements large, each element containing a {row, col} pair.
  for (int i = 0; i < adjDirection.length; i++) {
    shuffledAdjDirections[i] = adjDirection[ shuffleIndexes.get(i) ];
  }
  return shuffledAdjDirections;
}  

void valiDate(int hr, int yr, int mn, int dy) {
  int day = dy;
  int month = mn;
  int year = yr;
  if(day > 28) {
    if(month == 2 && year % 4 != 0)  day = 28;
  }
  if(day > 29) {
    if(month == 2)  day = 28;
  }
  if(day > 30) {
    if(month == 4 || month == 6 || month == 9 || month == 11)  day = 30;
  }
  
  String hourInput = str(hr) + ":00";
  //theTimes[0] = new Time(hourInput, day, month, year);
}
