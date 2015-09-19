//+------------------------------------------------------------------+
//|                                                         eaMM.mq4 |
//|                                   Copyright 2015, Pierre Rougier |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Pierre Rougier"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <stdlib.mqh>
#include <stderror.mqh>

#include "libLogger.mq4"

extern int exStopLossInPips=10;
bool isOpenedOrderPreviously=FALSE;

int m_MagicNumber=2015;
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
// commentaire ajouté par contributeur
   MqlTick last_tick;
   double NumberOfLotsToOpen;
   double StopLoss=1.13052;

   datetime OpenFirstOrderAtThisDateTime=D'2015.08.25 17:01:00';

   if(SymbolInfoTick(Symbol(),last_tick))
     {
      if(!isOpenedOrderPreviously)
        {
         if((last_tick.time==OpenFirstOrderAtThisDateTime))
           {
            Log(DEBUG,__FILE__,__FUNCTION__,__LINE__,StringConcatenate("TimeToString(Time[0]) : ",TimeToString(Time[0],TIME_DATE|TIME_SECONDS),
                " Ask :",Ask," Bid :",Bid," TimeSeconds :",TimeSeconds(last_tick.time)));
            Log(DEBUG,__FILE__,__FUNCTION__,__LINE__,StringConcatenate("Account currency is ",AccountCurrency()," Equity = ",AccountEquity(),
                " Digits ",Digits()," Point ",Point()));

            NumberOfLotsToOpen=1;
            OpenBuy(NumberOfLotsToOpen,StopLoss);
            isOpenedOrderPreviously=True;
           }
        }
     }
   else
     {
      Log(ERROR,__FILE__,__FUNCTION__,__LINE__,StringConcatenate("SymbolInfoTick() failed, error = ",GetLastError()));
     }

/*
   if((TimeToString(Time[0],TIME_DATE|TIME_MINUTES)>"2015.08.12 00:00")&&(Time[0],TIME_DATE|TIME_MINUTES)<"2015.08.12 01:00"))
     {
      Log(DEBUG,__FILE__,__FUNCTION__,__LINE__,StringConcatenate("TimeToString(Time[0],TIME_DATE|TIME_MINUTES) : ",TimeToString(Time[0],TIME_DATE|TIME_MINUTES)));
     }
*/
/*
   if(TimeToString(Time[0],TIME_DATE|TIME_MINUTES)>"2015.08.12 00:00")
     {
      Log(DEBUG,__FILE__,__FUNCTION__,__LINE__,StringConcatenate("TimeToString(Time[0],TIME_DATE|TIME_MINUTES) : ",TimeToString(Time[0],TIME_DATE|TIME_MINUTES)));
      if(!isOpenedOrderPreviously)
        {
         NumberOfLotsToOpen=1;
         OpenThisNumberOfLots(NumberOfLotsToOpen);
         isOpenedOrderPreviously=TRUE;
        }
     }
     */
/*     
    if    isPreviouslyOpenedOrderPreviously
      PrintFormat("Time :%s  Bar:%i  Close[i]:%G  _echelon:%G",TimeToString(Time[intBars]),intBars,Close[intBars],_echelon);
      Print("_SEARCHING :"+EnumToString(_SEARCHING));
     }
*/
  }
//+------------------------------------------------------------------+
void OpenBuy(const double &NumberOfLotsToOpen,const double &StopLoss)
  {
   int ticketOrder=0;
   RefreshRates();
   ticketOrder=OrderSend(Symbol(),OP_BUY,NumberOfLotsToOpen,Ask,40,StopLoss,0,"",m_MagicNumber,0,clrLime);
   if(ticketOrder<0)
     {
      Log(ERROR,__FILE__,__FUNCTION__,__LINE__,StringConcatenate("Problème ouverture Ordre : ",ErrorDescription(GetLastError()),"  NumberOfLotsToOpen :",NumberOfLotsToOpen));
     }
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
