//--------------------------------------------------------------------
// extremumprice.mq4 
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
extern int Quant_Bars=30;                       // Amount of bars
//--------------------------------------------------------------------
int start()                                     // Special funct. start()
  {
   int i;                                       // Bar number 
   double Minimum=Bid,                          // Minimal price
          Maximum=Bid;                          // Maximal price
 
   for(i=0;i<=Quant_Bars-1;i++)                 // From zero (!) to..
     {                                          // ..Quant_Bars-1 (!)
      if (Low[i]< Minimum)                      // If < than known
         Minimum=Low[i];                        // it will be min
      if (High[i]> Maximum)                     // If > than known
         Maximum=High[i];                       // it will be max
     }
   Alert("For the last ",Quant_Bars,            // Show message  
         " bars Min= ",Minimum," Max= ",Maximum);
   return;                                      // Exit start()
  }
//--------------------------------------------------------------------