class Advertisement{
  String adType;
  int numAds;
  
  Advertisement(String ad, int num){
    this.adType = ad;
    this.numAds = num;
  }
  
  
  void advertise(){
    if (adType.equals("billboard")){
      int people = this.numAds * 10;
    }
    else if (adType.equals("TV screen")){
      int people = this.numAds * 10;
    }
  }
}
