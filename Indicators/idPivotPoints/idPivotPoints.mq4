//+------------------------------------------------------------------+
//|                                                idPivotPoints.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Pierre8r Pierre Rougier."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 7
#property indicator_color1  Orange
#property indicator_color2  DarkBlue
#property indicator_color3  Maroon
#property indicator_color4  DarkBlue
#property indicator_color5  Maroon
#property indicator_color6  Green
#property indicator_color7  Lime


#include "clGraphicPivotPoints.mqh"
CGraphicPivotPoints *GraphicPivotPoints;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   GraphicPivotPoints=new CGraphicPivotPoints();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   GraphicPivotPoints.OnCalculate();

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete GraphicPivotPoints;
  }
//+------------------------------------------------------------------+
