//--------------------------------------------------------------------
// dialogue.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------- 1 --
#include <WinUser32.mqh>               // Needed to MessageBox
extern double Time_News=15.30;         // Time of important news
bool Question=false;                   // Flag (question is not put yet)
//--------------------------------------------------------------- 2 --
int start()                            // Special function start
  {
   PlaySound("tick.wav");              // At each tick
   double Time_cur=Hour()+ Minute()/100.0;// Current time (double)
   if (OrdersTotal()>0 && Question==false && Time_cur<=Time_News-0.05)
     {                                 // Providing some conditions
      PlaySound("news.wav");           // At each tick
      Question=true;                   // Flag (question is already put)
      int ret=MessageBox("Time of important news release. Close all orders?",
      "Question", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST); // Message box
      //--------------------------------------------------------- 3 --
      if(ret==IDYES)                   // If the answer is Yes
         Close_Orders();               // Close all orders
     }
   return;                             // Exit 
  }
//--------------------------------------------------------------- 4 --
void Close_Orders()                    // Cust. funct. for closing orders
  {
   Alert("Function of closing all orders is being executed.");// For illustration
   return;                             // Exit 
  }
//--------------------------------------------------------------- 5 --