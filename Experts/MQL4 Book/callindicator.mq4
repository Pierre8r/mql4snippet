//--------------------------------------------------------------------
// callindicator.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
extern int Period_MA = 21;            // Calculated MA period
bool Fact_Up = true;                  // Fact of report that price..
bool Fact_Dn = true;                  //..is above or below MA
//--------------------------------------------------------------------
int start()                           // Special function start()
  {
   double MA;                         // MA value on 0 bar    
//--------------------------------------------------------------------
                                      // Tech. ind. function call
   MA=iMA(NULL,0,Period_MA,0,MODE_SMA,PRICE_CLOSE,0); 
//--------------------------------------------------------------------
   if (Bid > MA && Fact_Up == true)   // Checking if price above
     {
      Fact_Dn = true;                 // Report about price above MA
      Fact_Up = false;                // Don't report about price below MA
      Alert("Price is above MA(",Period_MA,").");// Alert 
     }
//--------------------------------------------------------------------
   if (Bid < MA && Fact_Dn == true)   // Checking if price below
     {
      Fact_Up = true;                 // Report about price below MA
      Fact_Dn = false;                // Don't report about price above MA
      Alert("Price is below MA(",Period_MA,").");// Alert 
     }
//--------------------------------------------------------------------
   return;                            // Exit start()
  }
//--------------------------------------------------------------------