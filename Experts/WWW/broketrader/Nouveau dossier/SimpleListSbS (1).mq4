/****************************************************************************************

                                                                           SimpleList.mq4 
                                                                     (c) 2014 Broketrader 

   This source code is provided "as is" whithout any warraty of any king from the author.
   Use, distribute and modify this code freely.
   
   Broketrader, March 25 2014, First version.
   
****************************************************************************************/
#property copyright                 "(c) 2014 Broketrader"
#property version                   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers         0
#property indicator_plots           0




/****************************************************************************************
   Include Files
****************************************************************************************/
#include <SimpleListSbS.mqh>




/****************************************************************************************
   Global and User Input Variables
****************************************************************************************/
class ListedObject : public ListNode {
   string m_Name;
   
   public:
      ListedObject( string name ){
         m_Name = name;
      }   
      
      string Name() { return m_Name; }
};




/****************************************************************************************
   OnInit()
   Initializes Indicator Global Variables
****************************************************************************************/
int OnInit() {

   // Our List object
   List MyList;
   
   // Some simple objects to put in our list
   ListedObject* First = new ListedObject( "First Object" );
   ListedObject* Second = new ListedObject( "Second Object" );
   ListedObject* Third = new ListedObject( "Third Object" );
   
   // Insert Third object at the end of the list
   MyList.Insert( MyList.End(), Third );
   
   // Insert First object at the begining of the list
   MyList.Insert( MyList.Begin(), First  );

   // Insert Second object before Third
   MyList.Insert( Third, Second );
   
   // Iterate through our list
   ListedObject* pLO;
   for( ListNode* pN = MyList.Begin(); pN!= MyList.End(); pN = pN.Next() ){
      pLO = (ListedObject*) pN;
      Print( pLO.Name() );
   }

   return INIT_SUCCEEDED;
}








/****************************************************************************************
   OnCalculate()
   Indicator Iteration function
****************************************************************************************/
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   return(rates_total);
}


