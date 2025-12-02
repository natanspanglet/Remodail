class Car{
  int xCoord, yCoord, speed;
  
  Car(int s, int x, int y){
    this.speed = s;
    this.xCoord = x;
    this.yCoord = y;
  }
  

  void drawCar(){
    fill(255,0,0);
    square(xCoord,yCoord,carSize);
    
    xCoord += speed;
    
  }
  
}

// only call in setup's 'draw' function if the columns and rows are above 0, after user initiliaized
