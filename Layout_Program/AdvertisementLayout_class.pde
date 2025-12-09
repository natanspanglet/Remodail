class AdvertisementLayout {
  Advertisement[][] cityLayout;
  boolean adButtonClicked;
  String placeAdType = "none";
  int adRowIdx, adColIdx;
  
  AdvertisementLayout(int rows, int cols) {
    this.adButtonClicked = false;
    this.placeAdType = "none";
    
    this.cityLayout = new Advertisement[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        cityLayout[i][j] = new Advertisement("none", 0);
      }
    }
    
  }
  
  void putAdvertisement() {
    if (layout.cityLayout[this.adRowIdx][this.adColIdx] == 2) {
      this.cityLayout[this.adRowIdx][this.adColIdx].adType = this.placeAdType;
    } else if (layout.cityLayout[adRowIdx][adColIdx] == 4) {
      this.cityLayout[this.adRowIdx][this.adColIdx].adType = this.placeAdType;
    }
    
    if (this.placeAdType.equals("none")) {
      this.cityLayout[this.adRowIdx][this.adColIdx].adType = this.placeAdType;
    }
  }
  
}
