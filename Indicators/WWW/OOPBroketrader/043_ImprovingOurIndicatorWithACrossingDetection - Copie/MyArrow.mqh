/**********************************************************************************************************************

   MyArrow.mqh, (c) 2014 Broketrader 
                                                  
**********************************************************************************************************************/



/**********************************************************************************************************************
   Class MyArrow
   Handles MQL arrows
**********************************************************************************************************************/
class MyArrow {
   string m_Name;
   bool   m_Up;
   
   public:
   
            MyArrow( string name, bool up, color clr );
      void  SetPoint( datetime time, double price );
};




/**********************************************************************************************************************
   MyArrow
   Constructor
   name, MQL object name
   up, true for a up arrow, false for a down arrow
   clr, Arrow color
**********************************************************************************************************************/
MyArrow::MyArrow( string name, bool up, color clr){
   m_Name = name;
   m_Up   = up;
   
   if( m_Up ){
      ObjectCreate( ChartID(), m_Name, OBJ_ARROW_UP, 0, 0 , 0 );   
   }
   else{
      ObjectCreate( ChartID(), m_Name, OBJ_ARROW_DOWN, 0, 0 , 0 );   
   }
   ObjectSet( m_Name, OBJPROP_COLOR, clr );
}




/**********************************************************************************************************************
   SetPoint
   Sets the corrdinates of the arrow
   time, time coordinate.
   price, price coordinate.
**********************************************************************************************************************/
void MyArrow::SetPoint( datetime time, double price ){
   ObjectSetInteger( ChartID(), m_Name, OBJPROP_TIME1, time );
   if( m_Up ){
      ObjectSetDouble( ChartID(), m_Name, OBJPROP_PRICE1, price );
   }
   else{
      // Make some pixel adjustment to down arrow.
      int ChartHeightPixels = ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS );
      double PriceMax = ChartGetDouble( ChartID(), CHART_PRICE_MAX );
      double PriceMin = ChartGetDouble( ChartID(), CHART_PRICE_MIN );
      double PricePerPixel = (PriceMax-PriceMin) / ChartHeightPixels;
      ObjectSetDouble( ChartID(), m_Name, OBJPROP_PRICE1, price + 16 * PricePerPixel );
   }
}
