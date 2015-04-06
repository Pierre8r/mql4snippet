/****************************************************************************************

                                                                           SimpleList.mq4 
                                                                     (c) 2014 Broketrader 

   This source code is provided "as is" whithout any warraty of any king from the author.
   Use, distribute and modify this code freely.
   
   Broketrader, March 25 2014, First version.
   
****************************************************************************************/
#property copyright                 "(c) 2014 Broketrader"
#property version                   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers         0
#property indicator_plots           0




/****************************************************************************************
   Include Files
****************************************************************************************/
#include <SimpleListSbS.mqh>




/****************************************************************************************
   Global and User Input Variables
****************************************************************************************/




/****************************************************************************************
   OnInit()
   Initializes Indicator Global Variables
****************************************************************************************/
int OnInit() {

   List MyList;

   return INIT_SUCCEEDED;
}








/****************************************************************************************
   OnCalculate()
   Indicator Iteration function
****************************************************************************************/
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


