class Layout {
  //Fields
  //In the final program, numRows and numCols will be passed into the new Layout object
  //from the GUI sliders
  int numCityRows;
  int numCityCols;
  float leftBound;
  float rightBound;
  float upBound;
  float lowBound;
  float cellWidth;
  float cellHeight;
  int[][] cityLayout;
  //vertCoords = coordinates of vertical lines
  //horzCoords = coordinates of horizontal lines
  float[] vertCoords;
  float[] horzCoords;
  boolean buttonClicked;
  int structureType;
  int rowIndex;
  int colIndex;
  
  //Constructor
  Layout(int r, int c) {
    //Initialize values for coordinates of the bounds of the design rectangle and dimensions of individual cells
    this.numCityRows = r;
    this.numCityCols = c;
    this.leftBound = 100;
    this.rightBound = 700;
    this.upBound = 50;
    this.lowBound = 400;
    this.cellWidth = (this.rightBound - this.leftBound) / this.numCityCols;
    this.cellHeight = (this.lowBound - this.upBound) / this.numCityRows;
    
    this.buttonClicked = false;
    this.structureType = 5;
    
    //Initialize coordinates for individual cells (in effect)
    this.horzCoords = new float[this.numCityRows + 1];
    this.vertCoords = new float[this.numCityCols + 1];
    this.horzCoords[0] = this.upBound;
    for(int h = 1; h < this.numCityRows + 1; h ++) {
      this.horzCoords[h] = this.upBound + this.cellHeight * h;
    }
    this.vertCoords[0] = this.leftBound;
    for(int i = 1; i < this.numCityCols + 1; i ++) {
      this.vertCoords[i] = this.leftBound + this.cellWidth * i;
    }
    
    //Create the 2-D array responsible for storing data pertaining to type of object present in each individual cell
    //Populate the array; by default all values are initialized as 0
    this.cityLayout = new int[this.numCityRows][this.numCityCols];
    for(int i = 0; i < this.numCityRows; i ++) {
      for(int j = 0; j < this.numCityCols; j ++) {
        this.cityLayout[i][j] = 0;
      }
    }
  }
  
  void drawGrid() {
    //Code for drawing the lines goes here
    //Vertical lines drawn here
    for(int f = 0; f < this.numCityCols + 1; f ++) {
      stroke(255);
      strokeWeight(2);
      line(this.vertCoords[f], this.upBound, this.vertCoords[f], this.lowBound);
    }
    
    //Horizontal lines drawn here
    for(int f = 0; f < this.numCityRows + 1; f ++) {
      stroke(255);
      strokeWeight(2);
      line(this.leftBound, this.horzCoords[f], this.rightBound, this.horzCoords[f]);
    }
    
    for(int i = 0; i < this.numCityRows; i ++) {
      for(int j = 0; j < this.numCityCols; j ++) {
        //Default Colour/Walkable Area
        if(this.cityLayout[i][j] == 0) {
          fill(0, 255, 0);
        }
        
        //Store
        else if(this.cityLayout[i][j] == 1) {
          fill(255, 0, 0);
        }
        
        //Bus Stop
        else if(this.cityLayout[i][j] == 2) {
          fill(255, 255, 0);
        }
        
        //Road
        else if(this.cityLayout[i][j] == 3) {
          fill(127, 127, 127);
        }
        
        //Building
        else {
          fill(0, 0, 0);
        }
        
        //Draw the rectangle fo the according colour
        rect(this.vertCoords[j], this.horzCoords[i], this.cellWidth, this.cellHeight);
      }
    }
    
  }
  
  //Confirm a structure by entering it into the cityLayout 2-D array
  void putStructure() {
    this.cityLayout[this.rowIndex][this.colIndex] = this.structureType;
  }
  
  //This is a function that allows the user to see where their mouse is before they click
  //This is done by drawing a square that is a lighter shade of the colour of the structure type
  //into the tile over which the user's mouse is hovering
  void preStructure() {
    if(this.structureType == 0)  fill(0, 255, 0);
    else if(this.structureType == 1)  fill(255, 0, 0);
    else if(this.structureType == 2)  fill(255, 255, 0);
    else if(this.structureType == 3)  fill(127, 127, 127);
    else  fill(0, 0, 0);
    if(mouseX >= this.leftBound && mouseX < this.rightBound && mouseY >= this.upBound & mouseY < this.lowBound) {
      this.colIndex = int((mouseX - leftBound) / this.cellWidth);
      this.rowIndex = int((mouseY - upBound) / this.cellHeight);
      rect(this.vertCoords[this.colIndex], this.horzCoords[this.rowIndex], this.cellWidth, this.cellHeight);
    }
  }
}
