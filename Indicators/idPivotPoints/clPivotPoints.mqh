//+------------------------------------------------------------------+
//|                                                clPivotPoints.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Pierre8r Pierre Rougier."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPivotPoints
  {
private:
   double            _P,_S1,_R1,_S2,_R2,_S3,_R3;
   double            LastHigh,LastLow,x;
public:
                     CPivotPoints();
                    ~CPivotPoints();

   void              CPivotPoints::ComputePivotPoints(int scanBar);
   double            CPivotPoints::GetP();
   double            CPivotPoints::GetS1();
   double            CPivotPoints::GetR1();
   double            CPivotPoints::GetS2();
   double            CPivotPoints::GetR2();
   double            CPivotPoints::GetS3();
   double            CPivotPoints::GetR3();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPivotPoints::CPivotPoints()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPivotPoints::~CPivotPoints()
  {
  }
//+------------------------------------------------------------------+
void CPivotPoints::ComputePivotPoints(int scanBar)
  {
   if(High[scanBar+1]>LastHigh)
      LastHigh=High[scanBar+1];
//----
   if(Low[scanBar+1]<LastLow)
      LastLow=Low[scanBar+1];
   if(TimeDay(Time[scanBar])!=TimeDay(Time[scanBar+1]))
     {
      _P=(LastHigh+LastLow+Close[scanBar+1])/3;
      _R1 = (2*_P) - LastLow;
      _S1 = (2*_P) - LastHigh;
      _R2 = _P + (LastHigh - LastLow);
      _S2 = _P - (LastHigh - LastLow);
      _R3 = (2*_P) + (LastHigh - (2*LastLow));
      _S3 = (2*_P) - ((2* LastHigh) - LastLow);
      LastLow=Open[scanBar];
      LastHigh=Open[scanBar];
     }
  }
//+------------------------------------------------------------------+
double CPivotPoints::GetP()
  {
   return(_P);
  }
//+------------------------------------------------------------------+
double CPivotPoints::GetS1()
  {
   return(_S1);
  }
//+------------------------------------------------------------------+
double CPivotPoints::GetR1()
  {
   return(_R1);
  }
//+------------------------------------------------------------------+
double CPivotPoints::GetS2()
  {
   return(_S2);
  }
//+------------------------------------------------------------------+
double CPivotPoints::GetR2()
  {
   return(_R2);
  }
//+------------------------------------------------------------------+
double CPivotPoints::GetS3()
  {
   return(_S3);
  }
//+------------------------------------------------------------------+
double CPivotPoints::GetR3()
  {
   return(_R3);
  }
//+------------------------------------------------------------------+
