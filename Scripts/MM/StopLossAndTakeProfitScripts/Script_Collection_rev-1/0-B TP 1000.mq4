//+------------------------------------------------------------------+
//| 0-A-TP-1000                                                      |
//| Copyright 2012, File45.                                          |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, File45"
#property link      "http://codebase.mql4.com/en/author/file45"
#property show_inputs

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

extern int Take_Profit = 1000;

double itotal,pp;
     
int start()
{ 
   itotal=OrdersTotal();
   for(int cnt=itotal-1;cnt>=0;cnt--) 
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      
      if (OrderSymbol()==Symbol() && OrderType()==OP_BUY)
      {
         if (Take_Profit == 0)
         {
             ModifyTakeProfit(0);
         }
         else
         {
             ModifyTakeProfit(OrderOpenPrice() + Take_Profit*Point);
         } 
      }
      
      if (OrderSymbol()==Symbol() && OrderType()==OP_SELL)
      {
         if (Take_Profit == 0)
         {
             ModifyTakeProfit(0);
         }       
         else
         {   
            ModifyTakeProfit(OrderOpenPrice() - Take_Profit*Point);
         }        
      }  
   }
   return(0);
}

void ModifyTakeProfit(double idTakeProfit) 
{
   bool fmTP;
   fmTP=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),idTakeProfit,0,CLR_NONE);
}

