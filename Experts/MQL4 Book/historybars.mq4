//--------------------------------------------------------------------
// historybars.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
extern int Period_MA = 5;             // Calculated MA period
//--------------------------------------------------------------------
int start()                           // Special function start()
  {
   double MA_c,                       // MA value on bar 0   
          MA_p,                       // MA value on bar 4   
          Delta;                      // Difference between MA on bars 0 and 4
//--------------------------------------------------------------------
                                      // Technical indicator function call
   MA_c  = iMA(NULL,0,Period_MA,0,MODE_SMA,PRICE_CLOSE,0); 
   MA_p  = iMA(NULL,0,Period_MA,0,MODE_SMA,PRICE_CLOSE,4); 
   Delta = (MA_c - MA_p)/Point;       // Difference between MA on 0 and 4th bars
//--------------------------------------------------------------------
   if (Delta > 0 )                    // Current price higher than previous
      Alert("On 4 bars MA increased by ",Delta,"pt");  // Alert
   if (Delta < 0 )                    // Current price lower than previous
      Alert("On 4 bars MA decreased by ",-Delta,"pt");// Alert 
//--------------------------------------------------------------------
   return;                            // Exit start()
  }
//--------------------------------------------------------------------