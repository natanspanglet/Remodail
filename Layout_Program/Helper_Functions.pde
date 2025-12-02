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

boolean validPersonPlacement(PVector p) {
  int colIdxL = xPositionToIndex(p.x);
  int rowIdxT = yPositionToIndex(p.y);
  int colIdxR = xPositionToIndex(p.x + personWidth);
  int rowIdxB = yPositionToIndex(p.y + personWidth);
  
  if (layout.cityLayout[rowIdxT][colIdxL] == 0 && layout.cityLayout[rowIdxT][colIdxR] == 0 && layout.cityLayout[rowIdxB][colIdxL] == 0 && layout.cityLayout[rowIdxB][colIdxR] == 0 && p.x >= 0 && p.x + personWidth <= width && p.y >= 0 && p.y + personWidth <= height) {
    return true;
  } else {
    return false;
  }
}

boolean validCarPlacement(PVector p){
  int colIdxL = xPositionToIndex(p.x);
  int rowIdxT = yPositionToIndex(p.y);
  int colIdxR = xPositionToIndex(p.x + carSize);
  int rowIdxB = yPositionToIndex(p.y + carSize);
  
  if (layout.cityLayout[rowIdxT][colIdxL] == 3 && layout.cityLayout[rowIdxT][colIdxR] == 3 && layout.cityLayout[rowIdxB][colIdxL] == 3 && layout.cityLayout[rowIdxB][colIdxR] == 3 && p.x >= 3 && p.x + carSize <= width && p.y >= 3 && p.y + carSize <= height) {
    return true;
  } else {
    return false;
  }
  
}
