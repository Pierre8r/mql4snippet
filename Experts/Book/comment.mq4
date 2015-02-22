//--------------------------------------------------------------------
// comment.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
int start()                            // Special function start
  {
   int Orders=OrdersTotal();           // Number of orders
   if (Orders==0)                      // If numb. of ord. = 0
      Comment("No orders");            // Comment to the window corner
   else                                // If there are orders
      Comment("Available ",Orders," orders." );// Comment
   return;                             // Exit 
  }
//--------------------------------------------------------------------