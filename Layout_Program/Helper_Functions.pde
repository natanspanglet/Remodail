int xPositionToIndex(float x) {
  for(int j = 0; j < layout.numCityCols; j++) {
    float k = x - j * colSpacing;
    if (k <= colSpacing) {
      return j;
    }
  }
  return layout.numCityCols-1;
}

int yPositionToIndex(float y) {
  for (int i = 0; i < layout.numCityRows; i++) {
    float k = y - i * rowSpacing;
    if (k <= rowSpacing) {
      return i;
    }
  }
  
  return layout.numCityRows-1;
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
    float speed = random(1, 5);
    PVector v = new PVector(speed*cos(angle), speed*sin(angle));
    population[i] = new Person(p, v, speed, 10, 10);
  }
}
