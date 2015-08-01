//+------------------------------------------------------------------+ 
//|                                                       clArea.mqh | 
//|                                         Copyright 2014, Pierre8r | 
//|                                              http://www.mql4.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2014, Pierre8r" 
#property link      "http://www.mql4.com" 
#property version   "1.00" 
#property strict 

//---- input parameters 
#include "clArea.mqh" 
//+------------------------------------------------------------------+ 
//|                                                                  | 
//+------------------------------------------------------------------+ 
class CAreas 
  { 
private: 
   CArea            *Areas[]; 

public: 
                     CAreas(); 
                    ~CAreas(); 

   void              addArea(CArea *area); 
   double            GetResistance(datetime dtime); 
   double            GetSupport(datetime dtime); 
  }; 
//+------------------------------------------------------------------+ 
//|                                                                  | 
//+------------------------------------------------------------------+ 
CAreas::CAreas() 
  { 
  } 
//+------------------------------------------------------------------+ 
CAreas::~CAreas() 
  { 
   for(int i=ArraySize(Areas)-1; i>=0; i--) 
     { 
      if(CheckPointer(Areas[i])==POINTER_DYNAMIC) 
        { 
         delete Areas[i]; 
        } 
     } 
  } 
//+------------------------------------------------------------------+ 
void CAreas::addArea(CArea *area) 
  { 
   ArrayResize(Areas,ArraySize(Areas)+1,10); 
   Areas[ArraySize(Areas)-1]=area; 
  } 
//+------------------------------------------------------------------+ 
double CAreas::GetResistance(datetime dtime) 
  { 
   for(int i=ArraySize(Areas)-1; i>=0; i--) 
     { 
      if((Areas[i].GetStarTime()<dtime) && (Areas[i].GetEndTime()>dtime)) 
        { 
         return(Areas[i].GetResistance()); 
        } 
     } 
   return(-1); 
  } 
//+------------------------------------------------------------------+ 
double CAreas::GetSupport(datetime dtime) 
  { 
   for(int i=ArraySize(Areas)-1; i>=0; i--) 
     { 
      if((Areas[i].GetStarTime()<dtime) && (Areas[i].GetEndTime()>dtime)) 
        { 
         return(Areas[i].GetSupport()); 
        } 
     } 
   return(-1); 
  } 
//+------------------------------------------------------------------+ 