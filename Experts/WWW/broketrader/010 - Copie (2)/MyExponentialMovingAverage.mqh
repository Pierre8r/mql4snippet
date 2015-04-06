/**********************************************************************************************************************

   MySimpleMovingAverage.mqh, (c) 2014 Broketrader 
                                                  
**********************************************************************************************************************/




/**************************************************************************************************
   Include Files
**************************************************************************************************/
#include <MyMovingAverage.mqh>




/**********************************************************************************************************************
   Class MySimpleMovingAverage
   Computes moving averages
**********************************************************************************************************************/


class MyExponentialMovingAverage : public MyMovingAverage {

   public :
            MyExponentialMovingAverage( const int period );
      void  Compute( const int total_rates, const int prev_calcd, const double& price[], double& output[] );
};



/**********************************************************************************************************************
   Constructor
**********************************************************************************************************************/
MyExponentialMovingAverage::MyExponentialMovingAverage( int period ) : MyMovingAverage( period ){
}




/**********************************************************************************************************************
   
   Compute
   Computes the Exponential moving average.
   
   totalrates, Total rates in chart.
   prevcalcd, Previously calculated rates
   price, price data on which the calculation is done
   out, output buffer in which calculation must be stored
   
**********************************************************************************************************************/
void MyExponentialMovingAverage::Compute( const int totalrates, const int prevcalcd, const double& price[], double& out[] ) {

   int      i, Start;
   double   SmoothFactor;
   
   // If there are not enough rates,
   // i.e less than desired period, we just return. 
   if( totalrates <= m_Period ) {
      return;
   }
   
   SmoothFactor = 2.0 / (1.0+m_Period);
   // Calculate first visible value.
   if( prevcalcd==0 ) {
      Start = m_Period;
      out[0] = price[0];
      for( i=1; i<Start; i++ ){
         out[i]=price[i]*SmoothFactor+out[i-1]*(1.0-SmoothFactor);
      }
   }
   else {
      Start = prevcalcd-1;
   }
   // Calculate the remaining
   for( i=Start; i<totalrates && !IsStopped(); i++ ) {
      out[i] = price[i] * SmoothFactor + out[i-1] * (1.0-SmoothFactor);
   }
}

