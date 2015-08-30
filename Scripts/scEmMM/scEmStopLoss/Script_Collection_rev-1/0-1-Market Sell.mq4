//+------------------------------------------------------------------+
//|                                                        trade.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#property show_inputs

extern double Sell_Lots = 0.01;
extern int Sell_Slippage = 3;
//+------------------------------------------------------------------+
//| script "trading for all money"                                   |
//+------------------------------------------------------------------+
int start()
  {
//----
   string SL =  DoubleToStr(Sell_Lots,2);
   string SM =  DoubleToStr(Bid,Digits);
                 
   if(MessageBox("BUY : " + SL + " lots at " + SM + " " + Symbol(),
      "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return(1);              
//----
   int ticket=OrderSend(Symbol(),OP_SELL,Sell_Lots,Bid,Sell_Slippage,0,0,"expert comment",255,0,CLR_NONE);
   if(ticket<1)
     {
      int error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      return;
     }
//----
   OrderPrint();
   return(0);
  }
//+------------------------------------------------------------------+