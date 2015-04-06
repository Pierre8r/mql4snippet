/**************************************************************************************************

                                                                                     TickChart.mq4 
                                                                               (c) 2014 Broketrader 

   You can freely share or modify this source file as long as you please keep the original author
   copyright statement above. You are encouraged to sign and give some detail about your
   modifications below, last modification first. Thanks!
   
   * * *
   
   Broketrader, March 19 2014, First version.
   
**************************************************************************************************/
#property copyright                 "(c) 2014 Broketrader"
#property link                      ""
#property version                   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers         0
#property indicator_plots           0



/**************************************************************************************************
   Include Files
**************************************************************************************************/
#include <TickChart.mqh>




/**************************************************************************************************
   Global Variables
**************************************************************************************************/
input int                           CustomPeriod = 3;



/**************************************************************************************************
   OnInit()
   Initializes Indicator al Variables
**************************************************************************************************/
 
int OnInit() {
   
   //FileCopy(
   if( ! TickChart::Instance().OnInit( CustomPeriod ) ){
      return INIT_FAILED;
   }
   Comment( "Please open the M"+IntegerToString(CustomPeriod)+" offline chart." );
   return INIT_SUCCEEDED;
}


void OnDeinit( const int reason ){
   TickChart::Instance().OnDeinit();
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
   TickChart::Instance().OnCalculate();
   return(rates_total);
}


