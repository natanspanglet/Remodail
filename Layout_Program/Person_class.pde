class Person {
  PVector pos, vel;
  float visionRadius, money, buyUrge, speed;
  color skinTone;
  boolean spottedAdvertisement, headingToStore;
  ArrayList<int[]> pathToStore;
  
  Person(PVector p, PVector v, float s, float vR, float m){
    this.pos = p;
    this.vel = v;
    this.speed = s;
    this.visionRadius = vR;
    this.money = m;
    
    this.buyUrge = 0;
    this.skinTone = pickRandomSkinTone();
    this.spottedAdvertisement = true;
    this.headingToStore = false;
  }
  
  color pickRandomSkinTone() {
    int randomSkinToneIdx = int(random(0, skinTones.length));
    return skinTones[ randomSkinToneIdx ];
  }
  
  boolean checkCorners() {
    int colIdxL = xPositionToIndex(this.pos.x);
    int rowIdxT = yPositionToIndex(this.pos.y);
    int colIdxR = xPositionToIndex(this.pos.x + personWidth);
    int rowIdxB = yPositionToIndex(this.pos.y + personWidth);
    if (colIdxL == colIdxR && rowIdxT == rowIdxB) {
      return true;
    } else {
      return false;
    }
  }
  
  void drawMe() {
    stroke(this.skinTone);
    fill(this.skinTone);
    square(this.pos.x, this.pos.y, 20);
  }
  
  void goToSquare(int rowIdx, int colIdx) {
    PVector targetPos = new PVector(colIdx * colSpacing, rowIdx * rowSpacing);
    
    PVector directionVector = targetPos.sub(this.pos);
    float angle = directionVector.heading();
    this.vel = new PVector(this.speed * cos(angle), this.speed*sin(angle));
  }
  
  ArrayList<int[]> findPathToStore() {
    int startRow = yPositionToIndex(this.pos.y);
    int startCol = xPositionToIndex(this.pos.x);
    
    ArrayList< ArrayList< int[] > > allPaths = new ArrayList();
    boolean[][] visitedCityLayout = new boolean[layout.numCityRows][layout.numCityCols];
    for (int i = 0; i < layout.numCityRows; i++) {
      for (int j = 0; j < layout.numCityCols; j++) {
        visitedCityLayout[i][j] = false;
      }
    }
    int[] startingSquare = {startRow, startCol};
    ArrayList<int[]> startingPath = new ArrayList(); //<>//
    startingPath.add(startingSquare);
    
    allPaths.add(startingPath);
    
    ArrayList<int[]> generatedPath = new ArrayList();
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
        
        if (newRow < 0 || newRow >= layout.numCityRows || newCol < 0 || newCol >= layout.numCityCols) {
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
  
  void move() {
    if (this.spottedAdvertisement == true) {
      if (this.checkCorners() == false) {
        int colIdxL = xPositionToIndex(this.pos.x);
        int rowIdxT = yPositionToIndex(this.pos.y);
        goToSquare(rowIdxT, colIdxL);
        this.pos.add(this.vel);
      } else {
        this.spottedAdvertisement = false;
        this.headingToStore = true;
        
        this.pathToStore = this.findPathToStore();
      }
      
    }
    
    if (headingToStore == true) {
      println("HERE");
    }
    
    if (!spottedAdvertisement && !headingToStore) {
      if (random(100) <= 10) {
        float angle = random(0, TWO_PI);
        this.vel = new PVector(this.speed * cos(angle), this.speed*sin(angle));
      }
      
      this.pos.add(this.vel);
      if (validPlacement(pos, 0) == false) {
        this.pos.sub(this.vel);
      }
    }
  }
}
