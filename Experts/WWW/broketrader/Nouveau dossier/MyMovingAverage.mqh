/**********************************************************************************************************************

   MyMovingAverage.mqh, (c) 2014 Broketrader 
                                                  
**********************************************************************************************************************/




/**********************************************************************************************************************
   Class MyMovingAverage
   Computes moving averages
**********************************************************************************************************************/
class MyMovingAverage {
   private:
      int   m_Period;
      
   public:
            MyMovingAverage( int period );
      void  Compute( const int total_rates, const int prev_calcd, const double& price[], double& output[] );
};




/**********************************************************************************************************************
   Constructor
**********************************************************************************************************************/
MyMovingAverage::MyMovingAverage( int period ){
   m_Period = period;
}




/**********************************************************************************************************************
   
   Compute
   Computes the moving average.
   
   totalrates, Total rates in chart.
   prevcalcd, Previously calculated rates
   price, price data on which the calculation is done
   out, output buffer in which calculation must be stored
   
**********************************************************************************************************************/
void MyMovingAverage::Compute( const int totalrates, const int prevcalcd, const double& price[], double& out[] ) {

   int i, Start;
   
   // If there are not enough rates,
   // i.e less than desired period, we just return. 
   if( totalrates <= m_Period ) {
      return;
   }
   
   if( prevcalcd == 0 ) {
      Start = m_Period;
      // Calculate first visible value.
      double FirstValue=0;
      for( i=0; i<Start; i++ ){
         FirstValue += price[i];
      }
      FirstValue /= m_Period;
      out[Start-1] = FirstValue;
   }
   else {
      Start = prevcalcd - 1;
   }

   for( i=Start; i<totalrates && !IsStopped(); i++ ) {
      out[i] = out[i-1] + (price[i]-price[i-m_Period]) / m_Period;
   }
}

