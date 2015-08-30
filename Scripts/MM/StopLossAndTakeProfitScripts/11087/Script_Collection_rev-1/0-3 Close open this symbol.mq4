//+------------------------------------------------------------------+
//|                                          CloseAll_ThisSymbol.mq4 |
//|                               Copyright © 2011, Patrick M. White |
//|                     https://sites.google.com/site/marketformula/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Patrick M. White"
#property link      "https://sites.google.com/site/marketformula/"
// last updated November 11, 2011

// when MagicNumber = -1 then close all magic numbers
extern int MagicNumber = -1;

// pips of slippage to allow
extern int Slippage = 7; 

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   while(OrdersTotal() >0) {
      CloseThis(Slippage, MagicNumber);
      break;
   }
//--
   return(0);
  }
//+------------------------------------------------------------------+
// when MagicNumber = -1 then close all magic numbers
void CloseThis(int Slippage, int MagicNumber) {
   bool closed = false;
   for (int i = OrdersTotal(); i >=0; i--) {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      while(IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      if (OrderType() == OP_BUY && Symbol() == OrderSymbol() 
      && (MagicNumber == OrderMagicNumber() || MagicNumber == -1)) {
        closed = OrderClose( OrderTicket(), OrderLots(), Bid, Slippage, White);
      }
      if (OrderType() == OP_SELL && Symbol() == OrderSymbol()
       && (MagicNumber == OrderMagicNumber() || MagicNumber == -1)) {
        closed = OrderClose( OrderTicket(), OrderLots(), Ask, Slippage, White);
      }
   }
return(0);

}

