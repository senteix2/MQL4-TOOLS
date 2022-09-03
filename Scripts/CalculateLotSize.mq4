//+------------------------------------------------------------------+
//|                                             CalculateLotSize.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright " "
#property link      " "
#property version   "1.00"
#property strict
#property show_inputs 
#include  <Utils.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
input double maxRiskPercentagetaken = 0.0025 ;
input int pips= 5;
extern string currentSymbol = ""; //

void OnStart()
  {  
  
     currentSymbol =  StringCompare( currentSymbol,"", false)==0? Symbol():currentSymbol ; 
     
     string currency = AccountInfoString(ACCOUNT_CURRENCY);
     double lotSize = calculateLotSize(maxRiskPercentagetaken,pips,currentSymbol);
     double pipvalue  =  getTickValue(currentSymbol)*10 ;
     double pipvaluex10 = pipvalue*10 ;
     double maxLossDollar =  AccountEquity() * maxRiskPercentagetaken ;
     double maxRealLoss =  pipvalue*lotSize*pips  ;
     
     Alert("0.01 Lot with 1 pip = "+(string)NormalizeDouble(pipvalue/100, 2)+" "+currency+", 10 pip: "+(string)NormalizeDouble(pipvaluex10/100, 2)+" "+currency)  ; 
     Alert("0.1 Lot with 1 pip = "+(string)NormalizeDouble(pipvalue/10, 2)+" "+currency+", 10 pip: "+(string)NormalizeDouble(pipvaluex10/10, 2)+" "+currency)  ; 
     Alert("1 Lot with 1 pip = "+(string)NormalizeDouble(pipvalue, 2)+" "+currency+", 10 pip: "+(string)NormalizeDouble(pipvaluex10, 2)+" "+currency)  ; 
     Alert("Optimal Lot Size :" +DoubleToStr(lotSize,2)+" per "+IntegerToString(pips)+" pips maxTheoricalLoss:"+DoubleToStr(maxLossDollar,2)+" "+currency+" max real Loss:"+DoubleToStr(maxRealLoss,2)+" "+currency )  ; 
   
  }
//+------------------------------------------------------------------+
