/**************************************************************************************************

                                                                                     TickChart.mqh 
                                                                               (c) 2014 Broketrader 

   You can freely share or modify this source file as long as you please keep the original author
   copyright statement above. You are encouraged to sign and give some detail about your
   modifications below, last modification first. Thanks!
   
   * * *
   
   Broketrader, March 19 2014, First version.
   
**************************************************************************************************/
#property copyright "(c) 2014 broketrader"
#property strict




#import "user32.dll"
   int RegisterWindowMessageW(string lpString);
   int PostMessageW(int hWnd,int Msg,int wParam,int lParam);
#import




/**************************************************************************************************
   Include Files
**************************************************************************************************/
#include <WinUser32.mqh>




/**************************************************************************************************

   TickChart Class.
   Creates an offline reko chart and updates it.
                                                  
**************************************************************************************************/
class TickChart {
   
   struct   Rate{
      int      m_Time;
      double   m_Open, m_Low, m_High, m_Close, m_Vol;
   };
   
   static TickChart*       m_pInstance;
   int                     m_CustomPeriod;
   int                     m_FileHandle;
   Rate                    m_Rate;
   
   protected:
                           TickChart();

   public:
      static TickChart*    Instance();
      bool                 OnInit( int custperiod );
      void                 OnCalculate();
      void                 OnDeinit();
      
   
};




/**************************************************************************************************
   Initialization of static variables
   
**************************************************************************************************/
TickChart* TickChart::m_pInstance = NULL;




/**************************************************************************************************

   Constructor
   Initializes private variables.
                                                  
**************************************************************************************************/
TickChart::TickChart() {
   m_FileHandle   = -1;
}




/**************************************************************************************************
   Instance()
   Auto constructs the singleton object.
   
**************************************************************************************************/
static TickChart* TickChart::Instance() {
   if( m_pInstance == NULL ){
      m_pInstance = new TickChart();
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
bool TickChart::OnInit( int custperiod ) {

   m_CustomPeriod = custperiod;

   string CustomPeriodStr = IntegerToString( m_CustomPeriod );
   
   // Create history file
   m_FileHandle = FileOpenHistory( Symbol() + CustomPeriodStr + ".hst", FILE_BIN|FILE_WRITE|FILE_SHARE_READ|FILE_SHARE_WRITE );
   
   if( m_FileHandle < 0 ) {
      Print( "Error creating history file: " + IntegerToString(GetLastError()) );
      return false;
   }

   
   // Write file header.
   int      Version     = 400;
   string   CopyRight   = "(c) 2014 Broketrader TickChart";
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
   
   return true;
}





/**************************************************************************************************

   OnCalculate
   Updates renko file and current bar.
   bars: Current chart bars.
                                                  
**************************************************************************************************/
void TickChart::OnCalculate() {
   
   m_Rate.m_Close = Close[0];
   m_Rate.m_High  = Close[0];
   m_Rate.m_Low   = Close[0];
   m_Rate.m_Open  = Close[0];
   m_Rate.m_Vol   = 1;
   m_Rate.m_Time  = (int) TimeCurrent();

   FileWriteStruct( m_FileHandle, m_Rate );
   FileFlush( m_FileHandle );

   // Call extern functions to force chart redraw
   UpdateChartWindow( m_CustomPeriod );
}












/**************************************************************************************************

   UpdateChartWindow
   Sends the Refresh command to specific chart. Needs to be called when live updating the chart.
   /!\ Got this code from a previous indicator but don't know who the author is.
   /!\ Thanks to him/her ;-) 
                                                  
**************************************************************************************************/
int MT4InternalMsg = 0;
void UpdateChartWindow( int customperiod ) {
   
	static int hwnd = 0;
 
	if(hwnd == 0){
	   hwnd = WindowHandle(Symbol(), customperiod );
	}

	if(MT4InternalMsg == 0) {
	   MT4InternalMsg = RegisterWindowMessageW("MetaTrader4_Internal_Message");
	}

	if( hwnd != 0 ){
	   if(PostMessageW(hwnd, WM_COMMAND, 0x822c, 0) == 0){
	      hwnd = 0;
	   }
	}
	if(hwnd != 0 && MT4InternalMsg != 0){
	   PostMessageW( hwnd, MT4InternalMsg, 2, 1 );
	}

	return;
}




/**************************************************************************************************

   OnDeinit
   Must be called on indicator DeInit to close opened files
                                                  
**************************************************************************************************/
void TickChart::OnDeinit() {
   if( m_FileHandle != -1 ){
      FileClose( m_FileHandle );
   }
}



























