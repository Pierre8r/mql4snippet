//+------------------------------------------------------------------+ 
//|                                              eaSemiAutomatic.mq4 | 
//|                                   Copyright 2014, Pierre Rougier | 
//|                                              http://www.mql4.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2014, Pierre Rougier" 
#property link      "http://www.mql4.com" 
#property version   "1.00" 
#property strict 


#include <stderror.mqh> 
#include <stdlib.mqh> 

extern int magicNumber=2014;
//--- Strategy 
enum theStrategy
  {
   BuyStrategy=0,      // BuyStrategy 
   SellStrategy=1,     // SellStrategy 
   HedgingStrategy=2,  // HedgingStrategy 
  };
//--- input parameters 
input theStrategy  currentStrategy=HedgingStrategy;

extern  datetime Time1=D'2014.06.06 16:00';
extern  datetime Time2=D'2014.06.13 09:00';

extern  double neutralPrice1=1248.94;
extern  double neutralPrice2=1264.58;

extern  double highStopArea=1258.22;
extern  double highArea=1251.92;
extern  double lowArea=1244.69;

double numlot=0.1;
bool isTradingStopped;
//+------------------------------------------------------------------+ 
//| Expert initialization function                                   | 
//+------------------------------------------------------------------+ 
int OnInit()
  {
//--- 
   isTradingStopped=FALSE;

   Comment("currentStrategy : ",currentStrategy);

   double priceDiff=neutralPrice2-neutralPrice1;

   if(!ObjectCreate(0,"startHighStopArea",OBJ_TREND,0,Time1,highStopArea,Time2,highStopArea+priceDiff))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startHighStopArea",OBJPROP_COLOR,clrRed);

   if(!ObjectCreate(0,"startHighArea",OBJ_TREND,0,Time1,highArea,Time2,highArea+priceDiff))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startHighArea",OBJPROP_COLOR,clrBlue);

   if(!ObjectCreate(0,"startNeutralArea",OBJ_TREND,0,Time1,neutralPrice1,Time2,neutralPrice2))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startNeutralArea",OBJPROP_COLOR,clrLime);

   if(!ObjectCreate(0,"startLowArea",OBJ_TREND,0,Time1,lowArea,Time2,lowArea+priceDiff))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startLowArea",OBJPROP_COLOR,clrRed);

//--- 
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+ 
//| Expert deinitialization function                                 | 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason)
  {
//--- 

   ObjectDelete("startHighStopArea");
   ObjectDelete("startHighArea");
   ObjectDelete("startNeutralArea");
   ObjectDelete("startLowArea");
  }
//+------------------------------------------------------------------+ 
//| Expert tick function                                             | 
//+------------------------------------------------------------------+ 
void OnTick()
  {
//--- 

   if(isTradingStopped==False)
     {
      switch(currentStrategy)
        {
         case BuyStrategy :
            computeBuyStrategy();
            break;
         case SellStrategy :
            computeSellStrategy();
            break;
         case HedgingStrategy :
            computeHedgingStrategy();
            break;
         default:
            break;
        }
     }
  }
//+------------------------------------------------------------------+ 
void computeBuyStrategy()
  {

   if(Ask>ObjectGetValueByTime(0,"startHighArea",Time[0]))
     {
      computeCloseBuyOrder();
     }
   else if(Ask>ObjectGetValueByTime(0,"startNeutralArea",Time[0]))
     {
     }
   else if(Ask>ObjectGetValueByTime(0,"startLowArea",Time[0]))
     {
      computeOpenBuyOrder();
     }
   else
     {
      computeStopTrading();
     }
  }
//+------------------------------------------------------------------+ 
void computeSellStrategy()
  {

   if(Ask>ObjectGetValueByTime(0,"startHighStopArea",Time[0]))
     {
      computeStopTrading();
     }
   else if(Ask>ObjectGetValueByTime(0,"startHighArea",Time[0]))
     {
      computeOpenSellOrder();
     }
   else if(Ask>ObjectGetValueByTime(0,"startNeutralArea",Time[0]))
     {
     }
   else
     {
      computeCloseSellOrder();
     }
  }
//+------------------------------------------------------------------+ 
void computeHedgingStrategy()
  {
   if(isTradingStopped==False)
     {
      computeBuyStrategy();
     }
   if(isTradingStopped==False)
     {
      computeSellStrategy();
     }
  }
//+------------------------------------------------------------------+ 
void computeOpenBuyOrder()
  {
   if(isTradingStopped==False)
     {
      if(isOpenBuyOrder()==False)
        {
         openBuyOrder();
        }
     }
  }
//+------------------------------------------------------------------+ 
void computeOpenSellOrder()
  {
   if(isTradingStopped==False)
     {
      if(isOpenSellOrder()==False)
        {
         openSellOrder();
        }
     }
  }
//+------------------------------------------------------------------+ 
void computeCloseBuyOrder()
  {

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderType()==OP_BUY) && (OrderSymbol()==Symbol()))
        {
         closeOrder(OrderTicket());
        }
     }
  }
//+------------------------------------------------------------------+ 
void computeCloseSellOrder()
  {

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderType()==OP_SELL) && (OrderSymbol()==Symbol()))
        {
         closeOrder(OrderTicket());
        }
     }
  }
//+------------------------------------------------------------------+ 
void computeStopTrading()
  {
   closeAllOrders();
   isTradingStopped=true;
  }
//+------------------------------------------------------------------+ 
void closeAllOrders()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderSymbol()==Symbol()))
        {
         closeOrder(OrderTicket());
        }
     }
  }
//+------------------------------------------------------------------+ 
bool isOpenBuyOrder()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderType()==OP_BUY) && (OrderSymbol()==Symbol()))
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+ 
bool isOpenSellOrder()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderType()==OP_SELL) && (OrderSymbol()==Symbol()))
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+ 
void openBuyOrder()
  {
   int numOrdre=0;
   RefreshRates();

   numOrdre=OrderSend(Symbol(),OP_BUY,numlot*1,Ask,3,NULL,0,"",magicNumber,0,CLR_NONE);
   if(numOrdre==0)
     {
      processError("Problme ouverture Ordre : "+ErrorDescription(GetLastError()));
     }
  }
//+------------------------------------------------------------------+ 
void openSellOrder()
  {
   int numOrdre=0;
   RefreshRates();

   numOrdre=OrderSend(Symbol(),OP_SELL,numlot*1,Ask,3,NULL,0,"",magicNumber,0,CLR_NONE);
   if(numOrdre==0)
     {
      processError("Problme ouverture Ordre : "+ErrorDescription(GetLastError()));
     }
  }
//+------------------------------------------------------------------+ 
void closeOrder(int numOrdre)
  {

   if(OrderSelect(numOrdre,SELECT_BY_TICKET)==true)
     {
      RefreshRates();
      numlot=OrderLots();
      if(OrderClose(numOrdre,numlot,Bid,3))
        { processError("Passage fermeture Ordre - Changement etat de ordre");}
      else
        { processError("Probleme fermeture ordre "+ErrorDescription(GetLastError()));}
     }

  }
//+------------------------------------------------------------------+ 
void processError(string msgError)
  {
   Print("Error Message : ",msgError);
  }
//+------------------------------------------------------------------+ 
