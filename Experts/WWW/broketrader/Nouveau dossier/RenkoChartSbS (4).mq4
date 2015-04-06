/**************************************************************************************************

                                                                                     RenkoChart.mq4 
                                                                                        Broketrader 


   You can freely share and are are encouraged to modify and improve this source file
   as long as you please keep the original author copyright statement above and you write your
   modifications below, last modification first.
   

   Broketrader, March 18 2014, First version
   
**************************************************************************************************/
#property copyright                 "(c) 2014 Broketrader"
#property link                      ""
#property version                   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers         0
#property indicator_plots           0


input int BoxSize = 10;




/**************************************************************************************************
   Include Files
**************************************************************************************************/
#include <RenkoChartSbS.mqh>




/**************************************************************************************************
   Global Variables
**************************************************************************************************/
// None, we will use the RenkoChart singleton.




/**************************************************************************************************
   OnInit()
   Initializes Indicator al Variables
**************************************************************************************************/
int OnInit() {
   if( ! RenkoChart::Instance().OnInit( 3, BoxSize ) ){
      return INIT_FAILED;
   }
   return INIT_SUCCEEDED;
}




/**************************************************************************************************
   OnTimer
   The RenkoChart object uses the timer to write the history file while updating it's
   progress on the chart, that's why it's necessary to implements the OnTimer() function
   and call the corresponding RenkoObject method.
**************************************************************************************************/
void OnTimer() {
   RenkoChart::Instance().OnTimer();
}




/**************************************************************************************************
   OnDeInit()
**************************************************************************************************/
void OnDeinit( const int reason ){
   RenkoChart::Instance().OnDeinit();
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
   RenkoChart::Instance().OnCalculate( Bars );
   return(rates_total);
}


