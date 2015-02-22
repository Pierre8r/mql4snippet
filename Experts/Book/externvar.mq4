//--------------------------------------------------------------------
// externvar.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
extern double Level = 1.2500;                   // External variable
extern int        n = 5;                        // External variable
       bool  Fact_1 = false;                    // Global variable
       bool  Fact_2 = false;                    // Global variable
//--------------------------------------------------------------------
int start()                                     // Special function start()
  {
   double Price = Bid;                          // Local variable
   if (Fact_2==true)                            // If there was an Alert..
      return;                                   //..exit
 
   if (NormalizeDouble(Price,Digits) >= NormalizeDouble(Level,Digits))
      Fact_1 = true;                            // Event 1 happened
 
   if (Fact_1 == true && NormalizeDouble(Price,Digits)<=
                         NormalizeDouble(Level-n*Point,Digits))       
      My_Alert();                               // User-defined function call
 
   return;                                      // Exit start()
  }
//--------------------------------------------------------------------
void My_Alert()                                 // User-defined function
  {
   Alert("Conditions implemented");             // Alert
   Fact_2 = true;                               // Event 2 happened
   return;                                      // Exit user-defined function
  }
//--------------------------------------------------------------------