//+------------------------------------------------------------------+
//|                                                        close.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
#property show_confirm

//+------------------------------------------------------------------+
//| script "close first market order if it is first in the list"     |
//+------------------------------------------------------------------+
int start()
  {
   bool   result;
   double price;
   int    cmd,error;
//----
   if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
     {
      cmd=OrderType();
      //---- first order is buy or sell
      if(cmd==OP_BUY || cmd==OP_SELL)
        {
         while(true)
           {
            if(cmd==OP_BUY) price=Bid;
            else            price=Ask;
            result=OrderClose(OrderTicket(),OrderLots(),price,3,CLR_NONE);
            if(result!=TRUE) { error=GetLastError(); Print("LastError = ",error); }
            else error=0;
            if(error==135) RefreshRates();
            else break;
           }
        }
     }
   else Print( "Error when order select ", GetLastError());
//----
   return(0);
  }
//+------------------------------------------------------------------+