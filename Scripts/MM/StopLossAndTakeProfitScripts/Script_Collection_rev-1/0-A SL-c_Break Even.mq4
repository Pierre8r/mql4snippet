//+------------------------------------------------------------------+
//| 0-A-SL-mBE                                                       |
//| Copyright 2012, File45.                                          |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, File45"
#property link      "http://codebase.mql4.com/en/author/file45"
#property show_inputs

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

int StopLoss;

double itotal,pp;
     
int start()
{ 
   itotal=OrdersTotal();
   
   for(int cnt=itotal-1;cnt>=0;cnt--) 
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      
      if (OrderSymbol()==Symbol() && OrderType()==OP_BUY)
      {
         ModifyStopLoss(OrderOpenPrice());     
      }
      
      if (OrderSymbol()==Symbol() && OrderType()==OP_SELL)
      {
         ModifyStopLoss(OrderOpenPrice());       
      }  
   
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && Bid < OrderOpenPrice())
      {
         Alert("Unable to place SL Break Even - Bid below Order Open Price - Trade in Loss");
      }   
      
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && Ask > OrderOpenPrice())
      {
         Alert("Unable to place SL Break Even - Ask above Order Open Price - Trade in Loss");
      }   
   }
   return(0);
}

void ModifyStopLoss(double ldStopLoss) 
{
   bool fmSL;
   fmSL=OrderModify(OrderTicket(),OrderOpenPrice(),ldStopLoss,OrderTakeProfit(),0,CLR_NONE);
}

