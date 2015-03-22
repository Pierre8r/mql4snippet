//--------------------------------------------------------------------
// stringarray.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
extern double Level=1.3200;                     // Preset level 
string Text[101];                               // Array declaration
//--------------------------------------------------------------------
int init()                                      // Special funct. init()
  {                                             // Assigning values
   Text[1]="one ";             Text[15]="fifteen ";
   Text[2]="two ";             Text[16]="sixteen ";
   Text[3]="three ";           Text[17]="seventeen ";
   Text[4]="four ";            Text[18]="eighteen ";
   Text[5]="five ";            Text[19]="nineteen ";
   Text[6]="six ";             Text[20]="twenty ";
   Text[7]="seven ";           Text[30]="thirty ";
   Text[8]="eight ";           Text[40]="forty ";
   Text[9]="nine ";            Text[50]="fifty ";
   Text[10]="ten ";            Text[60]="sixty";
   Text[11]="eleven ";         Text[70]="seventy ";
   Text[12]="twelve ";         Text[80]="eighty ";
   Text[13]="thirteen ";       Text[90]="ninety";
   Text[14]="fourteen ";       Text[100]= "hundred";
   // Calculating values
   for(int i=20; i<=90; i=i+10)                // Cycle for tens
     {
      for(int j=1; j<=9; j++)                  // Cycle for units
         Text[i+j]=Text[i] + Text[j];          // Calculating value   
     }
   return;                                     // Exit init()
  }
//--------------------------------------------------------------------
int start()                                     // Special funct. start()
  {
   int Delta=NormalizeDouble((Bid-Level)/Point,0);// Excess 
//--------------------------------------------------------------------
   if (Delta>=0)                                // Price is not higher than level
     {
      Alert("Price below level");               // Alert
      return;                                   // Exit start()
     }
//--------------------------------------------------------------------
   if (Delta<100)                               // Price higher than 100
     {
      Alert("More than hundred points");        // Alert
      return;                                   // Exit start()
     }
//--------------------------------------------------------------------
   Alert("Plus ",Text[Delta],"pt.");            // Displaying
   return;                                      // Exit start()
  }
//--------------------------------------------------------------------