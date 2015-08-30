//+------------------------------------------------------------------+
//|                                        VisualOpenOrderWithMM.mq4 |
//|                                                             Itso |
//|                                                      itso@dir.bg |
//+------------------------------------------------------------------+
#property copyright "Itso"
#property link      "itso@dir.bg"
#property show_inputs
#include <stdlib.mqh>

extern double Risk = 0.05;

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   double MinLot = MarketInfo(Symbol(), MODE_MINLOT);
   double MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   double Step = MarketInfo(Symbol(), MODE_LOTSTEP);

   double StopLoss = WindowPriceOnDropped();
   double MoneyRisk = AccountFreeMargin() * Risk;
   double TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);

   double PointLoss;
   int cmd;
   double price;
   if(Ask>StopLoss)
   {
      //Open Long
      PointLoss = (Ask - StopLoss) / Point;
      cmd = OP_BUY;
      price = Ask;
   }
   else
   {
      //Open Short
      PointLoss = (StopLoss - Bid) / Point;
      cmd = OP_SELL;
      price = Bid;
   }

   double LotsRough = MoneyRisk / (TickValue * PointLoss);
   if(LotsRough<MinLot)
   {
      Print("Error. You don\'t have enough money!");
      return(0);
   }
   
   double Lots = MaxLot;
   for(double CheckedLot=MinLot; CheckedLot<=MaxLot; CheckedLot+=Step)
   {
      if(CheckedLot>LotsRough)
      {
         Lots = CheckedLot - Step;
         break;
      }
   }
   
   Print("Lots=",Lots);
   
   int ticket = OrderSend(Symbol(), cmd, Lots, price, 3, StopLoss, 0);
   if (ticket<0)
   {
      Print("Error: ", ErrorDescription(GetLastError()));
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+