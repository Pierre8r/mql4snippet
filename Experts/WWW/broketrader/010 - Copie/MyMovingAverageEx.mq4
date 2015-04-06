//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
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
#property indicator_buffers         1
#property indicator_plots           1
#property indicator_label1          "Main"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          1

/**************************************************************************************************
   Include Files
**************************************************************************************************/
#include <MyMovingAverage.mqh>

/**************************************************************************************************
   Global Variables
**************************************************************************************************/
input int                           MAPeriod = 20;
input int                           MAShift  = 0;
input ENUM_MA_METHOD                MAMethod = MODE_SMA;
input ENUM_APPLIED_PRICE            MAPrice  = PRICE_CLOSE;
double                              MainBuffer[];
MyMovingAverage                    *MyMA;
/**************************************************************************************************
   OnInit()
   Initializes Indicator al Variables
**************************************************************************************************/
int OnInit()
  {
   IndicatorBuffers( 1 );                    // We have only one indicator
   IndicatorDigits( Digits );                // Digits showwhen visualizing indicator value.
   SetIndexStyle( 0, DRAW_LINE );            // MA shown as a simple line
   SetIndexBuffer( 0, MainBuffer );          // Associate buffer to index.
   SetIndexShift( 0, MAShift );              // Apply user shift
   SetIndexLabel( 0, "MyMovingAverage" );    // Index Label
   ArrayInitialize( MainBuffer ,0);          // Initializes the array

                                             // Check that input parameter is valid
   if(MAPeriod<=0)
     {
      Print("Wrong input parameter MAPeriod");
      return INIT_FAILED;
     }

// Instantiate indicator objects
   MyMA=new MyMovingAverage(MAPeriod);

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

   ArraySetAsSeries(MainBuffer,true);
   ArraySetAsSeries(close,true);

   MyMA.Compute(rates_total,prev_calculated,close,MainBuffer);

// Return number of calculated rates.
   return(rates_total);
  }
//+------------------------------------------------------------------+
