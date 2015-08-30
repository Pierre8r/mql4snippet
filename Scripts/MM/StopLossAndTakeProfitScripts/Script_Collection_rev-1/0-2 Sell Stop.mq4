#property copyright "Copyright 2014, File45"
#property link      "http://codebase.mql4.com/en/author/file45"
#property show_inputs

#include <stdlib.mqh>
#include <WinUser32.mqh>
#property show_inputs

// Default Inputs: Start
extern double Sell_Lots  = 0.01;
extern double Sell_Stop_Price = 0.0;
extern int Slippage = 3;
extern int StopLoss = 0;
extern int TakeProfit = 0;
// Default Inputs: End

int start()
{
   if(Sell_Stop_Price > Bid)
   {
      Alert("Error: Sell_Stop_Price must be less than Bid") ;
      return;
   }    
   
   string SL =  DoubleToStr(Sell_Lots,2);
   
   if(MessageBox("SELL STOP : " + SL + " lots at " + DoubleToStr(Sell_Stop_Price,Digits) + " " + Symbol(),
                 "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return(1);
//----
   int ticket=OrderSend(Symbol(),OP_SELLSTOP,Sell_Lots,Sell_Stop_Price,Slippage,StopLoss,TakeProfit,"expert comment",255,0,CLR_NONE);
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

