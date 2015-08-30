//+------------------------------------------------------------------+
//| 0-A-SL-1000                                                      |
//| Copyright 2012, File45.                                          |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, File45"
#property link      "http://codebase.mql4.com/en/author/file45"
#property show_inputs

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

extern int StopLoss = 1000;

double itotal,pp;
     
int start()
{ 
   itotal=OrdersTotal();
   for(int cnt=itotal-1;cnt>=0;cnt--) 
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      
      if (OrderSymbol()==Symbol() && OrderType()==OP_BUY)
      {
         if (StopLoss == 0)
         {
             ModifyStopLoss(0);
         }
         else
         {
             ModifyStopLoss(OrderOpenPrice() - StopLoss*Point);
         } 
      }
      
      if (OrderSymbol()==Symbol() && OrderType()==OP_SELL)
      {
         if (StopLoss == 0)
         {
             ModifyStopLoss(0);
         }       
         else
         {
            ModifyStopLoss(OrderOpenPrice() + StopLoss*Point);
         }        
      }  
   }
   return(0);
}

void ModifyStopLoss(double ldStopLoss) 
{
   bool fmSL;
   fmSL=OrderModify(OrderTicket(),OrderOpenPrice(),ldStopLoss,OrderTakeProfit(),0,CLR_NONE);
}

