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
