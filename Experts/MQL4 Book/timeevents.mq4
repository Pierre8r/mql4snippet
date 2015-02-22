//--------------------------------------------------------------------
// timeevents.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------- 1 --
extern double Time_Cls=16.10;          // Orders closing time
bool Flag_Time=false;                  // Flag, there are no messages yet
//--------------------------------------------------------------- 2 --
int start()                            // Spec. start function
  {
   int    Cur_Hour=Hour();             // Server time in hours
   double Cur_Min =Minute();           // Server time in minutes
   double Cur_time=Cur_Hour + Cur_Min100; // Current time
   Alert(Cur_time);
   if (Cur_time>=Time_Cls)             // If the time for the event has come
      Executor();                      //.. then perform devised actions
   return;                             // Exit from start()
  }
//--------------------------------------------------------------- 3 --
int Executor()                         // User-defined function
  {
   if (Flag_Time==false)               // If there are no messages yet
     {                                 // .. then report (1 time)
      Alert("Important news time. Close orders.");
      Flag_Time=true;                  // Now the message has already appeared
     }
   return;                             // Exit user-defined function
  }
//--------------------------------------------------------------- 4 --