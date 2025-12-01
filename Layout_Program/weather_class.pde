class Weather {
  String weatherType;
  ArrayList<PVector> particles;
  int spawnRate = 2;  // how many particles appear per frame
  int maxParticles = 200;

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
  }

  void spawnParticles() {
    // Only spawn particles until we reach maxParticles
    for (int i = 0; i < spawnRate && particles.size() < maxParticles; i++) {
      particles.add(new PVector(random(0, width), random(0, height)));
    }
  }

  void drawParticles(int r, int g, int b) {
    fill(r, g, b);
    for (PVector p : particles) {
      square(p.x, p.y, 5);
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
