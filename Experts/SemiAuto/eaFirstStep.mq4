//+------------------------------------------------------------------+ 
//|                                                  eaFirstStep.mq4 | 
//|                                         Copyright 2014, Pierre8r | 
//|                                              http://www.mql4.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2014, Pierre8r" 
#property link      "http://www.mql4.com" 
#property version   "1.002" 
#property strict 

#include <stderror.mqh> 
#include <stdlib.mqh> 

extern int magicNumber=2014;

extern  double closeArea=1302.52;
extern  double neutralArea=1289.33;
extern  double openArea=1285.23;

double numlot=0.1;
bool isTradingStopped;
//+------------------------------------------------------------------+ 
//| Expert initialization function                                   | 
//+------------------------------------------------------------------+ 
int OnInit()
  {
//--- 
   isTradingStopped=false;

   if(!ObjectCreate(0,"startCloseArea",OBJ_HLINE,0,0,closeArea))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startCloseArea",OBJPROP_COLOR,clrBlue);

   if(!ObjectCreate(0,"startNeutralArea",OBJ_HLINE,0,0,neutralArea))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startNeutralArea",OBJPROP_COLOR,clrLime);

   if(!ObjectCreate(0,"startOpenArea",OBJ_HLINE,0,0,openArea))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
     }
   ObjectSet("startOpenArea",OBJPROP_COLOR,clrRed);

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

   if(Ask>closeArea)
     {
      computeCloseArea();
     }
   else if(Ask>neutralArea)
     {
     }
   else if(Ask>openArea)
     {
      computeOpenArea();
     }
   else
     {
      computeLossesArea();
     }

  }
//+------------------------------------------------------------------+ 
void computeCloseArea()
  {
   closeAllBuyOrders();
  }
//+------------------------------------------------------------------+ 
void computeOpenArea()
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
void computeLossesArea()
  {
   closeAllBuyOrders();
   isTradingStopped=true;
  }
//+------------------------------------------------------------------+ 
void closeAllBuyOrders()
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
void openBuyOrder()
  {
   int numOrdre=0;
   RefreshRates();
//    Print("openBuy()  -  Ask : ",  Ask, "  -  Bid : ",  Bid, "dBestBuyPrice : ",  dBestBuyPrice,  dBestBuyPrice - 0.001 ); 

   numOrdre=OrderSend(Symbol(),OP_BUY,numlot*1,Ask,3,NULL,0,"",magicNumber,0,CLR_NONE);
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
