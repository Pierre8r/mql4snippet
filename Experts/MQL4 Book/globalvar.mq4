//--------------------------------------------------------------------
// globalvar.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
int    Experts;                                 // Amount of EAs
double Depo=10000.0,                            // Set deposit
       Persent=30,                              // Set percentage     
       Money;                                   // Desired money
string Quantity="GV_Quantity";                  // GV name
//--------------------------------------------------------------------
int init()                                      // Special funct. init()
  {
   Experts=GlobalVariableGet(Quantity);         // Getting current value
   Experts=Experts+1;                           // Amount of EAs
   GlobalVariableSet(Quantity, Experts);        // New value
   Money=Depo*Persent/100/Experts;                // Money for EAs
   Alert("For EA in window ", Symbol()," allocated ",Money);
   return;                                      // Exit init()
  }
//--------------------------------------------------------------------
int start()                                     // Special funct. start()
  {
   int New_Experts= GlobalVariableGet(Quantity);// New amount of EAs
   if (Experts!=New_Experts)                    // If changed
     {
      Experts=New_Experts;                      // Now current
      Money=Depo*Persent/100/Experts;             // New money value 
      Alert("New value for EA ",Symbol(),": ",Money);
     }
   /*
   ...
   Here the main EA code should be indicated.
   The value of the variable Money is used in it.
   ...
   */
   return;                                      // Exit start()
  }
//--------------------------------------------------------------------
int deinit()                                    // Special funct. deinit()
  {
   if (Experts ==1)                             // If one EA..
      GlobalVariableDel(Quantity);              //..delete GV
   else                                         // Otherwise..
      GlobalVariableSet(Quantity, Experts-1);   //..diminish by 1
   Alert("EA detached from window ",Symbol());  // Alert about detachment
   return;                                      // Exit deinit()
  }
//--------------------------------------------------------------------