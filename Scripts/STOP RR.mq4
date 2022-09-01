//
//+------------------------------------------------------------------+
//|                                 DROP STOP RISK REWARD SCRIPT    |
//|                                                                  |
//|                                                                  |
//|                                    Configured by ClevaSys        |
//|                                                                  |
//+------------------------------------------------------------------+

#property description "Drop Limit Script With Risk Reward Ratio Inputs" 
#property description "Drop this script where you want to order to get filled" 
#property copyright "Author - ClevaSys" 
#include <stdlib.mqh>
#include <WinUser32.mqh>

// Add to forward slashes like the two before this line in front of #property show_inputs to stop this asking you to enter details and use te details in the code in the lines below here.
#property show_inputs

extern string Lot_Size = "How much to stake";
extern double Lots = 0.01 ;
extern string Risk_Size = "How many pips to risk - decimals ok e.g. 3.5 = 3.5 pips risk";
extern double Risk  = 5 ;
extern string Reward_Size = "Reward ratio - decimals ok e.g. 2.5 = reward would be is risk x 2.5 in pips";
extern double Reward_Ratio = 3 ;
double Slippage = 3 ;

int start()
  {
   int    expiration;
   double Price = WindowPriceOnDropped();
   int    slippage;
 
   int ticket0,ticket1;
   int NrOfDigits = MarketInfo(Symbol(),MODE_DIGITS);   
   int PipAdjust;                                       
      if(NrOfDigits == 5 || NrOfDigits == 3)            
         PipAdjust = 10;                                
         else
      if(NrOfDigits == 4 || NrOfDigits == 2)           
         PipAdjust = 1;   
//ORDER EXPIRY TIME            
         expiration=CurTime()+PERIOD_D1*60; // PERIOD_MN1 W1 D1 H12 H8 H6 H4 H3 H2 H1 M30 M15 M5 M1 all apply
  
   
   slippage = Slippage * PipAdjust; 
   
   double stop_loss = Price + Risk * Point * PipAdjust;
   double take_profit = Price - Risk*Reward_Ratio * Point * PipAdjust; 

   //BUYSTOP
   if(Bid < Price)
   {
   ticket0=OrderSend(Symbol(),OP_BUYSTOP,Lots,Price,slippage,Price-Risk*Point*PipAdjust,Price+Risk*Reward_Ratio*Point*PipAdjust,"BUY STOP D1",0,expiration,Blue);
   
   if(ticket1<1)
     {
      int error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      return(0);
     }
   }
   
   //SELLSTOP
   if(Ask > Price)
   {
   ticket0=OrderSend(Symbol(),OP_SELLSTOP,Lots,Price,slippage,Price+Risk*Point*PipAdjust,Price-Risk*Reward_Ratio*Point*PipAdjust,"SELL STOP D1",0,expiration,Red);
   if(ticket1<1)
     {
      error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      return(0);
     }
   }

   return(0);
  }
