//--------------------------------------------------------------------
// newbar.mq4  
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
extern int Quant_Bars=15;                       // Amount of bars
bool New_Bar=false;                             // Flag of a new bar
//--------------------------------------------------------------------
int start()                                     // Special funct. start()
  {
   double Minimum,                              // Minimal price
          Maximum;                              // Maximal price
//--------------------------------------------------------------------
   Fun_New_Bar();                               // Function call
   if (New_Bar==false)                          // If bar is not new..
      return;                                   // ..return
//--------------------------------------------------------------------
   int Ind_max =ArrayMaximum(High,Quant_Bars,1);// Bar index of max. price 
   int Ind_min =ArrayMinimum(Low, Quant_Bars,1);// Bar index of min. price 
   Maximum=High[Ind_max];                       // Desired max. price
   Minimum=Low[Ind_min];                        // Desired min. price
   Alert("For the last ",Quant_Bars,            // Show message  
   " bars Min= ",Minimum," Max= ",Maximum);
   return;                                      // Exit start()
  }
//--------------------------------------------------------------------
void Fun_New_Bar()                              // Funct. detecting ..
  {                                             // .. a new bar
   static datetime New_Time=0;                  // Time of the current bar
   New_Bar=false;                               // No new bar
   if(New_Time!=Time[0])                        // Compare time
     {
      New_Time=Time[0];                         // Now time is so
      New_Bar=true;                             // A new bar detected
     }
  }
//--------------------------------------------------------------------