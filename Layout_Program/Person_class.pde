class Person {
  PVector pos, vel;
  float visionRadius, money, buyUrge, speed, personAngle;
  color skinTone;
  boolean spottedAdvertisement, headingToStore;
  ArrayList<int[]> pathToStore;
  int[] nextPathRectangle;
  int currentPathIdx, nextPathRow, nextPathCol, octant, personRowIdx, personColIdx;
  
  Person(PVector p, PVector v, float s, float vR, float m, float pA){
    this.pos = p;
    this.vel = v;
    this.speed = s;
    this.visionRadius = vR;
    this.money = m;
    this.personAngle = pA;
    
    this.buyUrge = 0;
    this.skinTone = pickRandomSkinTone();
    this.spottedAdvertisement = false;
    this.headingToStore = false;
    this.currentPathIdx = 1;
    this.octant = int((this.personAngle * 8) / TWO_PI);
    this.personRowIdx = yPositionToIndex(this.pos.y);
    this.personColIdx = xPositionToIndex(this.pos.x);
  }
  
  // Method to pick a random skin tone out of the available options specified.
  color pickRandomSkinTone() {
    int randomSkinToneIdx = int(random(0, skinTones.length)); // Obtaining a random index in the skin tones array
    return skinTones[ randomSkinToneIdx ];
  }
  
  // Check if the person is fully inside of a specified square/rectangle
  boolean checkInRectangle(int squareRow, int squareCol) {
    int colIdxL = xPositionToIndex(this.pos.x); // Left side
    int rowIdxT = yPositionToIndex(this.pos.y); // Top side
    int colIdxR = xPositionToIndex(this.pos.x + personWidth); // Right side
    int rowIdxB = yPositionToIndex(this.pos.y + personWidth); // Bottom side
    
    // First 2 checks are seeing if both pairs of sides are in the same square/rectangle, the next 2 are checking if they are in the specified square/rectangle
    if (colIdxL == colIdxR && rowIdxT == rowIdxB && colIdxL == squareCol && rowIdxT == squareRow) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean checkValidRectangle(int row, int col) {
    if (row < 0 || row >= layout.numCityRows || col < 0 || col >= layout.numCityCols) {
      return false;
    } else {
      return true;
    }
  }
  
  // Tell the user to go to a specified square/rectangle
  void goToRectangle(int rowIdx, int colIdx) {
    float targetX = (colIdx + 0.5) * colSpacing; // The horizontally middle position of the square/rectangle
    float targetY = (rowIdx + 0.5) * rowSpacing; // The vertically middle position of the square/rectangle
    PVector targetPos = new PVector(targetX, targetY); // The vector of the middle of the specified square/rectangle
    
    PVector directionVector = targetPos.sub(this.pos); // Obtaining the vector that specifies what direction the person should go in to the specified square/rectangle
    this.personAngle = directionVector.heading(); // Obtaining the angle of the direction vector
    this.vel = new PVector(this.speed * cos(this.personAngle), this.speed*sin(this.personAngle)); // Changing the velocity of the person to go in the direction of the specified square
  }
  
  // BFS algorithm to find the path to the store
  ArrayList<int[]> findPathToStore() {
    
    // Our starting square/rectangle location in the city layout
    int startRow = this.personRowIdx;
    int startCol = this.personColIdx;
    
    ArrayList< ArrayList< int[] > > allPaths = new ArrayList(); // Array that stores all of the possible paths that the person goes in to find the store
    
    // Setting up the 2D array to see where the person has visited. We don't want to visit duplicate squares
    boolean[][] visitedCityLayout = new boolean[layout.numCityRows][layout.numCityCols];
    for (int i = 0; i < layout.numCityRows; i++) {
      for (int j = 0; j < layout.numCityCols; j++) {
        visitedCityLayout[i][j] = false;
      }
    }
    
    // Initializing the beginning path
    visitedCityLayout[startRow][startCol] = true;
    int[] startingSquare = {startRow, startCol};
    ArrayList<int[]> startingPath = new ArrayList(); //<>//
    startingPath.add(startingSquare);
    
    allPaths.add(startingPath);
    
    ArrayList<int[]> generatedPath = new ArrayList(); // The path that will be returned if the person can make it to the store
    while (allPaths.size() > 0) {
      ArrayList<int[]> curPath = allPaths.remove(0);
      int[] curSquare = curPath.get(curPath.size() - 1);
      int curRow = curSquare[0];
      int curCol = curSquare[1];
      
      if (curRow == layout.storeRow && curCol == layout.storeCol) {
        generatedPath = curPath;
        break;
      }
      
      for (int[] dir: adjDirection) {
        int newRow = curRow + dir[0];
        int newCol = curCol + dir[1];
        
        if (checkValidRectangle(newRow, newCol) == false) {
          continue;
        }
        
        if (layout.cityLayout[newRow][newCol] != 0 && layout.cityLayout[newRow][newCol] != 1) {
          continue;
        }
        
        if (visitedCityLayout[newRow][newCol] == false) {
          visitedCityLayout[newRow][newCol] = true;
          ArrayList<int[]> newPath = deepcopy(curPath);
          int[] newSquare = {newRow, newCol};
          newPath.add(newSquare);
          
          allPaths.add(newPath);
          
        }
      }
      
    }
    
    return generatedPath;
    
  }
  
  int getVisionDirectionIndex() {
    float rayOne = this.octant * (HALF_PI/2);
    float rayTwo = (this.octant + 1) * (HALF_PI/2);
    float diffOne = abs(this.personAngle - rayOne);
    float diffTwo = abs(this.personAngle - rayTwo);
    if (diffOne <= diffTwo) {
      return octant;
    } else {
      return (octant + 1) % 8;
    }
  }
  
  void move() {
    if (this.spottedAdvertisement == true) {
      if (this.checkInRectangle(this.personRowIdx, this.personColIdx) == false) {
        goToRectangle(this.personRowIdx, this.personColIdx);
        this.pos.add(this.vel);
      } else {
        this.spottedAdvertisement = false;
        this.headingToStore = true;
        
        this.pathToStore = this.findPathToStore();
        
        if (this.pathToStore.size() > 0) {
          this.nextPathRectangle = this.pathToStore.get(currentPathIdx);
          this.nextPathRow = this.nextPathRectangle[0];
          this.nextPathCol = this.nextPathRectangle[1];
        } else {
          this.nextPathRow = this.personRowIdx;
          this.nextPathCol = this.personColIdx;
        }
      }
      
    }
    
    if (headingToStore == true) {
      if (checkInRectangle(this.nextPathRow, this.nextPathCol) == false) {
        goToRectangle(this.nextPathRow, this.nextPathCol);
        this.pos.add(this.vel);
      } else {
        this.currentPathIdx++;
        
        if (this.currentPathIdx < this.pathToStore.size()) {
          this.nextPathRectangle = this.pathToStore.get(currentPathIdx);
          this.nextPathRow = this.nextPathRectangle[0];
          this.nextPathCol = this.nextPathRectangle[1];
        }
      }
    }
    
    if (!spottedAdvertisement && !headingToStore) {
      if (random(100) <= 7) {
        this.personAngle = random(0, TWO_PI);
        this.vel = new PVector(this.speed * cos(this.personAngle), this.speed*sin(this.personAngle));
      }
      
      this.pos.add(this.vel);
      if (validPlacement(pos, 0) == false) {
        this.pos.sub(this.vel);
      }
      int visionDirectionIndex = this.getVisionDirectionIndex();
      int visionDirectionRow = this.personRowIdx + visionDirection[visionDirectionIndex][0];
      int visionDirectionCol = this.personColIdx + visionDirection[visionDirectionIndex][1];
      
      if (checkValidRectangle(visionDirectionRow, visionDirectionCol) == true) {
        if (adLayout[visionDirectionRow][visionDirectionCol].adType.equals("none")) {
          println("WORKS");
        }
      }

    }
    
    this.personRowIdx = yPositionToIndex(this.pos.y);
    this.personColIdx = xPositionToIndex(this.pos.x);
  }
  
  // Drawing the person to the screen
  void drawMe() {
    noStroke();
    fill(this.skinTone);
    
    square(this.pos.x, this.pos.y, 20);
  }
}
