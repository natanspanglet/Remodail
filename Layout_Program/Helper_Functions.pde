int xPositionToIndex(float x) {
  for(int j = 0; j < numCityCols; j++) {
    float k = x - j * colSpacing;
    if (k <= colSpacing) {
      return j;
    }
  }
  return numCityCols-1;
}

int yPositionToIndex(float y) {
  for (int i = 0; i < numCityRows; i++) {
    float k = y - i * rowSpacing;
    if (k <= rowSpacing) {
      return i;
    }
  }
  
  return numCityRows-1;
}

boolean validPersonPlacement(PVector p) {
  int colIdxL = xPositionToIndex(p.x);
  int rowIdxT = yPositionToIndex(p.y);
  int colIdxR = xPositionToIndex(p.x + personWidth);
  int rowIdxB = yPositionToIndex(p.y + personWidth);
  
  if (cityLayout[rowIdxT][colIdxL] == 0 && cityLayout[rowIdxT][colIdxR] == 0 && cityLayout[rowIdxB][colIdxL] == 0 && cityLayout[rowIdxB][colIdxR] == 0 && p.x >= 0 && p.x + personWidth <= width && p.y >= 0 && p.y + personWidth <= height) {
    return true;
  } else {
    return false;
  }
}
