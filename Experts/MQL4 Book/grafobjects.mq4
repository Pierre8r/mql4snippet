//--------------------------------------------------------------------
// grafobjects.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
int start()                            // Special function start
  {
//--------------------------------------------------------------- 1 --
   int Sit;
   double MACD_M_0,MACD_M_1,           // Main line, 0 and 1st bar
   MACD_S_0,MACD_S_1;                  // Signal line, 0 and 1st bar
   string Text[4];                     // Declaring a string array
   color  Color[4];                    // Declaring an array of colors
 
   Text[0]= "Opening of Buy";          // Text for different situations
   Text[1]= "Opening of Sell";
   Text[2]= "Holding of Buy";
   Text[3]= "Holding of Sell";
 
   Color[0]= DeepSkyBlue;              // Object color ..
   Color[1]= LightPink;                // .. for different situations
   Color[2]= Yellow;
   Color[3]= Yellow;
//--------------------------------------------------------------- 2 --
   ObjectCreate("Label_Obj_MACD", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_Obj_MACD", OBJPROP_CORNER, 1);    // Reference corner
   ObjectSet("Label_Obj_MACD", OBJPROP_XDISTANCE, 10);// X coordinate
   ObjectSet("Label_Obj_MACD", OBJPROP_YDISTANCE, 15);// Y coordinate
//--------------------------------------------------------------- 3 --
   MACD_M_0 =iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);  // 0 bar
   MACD_S_0 =iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);// 0 bar
   MACD_M_1 =iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);  // 1 bar
   MACD_S_1 =iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);// 1 bar
//--------------------------------------------------------------- 4 --
   // Analyzing situation 
   if(MACD_M_1=MACD_S_0)                      // Crossing upwards
      Sit=0;
   if(MACD_M_1>MACD_S_1 && MACD_M_0<=MACD_S_0)// Crossing downwards
      Sit=1;
   if(MACD_M_1>MACD_S_1 && MACD_M_0>MACD_S_0) // Main above signal
      Sit=2;
   if(MACD_M_1