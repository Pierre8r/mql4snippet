//---------------------------------------------------------------------------------------
// onelevel.mq4
// The code should be used for educational purpose only.
//---------------------------------------------------------------------------------------
int start()                                            // Special function 'start'
  {
   double
   Level,                                              // Alert level
   Price;                                              // Current price
   Level=1.2753;                                       // Set the level
   Price=Bid;                                          // Request price
//---------------------------------------------------------------------------------------
   if (Price>Level)                                    // Operator 'if' with a condition
     {
      Alert("The price has exceeded the preset level");// Message to the trader
     }
//---------------------------------------------------------------------------------------
   return;                                             // Exit start()
  }
//---------------------------------------------------------------------------------------