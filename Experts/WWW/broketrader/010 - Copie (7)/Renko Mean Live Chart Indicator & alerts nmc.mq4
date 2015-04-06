//+---------------------------------------------------------------------------+
//|   EA VERSION
//|   RenkoLiveChart_v3.3.mq4
//|   Inspired from Renko script by "e4" (renko_live_scr.mq4)
//|   Copyleft 2009 LastViking
//|   
//|   Aug 12 2009 (LV): 
//|            - Wanted volume in my Renko chart so I wrote my own script
//|     
//|   Aug 20-21 2009 (LV) (v1.1 - v1.3):
//|            - First attempt at live Renko brick formation (bugs O bugs...)
//|            - Fixed problem with strange symbol names at some 5 digit 
//|               brokers (credit to Tigertron)
//|     
//|   Aug 24 2009 (LV) (v1.4):
//|            - Handle High / Low in history in a reasonable way (prev. 
//|               used Close)
//|   
//|   Aug 26 2009 (Lou G) (v1.5/v1.6):
//|            - Finaly fixing the "late appearance" (live Renko brick 
//|               formation) bug
//| 
//|   Aug 31 2009 (LV) (v2.0):
//|            - Not a script anylonger, but run as indicator 
//|            - Naroved down the MT4 bug that used to cause the "late appearance bug" 
//|               a little closer (has to do with High / Low gaps)
//|            - Removed the while ... sleep() loop. Renko chart is now tick 
//|               driven: -MUSH nicer to system resources this way
//| 
//|   Sep 03 2009 (LV) (v2.1):
//|            - Fixed so that Time[] holds the open time of the renko 
//|               bricks (prev. used time of close)
//|     
//|   Sep 16 2009 (Lou G) (v3.0): 
//|            - Optional wicks added
//|            - Conversion back to EA 
//|            - Auto adjust for 5 and 6 dec brokers added
//|               enter RenkoBoxSize as "actual" size e.g. "10" for 10 pips
//|            - Compensation for "zero compare" problem added
//|
//|   Okt 05 2009 (LV) (v3.1): 
//|            - Fixed a bug related to BoxOffset
//|            - Auto adjust for 3 and 4 dec JPY pairs
//|            - Removed init() function
//|            - Changed back to old style Renko brick formation
//| 
//|   Okt 13 2009 (LV) (v3.2): 
//|            - Added "EmulateOnLineChart" option (credit to Skipperxit/Mimmo)
//| 
//+---------------------------------------------------------------------------+
#property indicator_chart_window
#property copyright "" 
//+------------------------------------------------------------------+
#include <WinUser32.mqh>
#include <stdlib.mqh>
//+------------------------------------------------------------------+
#import "user32.dll"
   int RegisterWindowMessageW(string lpString);
   int PostMessageW(int hWnd,int Msg,int wParam,int lParam);
#import

//+------------------------------------------------------------------+
extern int    RenkoBoxSize       = 20;
extern int    RenkoBoxOffset     = 0;
extern int    RenkoTimeFrame     = 2;      // What time frame to use for the offline renko chart
extern bool   ShowWicks          = false;
extern bool   EmulateOnLineChart = true;
extern bool   StrangeSymbolName  = false;

