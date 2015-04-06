//+------------------------------------------------------------------+
//|                                                     Basket14.mq4 |
//|                                       Copyright © 2011, PatPatel |
//|                                       forexfactory.pat1@gmail.com|
//+------------------------------------------------------------------+

// Modified by GVC....

#property copyright "Copyright © 2011, PatPatel"
#property link      "forexfactory.pat1@gmail.com"
#include <WinUser32.mqh>
#include <stdlib.mqh>
#import "user32.dll"
    int RegisterWindowMessageA(string lpString); 
#import

#property indicator_chart_window

//-------------------------------------------------------------------
extern int NumOfPairs = 14;
extern int MaxBars = 1000;
extern int TF = 60;
string Pair_suffix;
string shortname;

string Pair[14];
double Factor,multiplier[14];
int j,StartBar;
string Currency;
static int ExtHandle=-1;
static int tf = 0;
int MN=0;
int MT4InternalMsg;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()


{
   
   Pair_suffix=StringTrimLeft(StringTrimRight(StringSubstr(Symbol(),6,StringLen(Symbol())-6)));
   
   Get_Trade_Pairs();
   Currency="BSKT"+PadValINT(NumOfPairs,2)+Pair_suffix; 
   GlobalVariableSet(Currency+"_"+TF+"_Fact",Factor);
   
   for(int kj=0;kj<NumOfPairs;kj++)
   {
   if(StringSubstr(Pair[kj],3,3)=="JPY") multiplier[kj]=1.0; else multiplier[kj]=100.0;
   }
   IndicatorShortName(Currency);


   if (TF==0) tf = Period();
   else tf = TF;
   
//Create initial file
   int    version=400;
   string c_copyright;
   string c_symbol=Currency;
   int    i_period=tf;
   int    i_digits=3;
   int    i_unused[13];


//DNK - indentify
   i_unused[0]=3; i_unused[1]=3; i_unused[2]=3;

//----  
   ExtHandle=FileOpenHistory(c_symbol+i_period+".hst", FILE_BIN|FILE_WRITE);
   if(ExtHandle < 0) return(-1);
//---- write history file header
   c_copyright="Copyright © 2011, PatPatel";
   FileWriteInteger(ExtHandle, version, LONG_VALUE);
   FileWriteString(ExtHandle, c_copyright, 64);
   FileWriteString(ExtHandle, c_symbol, 12);
   FileWriteInteger(ExtHandle, i_period, LONG_VALUE);
   FileWriteInteger(ExtHandle, i_digits, LONG_VALUE);
   FileWriteInteger(ExtHandle, 0, LONG_VALUE);       //timesign
   FileWriteInteger(ExtHandle, 0, LONG_VALUE);       //last_sync
   FileWriteArray(ExtHandle, i_unused, 0, 13);
   FileFlush(ExtHandle);
   if(ObjectFind(Currency+shortname+tf)==0)ObjectDelete(Currency+shortname+tf);
   return(0);
  }
  
//---- 
int deinit() {
   FileFlush(ExtHandle);
   FileClose(ExtHandle);
   ObjectDelete (Currency+shortname+tf);
   return(0);
}

//####################################################################
//+------------------------------------------------------------------+
//| Main program
//+------------------------------------------------------------------+
static datetime lastbar = 0;
static int last_fpos = 0;
static int hwnd;
static datetime last_time=0;

int start()

