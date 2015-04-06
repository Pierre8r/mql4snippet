/****************************************************************************************

                                                                           SimpleList.mqh 
                                                                     (c) 2014 Broketrader 

   This source code is provided "as is" whithout any warraty of any king from the author.
   Use, distribute and modify this code freely.
   
   Broketrader, March 25 2014, First version.
   
****************************************************************************************/
#property copyright "Broketrader"
#property strict




/****************************************************************************************
   Class ListNode
   All objects being listed need to be derived from this class.
****************************************************************************************/
class ListNode {
   ListNode* m_pNext;
   ListNode* m_pPrev;
   
   public:
      ListNode(){
         m_pNext = m_pPrev = NULL;
      }
};




/****************************************************************************************
   Class List
   Manages a list of ListNodes objects.
****************************************************************************************/
class List{

   ListNode*      m_pBegin;
   ListNode*      m_pEnd;
   
   public:
                  List();
   
};




/****************************************************************************************
   List()
   Class Constructor.
****************************************************************************************/
List::List(){
   m_pBegin = NULL;
   // We use an empty node that will serve to know when we are at the end of the list.
   m_pEnd = new ListNode();
}
