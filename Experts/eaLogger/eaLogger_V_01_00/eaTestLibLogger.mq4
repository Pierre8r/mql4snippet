//+------------------------------------------------------------------+
//|                                                     eaLogger.mq4 |
//|                                   Copyright 2015, Pierre Rougier |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Pierre Rougier"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "libLogger.mq4"

//WrongParameter must be between values 0 and 1.
//Values 0.2 and 0.321 are corrects, value 1.2 is incorrect.
//This is a fatal error we have to stop the program.
extern double WrongParameter=1.2;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

if((WrongParameter<0) || (WrongParameter>1))
  {
   Log(FATAL, StringConcatenate(__FILE__, __FUNCTION__, __LINE__, "WrongParameter must be between values 0 and 1. Value :", WrongParameter, " is incorrect."));
  }
   
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
   
  }
//+------------------------------------------------------------------+
