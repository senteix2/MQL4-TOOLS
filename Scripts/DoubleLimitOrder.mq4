#property copyright "David Aranda "
#property link      " "
#property version   "1.01"
#property strict
#property show_inputs
#include  <Utils.mqh>
#include <stdlib.mqh>
#include <WinUser32.mqh>

input double maxRiskPercentagetaken = 0.0025 ;
extern double Reward_Ratio1 = 5 ;
extern double Reward_Ratio2 = 10 ;
input int pips= 5;
extern string currentSymbol = ""; //
double Slippage = 3 ;

void OnStart()
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

           expiration=CurTime()+PERIOD_D1*60;

     slippage = Slippage * PipAdjust;
     double stop_loss = Price + pips * Point * PipAdjust;
     double take_profit1 = Price - pips*Reward_Ratio1 * Point * PipAdjust;
     double take_profit2 = Price - pips*Reward_Ratio2 * Point * PipAdjust;

     currentSymbol =  StringCompare( currentSymbol,"", false)==0? Symbol():currentSymbol ;

     string currency = AccountInfoString(ACCOUNT_CURRENCY);
     double lotSize = calculateLotSize(maxRiskPercentagetaken,pips,currentSymbol);
     double pipvalue  =  getTickValue(currentSymbol)*10 ;
     double pipvaluex10 = pipvalue*10 ;
     double maxLossDollar =  AccountEquity() * maxRiskPercentagetaken ;
     double maxRealLoss =  pipvalue*lotSize*pips  ;


        if(Ask > Price)
        {
        ticket0=OrderSend(Symbol(),OP_BUYLIMIT,lotSize,Price,slippage,Price-pips*Point*PipAdjust,Price+pips*Reward_Ratio1*Point*PipAdjust,"BUY LMT D1",0,expiration,Blue);
        printError(ticket0);
        ticket1=OrderSend(Symbol(),OP_BUYLIMIT,lotSize,Price,slippage,Price-pips*Point*PipAdjust,Price+pips*Reward_Ratio2*Point*PipAdjust,"BUY LMT D1",0,expiration,Blue);
        printError(ticket1);

        }

        //SELLLIMIT
        if(Bid < Price)
        {
        ticket0=OrderSend(Symbol(),OP_SELLLIMIT,lotSize,Price,slippage,Price+pips*Point*PipAdjust,Price-pips*Reward_Ratio1*Point*PipAdjust,"SELL LMT D1",0,expiration,Red);
        printError(ticket0);
        ticket1=OrderSend(Symbol(),OP_SELLLIMIT,lotSize,Price,slippage,Price+pips*Point*PipAdjust,Price-pips*Reward_Ratio2*Point*PipAdjust,"SELL LMT D1",0,expiration,Red);
        printError(ticket1);

        }



  }


void printError(int ticket){
     if(ticket<1)
          {
           int error=GetLastError();
           Print("Error = ",ErrorDescription(error));
          }
}
