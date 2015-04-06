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




#import "user32.dll"
   int RegisterWindowMessageW(string lpString);
   int PostMessageW(int hWnd,int Msg,int wParam,int lParam);
#import




/**************************************************************************************************
   Include Files
**************************************************************************************************/
#include <WinUser32.mqh>




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
   ulong                   m_FileCPos;
   bool                    m_InitDone;

   
   protected:
                           RenkoChart();
      bool                 ComputeRenkoBar( int index );
      void                 ComputeCurrentBar();

   public:
      static RenkoChart*   Instance();
      bool                 OnInit( int custperiod, int boxsizepips ); 
      void                 OnTimer();
      void                 OnCalculate( int bars );
      void                 OnDeinit();
   
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

   // Initiates event driven writing
   EventSetMillisecondTimer( 1 );

   return true;
 }
 
 
 
 
 /**************************************************************************************************

   OnTimer
   Does some amount of renko bar calculation.
                                                  
**************************************************************************************************/
void RenkoChart::OnTimer() {
   // Avoid re-entrancy
   EventKillTimer();
   
   // Compute let's say a maximum of 100000 bars at a time.
   for( int i=0; i<100000 && m_BarIndex >= 1; i++, m_BarIndex-- ){
      bool NewBar = ComputeRenkoBar( m_BarIndex );
      
      if( NewBar ){
         FileWriteStruct( m_FileHandle, m_Rate );
         // Reset volume for next bar
         m_Rate.m_Vol = 0;
      }
   }
   
   // If we have calculated all bars except the current one...
   if( m_BarIndex <= 1 ){
      // Finished. Display some termination info and don't rearm the timer anymore.
      Comment( "Renko Chart Completed. Please open the M3 offline chart" );
      // Store file position for further usage
      m_FileCPos = FileTell( m_FileHandle );
      // Close and we are done.
      FileClose( m_FileHandle );
      m_FileHandle = -1;
      m_InitDone = true;
   }
   else{
      // Not finished yet. Display some info text and rearm the timer
      double Completed = (double)(m_BarCount-m_BarIndex) / (double)m_BarCount * 100;
      Comment( "RenkoChart is creating the history file : " + DoubleToStr(Completed,0) + "% Completed" );
      EventSetMillisecondTimer( 1 );
   }
}




/**************************************************************************************************

   ComputeRenkoBar
   Compute Renko bar for a closed bar price.
   index: bar index.
   We get a new bar when the price is higher or lower than previous Renko bar high or low plus the
   box size. Computation is stored in the m_Rate structure.
   Returns true if a new bar is completed. False otherwise.
                                                  
**************************************************************************************************/
bool RenkoChart::ComputeRenkoBar( int index ) {
   bool Res = false;
   
   if( Close[index] > m_PrevHigh + m_BoxSize*Point ) {
      m_Rate.m_Open    = m_PrevHigh;
      m_Rate.m_Low     = m_Rate.m_Open;
      m_Rate.m_High    = m_Rate.m_Open + m_BoxSize*Point;
      m_Rate.m_Close   = m_Rate.m_High;
      Res = true;
   }
   else if( Close[index] < m_PrevLow - m_BoxSize*Point ) {
      m_Rate.m_Open    = m_PrevLow;
      m_Rate.m_High    = m_Rate.m_Open;
      m_Rate.m_Low     = m_Rate.m_Open - m_BoxSize*Point;
      m_Rate.m_Close   = m_Rate.m_Low;
      Res = true;
   }
   if( m_Rate.m_Vol == 0 ){
      m_Rate.m_Vol = (double)Volume[m_BarIndex];
   }
   else{
      m_Rate.m_Vol += (double)Volume[m_BarIndex];
   }
   
   if( Res ){
      m_Rate.m_Time = (int)Time[index];
      m_PrevHigh = m_Rate.m_High;
      m_PrevLow  = m_Rate.m_Low;
   }
   
   return Res;
}




/**************************************************************************************************

   OnCalculate
   Updates renko file and current bar.
   bars: Current chart bars.
                                                  
**************************************************************************************************/
void RenkoChart::OnCalculate( int bars ) {
   
   // We are still writing the histor file. Do nothing.
   if( ! m_InitDone ){
      return;
   }
   
   // On first call after history file creation, we must reopen the file
   if( m_FileHandle == -1 ){
      string CustomPeriodStr = IntegerToString( m_CustomPeriod );
      m_FileHandle = FileOpenHistory( Symbol() + CustomPeriodStr + ".hst", FILE_BIN|FILE_WRITE|FILE_READ|FILE_SHARE_READ|FILE_SHARE_WRITE );
      if( m_FileHandle == -1 ){
         Comment( "RenkoChart cannot update history file !" );
         return;
      }
   }
   
   // For all bars in chart that we have not yet computed...
   for( m_BarIndex=bars-m_BarCount; m_BarIndex >= 0; m_BarIndex-- ){
      
      if( m_BarIndex == 0 ){
         // Update current bar and keep file pos;
         // We rewrite last Renko bar values at the same file position
         ComputeCurrentBar();         
         FileSeek( m_FileHandle, m_FileCPos, SEEK_SET );
         FileWriteStruct( m_FileHandle, m_Rate );
         FileFlush( m_FileHandle );
      }
      else{
         // Look wether a new bar can be drawn (stored)
         bool NewBar = ComputeRenkoBar( m_BarIndex );
         if( NewBar ){
            FileSeek( m_FileHandle, m_FileCPos, SEEK_SET );
            FileWriteStruct( m_FileHandle, m_Rate );
            // Reset volume for next bar
            m_Rate.m_Vol = 0;
            FileFlush( m_FileHandle );
            m_FileCPos = FileTell( m_FileHandle );
         }
         
      }
   }
   // Call extern functions to force chart redraw
   UpdateChartWindow( m_CustomPeriod );
   m_BarCount = bars;
}




/**************************************************************************************************

   ComputeCurrentBar
   Compute Renko bar of the still open bar.
                                                  
**************************************************************************************************/
void RenkoChart::ComputeCurrentBar() {
   if( Close[0] > m_PrevHigh ){
      m_Rate.m_Open  = m_PrevHigh;
      m_Rate.m_Low   = m_Rate.m_Open;
      m_Rate.m_High  = Close[0];
      m_Rate.m_Close = Close[0];
   }
   else if( Close[0] < m_PrevLow ){
      m_Rate.m_Open  = m_PrevLow;
      m_Rate.m_High  = m_Rate.m_Open;
      m_Rate.m_Low   = Close[0];
      m_Rate.m_Close = Close[0];
   }
   else{
      m_Rate.m_Open  = Close[0];;
      m_Rate.m_High  = Close[0];;
      m_Rate.m_Low   = Close[0];
      m_Rate.m_Close = Close[0];
   }
   m_Rate.m_Time = (int)Time[0];
   m_Rate.m_Vol = (double)Volume[0];
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
void RenkoChart::OnDeinit() {
   if( m_FileHandle != -1 ){
      FileClose( m_FileHandle );
   }
}
