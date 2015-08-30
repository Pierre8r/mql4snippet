#property copyright "Copyright 2014, File45"
#property link      "http://codebase.mql4.com/en/author/file45"
#property show_inputs

#include <stdlib.mqh>
#include <WinUser32.mqh>
#property show_inputs

// Script: 0-1-Buy   

// Default Inputs: Start
extern double Buy_Lots  = 0.01;
extern int Buy_Slippage = 3;
// Default Inputs: Start

int start()
  {
   string BL =  DoubleToStr(Buy_Lots,2);
   string BM =  DoubleToStr(Ask,Digits);
   
   if(MessageBox("BUY : " + BL + " lots at " + BM + " " + Symbol(),
   "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return(1);
//----
   int ticket=OrderSend(Symbol(),OP_BUY,Buy_Lots,Ask,Buy_Slippage,0,0,"expert comment",255,0,CLR_NONE);
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

