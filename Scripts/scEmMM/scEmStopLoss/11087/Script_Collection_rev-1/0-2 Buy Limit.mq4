#property copyright "Copyright 2014, File45"
#property link      "http://codebase.mql4.com/en/author/file45"
#property show_inputs

#include <stdlib.mqh>
#include <WinUser32.mqh>
#property show_inputs

// Default Inputs: Start
extern double Buy_Lots  = 0.01;
extern double Buy_Limit_Price = 0.0;
extern int Slippage = 3;
extern int StopLoss = 0;
extern int TakeProfit = 0;
// Default Inputs: End

int start()
{
   string x = DoubleToStr(Ask,Digits);
   
   if(Buy_Limit_Price > Ask)
   {
      Alert("Error: Buy_Limit_Price must be less than " + x) ;
      return;
   }    
   
   string BL =  DoubleToStr(Buy_Lots,2);
   
   if(MessageBox("BUY LIMIT: " + BL + " lots at " + DoubleToStr(Buy_Limit_Price,Digits) + " " + Symbol(),
                 "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return(1);
//----
   int ticket=OrderSend(Symbol(),OP_BUYLIMIT,Buy_Lots,Buy_Limit_Price,Slippage,StopLoss,TakeProfit,"expert comment",255,0,CLR_NONE);
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

