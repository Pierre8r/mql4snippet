//+------------------------------------------------------------------+
//|                                        Indicator_SMA_Include.mq4 |
//|                                         Copyright 2013, Pierre8r |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Pierre8r"
#property link      ""

#include "incSMA.mqh" 

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

//---- indicator buffers
double ExtMapBuffer[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
//---- indicators
	int    draw_begin;
	string short_name;
//---- drawing settings
	SetIndexStyle(0,DRAW_LINE);
	IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
	if(incSMA.MA_Period<2) incSMA.MA_Period=20;
	draw_begin=incSMA.MA_Period-1;
//---- indicator short name
	short_name="SMA(";
	IndicatorShortName(short_name+incSMA.MA_Period+")");
	SetIndexDrawBegin(0,draw_begin);
//---- indicator buffers mapping
	SetIndexBuffer(0,ExtMapBuffer);
//---- initialization done
	return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
//----

//----
	return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
//----
   if(Bars<=incSMA.MA_Period) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) 
      {Print("ERREUR GRAVE : ExtCountedBars < 0");}
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
//----
	for(int i = Bars-(ExtCountedBars-1); i>=0; i--) {
		ExtMapBuffer[i]= incSMA.sma(i);
	}
//----
	return(0);
}
//+------------------------------------------------------------------+

