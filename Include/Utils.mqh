#property strict

double getPipSize(string _symbol)
{  
   return getPointSize(_symbol)*10;
}

double getPointSize(string _symbol){
    double tmp = MarketInfo(_symbol,MODE_POINT);
    while(!(tmp>0)){
      ChartOpen(_symbol,PERIOD_H1);
      Sleep(100);
      tmp = MarketInfo(_symbol,MODE_POINT);
      Print(" MODE_POINT is 0 for :"+_symbol+" trying again.. ",tmp);
    }
    
   return tmp;
}


double GetStopLossPrice(bool bIsLongPosition, double entryPrice, int maxLossInPips)

{
   double stopLossPrice;

   if (bIsLongPosition)

   {
      stopLossPrice = entryPrice - maxLossInPips * 0.0001;
   }

   else

   {
      stopLossPrice = entryPrice + maxLossInPips * 0.0001;
   }

   return stopLossPrice;

}


bool IsTradingAllowed()

{

   if(!IsTradeAllowed())

   {

      Print("Expert Advisor is NOT Allowed to Trade. Check AutoTrading.");
      return false;

   }

   if(!IsTradeAllowed(Symbol(), TimeCurrent()))

   {

      Print("Trading NOT Allowed for specific Symbol and Time");
      return false;

   }

   return true;

}
  

double calculateLotSize(double maxRiskPercentage, int maxLossInPips, string symbol)

{
  double accEquity = AccountEquity();
  double lotSize = MarketInfo(symbol,MODE_LOTSIZE);
  double tickValue = getTickValue(symbol);
    
  Print("account Equity: " , DoubleToStr(accEquity,2)," lotSize: " , DoubleToStr(lotSize,2)," tickValue Original: " ,tickValue);
  Print("MarketInfo(symbol,MODE_DIGITS): ", MarketInfo(symbol,MODE_DIGITS));
  
  if(MarketInfo(symbol,MODE_DIGITS) <= 3 && lotSize>1)
  {
    tickValue = tickValue /100;
  } else if(MarketInfo(symbol,MODE_DIGITS) <= 3  && !(lotSize>1)){
    tickValue = tickValue * 1000;
  }  
  double maxLossDollar = accEquity * maxRiskPercentage;
  double maxLossInQuoteCurr = maxLossDollar / tickValue;
  
  Print("maxRiskPercentage:",maxRiskPercentage," accEquity:",accEquity," = maxLossDollar:",maxLossDollar) ; 
  Print("tickValue: " + DoubleToStr(tickValue,5)+ " maxLossDollar: " + DoubleToStr(maxLossDollar,2));
  Print("maxLossInQuoteCurr: " , DoubleToStr(maxLossInQuoteCurr,2)," maxLossInPips:",DoubleToStr(maxLossInPips)," getPipSize:",getPipSize(symbol)); 

  double optimalLotSize = NormalizeDouble(maxLossInQuoteCurr /(maxLossInPips * getPipSize(symbol))/lotSize,2);
  Print("optimalLotSize:",optimalLotSize);
  return optimalLotSize;
}


double calculateLotSize(double maxRiskPercentage, double entryPrice, double stopLoss, string symbol)

{  Print("entryPrice: ",entryPrice," stopLoss:",stopLoss," getPipSize(",symbol,"):",getPipSize(symbol));
   int maxLossInPips = MathAbs(entryPrice - stopLoss)/(getPipSize(symbol));
   Print("maxLossInPips:",maxLossInPips); 
   return calculateLotSize(maxRiskPercentage,maxLossInPips, symbol);
}


bool isOrdersOpenByMagic(int magicNumber)

{
   int openOrders = OrdersTotal();  

   for(int i = 0; i < openOrders; i++)

   {
      if(OrderSelect(i,SELECT_BY_POS)==true)
      {
         if(OrderMagicNumber() == magicNumber) 
         {
            return true;
         }  
      }
   }

   return false;

}

double getTickValue(string _symbol){
    double tmp = MarketInfo(_symbol,MODE_TICKVALUE);
    while(!(tmp>0)){
      ChartOpen(_symbol,PERIOD_H1);
      Sleep(100);
      tmp = MarketInfo(_symbol,MODE_TICKVALUE);
      Print(" Tick is 0 for :"+_symbol+" trying again.. ",tmp);
    }
   return tmp;
}

double getMarketInfo(string _symbol, int _type ){
    double tmp = MarketInfo(_symbol,_type);
    while(!(tmp>0)){
      ChartOpen(_symbol,PERIOD_H1);
      Sleep(100);
      tmp = MarketInfo(_symbol,_type);
      Print(_type," is 0 for :"+_symbol+" trying again.. ",tmp);
    }
   return tmp;
}