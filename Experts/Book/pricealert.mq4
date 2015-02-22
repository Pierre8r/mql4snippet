//-------------------------------------------------------------------------------------
// pricealert.mq4
// The code should be used for educational purpose only.
//-------------------------------------------------------------------------------------
int start()                                     // Special function 'start'
  {
   double Level=1.3200;                           // Preset price level
   int Delta=NormalizeDouble((Bid-Level)Point,0); // Excess 
   if (Delta<=0)                                  // Price doesn't excess the level
     {
      Alert("The price is below the level");      // Message
      return;                                     // Exit start()
     }
//-------------------------------------------------------------------------------------
   switch(Delta)                                  // Header of the 'switch'
     {                                            // Start of the 'switch' body
      case 1 : Alert("Plus one point");     break;// Variations..
      case 2 : Alert("Plus two points");    break;
      case 3 : Alert("Plus three points");  break;
      case 4 : Alert("Plus four points");   break;//Here are presented
      case 5 : Alert("Plus five points");   break;//10 variations 'case',
      case 6 : Alert("Plus six points");    break;//but, in general case,
      case 7 : Alert("Plus seven points");  break;//the amount of variations 'case'
      case 8 : Alert("Plus eight points");  break;//is unlimited
      case 9 : Alert("Plus nine points");   break;
      case 10: Alert("Plus ten points");    break;
      default: Alert("More than ten points");     // It is not the same as the 'case'
     }                                            // End of the 'switch' body
//-------------------------------------------------------------------------------------
   return;                                        // Exit start()
  }
//-------------------------------------------------------------------------------------