//+------------------------------------------------------------------+ 
//|                                                       idAreas.mq4| 
//|                                        Copyright 2014, Pierrr8r. | 
//|                                              http://www.mql5.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2014, Pierrr8r." 
#property link      "http://www.mql5.com" 
#property version   "1.00" 
#property strict 

#property indicator_chart_window 
#property indicator_buffers 2 
#property indicator_color1 Pink 
#property indicator_color2 SpringGreen 


//---- input parameters 
#include "clArea.mqh" 
#include "clAreas.mqh" 

//---- 
CAreas Areas;

//---- buffers 
double Resistance_Buffer[];
double Support_Buffer[];
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int OnInit()
  {
//--- indicator buffers mapping 
   Print("init()");

   Areas.addArea(new CArea(D'1980.01.1 0:00', D'2008.10.19 0:00', 710, 700));
   Areas.addArea(new CArea(D'2008.10.19 1:00', D'2010.01.01 0:00', 1200, 1000));
   Areas.addArea(new CArea(D'2010.01.01 0:00', D'2200.01.1 0:00', 1800, 1500));

//---- indicators 

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Resistance_Buffer);
   SetIndexLabel(0,"Resistance");

   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Support_Buffer);
   SetIndexLabel(1,"Support");
//--- 
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+ 
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+ 
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
//--- 
   int limit=(Bars-IndicatorCounted())-1;
   for(int i=limit; i>=0; i--)
     {
      if(Areas.GetResistance(Time[i])>0)
        {
         Resistance_Buffer[i]=Areas.GetResistance(Time[i]);
        }
      else
        {
         Resistance_Buffer[i]=EMPTY_VALUE;
        }
      if(Areas.GetSupport(Time[i])>0)
        {
         Support_Buffer[i]=Areas.GetSupport(Time[i]);
        }
      else
        {
         Support_Buffer[i]=EMPTY_VALUE;
        }
     }

//--- return value of prev_calculated for next call 
   return(rates_total);
  }
//+------------------------------------------------------------------+ 
