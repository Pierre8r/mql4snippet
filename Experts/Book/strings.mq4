//--------------------------------------------------------------------
// strings.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------- 1 --
extern int Quant_Bars=100;             // Number of bars
datetime   Time_On;
string     Prefix    ="Paint_";
//--------------------------------------------------------------- 2 --
int init()                             // Spec. function init()
  {
   int Ind_Bar;                        // Bar index
   Time_On=Time [Quant_Bars];          // Time of first coloring
   for(Ind_Bar=Quant_Bars-1; Ind_Bar>=0; Ind_Bar--)// Bars cycle
     {
      Create(Ind_Bar,1);               // Draw a thin line
      Create(Ind_Bar,2);               // Draw a thick line
     }
   WindowRedraw();                     // Image redrawing
   return;                             // Exit init()
  }
//--------------------------------------------------------------- 3 --
int start()                            // Spec. function start()
  {
   datetime T1, T2;                    // 1 and 2 time coordinates
   int Error,Ind_Bar;                  // Error code and bar index
   double P1, P2;                      // 1 and 2 price coordinates
   color Col;                          // Color of created object
//--------------------------------------------------------------- 4 --
   for(int Line=1; Line<=2; Line++)    // Line type cycle
     {
      string Nom_Lin =Line + "_";      // String with the line number
      //    string Nom_Lin  = DoubleToStr(Line,0)+"_";// Can be so
      for(Ind_Bar=0; ;Ind_Bar++)       // Bar cycle
        {
//--------------------------------------------------------------- 5 --
         datetime T_Bar= Time[Ind_Bar];// Bar opening time
         if (T_Bar < Time_On) break;   // Don't color out of borders
         string Str_Time=TimeToStr(T_Bar);       // Time string
         string His_Name=Prefix+Nom_Lin+Str_Time;// Object name
//--------------------------------------------------------------- 6 --
         T1=ObjectGet(His_Name,OBJPROP_TIME1);// t1 coord. query
         Error=GetLastError();         // Error code receiving
         if (Error==4202)              // If there is no object :(
           {
            Create(Ind_Bar,Line);      // Object creating function call.
            continue;                  // To the next iteration
           }
//--------------------------------------------------------------- 7 --
         T2 =ObjectGet(His_Name,OBJPROP_TIME2); // t2 coord. query
         P1 =ObjectGet(His_Name,OBJPROP_PRICE1);// p1 coord. query
         P2 =ObjectGet(His_Name,OBJPROP_PRICE2);// p2 coord. query
         Col=ObjectGet(His_Name,OBJPROP_COLOR); // Color query
         if(T1!=T_Bar || T2!=T_Bar || // Incorrect coord. or color:
            (Line==1 && (P1!=High[Ind_Bar] || P2!=  Low[Ind_Bar])) ||
            (Line==2 && (P1!=Open[Ind_Bar] || P2!=Close[Ind_Bar])) ||
            (Open[Ind_Bar] Close[Ind_Bar] && Col!=Red)  ||
            (Open[Ind_Bar]==Close[Ind_Bar] && Col!=Green)  )
           {
            ObjectDelete(His_Name);    // Delete object
            Create(Ind_Bar,Line);      // Create correct object
           }
//--------------------------------------------------------------- 8 --
        }
     }
   WindowRedraw();                     // Image redrawing
   return;                             // Exit start()
  }
//--------------------------------------------------------------- 9 --
int deinit()                           // Spec. function deinit()
  {
   string Name_Del[1];                 // Array declaring
   int Quant_Del=0;                    // Number of objects to be deleted
   int Quant_Objects=ObjectsTotal();   // Total number of all objects
   ArrayResize(Name_Del,Quant_Objects);// Necessary array size
   for(int k=0; k<=Quant_Del; i++)     // Delete objects with names.. 
      ObjectDelete(Name_Del[i]);       // .. that array contains
   return;                             // Exit deinit()
  }
//-------------------------------------------------------------- 10 --
int Create(int Ind_Bar, int Line)      // User-defined function..
  {                                    // ..of objects creation
   color Color;                        // Object color
   datetime T_Bar=Time [Ind_Bar];      // Bar opening time
   double   O_Bar=Open [Ind_Bar];      // Bar open price
   double   C_Bar=Close[Ind_Bar];      // Bar close price
   double   H_Bar=High [Ind_Bar];      // Bar maximum price
   double   L_Bar=Low  [Ind_Bar];      // Bar minimum price
 
   string Nom_Lin =Line + "_";         // String - line number
   // string Nom_Lin  = DoubleToStr(Line,0)+"_";// Can be so
   string Str_Time=TimeToStr(T_Bar);   // String - open time.     
   string His_Name=Prefix+Nom_Lin+Str_Time;// Name of created object
   if (O_Bar < C_Bar) Color=Blue;      // Choosing the color depending on..
   if (O_Bar >C_Bar) Color=Red;        // .. parameters of the bar
   if (O_Bar ==C_Bar) Color=Green;
 
   switch(Line)                        // Thin or thick line
     {
      case 1:                          // Thin line
         ObjectCreate(His_Name,OBJ_TREND,0,T_Bar,H_Bar,T_Bar,L_Bar);
         break;                        // Exit from switch
      case 2:                          // Thick line
         ObjectCreate(His_Name,OBJ_TREND,0,T_Bar,O_Bar,T_Bar,C_Bar);
         ObjectSet(   His_Name, OBJPROP_WIDTH, 3);// Style     
     }
   ObjectSet(    His_Name, OBJPROP_COLOR, Color); // Color
   ObjectSet(    His_Name, OBJPROP_RAY,   false); // Ray
   ObjectSetText(His_Name,"Object is created by the EA",10);// Description
   return;                             // Exit user-defined function
  }
//-------------------------------------------------------------- 11 --