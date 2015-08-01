//+------------------------------------------------------------------+
//|                                                  LongOrShort.mq4 |
//|                                         Copyright 2013, Pierre8r |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Pierre8r"
#property link      ""

#include <stderror.mqh>
#include <stdlib.mqh>

double OrderPrice;

double numlot=0.1;
extern int magicNumber=20120724;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() 
  {
//----

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() 
  {
//----

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() 
  {
//----
   if(Close[1]>=Open[2]) 
     {
      if(isLongAlreadyOpen()) {}
      else 
        {
         closeAllOrders();
         openLong();
        }
     }

   if(Close[1]<Open[2]) 
     {
      if(isShortAlreadyOpen()) {}
      else 
        {
         closeAllOrders();
         openShort();
        }
     }

//----
   return(0);
  }
//+------------------------------------------------------------------+
void openLong() 
  {
   int numOrdre=0;
   RefreshRates();
   numOrdre=OrderSend(Symbol(),OP_BUY,numlot,Ask,3,NULL,0,"",magicNumber,0,CLR_NONE);
   if(numOrdre==0) 
     {
      Alert("Problme ouverture Ordre : "+ErrorDescription(GetLastError()));
     }
   if(OrderSelect(numOrdre,SELECT_BY_TICKET)==true) 
     {
      OrderPrice=OrderOpenPrice();
     }
   else
      Print("OrderSelect returned the error of ",GetLastError());
  }
//+------------------------------------------------------------------+
void openShort() 
  {
   int numOrdre=0;
   RefreshRates();
   numOrdre=OrderSend(Symbol(),OP_SELL,numlot,Ask,3,NULL,0,"",magicNumber,0,CLR_NONE);
   if(numOrdre==0) 
     {
      Alert("Problme ouverture Ordre : "+ErrorDescription(GetLastError()));
     }
   if(OrderSelect(numOrdre,SELECT_BY_TICKET)==true) 
     {
      OrderPrice=OrderOpenPrice();
     }
   else
      Print("OrderSelect returned the error of ",GetLastError());
  }
//+------------------------------------------------------------------+
bool isLongAlreadyOpen() 
  {
   for(int i=OrdersTotal()-1; i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symbol()) 
        {
         if(OrderType()==OP_BUY) 
           {
            return (true);
           }
        }
     }
   return (false);
  }
//+------------------------------------------------------------------+
bool isShortAlreadyOpen() 
  {
   for(int i=OrdersTotal()-1; i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symbol()) 
        {
         if(OrderType()==OP_SELL) 
           {
            return (true);
           }
        }
     }
   return (false);
  }
//+------------------------------------------------------------------+
void closeAllOrders() 
  {
   for(int i=OrdersTotal()-1; i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symbol()) 
        {
         closeOrder(OrderTicket());
        }
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
        { Alert("Passage fermeture Ordre - Changement etat de ordre");}
      else
        { Alert("Probleme fermeture ordre "+ErrorDescription(GetLastError()));}
     }
  }
//+------------------------------------------------------------------+
