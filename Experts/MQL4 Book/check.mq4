//----------------------------------------------------------------------------------
// Check.mqh
// The program is intended to be used as an example in MQL4 Tutorial.
//----------------------------------------------------------------------------- 1 --
// The function checking legality of the program used
// Inputs:
// - global variable 'Parol'
// - local constant "SuperBank"
// Returned values:
// true  - if the conditions of use are met
// false - if the conditions of use are violated
//----------------------------------------------------------------------------- 2 --
extern int Parol=12345; // Password to work on a real account
//----------------------------------------------------------------------------- 3 --
bool Check()                           // User-defined unction
  {
   if (IsDemo()==true)                 // If it is a demo account, then..
      return(true);                    // .. there are no other limitations
   if (AccountCompany()=="SuperBank")  // For corporate clients..
      return(true);                    // ..no password is required
   int Key=AccountNumber()*2+1000001;  // Calculate the key 
   if (Parol==Key)                     // If the password is true, then..
      return(true);                    // ..allow the user to work on a real account
   Inform(14);                         // Message about unauthorized use
   return(false);                      // Exit the user-defined function
  }
//----------------------------------------------------------------------------- 4 --