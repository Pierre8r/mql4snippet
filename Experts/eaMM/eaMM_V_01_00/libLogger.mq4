//+------------------------------------------------------------------+
//|                                                    libLogger.mq4 |
//|                                   Copyright 2015, Pierre Rougier |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2015, Pierre Rougier"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum LoggerLevel
  {
   DEBUG,
   INFO,
   WARNING,
   ERROR,
   FATAL
  };
//+------------------------------------------------------------------+
//|Log                                                               |
//+------------------------------------------------------------------+
void Log(LoggerLevel loggerLevel,string messsage) export
  {
   switch(loggerLevel)
     {
      case  DEBUG:
         Print(StringConcatenate(EnumToString(loggerLevel)," - ",messsage));
         break;
      case  INFO:
         Print(StringConcatenate(EnumToString(loggerLevel)," - ",messsage));
         break;
      case  WARNING:
         Print(StringConcatenate(EnumToString(loggerLevel)," - ",messsage));
         break;
      case  ERROR:
         Print(StringConcatenate(EnumToString(loggerLevel)," - ",messsage));
         break;
      case  FATAL:
         Print(StringConcatenate(EnumToString(loggerLevel)," - ",messsage));
         ExpertRemove();

         break;
      default:
         break;
     }
  }
//+------------------------------------------------------------------+
