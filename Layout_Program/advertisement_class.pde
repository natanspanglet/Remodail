class Advertisement{
  String adType;
  float effectiveness;
  
  Advertisement(String ad){
    this.adType = ad;
    
    if (this.adType.equals("billboard")) {
      this.effectiveness = 0.02;
    } else if (this.adType.equals("busStop")) {
      this.effectiveness = 0.01;
    }
    
    
  }
  
}
