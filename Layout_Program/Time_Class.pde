class Time {
  //Fields
  int startIndex;
  int timeIndex;
  int dayIndex;
  int hourOfDay;
  int dayOfMonth;
  int month;
  int weekDayIndex;
  int year;
  boolean isHoliday;
  PFont timeFont;
  int speedFactor;
  
  //This will be created using the data from the Holidays .txt file
  //This works since individual days can be represented as a series of integers with a fixed length
  //In the 2-D array, the length of each larger item will be 3
  //(one int for day of week, one for day of month, one for month of year)
  //For holidays that are independent of the day, put 7 different entries for that holiday, each with a different day of the week
  //For holidays that are not necessarily dependent on the calendar date (e.g. Super Saturday):
  //Have 7 different entries that have the same day of week, but different calendar dates within the interval of calendar dates
  //Have a function that compiles each passing day's relevant data into an array of the same format as the entries of this array
  //During the time updates, evaluate whether the current day is in the 2-D holidayList array
  //Assign a value to the isHoliday boolean variable accordingly
  //P.S. for the sake of simplicity, separate each item in each entry of the .txt file by only 1 character
  int[][] holidayList;
  int[] goodFridate;
  String holidayMessage;
  
  //Useful variables
  String[]week = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
  String[] months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
  int[] daysInMonthYear = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
  int[] daysInMonthLeapYear = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
  
  //Constructor
  Time(String dayTime, int monthDay, int theMonth, int theYear) {
    this.timeFont = createFont("Arial", 36);
    
    this.timeIndex = 0;
    this.speedFactor = 10;
    
    int colonIndex = dayTime.indexOf(":");
    this.hourOfDay = int(dayTime.substring(0, colonIndex));
    
    this.weekDayIndex = this.getWeekDay(monthDay, theMonth, theYear);
    
    this.dayOfMonth = monthDay;
    this.month = theMonth - 1;
    
    this.year = theYear;
    
    this.dayIndex = 0;
    this.startIndex = 0;
    if(this.year % 4 == 0) {
      for(int g = 0; g < this.month; g ++) {
        this.startIndex += daysInMonthLeapYear[g];
      }
    }
    else {
      for(int g = 0; g < this.month; g ++) {
        this.startIndex += daysInMonthYear[g];
      }
    }
    this.startIndex += (this.dayOfMonth - 1);
    
    //Fill the holiday list withh all holidays except Good Friday
    this.holidayList = new int[mostHolidays.length][3];
    for(int i = 0; i < mostHolidays.length - 1; i ++) {
      String[] thisHoliday = split(mostHolidays[i], "$");
      for(int j = 0; j < 3; j ++) {
        this.holidayList[i][j] = int(thisHoliday[j]);
      }
    }
    
    //Calculate the date of Good Friday for this calendar year and make that the final entry of the holiday list
    this.calculateGoodFridate();
    this.holidayList[mostHolidays.length - 1][0] = this.goodFridate[0];
    this.holidayList[mostHolidays.length - 1][1] = this.goodFridate[1];
    this.holidayList[mostHolidays.length - 1][2] = this.goodFridate[2];
    
    //Determine if tody is a holiday
    this.holidayToday();
  }
  
  
  //Methods
  void update() {
    this.timeIndex ++;
    
    //New Hour
    if(this.timeIndex % this.speedFactor == 0) {
      this.hourOfDay ++;
    }
    
    //New Day
    if(this.hourOfDay % 24 == 0 && this.timeIndex % this.speedFactor == 0) {
      this.hourOfDay = 0;
      this.weekDayIndex = (this.weekDayIndex % 7) + 1;
      this.dayOfMonth ++;
      this.dayIndex ++;
    }
    
    //Update Years and Months
    //With each passing month, every restaurant updates its finances
    //The conditin below is for if the year is a leap year
    if(this.year % 4 == 0) {
      if(this.dayOfMonth % daysInMonthLeapYear[this.month] == 1 && this.dayOfMonth != 1) {
        this.dayOfMonth = 1;
        this.month ++;
      }
      
      if((this.dayIndex + this.startIndex) % 366 == 0 && this.hourOfDay % 24 == 0 && this.timeIndex % this.speedFactor == 0) {
        this.year ++;
        this.startIndex = 0;
        this.month = 0;
        this.dayIndex = 0;
        this.calculateGoodFridate();
        this.holidayList[mostHolidays.length - 1][0] = this.goodFridate[0];
        this.holidayList[mostHolidays.length - 1][1] = this.goodFridate[1];
        this.holidayList[mostHolidays.length - 1][2] = this.goodFridate[2];
      }
    }
    
    //The condition below is for if the year is a regular year
    else {
      if(this.dayOfMonth % daysInMonthYear[this.month] == 1 && this.dayOfMonth != 1) {
        this.dayOfMonth = 1;
        this.month ++;
      }
      
      if((this.dayIndex + this.startIndex) % 365 == 0 && this.hourOfDay % 24 == 0 && this.timeIndex % this.speedFactor == 0) {
        this.year ++;
        this.startIndex = 0;
        this.month = 0;
        this.dayIndex = 0;
        this.calculateGoodFridate();
        this.holidayList[mostHolidays.length - 1][0] = this.goodFridate[0];
        this.holidayList[mostHolidays.length - 1][1] = this.goodFridate[1];
        this.holidayList[mostHolidays.length - 1][2] = this.goodFridate[2];
      }
    }
    
    //Determine if today is a holiday
    this.holidayToday();
  }
  
  //This function will be called at the beginning of each calendar year
  void calculateGoodFridate() {
    int goldenNumber = (this.year % 19) + 1;
    int epact =(11 * (goldenNumber - 1)) % 30;
    int month = 3;
    int paschal = 0;
    if(epact < 24) {
      paschal = 44 - epact;
      if(paschal > 31) {
        paschal -= 31;
        month += 1;
      }
    }
    else {
      paschal = 74 - epact;
      if(paschal > 31) {
        paschal -= 31;
        month += 1;
      }
    }
    
    //We have now determined that date of the Paschal Full Moon
    //Since Good Friday falls on the Friday before Easter Sunday, and Easter Sunday is the first Sunday after the Paschal Full Mooon:
    //Determine the day of the week of the Paschal Full Moon by first calculating how many days away it is from New Year's Day
    //by using the appropirate number of days in the year to figure out what day of the year (1-365) the Paschal Full Moon falls on
    //then, subtract one from that number
    //modulo that number by 7
    //add that number to the current week day index
    //modulo that number by 7
    //We have now figured out the day of the week on which the Paschal Full Moon falls
    //Subtract that number from 8, and add that number of days to the paschal variable, then adjust both the paschal and month variables as necessary
    //(that gives the date of Easter Sunday)
    //Subtract 2 from the paschal variable, then adjust both the paschal and month variables as necessary
    //This gives the necessary data for Good Friday, so upload the data to the holidayList 2-D array
    if(this.year % 4 == 0) {
      int date = 0;
      for(int i = 0; i < month - 1; i ++) {
        date += daysInMonthLeapYear[i];
      }
      date += paschal;
      date -= (this.startIndex + this.dayIndex + 1);
      //How many week days after today's week day the paschal occurs (below)
      date = date % 7;
      int paschalWeekDay = date + this.weekDayIndex;
      paschalWeekDay = ((paschalWeekDay - 1) % 7) + 1;
      paschalWeekDay = 8 - paschalWeekDay;
      paschal += paschalWeekDay;
      if(month == 3) {
        if(paschal > 31) {
          paschal -= 31;
          month += 1;
        }
      }
      //Now subtract 2 to adjust for the fact that Good Friday occurs on a Friday, not a Sunday
      paschal -= 2;
      if(paschal < 1) {
        paschal += 31;
        month -= 1;
      }
    }
    
    else {
      int date = 0;
      for(int i = 0; i < month - 1; i ++) {
        date += daysInMonthYear[i];
      }
      date += paschal;
      date -= (this.startIndex + this.dayIndex + 1);
      //How many week days after today's week day the paschal occurs (below)
      date = date % 7;
      int paschalWeekDay = date + this.weekDayIndex;
      paschalWeekDay = ((paschalWeekDay - 1) % 7) + 1;
      paschalWeekDay = 8 - paschalWeekDay;
      paschal += paschalWeekDay;
      if(month == 3) {
        if(paschal > 31) {
          paschal -= 31;
          month += 1;
        }
      }
      //Now subtract 2 to adjust for the fact that Good Friday occurs on a Friday, not a Sunday
      paschal -= 2;
      if(paschal < 1) {
        paschal += 31;
        month -= 1;
      }
    }
    
    this.goodFridate = new int[3];
    this.goodFridate[0] = 6;
    this.goodFridate[1] = paschal;
    this.goodFridate[2] = month - 1;
  }
  
  //Function to evaluate whether today is a holiday by comparing today's date numbers with the date numbers of every holiday
  //and seeing if today's date numbers align with one of the holidays' date numbers
  void holidayToday() {
    int[] evaluDate = new int[3];
    evaluDate[0] = this.weekDayIndex;
    evaluDate[1] = this.dayOfMonth;
    evaluDate[2] = this.month;
    int i = 0;
    this.isHoliday = false;
    while(i < (mostHolidays.length) && this.isHoliday == false) {
      if(evaluDate[0] == this.holidayList[i][0] && evaluDate[1] == this.holidayList[i][1] && evaluDate[2] == this.holidayList[i][2]) {
        this.isHoliday = true;
        String[] thissHoliday = split(mostHolidays[i], "$");
        this.holidayMessage = thissHoliday[3];
      }
      i ++;
    }
  }

  int getWeekDay(int d, int m, int y) {
    //The fixed reference point will be Thursday, December 4, 2025
    //First initialize variables for the total number of days between the dates as well as the number of leap years and non-leap years between the two years
    //(not including this year or the user-inputted year)
    int numDays = 0;
    int numLeaps = 0;
    int numNonLeaps = 0;
    int numYearsBetween = 0;
    if(y != 2025)  numYearsBetween = abs(y - 2025) - 1;
    if(y > 2025)  numLeaps = int(abs(y - 2025) / 4.00);
    else if(y < 2025)  numLeaps = round((2025 - y) / 4.00);
    numNonLeaps = numYearsBetween - numLeaps;
    numDays += 366 * numLeaps + 365 * numNonLeaps;
    
    //Now account the number of days between the 2 dates that fall within the years of importance
    //(2 separate cases for whether or not the user-inputted year of importance is 2025)
    //First, calculate the day of the year (1-365 or 366) on which the user-inputted date falls
    int mCheck = 0;
    if(y % 4 == 0) {
      for(int g = 0; g < m - 1; g ++)  mCheck += daysInMonthLeapYear[g];
      mCheck += d;
    }
    else {
      for(int g = 0; g < m - 1; g ++)  mCheck += daysInMonthYear[g];
      mCheck += d;
    }
    if(y == 2025) {
      int weekDaysAfter = (mCheck - 338) % 7;
      return ((5 + weekDaysAfter + 6) % 7) + 1;
    }
    else {
      if(y < 2025) {
        if(y % 4 == 0) {
          numDays += 338 + (366 - mCheck);
        }
        else {
          numDays += 338 + (365 - mCheck);
        }
        int weekDaysBefore = numDays % 7;
        return ((5 - weekDaysBefore + 6) % 7) + 1;
      }
      else {
        numDays += 27 + mCheck;
        int weekDaysAfter = numDays % 7;
        return ((5 + weekDaysAfter + 6) % 7) + 1;
      }
    }
  }
  
  void display() {
    fill(0);
    String theTimeDisplay = str(this.hourOfDay) + ":00, " + week[(this.weekDayIndex - 1) % 7] + ", " + months[this.month] + " " + str(this.dayOfMonth) + ", " + str(this.year);
    text(theTimeDisplay, 200, 40);
    if(this.isHoliday == true) {
      text(this.holidayMessage, 300, 500);
    }
  }
}
