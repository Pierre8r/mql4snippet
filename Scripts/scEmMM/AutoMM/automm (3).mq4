//+------------------------------------------------------------------+
//|                                                       automm.mq4 |
//|                                           Copyright 2015, dXerof |
//|                          http://free-bonus-deposit.blogspot.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2015, dXerof"
#property link      "http://free-bonus-deposit.blogspot.com/"
#property show_confirm
#property show_inputs

extern bool OPBUY=False;
extern bool OPSELL=False;
extern double Risk= 10;
extern double SL=20;
extern int Jumlah_OP=2;
extern double TakeProfit=20;
double Lots;
double ModifyTP;
extern bool CloseALL=False;
extern int MagicNumber=333;

int ticket;
int OpType;
double asbid,TP;
double RiskLoss;
double poen;
//+------------------------------------------------------------------+
//| script "send pending order with expiration data"                 |
//+------------------------------------------------------------------+
int start()
  {
   if(Digits==2 || Digits==4) poen=Point;
   if(Digits==3 || Digits==5) poen=10*Point;

   double tick=MarketInfo(Symbol(),MODE_TICKVALUE);
   double minlot=MarketInfo(Symbol(),MODE_MINLOT);
   double maxlot=MarketInfo(Symbol(),MODE_MAXLOT);
   double spread=MarketInfo(Symbol(),MODE_SPREAD);

   RiskLoss=(Risk/100)*AccountBalance();

   Lots=RiskLoss/((SL+spread)*tick);
//----
   if(OPBUY) { OpType=OP_BUY; asbid=Ask; if(TakeProfit>0) TP=NormalizeDouble(Ask+TakeProfit*poen,Digits); else TP=0;}
   if(OPSELL) { OpType=OP_SELL; asbid=Bid; if(TakeProfit>0) TP=NormalizeDouble(Bid-TakeProfit*poen,Digits); else TP=0;}

   double mylot;
   double newSL=SL+spread;

   mylot=NormalizeDouble(Lots/Jumlah_OP,2);

   if(mylot<=minlot) mylot=minlot;
   if(mylot>=maxlot) mylot=maxlot;

   if(mylot<minlot)
     {
      Print("not enough money....");
      Comment("\n\nNot enough money....");
      return(0);
     }

   for(int jop=0; jop<Jumlah_OP; jop++)
     {
      ticket=0;
      while(ticket==0)
        {
         ticket=OrderSend(Symbol(),OpType,mylot,asbid,30,0,0,"theDX",MagicNumber,0,Green);
        }
     }

   if(CloseALL)
     {
      int  total=OrdersTotal();
      for(int y=OrdersTotal()-1; y>=0; y--)
        {
         if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES))
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
              {
               ticket=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),5,Black);
              }
        }
     }

   ModifyTP=SL;

   if(ModifyTP>0)
     {
      for(int icnt=0; icnt<OrdersTotal(); icnt++)
        {
         if(OrderSelect(icnt,SELECT_BY_POS,MODE_TRADES))
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
              {
               if(OrderType()==OP_BUY) ticket=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-newSL*poen,Digits),OrderOpenPrice()+TakeProfit*poen,0,CLR_NONE);
               if(OrderType()==OP_SELL) ticket=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+newSL*poen,Digits),OrderOpenPrice()-TakeProfit*poen,0,CLR_NONE);
              }
        }
     }
//----
   Comment(
           "\n\n Risk % : ",Risk,
           "\n Max Loss $ : ",RiskLoss,
           "\n Balace : ",AccountBalance()
           );

   dpkfx();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void dpkfx()
  {
   int ipos=3;
   int xpos=30;
   int st=1;

   stats("dpkforex","dXerof . . .",12,"Impact",Red,ipos,xpos,30);
   stats("line2","http://free-bonus-deposit.blogspot.com",8,"Arial",White,ipos,xpos-1,18);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void stats(string tname,string word,int fsize,string ftype,color tcolor,int posxy,int posx,int posy)
  {
   ObjectCreate(tname,OBJ_LABEL,0,0,0);
   ObjectSetText(tname,word,fsize,ftype,tcolor);
   ObjectSet(tname,OBJPROP_CORNER,posxy);
   ObjectSet(tname,OBJPROP_XDISTANCE,posx);
   ObjectSet(tname,OBJPROP_YDISTANCE,posy);
  }
//+------------------------------------------------------------------+
