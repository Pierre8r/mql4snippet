//+------------------------------------------------------------------+
//|                                         clGraphicPivotPoints.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Pierre8r Pierre Rougier."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//---- input parameters
#include "clPivotPoints.mqh"
CPivotPoints *PivotPoints;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CGraphicPivotPoints
  {
private:

   //---- buffers
   double            PBuffer[];
   double            S1Buffer[];
   double            R1Buffer[];
   double            S2Buffer[];
   double            R2Buffer[];
   double            S3Buffer[];
   double            R3Buffer[];

   void              processError(string msgError);

public:
                     CGraphicPivotPoints();
                    ~CGraphicPivotPoints();

   void              OnCalculate();

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CGraphicPivotPoints::CGraphicPivotPoints()
  {

   PivotPoints=new CPivotPoints();

//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(0,PBuffer);
   SetIndexBuffer(1,S1Buffer);
   SetIndexBuffer(2,R1Buffer);
   SetIndexBuffer(3,S2Buffer);
   SetIndexBuffer(4,R2Buffer);
   SetIndexBuffer(5,S3Buffer);
   SetIndexBuffer(6,R3Buffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Pivot Point");
   SetIndexLabel(0,"Pivot Point");
//----
   SetIndexDrawBegin(0,1);

//----
   int fontsize=10;

   ObjectCreate("Pivot",OBJ_TEXT,0,0,0);
   ObjectSetText("Pivot","                 Pivot Point",fontsize,"Arial",Red);
   ObjectCreate("Sup1",OBJ_TEXT,0,0,0);
   ObjectSetText("Sup1","      S 1",fontsize,"Arial",Red);
   ObjectCreate("Res1",OBJ_TEXT,0,0,0);
   ObjectSetText("Res1","      R 1",fontsize,"Arial",Red);
   ObjectCreate("Sup2",OBJ_TEXT,0,0,0);
   ObjectSetText("Sup2","      S 2",fontsize,"Arial",Red);
   ObjectCreate("Res2",OBJ_TEXT,0,0,0);
   ObjectSetText("Res2","      R 2",fontsize,"Arial",Red);
   ObjectCreate("Sup3",OBJ_TEXT,0,0,0);
   ObjectSetText("Sup3","      S 3",fontsize,"Arial",Red);
   ObjectCreate("Res3",OBJ_TEXT,0,0,0);
   ObjectSetText("Res3","      R 3",fontsize,"Arial",Red);

//----

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CGraphicPivotPoints::~CGraphicPivotPoints()
  {
   delete PivotPoints;

   ObjectDelete("Pivot");
   ObjectDelete("Sup1");
   ObjectDelete("Res1");
   ObjectDelete("Sup2");
   ObjectDelete("Res2");
   ObjectDelete("Sup3");
   ObjectDelete("Res3");
  }
//+------------------------------------------------------------------+
void CGraphicPivotPoints::OnCalculate()
  {

// Start, fromBar, etc..
   int fromBar;
   int counted_bars=IndicatorCounted();

// check for possible errors
   if(counted_bars<0)
     {
      processError(StringConcatenate(__FUNCTION__,__LINE__,"IndicatorCounted() Below zero"));
      return;
     }

// Only check these
   fromBar=(Bars-2)-counted_bars;

// Check the signal foreach bar
   for(int scanBar=fromBar; scanBar>=0; scanBar--)
     {
      PivotPoints.ComputePivotPoints(scanBar);

      PBuffer[scanBar]=PivotPoints.GetP();
      S1Buffer[scanBar] = PivotPoints.GetS1();
      R1Buffer[scanBar] = PivotPoints.GetR1();
      S2Buffer[scanBar] = PivotPoints.GetS2();
      R2Buffer[scanBar] = PivotPoints.GetR2();
      S3Buffer[scanBar] = PivotPoints.GetS3();
      R3Buffer[scanBar] = PivotPoints.GetR3();
      
               ObjectMove("Pivot",0,Time[scanBar],PivotPoints.GetP());
         ObjectMove("Sup1",0,Time[scanBar],PivotPoints.GetS1());
         ObjectMove("Res1",0,Time[scanBar],PivotPoints.GetR1());
         ObjectMove("Sup2",0,Time[scanBar],PivotPoints.GetS2());
         ObjectMove("Res2",0,Time[scanBar],PivotPoints.GetR2());
         ObjectMove("Sup3",0,Time[scanBar],PivotPoints.GetS3());
         ObjectMove("Res3",0,Time[scanBar],PivotPoints.GetR3());


     }
  }
//+------------------------------------------------------------------+
void CGraphicPivotPoints::processError(string msgError)
  {
   Print("Error Message : ",msgError);
  }
//+------------------------------------------------------------------+
