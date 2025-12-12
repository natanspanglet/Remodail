class AdvertisementLayout {
  Advertisement[][] cityLayout;
  boolean adButtonClicked;
  String placeAdType = "none";
  int adRowIdx, adColIdx, billboardOffset;
  
  AdvertisementLayout(int rows, int cols) {
    this.adButtonClicked = false;
    this.placeAdType = "none";
    this.billboardOffset = 10;
    
    this.cityLayout = new Advertisement[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        cityLayout[i][j] = new Advertisement("none");
      }
    }
    
  }
  
  void putAdvertisement() {
    if (layout.cityLayout[this.adRowIdx][this.adColIdx] == 2 && this.placeAdType.equals("busStop")) {
      this.cityLayout[this.adRowIdx][this.adColIdx].adType = this.placeAdType;
    } else if (layout.cityLayout[adRowIdx][adColIdx] == 4 && this.placeAdType.equals("billboard")) {
      this.cityLayout[this.adRowIdx][this.adColIdx].adType = this.placeAdType;
    }
    
    if (this.placeAdType.equals("none")) {
      this.cityLayout[this.adRowIdx][this.adColIdx].adType = this.placeAdType;
    }
  }
  
  void drawGrid() {
    for (int i = 0; i < layout.numCityRows; i++) {
      for (int j = 0; j < layout.numCityCols; j++) {
        if (this.cityLayout[i][j].adType.equals("none") == false) {
          fill(155, 155, 155);
          noStroke();
          rect(j * layout.cellWidth + this.billboardOffset, i * layout.cellHeight + this.billboardOffset, layout.cellWidth - 2 * this.billboardOffset, layout.cellHeight - 2 * this.billboardOffset);
        }
      }
    }
  }
  
  void clearAdvertisements() {
    for (int i = 0; i < cityLayout.length; i++) {
      for (int j = 0; j < cityLayout[0].length; j++) {
        cityLayout[i][j].adType = "none";   // reset the ad in each cell
      }
    }
  
    adButtonClicked = false;
    placeAdType = "none";
  }

}
