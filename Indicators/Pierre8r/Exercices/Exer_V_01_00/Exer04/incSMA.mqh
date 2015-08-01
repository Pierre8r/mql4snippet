//+------------------------------------------------------------------+
//|                                                       incSMA.mq4 |
//|                                         Copyright 2013, Pierre8r |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Pierre8r"
#property link      ""

//---- indicator parameters
extern int incSMA.MA_Period=20;
//+------------------------------------------------------------------+
double incSMA.sma(int i) {
	double sum=0;
	int pos;

	if (Bars<incSMA.MA_Period) return(0);
	for(pos=(incSMA.MA_Period-1); pos>=0; pos--) {
		sum+=Close[pos+i];
	}
	return(sum/incSMA.MA_Period);
}
//+------------------------------------------------------------------+