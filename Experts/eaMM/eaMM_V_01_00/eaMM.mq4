//+------------------------------------------------------------------+
//|                                                         eaMM.mq4 |
//|                                   Copyright 2015, Pierre Rougier |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Pierre Rougier"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "libLogger.mq4"

extern int exStopLossInPips=10;
bool isNoOpenedOrderPreviously=TRUE;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double NumberOfLotsToOpen;

   if(TimeToString(Time[0],TIME_DATE|TIME_MINUTES)>"2015.08.12 15:00")
     {
      if(isNoOpenedOrderPreviously)
        {
         NumberOfLotsToOpen=1;
         OpenThisNumberOfLots(NumberOfLotsToOpen);
        }
     }
/*     
    if    isPreviouslyOpenedOrderPreviously
      PrintFormat("Time :%s  Bar:%i  Close[i]:%G  _echelon:%G",TimeToString(Time[intBars]),intBars,Close[intBars],_echelon);
      Print("_SEARCHING :"+EnumToString(_SEARCHING));
     }
*/
  }
//+------------------------------------------------------------------+
void OpenThisNumberOfLots(const double &NumberOfLotsToOpen)
  {
   int ticketOrder=0;
   RefreshRates();
   ticketOrder=OrderSend(Symbol(),OP_BUY,NumberOfLotsToOpen,Ask,40,NULL,0,"",m_MagicNumber,0,CLR_NONE);
   if(ticketOrder<0)
     {
      Log(ERROR,__FILE__,__FUNCTION__,__LINE__,StringConcatenate("Problème ouverture Ordre : ",ErrorDescription(GetLastError()),"  NumberOfLotsToOpen :",NumberOfLotsToOpen));
     }
  }
//+------------------------------------------------------------------+
