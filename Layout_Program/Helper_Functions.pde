int xPositionToIndex(float x) {
  int colIdx = int(x / colSpacing);
  if (colIdx >= layout.numCityCols) {
    colIdx = layout.numCityCols - 1;
  }
  return colIdx;
}

int yPositionToIndex(float y) {
  int rowIdx = int(y / rowSpacing);
  if (rowIdx >= layout.numCityRows) {
    rowIdx = layout.numCityRows - 1;
  }
  return rowIdx;
}

boolean validPlacement(PVector p, int check) {
  int colIdxL = xPositionToIndex(p.x);
  int rowIdxT = yPositionToIndex(p.y);
  int colIdxR = xPositionToIndex(p.x + personWidth);
  int rowIdxB = yPositionToIndex(p.y + personWidth);
  
  if (layout.cityLayout[rowIdxT][colIdxL] == check && layout.cityLayout[rowIdxT][colIdxR] == check && layout.cityLayout[rowIdxB][colIdxL] == check && layout.cityLayout[rowIdxB][colIdxR] == check && p.x >= 0 && p.x + personWidth <= width && p.y >= 0 && p.y + personWidth <= height) {
    return true;
  } else {
    return false;
  }
}

// Helper function to generate a new population each time the slider is changed
void generatePopulation() {
  population = new Person[populationNumber];
  for (int i = 0; i < population.length; i++) {
    
    boolean validPlacement = false;
    PVector p = new PVector(0, 0);
    
    while (validPlacement == false) {
      p = new PVector(int(random(0, width)), int(random(0, height)));
      validPlacement = validPlacement(p, 0);
    }
    
    float angle = random(0, TWO_PI);
    float speed = random(1.2, 5);
    PVector v = new PVector(speed*cos(angle), speed*sin(angle));
    population[i] = new Person(p, v, speed, 10, 10, angle);
  }
}

void generateAdLayout() {
  adLayout = new Advertisement[layout.numCityRows][layout.numCityCols];
  for (int i = 0; i < layout.numCityRows; i++) {
    for (int j = 0; j < layout.numCityCols; j++) {
      adLayout[i][j] = new Advertisement("none", 0);
    }
  }
}
int[][] shuffleAdjDirectionArray() {
  shuffleIndexes.shuffle();
  int[][] shuffledAdjDirections = new int[4][2];
  for (int i = 0; i < adjDirection.length; i++) {
    shuffledAdjDirections[i] = adjDirection[ shuffleIndexes.get(i) ];
  }
  return shuffledAdjDirections;
}  

void putAdvertisement() {
  if (layout.cityLayout[adRowIdx][adColIdx] == 2) {
    adLayout[adRowIdx][adColIdx].adType = placeAdType;
  } else if (layout.cityLayout[adRowIdx][adColIdx] == 4) {
    adLayout[adRowIdx][adColIdx].adType = placeAdType;
  }
  
  if (placeAdType.equals("none")) {
    adLayout[adRowIdx][adColIdx].adType = placeAdType;
  }
}



//void generateCars(){
// cars = new Car[carNum];
 
  
  
//}
