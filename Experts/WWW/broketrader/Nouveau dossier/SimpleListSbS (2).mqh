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
      
      // Next, Updates, Retrieves the next node.
      ListNode* Next( ListNode* next=NULL ){
         if( next != NULL ){
            m_pNext = next;
         }
         return m_pNext;
      }
      
      // Prev, Updates, Retrieves the previous node.
      ListNode* Prev( ListNode*prev=NULL ){
         if( prev != NULL ){
            m_pPrev = prev;
         }
         return m_pPrev;
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
      ListNode*   Begin();
      ListNode*   End();
      bool        Insert( ListNode* where, ListNode* node );
      bool        Contains( ListNode* node );
      bool        Remove( ListNode* node );
      int         Count();
      ListNode* operator[](int index);
   
};




/****************************************************************************************
   operator []( int index )
   Returns the element specified by index or NULL if the element is not in the list
****************************************************************************************/
ListNode* List::operator[]( int index ) {

   ListNode* pN = m_pBegin;
   
   for( int i=0; pN != NULL && i<index; i++, pN = pN.Next() ) {
   }
   
   return pN;
}




/****************************************************************************************
   Count()
   Returns the number of objects in the list.
****************************************************************************************/
int List::Count() {
   int Count = 0;

   for( ListNode* pN = m_pBegin; pN != NULL && pN != m_pEnd; pN = pN.Next() ) {
      Count++;
   }

   return Count;   
}




/****************************************************************************************
   Remove( ListNode* node )
   Removes (unlink) a node from the list.
   node, The ListNode object to be removed from the list
****************************************************************************************/
bool List::Remove( ListNode* node ) {
   
   // If node not in the list, nothing to do.
   if( ! Contains(node) ){
      return false;
   }
   
   // Special case where the node is the begin of the list.
   if( node == m_pBegin ){
      if( node.Next() == m_pEnd ){
         // Last node, just set begin pointer to NULL.
         m_pBegin = NULL;
         return true;
      }
      m_pBegin = node.Next();
      m_pBegin.Prev( NULL );
      return true;
   }
   
   // Update link pointers.
   node.Prev().Next( node.Next() );
   node.Next().Prev( node.Prev() );

   return true;   
}




/****************************************************************************************
   Contains( ListNode* node )
   Checks if a node is present in the list.
   node, the ListNode object for which the presence has to be checked.
****************************************************************************************/
bool List::Contains( ListNode* node ) {
   
   ListNode* pN = m_pBegin;
   
   // Empty list check.
   if( pN == NULL ){
      return false;
   }
   
   for( ; pN != m_pEnd; pN = pN.Next() ){
      if( pN == node ){
         return true;
      }
   }
   return false;
}




/****************************************************************************************
   Insert( ListNode* where, ListNode* node )
   Inserts a node in the List
   where, ListNode object pointer which represents the insertion point.
   node, ListNode object pointer to be inserted.
****************************************************************************************/
bool List::Insert( ListNode* where, ListNode* node ) {

   // We don't allow duplicates.      
   if( Contains( node ) ){
      return false;
   }   

   // Handle special case of empty list.
   if( (where == NULL && m_pBegin == NULL) || (where==m_pEnd && m_pBegin == NULL) ){
      m_pBegin = node;
      m_pBegin.Next( m_pEnd );
      m_pEnd.Prev( m_pBegin );
      return true;
   }

   // We don't allow inserting at a node not already present in our list.
   if( ! Contains( where ) ){
      return false;
   }   

   // Handle special where the insertion point is the begining of the list.
   if( where == m_pBegin ){
      node.Next( m_pBegin );
      m_pBegin.Prev( node );
      m_pBegin = node;
      return true;
   } 
   
   // any other case
   where.Prev().Next( node );
   node.Prev( where.Prev() );
   node.Next( where );
   where.Prev( node );  
   return true;
}




/****************************************************************************************
   End()
   Return a pointer to the end of the list.
****************************************************************************************/
ListNode* List::End() {
   return m_pEnd;
}




/****************************************************************************************
   Begin()
   Return a pointer to the begining of the list.
****************************************************************************************/
ListNode* List::Begin() {
   return m_pBegin;
}




/****************************************************************************************
   List()
   Class Constructor.
****************************************************************************************/
List::List(){
   m_pBegin = NULL;
   // We use an empty node that will serve to know when we are at the end of the list.
   m_pEnd = new ListNode();
}
