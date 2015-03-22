//--------------------------------------------------------------------
// moveobjects.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
extern int   Len_Cn=50;                // Channel length (bars)
extern color Col_Cn=Orange;            // Channel color
//--------------------------------------------------------------- 1 --
int init()                             // Special function init()
  {
   Create();                           // Calling user-def. func. of creation
   return;                             // Exit init()
  }
//--------------------------------------------------------------- 2 --
int start()                            // Special function start()
  {
   datetime T2;                        // Second time coordinate
   int Error;                          // Error code
//--------------------------------------------------------------- 3 --   
   T2=ObjectGet("Obj_Reg_Ch",OBJPROP_TIME2);// Requesting t2 coord.
   Error=GetLastError();               // Getting an error code
   if (Error==4202)                    // If no object :(
     {
      Alert("Regression channel is being managed",
            "\n Book_expert_82_2. deletion prohibited.");
      Create();                        // Calling user-def. func. of creation
      T2=Time[0];                      // Current value of t2 coordinate
     }
//--------------------------------------------------------------- 4 --
   if (T2!=Time[0])                    // If object is not in its place
     {
      ObjectMove("Obj_Reg_Ch", 0, Time[Len_Cn-1],0); //New t1 coord.
      ObjectMove("Obj_Reg_Ch", 1, Time[0],       0); //New t2 coord.
      WindowRedraw();                  // Redrawing the image 
     }
   return;                             // Exit start()
  }
//--------------------------------------------------------------- 5 --
int deinit()                           // Special function deinit()
  {
   ObjectDelete("Obj_Reg_Ch");         // Deleting the object
   return;                             // Exit deinit()
  }
//--------------------------------------------------------------- 6 --
int Create()                           // User-defined function..
  {                                    // ..of object creation
   datetime T1=Time[Len_Cn-1];         // Defining 1st time coord.
   datetime T2=Time[0];                // Defining 2nd time coord.
   ObjectCreate("Obj_Reg_Ch",OBJ_REGRESSION,0,T1,0,T2,0);// Creation
   ObjectSet(   "Obj_Reg_Ch", OBJPROP_COLOR, Col_Cn);    // Color
   ObjectSet(   "Obj_Reg_Ch", OBJPROP_RAY,   false);     // Ray
   ObjectSet(   "Obj_Reg_Ch", OBJPROP_STYLE, STYLE_DASH);// Style
   ObjectSetText("Obj_Reg_Ch","Created by the EA moveobjects",10);
   WindowRedraw();                     // Image redrawing
  }
//--------------------------------------------------------------- 7 --