//----------------------------------------------------------------------------------------
// usualexpert.mq4
// The code should be used for educational purpose only.
//----------------------------------------------------------------------------------- 1 --
#property copyright "Copyright © Book, 2007"
#property link      "http://AutoGraf.dp.ua"
//----------------------------------------------------------------------------------- 2 --
#include <stdlib.mqh>
#include <stderror.mqh>
#include <WinUser32.mqh>
//----------------------------------------------------------------------------------- 3 --
#include <Variables.mqh>   // Description of variables 
#include <Check.mqh>       // Checking legality of programs used
#include <Terminal.mqh>    // Order accounting
#include <Events.mqh>      // Event tracking function
#include <Inform.mqh>      // Data function
#include <Trade.mqh>       // Trade function
#include <Open_Ord.mqh>    // Opening one order of the preset type
#include <Close_All.mqh>   // Closing all orders of the preset type
#include <Tral_Stop.mqh>   // StopLoss modification for all orders of the preset type
#include <Lot.mqh>         // Calculation of the amount of lots
#include <Criterion.mqh>   // Trading criteria
#include <Errors.mqh>      // Error processing function
//----------------------------------------------------------------------------------- 4 --
int init()                             // Special function 'init'
  {
   Level_old=MarketInfo(Symbol(),MODE_STOPLEVEL );//Min. distance
   Terminal();                         // Order accounting function 
   return;                             // Exit init() 
  }
//----------------------------------------------------------------------------------- 5 --
int start()                            // Special function 'start'
  {
   if(Check()==false)                  // If the usage conditions..
      return;                          // ..are not met, then exit
   PlaySound("tick.wav");              // At every tick
   Terminal();                         // Order accounting function 
   Events();                           // Information about events
   Trade(Criterion());                 // Trade function
   Inform(0);                          // To change the color of objects
   return;                             // Exit start()
  }
//----------------------------------------------------------------------------------- 6 --
int deinit()                           // Special function deinit()
  {
   Inform(-1);                         // To delete objects
   return;                             // Exit deinit()
  }
//----------------------------------------------------------------------------------- 7 --