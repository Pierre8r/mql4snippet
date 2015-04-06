//+------------------------------------------------------------------+
//|                                              MyMovingAverage.mq4 |
//|                                                      Broketrader |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
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




/********************************************************************
   Global Variables
********************************************************************/
double                              MainBuffer[];
input int                           MAPeriod = 14;
input int                           MAShift  = 0;
input ENUM_MA_METHOD                MAMethod = MODE_SMA;
input ENUM_APPLIED_PRICE            MAPrice  = PRICE_CLOSE;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/********************************************************************
   OnInit()
   Initializes Indicator globaal Variables
********************************************************************/
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

   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/********************************************************************
   OnCalculate()
   Indicator Iteration function
********************************************************************/
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

   int i,Start;

// If there are not enough rates,
// i.e less than desired period, we just return. 
   if(rates_total<=MAPeriod) 
     {
      return 0;
     }

// We don't use data as series
   ArraySetAsSeries(MainBuffer,false);
   ArraySetAsSeries(close,false);

   if(prev_calculated==0) 
     {
      // Calculates first visible value.
      double FirstValue=0;
      Start= MAPeriod;
      for(i=0; i<Start; i++)
        {
         FirstValue+=close[i];
        }
      FirstValue/=MAPeriod;
      MainBuffer[Start-1]=FirstValue;
     }
   else 
     {
      Start=prev_calculated-1;
     }

   for(i=Start; i<rates_total && !IsStopped(); i++) 
     {
      MainBuffer[i]=MainBuffer[i-1]+(close[i]-close[i-MAPeriod])/MAPeriod;
     }

// Return number of calculated rates.
   return(rates_total);
  }



/********************************************************************
   End of File
********************************************************************/
//+------------------------------------------------------------------+