{


   if (ExtHandle==-1) Print ("Error");
   
   int counted_bars=IndicatorCounted();
   //---- check for possible errors
   if(counted_bars<0) return(-1);
   
   StartBar = MaxBars;
   
   if (counted_bars>0) StartBar=Bars-counted_bars;

   //---- main loop
   for(int i=StartBar; i>=0; i--)
   {  
      if (lastbar < iTime(Symbol(),tf,i)) 
      {
         last_fpos=FileTell(ExtHandle);
         lastbar=iTime(Symbol(),tf,i);
      }
      else
      {
         FileSeek(ExtHandle,last_fpos,SEEK_SET);  
      }
      

      datetime timebar=iTime(Symbol(),tf,i);
      
      // Change kk to -1300 if HLOC values are less than 0. 
      double kk=-Factor;
      double sum_A_Pair_C=kk;
      double sum_A_Pair_H=kk;
      double sum_A_Pair_L=kk;
      double sum_A_Pair_O=kk;
      double sum_A_Pair_V=0.0;
      
      for (j=0;j<NumOfPairs;j++)
      {
        int shift=iBarShift(Pair[j],tf,timebar);
         if (iTime(Pair[j],tf,i)>iTime(Pair[j],tf,shift)) {
            shift++;         
         } 
         sum_A_Pair_C=sum_A_Pair_C  +iClose(Pair[j],tf,shift)*multiplier[j];
         sum_A_Pair_H=sum_A_Pair_H  + iHigh(Pair[j],tf,shift)*multiplier[j];
         sum_A_Pair_L=sum_A_Pair_L  +  iLow(Pair[j],tf,shift)*multiplier[j];
         sum_A_Pair_O=sum_A_Pair_O  + iOpen(Pair[j],tf,shift)*multiplier[j];
         sum_A_Pair_V=sum_A_Pair_V  +iVolume(Pair[j],tf,shift);
      }
      
      //Update file with current values
         
      FileWriteInteger(ExtHandle, lastbar, LONG_VALUE);
      FileWriteDouble(ExtHandle, sum_A_Pair_O, DOUBLE_VALUE);
      FileWriteDouble(ExtHandle, sum_A_Pair_L, DOUBLE_VALUE);
      FileWriteDouble(ExtHandle, sum_A_Pair_H, DOUBLE_VALUE);
      FileWriteDouble(ExtHandle, sum_A_Pair_C, DOUBLE_VALUE);
      FileWriteDouble(ExtHandle, sum_A_Pair_V, DOUBLE_VALUE);
      FileFlush(ExtHandle); 
      }
      
      // Update Basket Chart if Available
      
      static int hwnd = 0;
      if (hwnd == 0)  hwnd = WindowHandle(Currency, tf);

    if(MT4InternalMsg == 0) 
        MT4InternalMsg = RegisterWindowMessageA("MetaTrader4_Internal_Message");

    if(hwnd != 0) if(PostMessageA(hwnd, WM_COMMAND, 0x822c, 0) == 0) hwnd = 0;
    if(hwnd != 0 && MT4InternalMsg != 0) PostMessageA(hwnd, MT4InternalMsg, 2, 1);
      
      
   return(0);
}
//+------------------------------------------------------------------+


