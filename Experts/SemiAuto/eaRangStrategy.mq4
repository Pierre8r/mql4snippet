//+------------------------------------------------------------------+ 
//|                                               eaRangStrategy.mq4 | 
//|                                         Copyright 2014, Pierre8r | 
//|                                              http://www.mql4.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2014, Pierre Rougier" 
#property link      "http://www.mql4.com" 
#property version   "1.002" 
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

extern  double highStopArea=1310.10;
extern  double highArea=1302.52;
extern  double neutralArea=1289.33;
extern  double lowArea=1285.23;
extern  double lowStopArea=1285.23;

double numlot=0.1;
bool isTradingStopped;
//+------------------------------------------------------------------+ 
//| Expert initialization function                                   | 
//+------------------------------------------------------------------+ 
int OnInit()
  {
//--- 
   isTradingStopped=FALSE;

   if(!ObjectCreate(0,"startHighStopArea",OBJ_HLINE,0,0,highStopArea))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startHighStopArea",OBJPROP_COLOR,clrRed);

   if(!ObjectCreate(0,"startHighArea",OBJ_HLINE,0,0,highArea))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startHighArea",OBJPROP_COLOR,clrBlue);

   if(!ObjectCreate(0,"startNeutralArea",OBJ_HLINE,0,0,neutralArea))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startNeutralArea",OBJPROP_COLOR,clrLime);

   if(!ObjectCreate(0,"startLowArea",OBJ_HLINE,0,0,lowArea))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startLowArea",OBJPROP_COLOR,clrRed);

   if(!ObjectCreate(0,"startOpenArea",OBJ_HLINE,0,0,lowStopArea))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startLowStopArea",OBJPROP_COLOR,clrRed);

//--- 
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+ 
//| Expert deinitialization function                                 | 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason)
  {
//--- 

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

   if(Ask>highArea)
     {
      computeCloseBuyOrder();
     }
   else if(Ask>neutralArea)
     {
     }
   else if(Ask>lowArea)
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

   if(Ask>highStopArea)
     {
      computeStopTrading();
     }
   else if(Ask>highArea)
     {
      computeOpenSellOrder();
     }
   else if(Ask>neutralArea)
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
