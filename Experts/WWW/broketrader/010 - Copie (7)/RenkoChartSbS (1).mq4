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
   return INIT_SUCCEEDED;
}




/**************************************************************************************************
   OnDeInit()
**************************************************************************************************/
void OnDeinit( const int reason ){
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
   return(rates_total);
}


