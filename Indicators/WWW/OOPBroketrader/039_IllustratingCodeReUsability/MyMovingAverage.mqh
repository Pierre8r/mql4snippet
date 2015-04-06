/**********************************************************************************************************************

   MyMovingAverage.mqh, (c) 2014 Broketrader 
                                                  
**********************************************************************************************************************/



/**********************************************************************************************************************
   Class MyMovingAverage
   Computes moving averages
**********************************************************************************************************************/
class MyMovingAverage {
   
   protected:
      double               m_Buffer[];
   
      int                  m_Period;
      double               m_LastValues[3];
      ENUM_APPLIED_PRICE   m_AppliedPrice;
      ENUM_MA_METHOD       m_Method;
      
      void                 ComputeSma( const int totalrates, const int prevcalcd, const double& price[] );
      void                 ComputeEma( const int totalrates, const int prevcalcd, const double& price[] );
      
   public:

      
      void                 Compute( const int totalrates, const int prevcalcd, const double& open[], const double& high[], const double& low[], const double& close[] );
      bool                 Initialize( int plotindex, int period, int shift, ENUM_MA_METHOD method, ENUM_APPLIED_PRICE applprice, string label, int linestyle );
                           MyMovingAverage(){}
                           
};




bool MyMovingAverage::Initialize( int plotindex, int period, int shift, ENUM_MA_METHOD method, ENUM_APPLIED_PRICE applprice, string label, int linestyle ){
   
   if( period <= 0 ){
      Print( "MyMovingAverage:Initialize:"+label+", Wrong input parameter period" );
      return false;
   }
   
   ArraySetAsSeries( m_Buffer, false );
   
   m_Period = period;
   m_AppliedPrice = applprice;
   m_Method = method;
   
   SetIndexBuffer( plotindex, m_Buffer ); // Associate buffer to index.
   SetIndexShift( plotindex, shift );     // Apply user shift
   SetIndexLabel( plotindex, label );     // Index Label
   SetIndexStyle( plotindex, linestyle ); // MA shown as a simple line
   
   ArrayInitialize( m_Buffer ,0);         // Initializes the array
   
   return true;
}




/**********************************************************************************************************************
   
   ComputeEma
   Computes the Expoential moving average.
   
   totalrates, Total rates in chart.
   prevcalcd, Previously calculated rates
   price, price data on which the calculation is done
   
**********************************************************************************************************************/
void MyMovingAverage::ComputeEma( const int totalrates, const int prevcalcd, const double& price[] ) {
   int      i, Start;
   double   SmoothFactor;
   
   
   SmoothFactor = 2.0 / (1.0+m_Period);
   // Calculate first visible value.
   if( prevcalcd==0 ) {
      Start = m_Period;
      m_Buffer[0] = price[0];
      for( i=1; i<Start; i++ ){
         m_Buffer[i]=price[i]*SmoothFactor+m_Buffer[i-1]*(1.0-SmoothFactor);
      }
   }
   else {
      Start = prevcalcd-1;
   }
   // Calculate the remaining
   for( i=Start; i<totalrates && !IsStopped(); i++ ) {
      m_Buffer[i] = price[i] * SmoothFactor + m_Buffer[i-1] * (1.0-SmoothFactor);
   }
}





/**********************************************************************************************************************
   
   ComputeSma
   Computes the Simple moving average.
   
   totalrates, Total rates in chart.
   prevcalcd, Previously calculated rates
   price, price data on which the calculation is done
   
**********************************************************************************************************************/
void MyMovingAverage::ComputeSma( const int totalrates, const int prevcalcd, const double& price[] ) {
   int i, Start;
   
   
   if( prevcalcd == 0 ) {
      Start = m_Period;
      // Calculate first visible value.
      double FirstValue=0;
      for( i=0; i<Start; i++ ){
         FirstValue += price[i];
      }
      FirstValue /= m_Period;
      m_Buffer[Start-1] = FirstValue;
   }
   else {
      Start = prevcalcd - 1;
   }

   for( i=Start; i<totalrates && !IsStopped(); i++ ) {
      m_Buffer[i] = m_Buffer[i-1] + (price[i]-price[i-m_Period]) / m_Period;
   }
   
}



/**********************************************************************************************************************
   
   Compute
   Computes moving averages.
   
   totalrates, Total rates in chart.
   prevcalcd, Previously calculated rates
   open, high, low, close, price data on which the calculation is done
   
**********************************************************************************************************************/
void MyMovingAverage::Compute( const int totalrates, const int prevcalcd, const double& open[], const double& high[], const double& low[], const double& close[] ){

   // If there are not enough rates,
   // i.e less than desired period, we just return. 
   if( totalrates <= m_Period ) {
      return;
   }

   // It's important to make these calls before each new calculation !
   ArraySetAsSeries( open, false );
   ArraySetAsSeries( high, false );
   ArraySetAsSeries( low, false );
   ArraySetAsSeries( close, false );
   ArraySetAsSeries( m_Buffer, false );

   switch( m_Method ){
   
      case MODE_SMA:
         switch( m_AppliedPrice ){
            case PRICE_OPEN: ComputeSma( totalrates, prevcalcd, open ); break;
            case PRICE_HIGH: ComputeSma( totalrates, prevcalcd, high ); break;
            case PRICE_LOW: ComputeSma( totalrates, prevcalcd, low ); break;
            case PRICE_CLOSE: ComputeSma( totalrates, prevcalcd, close ); break;
         }

      case MODE_EMA:
         switch( m_AppliedPrice ){
            case PRICE_OPEN: ComputeEma( totalrates, prevcalcd, open ); break;
            case PRICE_HIGH: ComputeEma( totalrates, prevcalcd, high ); break;
            case PRICE_LOW: ComputeEma( totalrates, prevcalcd, low ); break;
            case PRICE_CLOSE: ComputeEma( totalrates, prevcalcd, close ); break;
         }
   }
}








