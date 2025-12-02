class Car{
  int xCoord, yCoord, speed;
  float size;
  
  Car(int s, int x, int y){
    this.speed = s;
    this.xCoord = x;
    this.yCoord = y;
  }
  
  void update(){
    xCoord += speed;
    size = height / float(rows) - 20;
  }

  void drawCar(){
    fill(255,0,0);
    square(xCoord,yCoord,size);
    
  }
  
}

// only call in setup's 'draw' function if the columns and rows are above 0, after user initiliaized
