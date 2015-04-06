/**************************************************************************************************
                                                                                MyMovingAverage.mq4 
                                                                                        Broketrader 
                                                                                http://www.mql5.com 
**************************************************************************************************/
#property copyright                 "Broketrader"
#property link                      "http://www.mql5.com"
#property version                   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers         2
#property indicator_plots           2

#property indicator_label1          "FastMA"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          1


#property indicator_label2          "SlowMA"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrGreen
#property indicator_style2          STYLE_SOLID
#property indicator_width2          1




/**************************************************************************************************
   Include Files
**************************************************************************************************/
#include <MyMovingAverage.mqh>



/**************************************************************************************************
   Global Variables
**************************************************************************************************/
const int                           FastMaPlotIndex   = 0;
input int                           FastMaPeriod      = 20;
input int                           FastMaShift       = 0;
input ENUM_MA_METHOD                FastMaMethod      = MODE_SMA;
input ENUM_APPLIED_PRICE            FastMaPrice       = PRICE_CLOSE;
const string                        FastMaLabel      = "FastMa";

const int                           SlowMaPlotIndex   = 1;
input int                           SlowMaPeriod      = 50;
input int                           SlowMaShift       = 0;
input ENUM_MA_METHOD                SlowMaMethod      = MODE_SMA;
input ENUM_APPLIED_PRICE            SlowMaPrice       = PRICE_CLOSE;
const string                        SlowMaLabel      = "SlowMa";

MyMovingAverage                     FastMA;
MyMovingAverage                     SlowMA;



/**************************************************************************************************
   OnInit()
   Initializes Indicator al Variables
**************************************************************************************************/
int OnInit() {

   IndicatorBuffers( 2 );                    // We have two indicators
   IndicatorDigits( Digits );                // Digits for visualizing its value.
   
   if( ! FastMA.Initialize( FastMaPlotIndex, FastMaPeriod, FastMaShift, FastMaMethod, FastMaPrice, FastMaLabel, DRAW_LINE ) ){
      return INIT_FAILED;
   }

   if( ! SlowMA.Initialize( SlowMaPlotIndex, SlowMaPeriod, SlowMaShift, SlowMaMethod, SlowMaPrice, SlowMaLabel, DRAW_LINE ) ){
      return INIT_FAILED;
   }
   
   MyMovingAverage::ClearArrows();
   
   return INIT_SUCCEEDED;
}




/**************************************************************************************************
   OnCalculate()
   Indicator Iteration function
**************************************************************************************************/
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
   ArraySetAsSeries( time, false );
   
   FastMA.Compute( rates_total, prev_calculated, open, high, low, close ); 
   SlowMA.Compute( rates_total, prev_calculated, open, high, low, close ); 
   
   MyMovingAverage::ShowCrossings( rates_total, time, FastMA, SlowMA );
   
   
   return(rates_total);
   
}


