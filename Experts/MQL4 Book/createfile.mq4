//--------------------------------------------------------------------
// createfile.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------- 1 --
extern string Date_1="";   // 2007.05.11 10:30
extern string Text_1="";   // CHF Construction licenses
extern string Date_2="";   // 2007.05.11 12:00
extern string Text_2="";   // GBP Refinance rate,2%,2.5%
extern string Date_3="";   // 2007.05.11 13:15
extern string Text_3="";   // EUR Meeting of G10 banks governors
extern string Date_4="";   // 2007.05.11 15:30
extern string Text_4="";   // USD USA unemployment rate
extern string Date_5="";   // 2007.05.11 18:30
extern string Text_5="";   // JPY Industrial production
//--------------------------------------------------------------- 2 --
int start()                            // Spec. function start()
  {
//--------------------------------------------------------------- 3 --
   int Handle,                         // File descriptor
   Qnt_Symb;                           // Number of recorded symbols
   string File_Name="News.csv";        // File name
   string Erray[5,2];                  // Array for 5 news
//--------------------------------------------------------------- 4 --
   Erray[0,0]=Date_1;                  // Fill the array with values
   Erray[0,1]=Text_1;
   Erray[1,0]=Date_2;
   Erray[1,1]=Text_2;
   Erray[2,0]=Date_3;
   Erray[2,1]=Text_3;
   Erray[3,0]=Date_4;
   Erray[3,1]=Text_4;
   Erray[4,0]=Date_5;
   Erray[4,1]=Text_5;
//--------------------------------------------------------------- 5 --
   Handle=FileOpen(File_Name,FILE_CSV|FILE_WRITE,";");//File opening
   if(Handle==-1)                      // File opening fails
     {
      Alert("An error while opening the file. ",// Error message
              "May be the file is busy by the other applictiom");
      PlaySound("Bzrrr.wav");          // Sound accompaniment
      return;                          // Exir start()      
     }
//--------------------------------------------------------------- 6 --
   for(int i=0; i<=4; i++)             // Cycle throughout the array
     {
      if(StringLen(Erray[i,0])== 0  || // If the value of the first or..
         StringLen(Erray[i,1])== 0)    // ..second variable is not entered
         break;                        // .. then exit the cycle
      Qnt_Symb=FileWrite(Handle,Erray[i,0],Erray[i,1]);//Writing to the file
      if(Qnt_Symb < 0)                 // If failed
        {
         Alert("Error writing to the file",GetLastError());// Message
         PlaySound("Bzrrr.wav");       // Sound accompaniment
         FileClose( Handle );          // File closing
         return;                       // Exit start()      
        }
     }
//--------------------------------------------------------------- 7 --
   FileClose( Handle );                // File closing
   Alert("The ",File_Name," file created.");// Message
   PlaySound("Bulk.wav");              // Sound accompaniment
   return;                             // Exit start()
  }
//--------------------------------------------------------------- 8 --