int Get_Trade_Pairs()
  {
   switch (NumOfPairs)
      {
      case 1:  Pair[0] = "GBPJPY" + Pair_suffix;
               Factor=0.0;
               break;
      case 2:  Pair[0] = "GBPUSD" + Pair_suffix;
               Pair[1] = "EURUSD" + Pair_suffix;
               Factor=200.0;
               break;
      case 4:  Pair[0] = "GBPUSD" + Pair_suffix;
               Pair[1] = "EURJPY" + Pair_suffix;
               Pair[2] = "EURUSD" + Pair_suffix;
               Pair[3] = "GBPJPY" + Pair_suffix;
               Factor=400.0;
               break;
      case 5:  Pair[0] = "AUDJPY" + Pair_suffix;
               Pair[1] = "NZDUSD" + Pair_suffix;
               Pair[2] = "EURJPY" + Pair_suffix;
               Pair[3] = "GBPJPY" + Pair_suffix;
               Pair[4] = "GBPUSD" + Pair_suffix;               
               Factor=500.0;
               break;         
      case 6:  Pair[0] = "GBPUSD" + Pair_suffix;
               Pair[1] = "EURJPY" + Pair_suffix;
               Pair[2] = "AUDUSD" + Pair_suffix;
               Pair[3] = "EURUSD" + Pair_suffix;
               Pair[4] = "GBPJPY" + Pair_suffix;
               Pair[5] = "NZDUSD" + Pair_suffix;
               Factor=600.0;
               break;
      case 7:  Pair[0] = "USDJPY" + Pair_suffix;
               Pair[1] = "EURJPY" + Pair_suffix;
               Pair[2] = "GBPJPY" + Pair_suffix;
               Pair[3] = "NZDJPY" + Pair_suffix;
               Pair[4] = "AUDJPY" + Pair_suffix;
               Pair[5] = "CHFJPY" + Pair_suffix;
               Pair[6] = "CADJPY" + Pair_suffix;               
               Factor=700.0;
               break;          
      case 8:  Pair[0] = "GBPUSD" + Pair_suffix;
               Pair[1] = "EURJPY" + Pair_suffix;
               Pair[2] = "AUDUSD" + Pair_suffix;
               Pair[3] = "NZDJPY" + Pair_suffix;
               Pair[4] = "EURUSD" + Pair_suffix;
               Pair[5] = "GBPJPY" + Pair_suffix;
               Pair[6] = "NZDUSD" + Pair_suffix;
               Pair[7] = "AUDJPY" + Pair_suffix;
               Factor=800.0;
               break;
      case 10: Pair[0] = "GBPUSD" + Pair_suffix;
               Pair[1] = "EURGBP" + Pair_suffix;
               Pair[2] = "GBPJPY" + Pair_suffix;
               Pair[3] = "CADJPY" + Pair_suffix;
               Pair[4] = "NZDUSD" + Pair_suffix;
               Pair[5] = "EURUSD" + Pair_suffix;
               Pair[6] = "USDJPY" + Pair_suffix;
               Pair[7] = "AUDUSD" + Pair_suffix;
               Pair[8] = "NZDJPY" + Pair_suffix;
               Pair[9] = "GBPCHF" + Pair_suffix;
               Factor=1000.0;
               break;
      case 12: Pair[0] = "GBPUSD" + Pair_suffix;
               Pair[1] = "EURGBP" + Pair_suffix;
               Pair[2] = "GBPJPY" + Pair_suffix;
               Pair[3] = "CADJPY" + Pair_suffix;
               Pair[4] = "NZDUSD" + Pair_suffix;
               Pair[5] = "AUDJPY" + Pair_suffix;
               Pair[6] = "EURUSD" + Pair_suffix;
               Pair[7] = "USDJPY" + Pair_suffix;
               Pair[8] = "AUDUSD" + Pair_suffix;
               Pair[9] = "NZDJPY" + Pair_suffix;
               Pair[10] = "GBPCHF" + Pair_suffix;
               Pair[11] = "CHFJPY" + Pair_suffix;
               Factor=1200.0;
               break;
      case 14: Pair[0] = "GBPUSD" + Pair_suffix;
               Pair[1] = "EURGBP" + Pair_suffix;
               Pair[2] = "GBPJPY" + Pair_suffix;
               Pair[3] = "USDCHF" + Pair_suffix;
               Pair[4] = "NZDUSD" + Pair_suffix;
               Pair[5] = "AUDJPY" + Pair_suffix;
               Pair[6] = "EURJPY" + Pair_suffix;
               Pair[7] = "EURUSD" + Pair_suffix;
               Pair[8] = "USDJPY" + Pair_suffix;
               Pair[9] = "AUDUSD" + Pair_suffix;
               Pair[10] = "NZDJPY" + Pair_suffix;
               Pair[11] = "GBPCHF" + Pair_suffix;
               Pair[12] = "CHFJPY" + Pair_suffix;
               Pair[13] = "EURCHF" + Pair_suffix;
               Factor=1400.0;
               break;
       default: break;
       }
       Currency=Currency+Pair_suffix;
//----
   return(0);
  }
  
  string PadValINT(int Val,  int PadSpc)
{
  string S = Val;
  
  while ( StringLen(S) < PadSpc ) S = "0" + S;
  
  return(S); 
}