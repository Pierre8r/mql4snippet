//+------------------------------------------------------------------+ 
//|                                                       clArea.mqh | 
//|                                         Copyright 2014, Pierre8r | 
//|                                              http://www.mql4.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2014, Pierre8r" 
#property link      "http://www.mql4.com" 
#property version   "1.00" 
#property strict 
//+------------------------------------------------------------------+ 
//|                                                                  | 
//+------------------------------------------------------------------+ 
class CArea 
  { 
private: 
   datetime          m_startTime; 
   datetime          m_endTime; 
   double            m_resistance; 
   double            m_support; 

public: 
                     CArea(datetime startTime,datetime endTime,double  resistance,double support); 
                    ~CArea(); 
   //--- Getter methods 
   datetime          GetStarTime(void); 
   datetime          GetEndTime(void); 
   double            GetResistance(void); 
   double            GetSupport(void); 

  }; 
//+------------------------------------------------------------------+ 
void CArea::CArea(datetime startTime,datetime endTime,double  resistance,double support) 
  { 
   m_startTime=startTime; 
   m_endTime=endTime; 
   m_resistance=resistance; 
   m_support=support; 
  } 
//+------------------------------------------------------------------+ 
CArea::~CArea() 
  { 
  } 
//+------------------------------------------------------------------+ 
datetime CArea::GetStarTime(void) 
  { 
   return m_startTime; 
  } 
//+------------------------------------------------------------------+ 
datetime CArea::GetEndTime(void) 
  { 
   return m_endTime; 
  } 
//+------------------------------------------------------------------+ 
double  CArea::GetResistance(void) 
  { 
   return m_resistance; 
  } 
//+------------------------------------------------------------------+ 
double  CArea::GetSupport(void) 
  { 
   return m_support; 
  } 
//+------------------------------------------------------------------+ 