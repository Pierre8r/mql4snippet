//-----------------------------------------------------------------------------------
// charts.mq4
// The code should be used for educational purpose only.
//------------------------------------------------------------------------------ 1 --
int   Win_Mom_old=0,                          // Old number of subwindow Moment.
      Win_RSI_old=0;                          // Old number of subwindow RSI
color Color[5];                               // Declaration of the color array
string Text[5];                               // Declaration of the string array
//------------------------------------------------------------------------------ 2 --
int init()                                    // Special function init()
  {   
   Win_RSI_old=0;                             // Technical moment
   Win_Mom_old=0;                             // Technical moment
 
   Text[0]= "RSI(14) is below 30. Buy";       // Texts for situations RSI
   Text[1]= "RSI(14) is above 70. Sell";      // Texts for situations RSI
   Text[2]= "RSI(14) is between 30 and 70";   // Texts for situations RSI
   Text[3]= "Momentum(14) is growing";        // Texts for situations Momentum
   Text[4]= "Momentum(14) is sinking";        // Texts for situations Momentum
   Color[0]= DeepSkyBlue;                     // Object color for ..
   Color[1]= LightPink;                       // .. different situations ..
   Color[2]= Orange;                          // .. of the indicator RSI
   Color[3]= Color[0];                        // The same colors for Momentum
   Color[4]= Color[1];                        // The same colors for Momentum
 
   Create_RSI(0);                             // Creation of the first object
   Create_Mom(0);                             // Creation of the second object
   Main();                                    // Call to user-defined function
   return;                                    // Exit init()
  }
//------------------------------------------------------------------------------ 3 --
int start()                                   // Special function 'start'
  {
   Main();                                    // Call to the user-defined function
   return;                                    // Exit start()
  }
//------------------------------------------------------------------------------ 4 --
int deinit()                                  // Special function deinit()
  {
   ObjectDelete("Obj_RSI");                   // Deletion of the object
   ObjectDelete("Obj_Mom");                   // Deletion of the object
   return;                                    // Exit deinit()
  }
//------------------------------------------------------------------------------ 5 --
int Main()                                    // User-defined function
  {
   int                                        // Integer variables
   Win_RSI_new=0,                             // New number of the subwindow RSI
   Win_Mom_new=0,                             // New number of the subwindow Moment.
   Ind_RSI, Ind_Mom;                          // Indexes for situations
   double                                     // Real variables
   RSI,                                       // Value of RSI on bar 0
   Mom_0, Mom_1;                              // Value of Mom. on bars 0 and 1
//------------------------------------------------------------------------------ 6 --
   RSI=iRSI(NULL,0,14,PRICE_CLOSE,0);         // RSI(14) on zero bar
   Ind_RSI=2;                                 // RSI between levels 30 and 70
   if(RSI < 30)Ind_RSI=0;                     // RSI at the bottom. To buy
   if(RSI > 70)Ind_RSI=1;                     // RSI on the top. To sell     
//------------------------------------------------------------------------------ 7 --
   Win_RSI_new=WindowFind("RSI(14)");         // Window number of indicator RSI
   if(Win_RSI_new==-1) Win_RSI_new=0;         // If there is no ind., then the main window
   if(Win_RSI_new!=Win_RSI_old)               // Deleted or placed ..
     {                                        // .. window of indicator RSI
      ObjectDelete("Obj_RSI");                // Deletion of the object
      Create_RSI(Win_RSI_new);                // Create an object in the desired window
      Win_RSI_old=Win_RSI_new;                // Remember this window
     }                                        // Change the textual description:
   ObjectSetText("Obj_RSI",Text[Ind_RSI],10,"Arial",Color[Ind_RSI]);
//------------------------------------------------------------------------------ 8 --
   Mom_0=iMomentum(NULL,0,14,PRICE_CLOSE,0);  // Value on zero bar
   Mom_1=iMomentum(NULL,0,14,PRICE_CLOSE,1);  // Value on the preceding bar 
   if(Mom_0 >=Mom_1)Ind_Mom=3;                // Indicator line goes up
   if(Mom_0 < Mom_1)Ind_Mom=4;                // Indicator line goes down
//------------------------------------------------------------------------------ 9 --
   Win_Mom_new=WindowFind("Momentum(14)");    // Window number of indicator Momen
   if(Win_Mom_new==-1) Win_Mom_new=0;         // If there is no ind., then the main window
   if(Win_Mom_new!=Win_Mom_old)               // Deleted or placed ..
     {                                        // .. the window of Momentum indicator
      ObjectDelete("Obj_Mom");                // Deletion of the object
      Create_Mom(Win_Mom_new);                // Create an object in the desired window
      Win_Mom_old=Win_Mom_new;                // Remember this window
     }                                        // Change the textual description:
   ObjectSetText("Obj_Mom",Text[Ind_Mom],10,"Arial",Color[Ind_Mom]);
//----------------------------------------------------------------------------- 10 --
   WindowRedraw();                            // Redrawing the image 
   return;                                    // Exit the user-defined function
  }
//----------------------------------------------------------------------------- 11 --
int Create_RSI(int Win)                       // User-defined function
  {                                           // ..of creation of an object
   ObjectCreate("Obj_RSI",OBJ_LABEL, Win, 0,0); // Creation of an object
   ObjectSet("Obj_RSI", OBJPROP_CORNER, 0);     // Anchoring to an angle
   ObjectSet("Obj_RSI", OBJPROP_XDISTANCE, 3);  // Coordinate X
   if (Win==0)
      ObjectSet("Obj_RSI",OBJPROP_YDISTANCE,20);// Coordinate Y
   else
      ObjectSet("Obj_RSI",OBJPROP_YDISTANCE,15);// Coordinate Y
   return;                                      // Exit the user-defined function
  }
//----------------------------------------------------------------------------- 12 --
int Create_Mom(int Win)                         // User-defined function
  {                                             // ..creating an object
   ObjectCreate("Obj_Mom",OBJ_LABEL, Win, 0,0); // Creation of an object
   ObjectSet("Obj_Mom", OBJPROP_CORNER, 0);     // Anchoring to an angle
   ObjectSet("Obj_Mom", OBJPROP_XDISTANCE, 3);  // Coordinate X
   if (Win==0)
      ObjectSet("Obj_Mom",OBJPROP_YDISTANCE, 5);// Coordinate Y
   else
      ObjectSet("Obj_Mom",OBJPROP_YDISTANCE,15);// Coordinate Y
   return;                                      // Exit the user-defined function
  }
//----------------------------------------------------------------------------- 13 --