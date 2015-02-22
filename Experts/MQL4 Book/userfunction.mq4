//--------------------------------------------------------------------
// userfunction.mq4
// To be used as an example in MQL4 book.
//--------------------------------------------------------------------
int Count=0;                                    // Global variable
//--------------------------------------------------------------------
int init()                                      // Special funct. init()
   {
   Alert ("Function init() triggered at start");// Alert
   return;                                      // Exit init()
   }   
//--------------------------------------------------------------------
int start()                                     // Special funct. start()
   {
   double Price = Bid;                          // Local variable
   My_Function();                               // Custom funct. call
   Alert("New tick ",Count,"   Price = ",Price);// Alert
   return;                                      // Exit start()
   }
//--------------------------------------------------------------------
int deinit()                                    // Special funct. deinit()
   {
   Alert ("Function deinit() triggered at exit");// Alert
   return;                                      // Exit deinit()
   }
//--------------------------------------------------------------------
int My_Function()                               // Custom funct. description
   {
   Count++;                                     // Counter of calls 
   }
//--------------------------------------------------------------------