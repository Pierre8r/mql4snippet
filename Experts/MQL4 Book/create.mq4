//--------------------------------------------------------------------
// create.mq4
// To be used as an example in MQL4 book.
//--------------------------------------------------------------------
int Count=0;                                    // Global variable
//--------------------------------------------------------------------
int init()                                      // Spec. funct. init()
   {
   Alert ("Funct. init() triggered at start");  // Alert
   return;                                      // Exit init()
   }   
//--------------------------------------------------------------------
int start()                                     // Spec. funct. start()
   {
   double Price = Bid;                          // Local variable
   Count++;                                     // Ticks counter
   Alert("New tick ",Count,"   Price = ",Price);// Alert
   return;                                      // Exit start()
   }
//--------------------------------------------------------------------
int deinit()                                    // Spec. funct. deinit()
   {
   Alert ("Funct. deinit() triggered at exit"); // Alert
   return;                                      // Exit deinit()
   }
//--------------------------------------------------------------------