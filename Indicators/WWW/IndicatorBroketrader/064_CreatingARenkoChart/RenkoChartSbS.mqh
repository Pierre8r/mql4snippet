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

   static RenkoChart*      m_pInstance;
   
   protected:
                           RenkoChart();

   public:
      static RenkoChart*   Instance();
   
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




