//--------------------------------------------------------------------
// countticks.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
int Tick;                              // Global variable
//--------------------------------------------------------------------
int start()                            // Special function start()
  {
   Tick++;                             // Tick counter
   Comment("Received: tick No ",Tick); // Alert that contains number
   return;                             // start() exit operator
  }
//--------------------------------------------------------------------