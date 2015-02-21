//+------------------------------------------------------------------+
//|                                                    Indicator.mqh |
//|                   Copyright 2009-2013, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#include "Series.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//enum ENUM_OBJ_TIMEFRAMES
//  {
#define    OBJ_NO_PERIODS 0
#define    OBJ_PERIOD_M1  0x00000001
#define    OBJ_PERIOD_M2  0x00000002
#define    OBJ_PERIOD_M3  0x00000004
#define    OBJ_PERIOD_M4  0x00000008
#define    OBJ_PERIOD_M5  0x00000010
#define    OBJ_PERIOD_M6  0x00000020
#define    OBJ_PERIOD_M10 0x00000040
#define    OBJ_PERIOD_M12 0x00000080
#define    OBJ_PERIOD_M15 0x00000100
#define    OBJ_PERIOD_M20 0x00000200
#define    OBJ_PERIOD_M30 0x00000400
#define    OBJ_PERIOD_H1  0x00000800
#define    OBJ_PERIOD_H2  0x00001000
#define    OBJ_PERIOD_H3  0x00002000
#define    OBJ_PERIOD_H4  0x00004000
#define    OBJ_PERIOD_H6  0x00008000
#define    OBJ_PERIOD_H8  0x00010000
#define    OBJ_PERIOD_H12 0x00020000
#define    OBJ_PERIOD_D1  0x00040000
#define    OBJ_PERIOD_W1  0x00080000
#define    OBJ_PERIOD_MN1 0x00100000
#define    OBJ_ALL_PERIODS 0x001fffff
//  };
enum ENUM_INDICATOR
  {
   IND_AC,           // Accelerator Oscillator
   IND_AD,           // Accumulation/Distribution
   IND_ADX,          // Average Directional Index
   IND_ADXW,         // - ADX by Welles Wilder
   IND_ALLIGATOR,    // Alligator
   IND_AMA,          // - Adaptive Moving Average
   IND_AO,           // Awesome Oscillator
   IND_ATR,          // Average True Range
   IND_BANDS,        // Bollinger Bands®
   IND_BEARS,        // Bears Power
   IND_BULLS,        // Bulls Power
   IND_BWMFI,        // Market Facilitation Index
   IND_CCI,          // Commodity Channel Index
   IND_CHAIKIN,      // - Chaikin Oscillator
   IND_CUSTOM,       // Custom indicator
   IND_DEMA,         // - Double Exponential Moving Average
   IND_DEMARKER,     // DeMarker
   IND_ENVELOPES,    // Envelopes
   IND_FORCE,        // Force Index
   IND_FRACTALS,     // Fractals
   IND_FRAMA,        // - Fractal Adaptive Moving Average
   IND_GATOR,        // Gator Oscillator
   IND_ICHIMOKU,     // Ichimoku Kinko Hyo
   IND_MA,           // Moving Average
   IND_MACD,         // MACD
   IND_MFI,          // Money Flow Index
   IND_MOMENTUM,     // Momentum
   IND_OBV,          // On Balance Volume
   IND_OSMA,         // OsMA
   IND_RSI,          // Relative Strength Index
   IND_RVI,          // Relative Vigor Index
   IND_SAR,          // Parabolic SAR
   IND_STDDEV,       // Standard Deviation
   IND_STOCHASTIC,   // Stochastic Oscillator
   IND_TEMA,         // - Triple Exponential Moving Average
   IND_TRIX,         // - Triple Exponential Moving Averages Oscillator
   IND_VIDYA,        // - Variable Index Dynamic Average
   IND_VOLUMES,      // - Volumes
   IND_WPR           // Williams' Percent Range
  };
enum ENUM_APPLIED_VOLUME
  {
  };
//+------------------------------------------------------------------+
//| Class CIndicator.                                                |
//| Purpose: Base class of technical indicators.                     |
//|          Derives from class CSeries.                             |
//+------------------------------------------------------------------+
class CIndicator : public CSeries
  {
public:
                     CIndicator(void);
                    ~CIndicator(void);
   //--- method for creating
   bool              Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const ENUM_INDICATOR type,const int num_params,const MqlParam &params[]);
   //--- methods of access to data
   virtual double    GetData(const int index) const { return(GetData(0,index)); }
   virtual double    GetData(const int buffer_num,const int index) const { return (0); }
   //--- methods for find extremum
//   int               Minimum(const int buffer_num,const int start,const int count) const;
//   double            MinValue(const int buffer_num,const int start,const int count,int &index) const;
//   int               Maximum(const int buffer_num,const int start,const int count) const;
//   double            MaxValue(const int buffer_num,const int start,const int count,int &index) const;
   //--- methods of conversion of constants to strings
   string            MethodDescription(const int val) const;
   string            PriceDescription(const int val) const;
   string            VolumeDescription(const int val) const;

