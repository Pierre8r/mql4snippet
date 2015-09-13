//+------------------------------------------------------------------+
//|                                                     MMScript.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
#property show_inputs
extern double Entry;
extern double SL;
extern string Types = "0 is buy,1 is sell,2 pend_buy,3 pend_sell";
extern int PendingType = -1;
extern string Note = "ON is 1 and OFF is 0";
extern int TP_ON_OR_OFF = 1;
extern double Account=10000;
extern double DollarVol=1;
extern double MinVol = 0.1;
extern double MaxVol = 100;
extern double Percentage = 2;

int start()
  {
//  double x = 123456.8599;
//  int index = StringFind(""+x,".",0);
//  x=StrToDouble(StringSubstr(DoubleToStr(x,2),0,index+2));
  
//  Alert("x=:"+x+" str="+StringSubstr(DoubleToStr(x,2),0,3));
//----
// test
//      Alert("Entry="+Entry);
//      Alert("Vol: "+calcV(Entry));
//      Alert("Profit: "+calcP(Entry));
      
      if(PendingType > -1 && PendingType < 4)
         execute();
//----
   return(0);
  }
void execute()
{
   int order;
   // calcV(); 
 //  Alert("Reached");
   double v = calcV(Entry);
   double profit = 0;
   double price = 0;
   if(TP_ON_OR_OFF == 1)
      profit = calcP(Entry);
         
   switch(PendingType)
   {
      case 0: 
      {
         v = calcV(Ask);
         if(v >= MinVol)
           order = OrderSend(Symbol(),OP_BUY,calcV(Ask),Ask,0,0,0,"TP1="+NormalizeDouble(calcP(Ask),5)
           +" SL="+NormalizeDouble(calculateSL(Ask),0),0,0,Green);  
         else Alert("Not enough funds Vol="+v);
      
         if(order > 0) 
         {
            OrderSelect(order,SELECT_BY_TICKET);
            price = OrderOpenPrice();
            if(TP_ON_OR_OFF == 1)          
               profit = calcP(price);
            OrderModify(order,price,SL,profit,NULL);
         }
      } 
      break;
      case 1:
      {
         v = calcV(Bid);
 //        Alert("v="+v);
         if(v >= MinVol)
            order = OrderSend(Symbol(),OP_SELL,calcV(Bid),Bid,0,0,0,"TP1="+NormalizeDouble(calcP(Bid),5)
            +"SL="+calculateSL(Bid),0,0,Red);   
         else Alert("Not enough funds Vol="+v); 

         if(order > 0) 
         {
            OrderSelect(order,SELECT_BY_TICKET);
            price = OrderOpenPrice();
            if(TP_ON_OR_OFF == 1)
               profit = calcP(price);
            OrderModify(order,price,SL,profit,NULL);
         }
      }  
      break;
      case 2:
      {
         if(v < MinVol)
            Alert("Not enough funds Vol="+v);
         if(Entry >= Ask)
            order = OrderSend(Symbol(),OP_BUYSTOP,calcV(Entry),Entry,0,0,0,"TP1="+NormalizeDouble(calcP(Entry),5)
            +" SL="+calculateSL(Entry),0,0,Green);       
         else
            order = OrderSend(Symbol(),OP_BUYLIMIT,calcV(Entry),Entry,0,0,0,"TP1="+NormalizeDouble(calcP(Entry),5)
            +" SL="+calculateSL(Entry),0,0,Green);
      }
      break;
      case 3:
      {
         if(v < MinVol)
            Alert("Not enough funds Vol="+v);      
         if(Entry <= Bid)
            order = OrderSend(Symbol(),OP_SELLSTOP,calcV(Entry),Entry,0,0,0,"TP1="+NormalizeDouble(calcP(Entry),5)
            +" SL="+calculateSL(Entry),0,0,Red);
         else
            order = OrderSend(Symbol(),OP_SELLLIMIT,calcV(Entry),Entry,0,0,0,"TP1="+NormalizeDouble(calcP(Entry),5)
            +" SL="+calculateSL(Entry),0,0,Red);
      }
      break;
   }
   if(order > 0 && (PendingType == 2 || PendingType == 3))
   {
    //  Alert("reached");
      OrderSelect(order,SELECT_BY_TICKET);
      price = OrderOpenPrice();
      OrderModify(order,price,SL,profit,NULL);
   }
}

double calcV(double price) 
{
   double v = -1;
   
   v = (((Percentage/100) * Account) / calculateSL(price)) * DollarVol; 
   int index = StringFind(""+v,".",0);
   v=StrToDouble(StringSubstr(DoubleToStr(v,2),0,index+2));
   if(v > MaxVol) 
   {
      Alert("Max Vol reached v="+v);
      v = MaxVol;
   } 
   return (v);
}

double calculateSL(double price) 
{

   double actualSL = 0; 
   
   // test
         double x = MathAbs(price - SL);
         actualSL = x / Point;
           
   if(Digits == 3 || Digits == 5)
      actualSL = actualSL / 10;

   return (actualSL);
}

double calcP(double price)
{
   double x = 0;
   double P = 0;
   
   if(price > SL)
   {
      x = calculateSL(price);
      P = price + Point * x;
      return (P);
   }
     
   if(price < SL)
   {
      x = calculateSL(price);
      P = price - Point * x;
      return (P);
   } 
   // test
   return (P);
}
//+------------------------------------------------------------------+