//class Car {
//  PVector pos;  
//  float speed;
//  PVector dir;   
//  int row, col;  
//  Car[] allCars;

//  Car(float s, PVector p, Car[] allCarsArray) {
//    this.speed = s;
//    this.allCars = allCarsArray;

//    // Convert random pixel pos -> grid position
//    col = xPositionToIndex(p.x);
//    row = yPositionToIndex(p.y);

//    //Go to center of road tile
//    pos = new PVector(cellCenterX(col), cellCenterY(row));

//    chooseNewDirection();
//  }

//  float cellCenterX(int col) {
//    return col * colSpacing + colSpacing / 2;
//  }

//  float cellCenterY(int row) {
//    return row * rowSpacing + rowSpacing / 2;
//  }

////The cars randomly move direction 
//  void chooseNewDirection() {
//    int r = int(random(4));
//    if (r == 0 && canMoveTo(col+1, row)) dir = new PVector(1, 0);   // Right
//    else if (r == 1 && canMoveTo(col-1, row)) dir = new PVector(-1, 0); // Left
//    else if (r == 2 && canMoveTo(col, row+1)) dir = new PVector(0, 1);  // Down
//    else if (r == 3 && canMoveTo(col, row-1)) dir = new PVector(0, -1); // Up
//    else chooseNewDirection(); // retry if chosen direction blocked
//  }

//  //Check if the next grid cell is a road and in bounds
//  boolean canMoveTo(int c, int r) {
//    if(c < 0 || c >= layout.numCityCols || r < 0 || r >= layout.numCityRows) return false;
//    return layout.cityLayout[r][c] == 3;
//  }

//  void move() {

//    //Checks if the car is on teh screen 
//    if (pos.x < 0 || pos.x + carSize > 800) dir.x *= -1;
//    if (pos.y < 0 || pos.y + carSize > 600) dir.y *= -1;

//    int nextCol = col;
//    int nextRow = row;

//    if (dir.x != 0) {
//        nextCol = xPositionToIndex(pos.x + dir.x * speed);
//        //Keeps the car centred vertically 
//        pos.y = cellCenterY(row); 
//    } else if (dir.y != 0) {
//      //Keeps the car centred horizontally 
//        nextRow = yPositionToIndex(pos.y + dir.y * speed);
//        pos.x = cellCenterX(col); // keep car centered horizontally
//    }

//    //Checks if the next tiles are roads
//    if (canMoveTo(nextCol, nextRow)) {
//        // --- Check for collisions with other cars ---
//        PVector nextPos = new PVector(pos.x + dir.x * speed, pos.y + dir.y * speed);
//        boolean collision = false;

//        for (Car other: allCars) {
//            if (other != this && dist(nextPos.x, nextPos.y, other.pos.x, other.pos.y) < carSize) {
//                collision = true;
//                break;
//            }
//        }

//        //Move if the result will be no collision 
//        if (!collision) {
//            pos = nextPos;
//            col = nextCol;
//            row = nextRow;
//        } 
        
//        //If there is a collision change direction 
//        else {
//            chooseNewDirection(); // pick a new direction if collision detected
//        }
//    }
    
//    //If there is no road change direction 
//    else {
//        chooseNewDirection(); 
//    }
//}

//  void drawCar() {
//    fill(255, 194, 137);
//    square(pos.x, pos.y, carSize);
//  }
//}
