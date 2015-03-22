//--------------------------------------------------------------------
// staticvar.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
int start()                            // Special function start()
  {
   static int Tick;                    // Static local variable
   Tick++;                             // Tick counter
   Comment("Received: tick No ",Tick); // Alert that contains number
   return;                             // start() exit operator
  }
//--------------------------------------------------------------------