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
    this.spottedAdvertisement = false;
  }
  
  color pickRandomSkinTone() {
    int randomSkinToneIdx = int(random(0, skinTones.length));
    return skinTones[ randomSkinToneIdx ];
  }
  
  void drawMe() {
    stroke(this.skinTone);
    fill(this.skinTone);
    square(this.pos.x, this.pos.y, 20);
  }
  
  void move() {
    if (spottedAdvertisement == true) {
    
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