protected:
   //--- methods of tuning
   virtual bool      Initialize(const string symbol,const ENUM_TIMEFRAMES period,
                                const int num_params,const MqlParam &params[]) {return(false);}
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
void CIndicator::CIndicator(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
void CIndicator::~CIndicator(void)
  {
  }
//+------------------------------------------------------------------+
//| Creation of the indicator with universal parameters              |
//+------------------------------------------------------------------+
bool CIndicator::Create(const string symbol,const ENUM_TIMEFRAMES period,
                        const ENUM_INDICATOR type,const int num_params,const MqlParam &params[])
  {
//--- check history
   SetSymbolPeriod(symbol,period);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Find minimum of a specified buffer                               |
//+------------------------------------------------------------------+
/*int CIndicator::Minimum(const int buffer_num,const int start,const int count) const
  {
//--- check
   if(m_handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(-1);
     }
   if(buffer_num>=m_buffers_total)
     {
      SetUserError(ERR_USER_INVALID_BUFF_NUM);
      return(-1);
     }
//---
   CIndicatorBuffer *buffer=At(buffer_num);
   if(buffer==NULL)
      return(-1);
//---
   return(buffer.Minimum(start,count));
  }*/
//+------------------------------------------------------------------+
//| Find minimum of a specified buffer                               |
//+------------------------------------------------------------------+
/*double CIndicator::MinValue(const int buffer_num,const int start,const int count,int &index) const
  {
   int    idx=Minimum(buffer_num,start,count);
   double res=EMPTY_VALUE;
//--- check
   if(idx!=-1)
     {
      CIndicatorBuffer *buffer=At(buffer_num);
      res=buffer.At(idx);
      index=idx;
     }
//---
   return(res);
  }*/
//+------------------------------------------------------------------+
//| Find maximum of a specified buffer                               |
//+------------------------------------------------------------------+
/*int CIndicator::Maximum(const int buffer_num,const int start,const int count) const
  {
//--- check
   if(m_handle==INVALID_HANDLE)
     {
      SetUserError(ERR_USER_INVALID_HANDLE);
      return(-1);
     }
   if(buffer_num>=m_buffers_total)
     {
      SetUserError(ERR_USER_INVALID_BUFF_NUM);
      return(-1);
     }
//---
   CIndicatorBuffer *buffer=At(buffer_num);
   if(buffer==NULL)
      return(-1);
//---
   return(buffer.Maximum(start,count));
  }*/
//+------------------------------------------------------------------+
//| Find maximum of specified buffer                                 |
//+------------------------------------------------------------------+
/*double CIndicator::MaxValue(const int buffer_num,const int start,const int count,int &index) const
  {
   int    idx=Maximum(buffer_num,start,count);
   double res=EMPTY_VALUE;
//--- check
   if(idx!=-1)
     {
      CIndicatorBuffer *buffer=At(buffer_num);
      res=buffer.At(idx);
      index=idx;
     }
//---
   return(res);
  }*/
//+------------------------------------------------------------------+
//| Converting value of ENUM_MA_METHOD into string                   |
//+------------------------------------------------------------------+
string CIndicator::MethodDescription(const int val) const
  {
   string str;
//--- array for conversion of ENUM_MA_METHOD to string
   static string _m_str[]={"SMA","EMA","SMMA","LWMA"};
//--- check
   if(val<0)
      return("ERROR");
//---
   if(val<4)
      str=_m_str[val];
   else
   if(val<10)
      str="METHOD_UNKNOWN="+IntegerToString(val);
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Converting value of ENUM_APPLIED_PRICE into string               |
//+------------------------------------------------------------------+
string CIndicator::PriceDescription(const int val) const
  {
   string str;
//--- array for conversion of ENUM_APPLIED_PRICE to string
   static string _a_str[]={"Close","Open","High","Low","Median","Typical","Weighted"};
//--- check
   if(val<0)
      return("Unknown");
//---
   if(val<7)
      str=_a_str[val];
   else
     {
      if(val<10)
         str="PriceUnknown="+IntegerToString(val);
      else
         str="AppliedHandle="+IntegerToString(val);
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Converting value of ENUM_APPLIED_VOLUME into string              |
//+------------------------------------------------------------------+
string CIndicator::VolumeDescription(const int val) const
  {
   string str;
//--- array for conversion of ENUM_APPLIED_VOLUME to string
   static string _v_str[]={"None","Tick","Real"};
//--- check
   if(val<0)
      return("Unknown");
//---
   if(val<3)
      str=_v_str[val];
   else
     {
      if(val<10)
         str="VolumeUnknown="+IntegerToString(val);
      else
         str="AppliedHandle="+IntegerToString(val);
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
