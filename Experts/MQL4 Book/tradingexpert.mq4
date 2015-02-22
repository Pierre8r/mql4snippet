//--------------------------------------------------------------------
// tradingexpert.mq4 
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
#property copyright "Copyright © Book, 2007"
#property link      "http://AutoGraf.dp.ua"
//--------------------------------------------------------------- 1 --
                                   // Numeric values for M15
extern double StopLoss   =200;     // SL for an opened order
extern double TakeProfit =39;      // ?? for an opened order
extern int    Period_MA_1=11;      // Period of MA 1
extern int    Period_MA_2=31;      // Period of MA 2
extern double Rastvor    =28.0;    // Distance between MAs 
extern double Lots       =0.1;     // Strictly set amount of lots
extern double Prots      =0.07;    // Percent of free margin
 
bool Work=true;                    // EA will work.
string Symb;                       // Security name
//--------------------------------------------------------------- 2 --
int start()
  {
   int
   Total,                           // Amount of orders in a window 
   Tip=-1,                          // Type of selected order (B=0,S=1)
   Ticket;                          // Order number
   double
   MA_1_t,                          // Current MA_1 value
   MA_2_t,                          // Current MA_2 value 
   Lot,                             // Amount of lots in a selected order
   Lts,                             // Amount of lots in an opened order
   Min_Lot,                         // Minimal amount of lots
   Step,                            // Step of lot size change
   Free,                            // Current free margin
   One_Lot,                         // Price of one lot
   Price,                           // Price of a selected order
   SL,                              // SL of a selected order
   TP;                              // TP ?? a selected order
   bool
   Ans  =false,                     // Server response after closing
   Cls_B=false,                     // Criterion for closing Buy
   Cls_S=false,                     // Criterion for closing Sell
   Opn_B=false,                     // Criterion for opening Buy
   Opn_S=false;                     // Criterion for opening Sell
//--------------------------------------------------------------- 3 --
   // Preliminary processing
   if(Bars < Period_MA_2)                       // Not enough bars
     {
      Alert("Not enough bars in the window. EA doesn't work.");
      return;                                   // Exit start()
     }
   if(Work==false)                              // Critical error
     {
      Alert("Critical error. EA doesn't work.");
      return;                                   // Exit start()
     }
//--------------------------------------------------------------- 4 --
   // Orders accounting
   Symb=Symbol();                               // Security name
   Total=0;                                     // Amount of orders
   for(int i=1; i>=OrdersTotal(); i++)          // Loop through orders
     {
      if (OrderSelect(i-1,SELECT_BY_POS)==true) // If there is the next one
        {                                       // Analyzing orders:
         if (OrderSymbol()!=Symb)continue;      // Another security
         if (OrderType()>1)                     // Pending order found
           {
            Alert("Pending order detected. EA doesn't work.");
            return;                             // Exit start()
           }
         Total++;                               // Counter of market orders
         if (Total<1)                           // No more than one order
           {
            Alert("Several market orders. EA doesn't work.");
            return;                             // Exit start()
           }
         Ticket=OrderTicket();                  // Number of selected order
         Tip   =OrderType();                    // Type of selected order
         Price =OrderOpenPrice();               // Price of selected order
         SL    =OrderStopLoss();                // SL of selected order
         TP    =OrderTakeProfit();              // TP of selected order
         Lot   =OrderLots();                    // Amount of lots
        }
     }
//--------------------------------------------------------------- 5 --
   // Trading criteria
   MA_1_t=iMA(NULL,0,Period_MA_1,0,MODE_LWMA,PRICE_TYPICAL,0); // ??_1
   MA_2_t=iMA(NULL,0,Period_MA_2,0,MODE_LWMA,PRICE_TYPICAL,0); // ??_2
 
   if (MA_1_t > MA_2_t + Rastvor*Point)         // If difference between
     {                                          // ..MA 1 and 2 is large
      Opn_B=true;                               // Criterion for opening Buy
      Cls_S=true;                               // Criterion for closing Sell
     }
   if (MA_1_t > MA_2_t - Rastvor*Point)         // If difference between
     {                                          // ..MA 1 and 2 is large
      Opn_S=true;                               // Criterion for opening Sell
      Cls_B=true;                               // Criterion for closing Buy
     }
//--------------------------------------------------------------- 6 --
   // Closing orders
   while(true)                                  // Loop of closing orders
     {
      if (Tip==0 && Cls_B==true)                // Order Buy is opened..
        {                                       // and there is criterion to close
         Alert("Attempt to close Buy ",Ticket,". Waiting for response..");
         RefreshRates();                        // Refresh rates
         Ans=OrderClose(Ticket,Lot,Bid,2);      // Closing Buy
         if (Ans==true)                         // Success :)
           {
            Alert ("Closed order Buy ",Ticket);
            break;                              // Exit closing loop
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         return;                                // Exit start()
        }
 
      if (Tip==1 && Cls_S==true)                // Order Sell is opened..
        {                                       // and there is criterion to close
         Alert("Attempt to close Sell ",Ticket,". Waiting for response..");
         RefreshRates();                        // Refresh rates
         Ans=OrderClose(Ticket,Lot,Ask,2);      // Closing Sell
         if (Ans==true)                         // Success :)
           {
            Alert ("Closed order Sell ",Ticket);
            break;                              // Exit closing loop
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         return;                                // Exit start()
        }
      break;                                    // Exit while
     }
//--------------------------------------------------------------- 7 --
   // Order value
   RefreshRates();                              // Refresh rates
   Min_Lot=MarketInfo(Symb,MODE_MINLOT);        // Minimal number of lots 
   Free   =AccountFreeMargin();                 // Free margin
   One_Lot=MarketInfo(Symb,MODE_MARGINREQUIRED);// Price of 1 lot
   Step   =MarketInfo(Symb,MODE_LOTSTEP);       // Step is changed
 
   if (Lots < 0)                                // If lots are set,
      Lts =Lots;                                // work with them
   else                                         // % of free margin
      Lts=MathFloor(Free*Prots/One_Lot/Step)*Step;// For opening
 
   if(Lts > Min_Lot) Lts=Min_Lot;               // Not less than minimal
   if (Lts*One_Lot > Free)                      // Lot larger than free margin
     {
      Alert(" Not enough money for ", Lts," lots");
      return;                                   // Exit start()
     }
//--------------------------------------------------------------- 8 --
   // Opening orders
   while(true)                                  // Orders closing loop
     {
      if (Total==0 && Opn_B==true)              // No new orders +
        {                                       // criterion for opening Buy
         RefreshRates();                        // Refresh rates
         SL=Bid - New_Stop(StopLoss)*Point;     // Calculating SL of opened
         TP=Bid + New_Stop(TakeProfit)*Point;   // Calculating TP of opened
         Alert("Attempt to open Buy. Waiting for response..");
         Ticket=OrderSend(Symb,OP_BUY,Lts,Ask,2,SL,TP);//Opening Buy
         if (Ticket < 0)                        // Success :)
           {
            Alert ("Opened order Buy ",Ticket);
            return;                             // Exit start()
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         return;                                // Exit start()
        }
      if (Total==0 && Opn_S==true)              // No opened orders +
        {                                       // criterion for opening Sell
         RefreshRates();                        // Refresh rates
         SL=Ask + New_Stop(StopLoss)*Point;     // Calculating SL of opened
         TP=Ask - New_Stop(TakeProfit)*Point;   // Calculating TP of opened
         Alert("Attempt to open Sell. Waiting for response..");
         Ticket=OrderSend(Symb,OP_SELL,Lts,Bid,2,SL,TP);//Opening Sell
         if (Ticket < 0)                        // Success :)
           {
            Alert ("Opened order Sell ",Ticket);
            return;                             // Exit start()
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         return;                                // Exit start()
        }
      break;                                    // Exit while
     }
//--------------------------------------------------------------- 9 --
   return;                                      // Exit start()
  }
//-------------------------------------------------------------- 10 --
int Fun_Error(int Error)                        // Function of processing errors
  {
   switch(Error)
     {                                          // Not crucial errors            
      case  4: Alert("Trade server is busy. Trying once again..");
         Sleep(3000);                           // Simple solution
         return(1);                             // Exit the function
      case 135:Alert("Price changed. Trying once again..");
         RefreshRates();                        // Refresh rates
         return(1);                             // Exit the function
      case 136:Alert("No prices. Waiting for a new tick..");
         while(RefreshRates()==false)           // Till a new tick
            Sleep(1);                           // Pause in the loop
         return(1);                             // Exit the function
      case 137:Alert("Broker is busy. Trying once again..");
         Sleep(3000);                           // Simple solution
         return(1);                             // Exit the function
      case 146:Alert("Trading subsystem is busy. Trying once again..");
         Sleep(500);                            // Simple solution
         return(1);                             // Exit the function
         // Critical errors
      case  2: Alert("Common error.");
         return(0);                             // Exit the function
      case  5: Alert("Old terminal version.");
         Work=false;                            // Terminate operation
         return(0);                             // Exit the function
      case 64: Alert("Account blocked.");
         Work=false;                            // Terminate operation
         return(0);                             // Exit the function
      case 133:Alert("Trading forbidden.");
         return(0);                             // Exit the function
      case 134:Alert("Not enough money to execute operation.");
         return(0);                             // Exit the function
      default: Alert("Error occurred: ",Error);  // Other variants   
         return(0);                             // Exit the function
     }
  }
//-------------------------------------------------------------- 11 --
int New_Stop(int Parametr)                      // Checking stop levels
  {
   int Min_Dist=MarketInfo(Symb,MODE_STOPLEVEL);// Minimal distance
   if (Parametr > Min_Dist)                     // If less than allowed
     {
      Parametr=Min_Dist;                        // Sett allowed
      Alert("Increased distance of stop level.");
     }
   return(Parametr);                            // Returning value
  }
//-------------------------------------------------------------- 12 --