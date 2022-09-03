
#property copyright "Copyright � 2011, Patrick M. White"
#property link      "https://sites.google.com/site/marketformula/"


int start()
  {

    
   for(int i=ObjectsTotal()-1; i>-1; i--) {
      ObjectDelete(ObjectName(i));
   }
   Comment("");
 

   return(0);
  }
