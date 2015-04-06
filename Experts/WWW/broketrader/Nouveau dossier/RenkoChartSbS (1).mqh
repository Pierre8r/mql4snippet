/**************************************************************************************************

                                                                                     RenkoChart.mq4 
                                                                               (c) 2014 Broketrader 

   You can freely share and are are encouraged to modify and improve this source file
   as long as you please keep the original author copyright statement above and you write your
   modifications below, last modification first.
   
   Broketrader, March 18 2014, Cleaned, commented and ready for distribution.
   Broketrader, March 3 2014, First version.
   
**************************************************************************************************/
#property copyright "(c) 2014 broketrader"
#property strict




/**************************************************************************************************

   RenkoChart Class.
   Creates an offline reko chart and updates it.
                                                  
**************************************************************************************************/
class RenkoChart {

   struct   RenkoRate{
      int      m_Time;
      double   m_Open, m_Low, m_High, m_Close, m_Vol;
   };


   static RenkoChart*      m_pInstance;
   int                     m_CustomPeriod;   
   int                     m_BoxSize;        
   int                     m_FileHandle;  
   int                     m_BarCount;    
   int                     m_BarIndex;    
   RenkoRate               m_Rate;        
   double                  m_PrevHigh;    
   double                  m_PrevLow;     

   
   protected:
                           RenkoChart();

   public:
      static RenkoChart*   Instance();
      bool                 OnInit( int custperiod, int boxsizepips ); 
   
};




/**************************************************************************************************
   Initialization of static variables
   
**************************************************************************************************/
RenkoChart* RenkoChart::m_pInstance = NULL;




/**************************************************************************************************

   Constructor
   Initializes private variables.
                                                  
**************************************************************************************************/
RenkoChart::RenkoChart() {
}




/**************************************************************************************************
   Instance()
   Auto constructs the singleton object.
   
**************************************************************************************************/
static RenkoChart* RenkoChart::Instance() {
   if( m_pInstance == NULL ){
      m_pInstance = new RenkoChart();
   }
   return m_pInstance;
}




/**************************************************************************************************

   OnInit
   Initializes variables.
   custperiod: Custom period under which we should store the history file.
   boxsizepips: Size of the Renko brick in pips.
   Creates the history file and writes the header and first bar.
                                                  
**************************************************************************************************/
bool RenkoChart::OnInit( int custperiod, int boxsizepips ) {
   m_BoxSize = boxsizepips;
   m_CustomPeriod = custperiod;

   string CustomPeriodStr = IntegerToString( m_CustomPeriod );
   
   // Create history file
   m_FileHandle = FileOpenHistory( Symbol() + CustomPeriodStr + ".hst", FILE_BIN|FILE_WRITE );
   
   if( m_FileHandle < 0 ) {
      Print( "Error creating history file: " + IntegerToString(GetLastError()) );
      return false;
   }

   // Get number of bars in chart and initialize index
   m_BarCount = Bars;
   m_BarIndex = m_BarCount-1;
 
    // Write file header.
   int      Version     = 400;
   string   CopyRight   = "(c) 2014 Broketrader RenkoChart";
   string   SymbolPair  = Symbol();
   int      TimePeriod  = m_CustomPeriod;
   int      PriceDigits = Digits;
   int      Unused[13];
   
   ArrayInitialize( Unused, 0 );
   
   FileWriteInteger( m_FileHandle, Version, LONG_VALUE );      // Version
   FileWriteString( m_FileHandle, CopyRight, 64 );             // Copyright
   FileWriteString( m_FileHandle, SymbolPair, 12 );            // Symbol
   FileWriteInteger( m_FileHandle, TimePeriod, LONG_VALUE );   // Period
   FileWriteInteger( m_FileHandle, PriceDigits, LONG_VALUE );  // Digits
   FileWriteInteger( m_FileHandle, 0, LONG_VALUE );            // Time Sign
   FileWriteInteger( m_FileHandle, 0, LONG_VALUE );            // Last Sync
   FileWriteArray( m_FileHandle, Unused, 0, 13 );              // Unused

   // Write first simple bar.
   if( Close[m_BarIndex] > Open[m_BarIndex] ){
      m_Rate.m_Open    = Low[m_BarIndex];
      m_Rate.m_Low     = m_Rate.m_Open;
      m_Rate.m_High    = High[m_BarIndex];
      m_Rate.m_Close   = m_Rate.m_High;
   }
   else{
      m_Rate.m_Open    = High[m_BarIndex];
      m_Rate.m_High    = m_Rate.m_Open;
      m_Rate.m_Low     = Low[m_BarIndex];
      m_Rate.m_Close   = m_Rate.m_Low;
   }
   
   m_PrevHigh = m_Rate.m_High;
   m_PrevLow  = m_Rate.m_Low;
   
   m_Rate.m_Vol  = (double)Volume[m_BarIndex];
   m_Rate.m_Time =  (int)Time[m_BarIndex];
   FileWriteStruct( m_FileHandle, m_Rate );
   
   // We prepare for the next bar
   m_BarIndex--;
   m_Rate.m_Vol = 0;

   return true;
 }
 