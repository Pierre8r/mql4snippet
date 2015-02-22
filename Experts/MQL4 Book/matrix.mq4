//--------------------------------------------------------------------
// matrix.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------- 1 --
int start()                            // Special function start()
  {
   int Mas_1[3][5]={1,2,3,4,5,  11,12,13,14,15,  21,22,23,24,25};
   int Mas_2[5][3];
   int R0= ArrayRange( Mas_1, 0);      // Number of elements in first dim.
   int R1= ArrayRange( Mas_1, 1);      // Number of elements in second dim.

   for(int i=0; i<R0; i++)             // По первому измерению Mas_1
     {
      for(int j=0; j<R1; j++)          // По второму измерению Mas_1
         Mas_2[j][i]=Mas_1[i][j];      // Транспонирование матрицы
     }
   Comment( Mas_2[0][0]," ",Mas_2[0][1]," ",Mas_2[0][2],"\n",
            Mas_2[1][0]," ",Mas_2[1][1]," ",Mas_2[1][2],"\n",
            Mas_2[2][0]," ",Mas_2[2][1]," ",Mas_2[2][2],"\n",
            Mas_2[3][0]," ",Mas_2[3][1]," ",Mas_2[3][2],"\n",
            Mas_2[4][0]," ",Mas_2[4][1]," ",Mas_2[4][2]);
   return;                             // Выход из start()
  }
//--------------------------------------------------------------- 2 --