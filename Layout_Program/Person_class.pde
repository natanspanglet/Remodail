class Person {
  PVector pos, vel;
  float visionRadius, money, buyUrge, speed;
  color skinTone;
  boolean spottedAdvertisement, headingToStore;
  
  Person(PVector p, PVector v, float s, float vR, float m){
    this.pos = p;
    this.vel = v;
    this.speed = s;
    this.visionRadius = vR;
    this.money = m;
    
    this.buyUrge = 0;
    this.skinTone = pickRandomSkinTone();
    this.spottedAdvertisement = true;
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
  
  void move() {
    if (this.spottedAdvertisement == true) {
      if (this.checkCorners() == false) {
        int colIdxL = xPositionToIndex(this.pos.x);
        int rowIdxT = yPositionToIndex(this.pos.y);
        goToSquare(rowIdxT, colIdxL);
        this.pos.add(this.vel);
      }
      
    }
    
    if (headingToStore == true) {
      this.pos.add(this.vel);
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
