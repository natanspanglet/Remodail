class Car{
  PVector pos;
  int speed;
  
  Car(int s, PVector p){
    this.speed = s;
    this.pos = p;
  }
  
  void move() {
    this.pos.x += this.speed;
  }

  void drawCar(){
    fill(255,0,0);
    square(this.pos.x, this.pos.y, carSize);
  }
  
}

// only call in setup's 'draw' function if the columns and rows are above 0, after user initiliaized
