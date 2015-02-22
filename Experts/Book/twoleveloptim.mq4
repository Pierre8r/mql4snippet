//-----------------------------------------------------------------------
// twoleveloptim.mq4
// The code should be used for educational purpose only.
//-----------------------------------------------------------------------
int start()                                  // Special function start()
  {
   double
   Level_1,                                  // Alert level 1
   Level_2,                                  // Alert level 2
   Price;                                    // Current price
   Level_1=1.2850;                           // Set level 1
   Level_2=1.2800;                           // Set level 2
   Price=Bid;                                // Request price
//-----------------------------------------------------------------------
   if (Price > Level_1)                      // Check level 1
     {
      Alert("The price is above level 1");   // Message to the trader
     }
   else
     {
      if (Price < Level_2)                   // Check level 2
        {
         Alert("The price is above level 2"); // Message to the trader
        }
     }
//-----------------------------------------------------------------------
   return;                                   // Exit start()
  }
//-----------------------------------------------------------------------