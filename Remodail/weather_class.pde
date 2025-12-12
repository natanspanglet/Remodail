class Weather {
  String weatherType;
  ArrayList<PVector> particles;
  int spawnRate, maxParticles;
  float buyEffect, life; 

  Weather(String wt) {
    this.weatherType = wt;
    this.spawnRate = 2;
    this.maxParticles = 200;
    
    if (this.weatherType.equals("raining"))
      this.buyEffect = -0.02;
    else if (this.weatherType.equals("sunny"))
      this.buyEffect = 0.01;
    else if (this.weatherType.equals("snowing"))
      this.buyEffect = -0.01;
    
    particles = new ArrayList();
  }

  void update() {
    if (this.weatherType.equals("raining"))
      rain();
    else if (this.weatherType.equals("sunny"))
      sunny();
    else if (this.weatherType.equals("snowing"))
      snow();
   removeOldParticles();
  }

  void spawnParticles() {
    // Only spawn particles until we reach maxParticles
    for (int i = 0; i < this.spawnRate && particles.size() < this.maxParticles; i++) {
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
