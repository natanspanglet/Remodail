class Person { //<>// //<>//
  PVector pos, vel;
  float visionRadius, money, buyUrge, speed, personAngle;
  color skinTone;
  boolean spottedAdvertisement, headingToStore, visible;
  ArrayList<int[]> pathToStore;
  int[] nextPathRectangle;
  int currentPathIdx, nextPathRow, nextPathCol, octant, personRowIdx, personColIdx, visionDirectionRow, visionDirectionCol, adFrameCounter;

  Person(PVector p, PVector v, float s, float m, float pA) {
    this.pos = p;
    this.vel = v;
    this.speed = s;
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
    this.adFrameCounter = 0;
    this.visible = true;
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

  // Method to check if a specified row and column is within the bounds of the 2D cityLayout array
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
    
    /*
    MORE EFFICIENT BFS ALGORITHM AFTER MUCH THOUGHT
    Inspiration: Tony asked me "How would this program run in virtual desktop? Your BFS algorithm is so resource intensive" (not literally, that's more of an abridged version of what he told me). So I thought: CHALLENGE ACCEPTED
    This method searches for a path from the person to the store. The BFS algorithm begins searching at the store's location, and then branches out until it reaches where the person is located.
    The path is stored in a 3D array. Each {row, col} pair in the visitedCityLayout 3D array stores where the person just came from. E.g: If the person was just on (3,4) and moved to (3,5), the visitedCityLayout[3][5] would store the {row, col} pair of {3, 4}.
    This allows the algorithm to simply "backtrack" from the person to the store, as we just add the current row and current column to the generatedPath array, and then use it to go to the previous one, continuing on until we reach the store.
    This makes the method a lot more efficient because we no longer store every single path of the possible paths the person can travel. 
    */

    // Our starting square/rectangle location in the city layout
    int startRow = this.personRowIdx;
    int startCol = this.personColIdx;

    ArrayList< int[] > allPaths = new ArrayList(); // Array that stores all of the possible paths that the person goes in to find the store

    // Setting up the 3D array to see where the person has visited. We don't want to visit duplicate squares. If a tile/square is [-1, -1], that means they haven't visited it. If it's other numbers, then they have visited it.
    int[][][] visitedCityLayout = new int[layout.numCityRows][layout.numCityCols][2];
    for (int i = 0; i < layout.numCityRows; i++) {
      for (int j = 0; j < layout.numCityCols; j++) {
        visitedCityLayout[i][j][0] = -1; // Stores the row that the person just came from
        visitedCityLayout[i][j][1] = -1; // Stores the column that the person just came from
      }
    }

    // Initializing the beginning path
    visitedCityLayout[layout.storeRow][layout.storeCol][0] = startRow;
    visitedCityLayout[layout.storeRow][layout.storeCol][1] = startCol;
    int[] startPath = {layout.storeRow, layout.storeCol};
    allPaths.add(startPath);
    
    ArrayList< int[] > generatedPath = new ArrayList(); // The path that will be returned if the person can make it to the store. If they can't make it, the generatedPath variable will be empty
    while (allPaths.size() > 0) {
      
      // The current tile/square obtained from the BFS
      int[] curSquare = allPaths.remove(0);
      int curRow = curSquare[0]; // Row from the current tile/square
      int curCol = curSquare[1]; // Column from the current tile/square
      
      // If we have reached the store's tile/square, construct the generatedPath for the user t
      if (curRow == startRow && curCol == startCol) {
        while (curRow != layout.storeRow || curCol != layout.storeCol) {
          int[] curPath = {curRow, curCol};
          generatedPath.add(curPath);

          int prevRow = visitedCityLayout[curRow][curCol][0];
          int prevCol = visitedCityLayout[curRow][curCol][1];

          curRow = prevRow;
          curCol = prevCol;
        }
        int[] prevPath = {curRow, curCol};
        generatedPath.add(prevPath);
        break;
      }
      
      // Going in all four adjacent directions
      for (int[] dir : shuffleAdjDirectionArray()) {
        int newRow = curRow + dir[0]; // dir[0] corresponds to the direction of the row (-1 means going up, 1 means going down)
        int newCol = curCol + dir[1]; // dir[1] corresponds to the direction of the column (-1 means going left, 1 means going right)

        // A lot of checks to make sure that the new row and new column of the search is a valid location
        if (checkValidRectangle(newRow, newCol) == false) {
          continue;
        }

        if (layout.cityLayout[newRow][newCol] != 0 && layout.cityLayout[newRow][newCol] != 1) {
          continue;
        }
        
        // If we have not visited the new row and new column we are at:
        if (visitedCityLayout[newRow][newCol][0] == -1 && visitedCityLayout[newRow][newCol][1] == -1) {
          visitedCityLayout[newRow][newCol][0] = curRow; // As stated in the method briefing, we assign the new row location with the previous one
          visitedCityLayout[newRow][newCol][1] = curCol; // As stated in the method briefing, we assign the new column location with the previous one
          int[] nextPath = {newRow, newCol};

          allPaths.add(nextPath);
        }
      }
    }

    return generatedPath;
  }
   
  // Method to get the index of which tile the person is currently seeing.
  int getVisionDirectionIndex() {
    /*
      Grid is broken up into octants. Each ray refers to one of the rays of the octant diagram:
      \|/ <-- ray
      ---
      /|\ <-- ray
       ^
       |
       ray
       etc.
    */
    
    float rayOne = this.octant * (HALF_PI/2);
    float rayTwo = (this.octant + 1) * (HALF_PI/2);
    
    // Diff is used to determine which ray is closer to the angle the person is currently looking at. Whichever ray is closer will be used to determine which tile the person is looking at
    float diffOne = abs(this.personAngle - rayOne);
    float diffTwo = abs(this.personAngle - rayTwo);
    if (diffOne <= diffTwo) {
      return octant;
    } else {
      return (octant + 1) % 8; // Mod by 8 because octant + 1 can return 7, and 7 + 1 = 8, which will result in an error.
    }
  }
  
  // Method to calculate the buy urge as the person continuously looks at the advertisement.
  float calculateBuyUrge() {
    float addBuyUrge = adLayout.cityLayout[this.visionDirectionRow][this.visionDirectionCol].effectiveness;
    
    if (theTimes[0].isHoliday == true) {
      addBuyUrge += 0.1;
    }
    
    addBuyUrge += weather.buyEffect;
    
    if (this.money <= 50000) {
      addBuyUrge += 0.01;
    } else if (this.money <= 250000) {
      addBuyUrge += 0.02;
    } else if (this.money <= 500000) {
      addBuyUrge += 0.03;
    } else {
      addBuyUrge += 0.04;
    }
    
    if (storeProductPriceRowNum == 0) {
      addBuyUrge += 0.02;
    } else if (storeProductPriceRowNum == 1) {
      addBuyUrge += 0.01;
    } else {
      addBuyUrge -= 0.1;
    }
    
    if (16 <= theTimes[0].hourOfDay && theTimes[0].hourOfDay <= 18) {
      addBuyUrge += 0.05;
    }
    
    return addBuyUrge;
  }
  
  // RESETTING ALL OF THE FIELDS OF THE PERSON, WHICH RESETS THE PERSON ENTIRELY
  void resetPerson() {
    boolean personValidPlacement = false;
    PVector p = new PVector(0, 0);
    
    while (personValidPlacement == false) {
      p = new PVector(int(random(0, width)), int(random(0, height)));
      personValidPlacement = validPlacement(p, 0);
    }
    
    this.pos = p;
    this.personAngle = random(0, TWO_PI);
    this.speed = random(1.2, 3.5);
    this.money = int(random(100, 1000000));
    this.vel = new PVector(this.speed*cos(this.personAngle), speed*sin(this.personAngle));
    
    this.buyUrge = 0;
    this.skinTone = pickRandomSkinTone();
    this.spottedAdvertisement = false;
    this.headingToStore = false;
    this.currentPathIdx = 1;
    this.octant = int((this.personAngle * 8) / TWO_PI);
    this.personRowIdx = yPositionToIndex(this.pos.y);
    this.personColIdx = xPositionToIndex(this.pos.x);
    this.adFrameCounter = 0;
  }

  void move() {
    // First check if a person has already spotted an advertisement
    if (this.spottedAdvertisement == true) {

      // Check if the person is fully contained in a square/rectangle to avoid clipping
      if (this.checkInRectangle(this.personRowIdx, this.personColIdx) == false) {
        // Make the person go fully contained in the nearest square
        goToRectangle(this.personRowIdx, this.personColIdx);
        this.pos.add(this.vel);
      } else {
        
        this.adFrameCounter++;
        
        if (random(0, 100) <= this.buyUrge){
          
          // Begin the person's journey to find the store
          this.spottedAdvertisement = false;
          this.headingToStore = true;
  
          this.pathToStore = this.findPathToStore();
  
          // If there is a valid path to the store, begin going towards it. Else, stay at the same location
          if (this.pathToStore.size() > 0) {
            
            this.nextPathRectangle = this.pathToStore.get(currentPathIdx); // currentPathIdx starts at 1 because the first element (0) is the current position.
            this.nextPathRow = this.nextPathRectangle[0];
            this.nextPathCol = this.nextPathRectangle[1];
            
          } else {
            
            this.nextPathRow = this.personRowIdx;
            this.nextPathCol = this.personColIdx;
          }
        
        } else {
          
          // If the person gets tired of seeing the advertisement (2 seconds), then make the person leave the advertisement grounds and reset the values associated with it.
          if (this.adFrameCounter >= 60) {
            this.spottedAdvertisement = false;
            this.adFrameCounter = 0;
            this.buyUrge = random(0, 0.5);
            
          } else {
            
            // The buyUrge of the person will increase as they continue to stare at the advertisement,
            this.buyUrge += this.calculateBuyUrge();
          }
          
        }
        
      }
    }

    // When the user has begun to go to the store
    if (headingToStore == true) {

      // Check to see if the person is at the location of the next tile in the path to the store
      if (checkInRectangle(this.nextPathRow, this.nextPathCol) == false) {
        goToRectangle(this.nextPathRow, this.nextPathCol);
        this.pos.add(this.vel);
      } else {

        // If the person is at the next path, update on where the person should go next
        this.currentPathIdx++;
        
        // If the person has yet to reach the store, then find the next tile to go to in the pathToStore array. Otherwise, we are at the store, and we reset the person
        if (this.currentPathIdx < this.pathToStore.size()) {
          this.nextPathRectangle = this.pathToStore.get(currentPathIdx);
          this.nextPathRow = this.nextPathRectangle[0];
          this.nextPathCol = this.nextPathRectangle[1];
        } else {
          if (storeProductPriceRowNum == 0) {
            storeRevenue += random(0, 49);
          } else if (storeProductPriceRowNum == 1) {
            storeRevenue += random(50, 99);
          } else {
            storeRevenue += random(100, 1000);
          }
          storeRevenue = roundAny(storeRevenue, 2);
          
          this.resetPerson();
        }
      }
    }

    // If the person has neither spotted an advertisment nor headed towards a store, make them in "free motion"
    if (!spottedAdvertisement && !headingToStore) {

      // Changing the direction/heading of the person
      if (random(100) <= 5) {
        this.personAngle = random(0, TWO_PI);
        this.vel = new PVector(this.speed * cos(this.personAngle), this.speed*sin(this.personAngle));
      }

      // Making the person actually move
      this.pos.add(this.vel);

      // If the person is not in a valid location, revert the applied movement
      if (validPlacement(pos, 0) == false) {
        this.pos.sub(this.vel);
      }

      // Checking if the person can see an advertisement within the vicinity
      int visionDirectionIndex = this.getVisionDirectionIndex();
      this.visionDirectionRow = this.personRowIdx + visionDirection[visionDirectionIndex][0];
      this.visionDirectionCol = this.personColIdx + visionDirection[visionDirectionIndex][1];

      if (checkValidRectangle(this.visionDirectionRow, this.visionDirectionCol) == true) {
        if (adLayout.cityLayout[this.visionDirectionRow][this.visionDirectionCol].adType.equals("busStop")) {
          
          this.spottedAdvertisement = true;
          this.buyUrge = this.calculateBuyUrge();
          
        } else if (adLayout.cityLayout[this.visionDirectionRow][this.visionDirectionCol].adType.equals("billboard")) {
          
          this.spottedAdvertisement = true;
          this.buyUrge = this.calculateBuyUrge();
          
        } else if (layout.cityLayout[this.visionDirectionRow][this.visionDirectionCol] == 1 && random(0, 100) <= 5) { // If the person sees the store, then make them go into the store at a 5% chance
          this.headingToStore = true;
  
          this.pathToStore = this.findPathToStore();
  
          // If there is a valid path to the store, begin going towards it. Else, stay at the same location
          if (this.pathToStore.size() > 0) {
            
            this.nextPathRectangle = this.pathToStore.get(currentPathIdx); // currentPathIdx starts at 1 because the first element (0) is the current position.
            this.nextPathRow = this.nextPathRectangle[0];
            this.nextPathCol = this.nextPathRectangle[1];
            
          } else {
            
            this.nextPathRow = this.personRowIdx;
            this.nextPathCol = this.personColIdx;
          }
        }
      }
    }
    
    

    // Updating the current person's row and column index in the 2D cityLayout array
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