extern bool   alertsOn           = true;
extern bool   alertsMessage      = true;
extern bool   alertsSound        = false;
extern bool   alertsNotify       = true;
extern bool   alertsEmail        = true;
extern string soundFile          = "alert2.wav"; 
//+------------------------------------------------------------------+
int HstHandle = -1, LastFPos = 0, MT4InternalMsg = 0;
string SymbolName;
//+------------------------------------------------------------------+
void UpdateChartWindow() {
	static int hwnd = 0;
 
	if(hwnd == 0) hwnd = WindowHandle(SymbolName, RenkoTimeFrame);

	if(EmulateOnLineChart && MT4InternalMsg == 0) 
		MT4InternalMsg = RegisterWindowMessageW("MetaTrader4_Internal_Message");

	if(hwnd != 0) if(PostMessageW(hwnd, WM_COMMAND, 0x822c, 0) == 0) hwnd = 0;
	if(hwnd != 0 && MT4InternalMsg != 0) PostMessageW(hwnd, MT4InternalMsg, 2, 1);

	return;
}
int init()
{
   return (0);
}
//+------------------------------------------------------------------+
int start() {

	static double BoxPoints, UpWick, DnWick;
	static double PrevLow, PrevHigh, PrevOpen, PrevClose, CurVolume, CurLow, CurHigh, CurOpen, CurClose;
	static datetime PrevTime;
   	
	//+------------------------------------------------------------------+
	// This is only executed ones, then the first tick arives.
	MqlRates rates;
	if(HstHandle < 0) {
		// Init

		// Error checking	
		if(!IsConnected()) {
			Print("Waiting for connection...");
			return(0);
		}							
		if(!IsDllsAllowed()) {
			Print("Error: Dll calls must be allowed!");
			return(-1);
		}		
		if(MathAbs(RenkoBoxOffset) >= RenkoBoxSize) {
			Print("Error: |RenkoBoxOffset| should be less then RenkoBoxSize!");
			return(-1);
		}
		switch(RenkoTimeFrame) {
		case 1: case 5: case 15: case 30: case 60: case 240:
		case 1440: case 10080: case 43200: case 0:
			Print("Error: Invald time frame used for offline renko chart (RenkoTimeFrame)!");
			return(-1);
		}
		//
		
		int BoxSize = RenkoBoxSize;
		int BoxOffset = RenkoBoxOffset;
		if(Digits == 5 || (Digits == 3 && StringFind(Symbol(), "JPY") != -1)) {
			BoxSize = BoxSize*10;
			BoxOffset = BoxOffset*10;
		}
		if(Digits == 6 || (Digits == 4 && StringFind(Symbol(), "JPY") != -1)) {
			BoxSize = BoxSize*100;		
			BoxOffset = BoxOffset*100;
		}
		
		if(StrangeSymbolName) SymbolName = StringSubstr(Symbol(), 0, 6);
		else SymbolName = Symbol();
		BoxPoints = NormalizeDouble(BoxSize*Point, Digits);
		PrevLow = NormalizeDouble(BoxOffset*Point + MathFloor(Close[Bars-1]/BoxPoints)*BoxPoints, Digits);
		DnWick = PrevLow;
		PrevHigh = PrevLow + BoxPoints;
		UpWick = PrevHigh;
		PrevOpen = PrevLow;
		PrevClose = PrevHigh;
		CurVolume = 1;
		PrevTime = Time[Bars-1];
	
		// create / open hst file		
		HstHandle = FileOpenHistory(SymbolName + (string)RenkoTimeFrame + ".hst", FILE_BIN|FILE_WRITE|FILE_ANSI);
		FileClose(HstHandle); HstHandle = -1;
		HstHandle = FileOpenHistory(SymbolName + (string)RenkoTimeFrame + ".hst", FILE_BIN|FILE_READ|FILE_WRITE|FILE_SHARE_WRITE|FILE_SHARE_READ|FILE_ANSI);
		if(HstHandle < 0) {
			Print("Error: can\'t create / open history file: " + ErrorDescription(GetLastError()) + ": " + SymbolName + RenkoTimeFrame + ".hst");
			return(-1);
		}
		//
   	
		// write hst file header
		int HstUnused[13];
		FileWriteInteger(HstHandle, 401, LONG_VALUE); 			// Version
		FileWriteString(HstHandle, "Public domain", 64);					// Copyright
		FileWriteString(HstHandle, SymbolName, 12);			// Symbol
		FileWriteInteger(HstHandle, RenkoTimeFrame, LONG_VALUE);	// Period
		FileWriteInteger(HstHandle, Digits, LONG_VALUE);		// Digits
		FileWriteInteger(HstHandle, 0, LONG_VALUE);			// Time Sign
		FileWriteInteger(HstHandle, 0, LONG_VALUE);			// Last Sync
		FileWriteArray(HstHandle, HstUnused, 0, 13);			// Unused
		//
   	
 		// process historical data
  		int i = Bars-2;
		//Print(Symbol() + " " + High[i] + " " + Low[i] + " " + Open[i] + " " + Close[i]);
		//---------------------------------------------------------------------------
  		while(i >= 0) {
  		
			CurVolume = CurVolume + Volume[i];
		
			UpWick    = MathMax(UpWick, High[i]);
			DnWick    = MathMin(DnWick, Low[i]);

			// update low before high or the reverse depending on previous bar
			bool UpTrend = High[i]+Low[i] > High[i+1]+Low[i+1];
			while(!UpTrend && (Low[i] < PrevLow-BoxPoints || CompareDoubles(Low[i], PrevLow-BoxPoints))) {
  				PrevHigh  = PrevHigh - 0.5 * BoxPoints;
  				PrevLow   = PrevLow - 0.5 * BoxPoints;
  				PrevOpen  = PrevHigh;
  				PrevClose = PrevLow;

            rates.time = PrevTime;
            rates.open = PrevOpen;
            rates.low  = PrevLow;
            if(ShowWicks && UpWick > PrevHigh)
                  rates.high = UpWick;
            else  rates.high = PrevHigh;             
            rates.close = PrevClose;
            rates.real_volume = (long)CurVolume;
            rates.tick_volume = (long)CurVolume;
   				FileWriteStruct(HstHandle,rates);

//				FileWriteInteger(HstHandle,PrevTime,LONG_VALUE);
//				 FileWriteDouble(HstHandle,PrevOpen,DOUBLE_VALUE);
//				 FileWriteDouble(HstHandle,PrevLow, DOUBLE_VALUE);

//				if(ShowWicks && UpWick > PrevHigh) FileWriteDouble(HstHandle, UpWick, DOUBLE_VALUE);
//				else FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				  				  			
//				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
//				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
				
				UpWick    = 0;
				DnWick    = EMPTY_VALUE;
				CurVolume = 0;
				CurHigh   = PrevLow;
				CurLow    = PrevLow;  
				
				if(PrevTime < Time[i]) PrevTime = Time[i];
				else PrevTime++;
			}
		
			while(High[i] > PrevHigh+BoxPoints || CompareDoubles(High[i], PrevHigh+BoxPoints)) {
  				PrevHigh  = PrevHigh + 0.5 * BoxPoints;
  				PrevLow   = PrevLow + 0.5 * BoxPoints;
  				PrevOpen  = PrevLow;
  				PrevClose = PrevHigh;
  			
            rates.time = PrevTime;
            rates.open = PrevOpen;
            rates.high = PrevHigh;
            if(ShowWicks && DnWick < PrevLow)
                  rates.low = DnWick;
            else  rates.low = PrevLow;             
            rates.close = PrevClose;
            rates.real_volume = (long)CurVolume;
            rates.tick_volume = (long)CurVolume;
   				FileWriteStruct(HstHandle,rates);

//				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
//				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);

//            if(ShowWicks && DnWick < PrevLow) FileWriteDouble(HstHandle, DnWick, DOUBLE_VALUE);
//				else FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
  				  			
//				FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
//				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
//				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
				
				UpWick    = 0;
				DnWick    = EMPTY_VALUE;
				CurVolume = 0;
				CurHigh   = PrevHigh;
				CurLow    = PrevHigh;  
				
				if(PrevTime < Time[i]) PrevTime = Time[i];
				else PrevTime++;
			}
		
			while(UpTrend && (Low[i] < PrevLow-BoxPoints || CompareDoubles(Low[i], PrevLow-BoxPoints))) {
  				PrevHigh  = PrevHigh - 0.5 * BoxPoints;
  				PrevLow   = PrevLow - 0.5 * BoxPoints;
  				PrevOpen  = PrevHigh;
  				PrevClose = PrevLow;
  			
            rates.time = PrevTime;
            rates.open = PrevOpen;
            rates.low  = PrevLow;
            if(ShowWicks && UpWick > PrevHigh)
                  rates.high = UpWick;
            else  rates.high = PrevHigh;             
            rates.close = PrevClose;
            rates.real_volume = (long)CurVolume;
            rates.tick_volume = (long)CurVolume;
   				FileWriteStruct(HstHandle,rates);

//				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
//				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
//				FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
				
//				if(ShowWicks && UpWick > PrevHigh) FileWriteDouble(HstHandle, UpWick, DOUBLE_VALUE);
//				else FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				
//				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
//				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);

				UpWick    = 0;
				DnWick    = EMPTY_VALUE;
				CurVolume = 0;
				CurHigh   = PrevLow;
				CurLow    = PrevLow;  
								
				if(PrevTime < Time[i]) PrevTime = Time[i];
				else PrevTime++;
			}		
			i--;
		} 
		LastFPos = FileTell(HstHandle);   // Remember Last pos in file
		//
			
		Comment("RenkoLiveChart(" + RenkoBoxSize + "): Open Offline ", SymbolName, ",M", RenkoTimeFrame, " to view chart");
		
		if(Close[0] > MathMax(PrevClose, PrevOpen)) CurOpen = MathMax(PrevClose, PrevOpen);
		else if (Close[0] < MathMin(PrevClose, PrevOpen)) CurOpen = MathMin(PrevClose, PrevOpen);
		else CurOpen = Close[0];
		
		CurClose = Close[0];
				
		if(UpWick > PrevHigh) CurHigh = UpWick;
		if(DnWick < PrevLow) CurLow = DnWick;
  
              rates.time = PrevTime;
            rates.open = CurOpen;
            rates.low  = CurLow;
            rates.high = CurHigh;             
            rates.close = CurClose;
            rates.real_volume = (long)CurVolume;
            rates.tick_volume = (long)CurVolume;
   				FileWriteStruct(HstHandle,rates);
    
//		FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);		// Time
//		FileWriteDouble(HstHandle, CurOpen, DOUBLE_VALUE);         	// Open
//		FileWriteDouble(HstHandle, CurLow, DOUBLE_VALUE);		// Low
//		FileWriteDouble(HstHandle, CurHigh, DOUBLE_VALUE);		// High
//		FileWriteDouble(HstHandle, CurClose, DOUBLE_VALUE);		// Close
//		FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);		// Volume				
		FileFlush(HstHandle);
            
		UpdateChartWindow();
		
		return(0);
 		// End historical data / Init		
	} 		
	//----------------------------------------------------------------------------
 	// HstHandle not < 0 so we always enter here after history done
	// Begin live data feed
   			
	UpWick = MathMax(UpWick, Bid);
	DnWick = MathMin(DnWick, Bid);

	CurVolume++;   			
	FileSeek(HstHandle, LastFPos, SEEK_SET);

 	//-------------------------------------------------------------------------	   				
 	// up box	   				
   	if(Bid > PrevHigh + 0.5 * BoxPoints || CompareDoubles(Bid, PrevHigh + 0.5 * BoxPoints)) {
		PrevHigh  = PrevHigh + 0.5 * BoxPoints;
		PrevLow   = PrevLow  + 0.5 * BoxPoints;
  		PrevOpen  = PrevLow;
  		PrevClose = PrevHigh;
  
              rates.time = PrevTime;
            rates.open = PrevOpen;
            rates.high = PrevHigh;
            if(ShowWicks && DnWick < PrevLow)
                  rates.low = DnWick;
            else  rates.low = PrevLow;             
            rates.close = PrevClose;
            rates.real_volume = (long)CurVolume;
            rates.tick_volume = (long)CurVolume;
   				FileWriteStruct(HstHandle,rates);
				  			
//		FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
//		 FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);

//		if (ShowWicks && DnWick < PrevLow) FileWriteDouble(HstHandle, DnWick, DOUBLE_VALUE);
//		else FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
		  			
//		FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
//		FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
//		FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
      	   FileFlush(HstHandle);
  	  	LastFPos = FileTell(HstHandle);   // Remeber Last pos in file				  							
      	
		if(PrevTime < TimeCurrent()) PrevTime = TimeCurrent();
		else PrevTime++;
            		
  		CurVolume = 0;
		CurHigh = PrevHigh;
		CurLow = PrevHigh;  
		
		UpWick = 0;
		DnWick = EMPTY_VALUE;
		if(alertsOn) DisplayAlert("Bullish Candle on: ",PrevHigh);  		
  	}
 	//-------------------------------------------------------------------------	   				
 	// down box
	else if(Bid < PrevLow - 0.5 * BoxPoints || CompareDoubles(Bid,PrevLow - 0.5 * BoxPoints)) {
  		PrevHigh  = PrevHigh - 0.5 * BoxPoints;
  		PrevLow   = PrevLow - 0.5 * BoxPoints;
  		PrevOpen  = PrevHigh;
  		PrevClose = PrevLow;
  
              rates.time = PrevTime;
            rates.open = PrevOpen;
            rates.low  = PrevLow;
            if(ShowWicks && UpWick > PrevHigh)
                  rates.high = UpWick;
            else  rates.high = PrevHigh;             
            rates.close = PrevClose;
            rates.real_volume = (long)CurVolume;
            rates.tick_volume = (long)CurVolume;
   				FileWriteStruct(HstHandle,rates);
				  			
//		FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
//		FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
//		FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);

//		if(ShowWicks && UpWick > PrevHigh) FileWriteDouble(HstHandle, UpWick, DOUBLE_VALUE);
//		else                               FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				  			
//		    FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
//		    FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
      	       FileFlush(HstHandle);
  	  	LastFPos = FileTell(HstHandle);   // Remeber Last pos in file				  							
      	
		if(PrevTime < TimeCurrent()) PrevTime = TimeCurrent();
		else                         PrevTime++;      	
            		
  		CurVolume = 0;
		CurHigh = PrevLow;
		CurLow = PrevLow;  
		
		UpWick = 0;
		DnWick = EMPTY_VALUE;
		if(alertsOn) DisplayAlert("Bearish Candle on: ",PrevLow);  		
     	} 
 	//-------------------------------------------------------------------------	   				
   	// no box - high/low not hit				
	else {
		if(Bid > CurHigh) CurHigh = Bid;
		if(Bid < CurLow) CurLow = Bid;
/*		
		if(PrevHigh <= Bid) CurOpen = PrevHigh;
		else if(PrevLow >= Bid) CurOpen = PrevLow;
		else CurOpen = Bid;
*/		
      CurOpen = PrevClose;
		CurClose = Bid;

            rates.time = PrevTime;
            rates.open = CurOpen;
            rates.low  = CurLow;
            rates.high = CurHigh;             
            rates.close = CurClose;
            rates.real_volume = (long)CurVolume;
            rates.tick_volume = (long)CurVolume;
   				FileWriteStruct(HstHandle,rates);
		
//		FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);		// Time
//		FileWriteDouble(HstHandle, CurOpen, DOUBLE_VALUE);         	// Open
//		FileWriteDouble(HstHandle, CurLow, DOUBLE_VALUE);		// Low
//		FileWriteDouble(HstHandle, CurHigh, DOUBLE_VALUE);		// High
//		FileWriteDouble(HstHandle, CurClose, DOUBLE_VALUE);		// Close
//		FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);		// Volume				
            FileFlush(HstHandle);
            
     	}
		UpdateChartWindow();            
     	return(0);
}
//+------------------------------------------------------------------+
int deinit() {
	if(HstHandle >= 0) {
		FileClose(HstHandle);
		HstHandle = -1;
	}
   	Comment("");
	return(0);
}
//+------------------------------------------------------------------+

//
//
//
//
//

void DisplayAlert(string doWhat, int shift)
{
    string message;
    static datetime lastAlertTime;
    if(shift <= 2 && Time[0] != lastAlertTime)
    {
      message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," RenkoLiveChart ",doWhat);
          if (alertsMessage) Alert(message);
          if (alertsNotify)  SendNotification(StringConcatenate(Symbol(), Period() ," RenkoLiveChart " +" "+message));
          if (alertsEmail)   SendMail(StringConcatenate(Symbol()," RenkoLiveChart "),message);
          if (alertsSound)   PlaySound(soundFile); 
          lastAlertTime = Time[0];
    }
}
   