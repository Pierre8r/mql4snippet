//--------------------------------------------------------------------
// callstohastic.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
int start()                       // Special function start()
  {
   double M_0, M_1,               // Value MAIN on 0 and 1st bars
          S_0, S_1;               // Value SIGNAL on 0 and 1st bars
//--------------------------------------------------------------------
                                  // Tech. ind. function call
   M_0 = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,  0);// 0 bar
   M_1 = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,  1);// 1st bar
   S_0 = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);// 0 bar
   S_1 = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,1);// 1st bar
//--------------------------------------------------------------------
                                  // Analysis of the situation
   if( M_1 < S_1 && M_0 >= S_0 )  // Green line crosses red upwards
      Alert("Crossing upwards. BUY."); // Alert 
   if( M_1 > S_1 && M_0 <= S_0 )  // Green line crosses red downwards
      Alert("Crossing downwards. SELL."); // Alert 
      
   if( M_1 > S_1 && M_0 > S_0 )   // Green line higher than red
      Alert("Continue holding Buy position.");       // Alert 
   if( M_1 < S_1 && M_0 < S_0 )   // Green line lower than red
      Alert("Continue holding Buy position.");       // Alert 
//--------------------------------------------------------------------
   return;                         // Exit start()
  }
//--------------------------------------------------------------------