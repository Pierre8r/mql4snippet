//------------------------------------------------------------------------------------
// modifystoploss.mq4
// The code should be used for educational purpose only.
//------------------------------------------------------------------------------------
extern int Tral_Stop=10;                        // Trailing distance
//------------------------------------------------------------------------------- 1 --
int start()                                     // Special function 'start'
  {
   string Symb=Symbol();                        // Symbol
//------------------------------------------------------------------------------- 2 --
   for(int i=1; i<=OrdersTotal(); i++)          // Cycle searching in orders
     {
      if (OrderSelect(i-1,SELECT_BY_POS)==true) // If the next is available
        {                                       // Analysis of orders:
         int Tip=OrderType();                   // Order type
         if(OrderSymbol()!=Symb||Tip>1)continue;// The order is not "ours"
         double SL=OrderStopLoss();             // SL of the selected order
         //---------------------------------------------------------------------- 3 --
         while(true)                            // Modification cycle
           {
            double TS=Tral_Stop;                // Initial value
            int Min_Dist=MarketInfo(Symb,MODE_STOPLEVEL);//Min. distance
            if (TS < Min_Dist)                  // If less than allowed
               TS=Min_Dist;                     // New value of TS
            //------------------------------------------------------------------- 4 --
            bool Modify=false;                  // Not to be modified
            switch(Tip)                         // By order type
              {
               case 0 :                         // Order Buy
                  if (NormalizeDouble(SL,Digits)< // If it is lower than we want
                     NormalizeDouble(Bid-TS*Point,Digits))
                    {
                     SL=Bid-TS*Point;           // then modify it
                     string Text="Buy ";        // Text for Buy 
                     Modify=true;               // To be modified
                    }
                  break;                        // Exit 'switch'
               case 1 :                         // Order Sell
                  if (NormalizeDouble(SL,Digits)> // If it is higher than we want
                     NormalizeDouble(Ask+TS*Point,Digits)
                     || NormalizeDouble(SL,Digits)==0)//or equal to zero
                    {
                     SL=Ask+TS*Point;           // then modify it
                     Text="Sell ";              // Text for Sell 
                     Modify=true;               // To be modified
                    }
              }                                 // End of 'switch'
            if (Modify==false)                  // If it is not modified
               break;                           // Exit 'while'
            //------------------------------------------------------------------- 5 --
            double TP    =OrderTakeProfit();    // TP of the selected order
            double Price =OrderOpenPrice();     // Price of the selected order
            int    Ticket=OrderTicket();        // Ticket of the selected order
 
            Alert ("Modification ",Text,Ticket,". Awaiting response..");
            bool Ans=OrderModify(Ticket,Price,SL,TP,0);//Modify it!
            //------------------------------------------------------------------- 6 --
            if (Ans==true)                      // Got it! :)
              {
               Alert ("Order ",Text,Ticket," is modified:)");
               break;                           // From modification cycle.
              }
            //------------------------------------------------------------------- 7 --
            int Error=GetLastError();           // Failed :(
            switch(Error)                       // Overcomable errors
              {
               case 130:Alert("Wrong stops. Retrying.");
                  RefreshRates();               // Update data
                  continue;                     // At the next iteration
               case 136:Alert("No prices. Waiting for a new tick..");
                  while(RefreshRates()==false)  // To the new tick
                     Sleep(1);                  // Cycle delay
                  continue;                     // At the next iteration
               case 146:Alert("Trading subsystem is busy. Retrying ");
                  Sleep(500);                   // Simple solution
                  RefreshRates();               // Update data
                  continue;                     // At the next iteration
                  // Critical errors
               case 2 : Alert("Common error.");
                  break;                        // Exit 'switch'
               case 5 : Alert("Old version of the client terminal.");
                  break;                        // Exit 'switch'
               case 64: Alert("Account is blocked.");
                  break;                        // Exit 'switch'
               case 133:Alert("Trading is prohibited");
                  break;                        // Exit 'switch'
               default: Alert("Occurred error ",Error);//Other errors
              }
            break;                              // From modification cycle
           }                                    // End of modification cycle
         //---------------------------------------------------------------------- 8 --
        }                                       // End of order analysis
     }                                          // End of order search
//------------------------------------------------------------------------------- 9 --
   return;                                      // Exit start()
  }
//------------------------------------------------------------------------------ 10 --