//+------------------------------------------------------------------+
//|                                                Indicator_SMA.mq4 |
//|                                         Copyright 2013, Pierre8r |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Pierre8r"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- indicator parameters
extern int MA_Period=20;
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
	if(MA_Period<2) MA_Period=20;
	draw_begin=MA_Period-1;
//---- indicator short name
	short_name="SMA(";
	IndicatorShortName(short_name+MA_Period+")");
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
   if(Bars<=MA_Period) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) 
      {Print("ERREUR GRAVE : ExtCountedBars < 0");}
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
//----
	for(int i = Bars-(ExtCountedBars-1); i>=0; i--) {
		ExtMapBuffer[i]= sma(i);
	}
//----
	return(0);
}
//+------------------------------------------------------------------+
double sma(int i) {
	double sum=0;
	int pos;

	if (Bars<MA_Period) return(0);
	for(pos=(MA_Period-1); pos>=0; pos--) {
		sum+=Close[pos+i];
	}
	return(sum/MA_Period);
}
//+------------------------------------------------------------------+
