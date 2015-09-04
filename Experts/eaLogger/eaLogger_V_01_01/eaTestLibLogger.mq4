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
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Log(INFO,__FILE__,__FUNCTION__,__LINE__,"Tout se passe bien pour le moment durant OnInit");
   Log(INFO,__FILE__,__FUNCTION__,__LINE__,"Tout se passe bien pour le moment durant OnInit");
   Log(INFO,__FILE__,__FUNCTION__,__LINE__,"Tout se passe bien pour le moment durant OnInit");
   Log(FATAL,__FILE__,__FUNCTION__,__LINE__,"Erreure fatale durant OnInit");
   Log(INFO,__FILE__,__FUNCTION__,__LINE__,"Tout se passe bien pour le moment durant OnInit");
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
   Log(INFO,__FILE__,__FUNCTION__,__LINE__,"One tick more");

  }
//+------------------------------------------------------------------+
