class Weather {
  String weatherType;
  ArrayList<PVector> particles;
  int spawnRate = 2;  // how many particles appear per frame
  int maxParticles = 200;
  float life; 

  Weather(String wt) {
    this.weatherType = wt;
    particles = new ArrayList();
  }

  void update() {
    if (weatherType.equals("raining"))
      rain();
    else if (weatherType.equals("sunny"))
      sunny();
    else if (weatherType.equals("snowing"))
      snow();
   removeOldParticles();
  }

  void spawnParticles() {
    // Only spawn particles until we reach maxParticles
    for (int i = 0; i < spawnRate && particles.size() < maxParticles; i++) {
      float x = random(width);
      float y = random(height);
      //How long the particles will stay on screen 
      float life = random(20, 60);   

    particles.add(new PVector(x, y, life)); 
  }
  }

  void drawParticles(int r, int g, int b) {
    fill(r, g, b);
    noStroke();
    for (PVector p : particles) {
      square(p.x, p.y, 5);
    }
  }
  
  void removeOldParticles() {
  for (int i = particles.size() - 1; i >= 0; i--) {
    PVector p = particles.get(i);
    
    //Subtracts lifespan each frame 
    p.z--;      

    if (p.z <= 0) {
      //Removes the particle from the screen 
      particles.remove(i); 
    }
  }
}


  void rain() {
    spawnParticles();
    drawParticles(50, 150, 255);
  }

  void sunny() {
    fill(255, 200, 50);
    square(width - 100, height * 0.1, 50);
  }

  void snow() {
    spawnParticles();
    drawParticles(255, 255, 255);
  }
  
}
