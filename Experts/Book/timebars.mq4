//--------------------------------------------------------------------
// timebars.mq4
// The program is intended to be used as an example in MQL4 Tutorial.
//--------------------------------------------------------------------
int start()                            // Spec. function start()
  {
   Alert("TimeCurrent=",TimeToStr(TimeCurrent(),TIME_SECONDS),
         " Time[0]=",TimeToStr(Time[0],TIME_SECONDS));
   return;                             // Exit start()
  }
//--------------------------------------------------------------------