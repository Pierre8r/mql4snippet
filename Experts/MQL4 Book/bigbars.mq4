//--------------------------------------------------------------------
// bigbars.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------- 1 --
extern int Quant_Pt=20;                // Number of points
//--------------------------------------------------------------- 2 --
int start()                            // Spec. function start()
  {
   int H_L=0;                          // Height of the bar
   for(int i=0; H_L<Quant_Pt; i++)     // Cycle for bars
     {
      H_L=MathAbs(High[i]-Low[i])/Point;//Height of the bar
      if (H_L>=Quant_Pt)               // if the high bar is not found
        {
         int YY=TimeYear(  Time[i]);   // Year
         int MN=TimeMonth( Time[i]);   // Month         
         int DD=TimeDay(   Time[i]);   // Day
         int HH=TimeHour(  Time[i]);   // Hour         
         int MM=TimeMinute(Time[i]);   // Minute
         Comment("The last price movement more than ",Quant_Pt,//Message
         " pt happened ", DD,".",MN,".",YY," ",HH,":",MM);//output
        }
     }
   return;                             // Exit start()
  }
//--------------------------------------------------------------- 3 --