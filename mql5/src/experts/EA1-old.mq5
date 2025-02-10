//+------------------------------------------------------------------+
//|                                                        Test1.mq5 |
//|                                                       Chuan Wang |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <trade/trade.mqh>
#include <helper/helper.mqh>

#property copyright "Chuan Wang"
#property link "https://www.mql5.com"
#property version "1.00"

ulong expertUID = 6622438;

//+------------------------------------------------------------------+
input LotMode lotMode = LOT_MODE_PERCENT;
input double positionSize = 1;

input int tradingStartHour = 9;
input int tradingCloseHour = 16;

input int emaPeriod = 200;
int emaHandle;
double ema[];

input int atrPeriod = 10;
int atrHandle;
double atr[];

input int donchianPeriod = 20;
int donchianHandle;
double donchianUpper[];
double donchianMid[];
double donchianLower[];

input int superTrendPeriod = 34;
input double superTrendMultiplier = 3.5;
int superTrendHandle;
double superTrend[];

BarType t1Bar;

datetime lastBarTime = 0;

double t2BarHigh = 0;
double t2BarLow = 0;
double t2BarOpen = 0;
double t2BarClose = 0;

double t1BarHigh = 0;
double t1BarLow = 0;
double t1BarOpen = 0;
double t1BarClose = 0;

CTrade trade;

bool conditionInputsValid()
{
    if (lotMode == LOT_MODE_FIXED && (positionSize < 0.01 || positionSize > 1))
    {
        Alert("Invalid fixed position size");
        return false;
    }
    else if (lotMode == LOT_MODE_PERCENT && (positionSize < 0.1 || positionSize > 1))
    {
        Alert("Invalid position size percent");
        return false;
    }
    else if (lotMode == LOT_MODE_MONETARY && (positionSize < 1 || positionSize > 100))
    {
        Alert("Invalid position size percent");
        return false;
    }
    return true;
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- create timer
    EventSetTimer(60); // every 60 seconds

    t1Bar = UNDEFINED;

    atrHandle = iATR(_Symbol, _Period, atrPeriod);
    emaHandle = iMA(_Symbol, _Period, emaPeriod, 0, MODE_EMA, PRICE_CLOSE);
    donchianHandle = iCustom(_Symbol, _Period, "Free Indicators\\Donchian Channel.ex5", donchianPeriod);
    superTrendHandle = iCustom(_Symbol, _Period, "SuperTrend.ex5", superTrendPeriod, superTrendMultiplier);

    if (emaHandle == INVALID_HANDLE || atrHandle == INVALID_HANDLE || donchianHandle == INVALID_HANDLE || superTrendHandle == INVALID_HANDLE)
    {
        PrintFormat("Failed to create handle for indicator for the symbol %s/%s, error code %d",
                    _Symbol, EnumToString(_Period), GetLastError());
        return (INIT_FAILED);
    }
    else
    {
        initBuffers();
    }
    return (INIT_SUCCEEDED);
}

void initBuffers()
{
    initBuffer(atr);
    initBuffer(ema);
    initBuffer(donchianUpper);
    initBuffer(donchianMid);
    initBuffer(donchianLower);
    initBuffer(superTrend);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    //--- destroy timer
    EventKillTimer();
    indicatorRelease(atrHandle);
    indicatorRelease(emaHandle);
    indicatorRelease(donchianHandle);
    indicatorRelease(superTrendHandle);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    if (checkNewBar())
    {
        onNewBar();
    }
    // optionally check when outside trading hours
}

bool checkNewBar()
{
    datetime currentBarTime = getCurrentBarTime();
    if (currentBarTime > lastBarTime)
    {
        // Print("New bar formed at ", TimeToString(currentBarTime, TIME_DATE | TIME_MINUTES));
        lastBarTime = currentBarTime;
        return true;
    }
    else
    {
        return false;
    }
}

void onNewBar()
{
    resetBars();
    bufferEma();
    bufferAtr();
    bufferDonchian();
    bufferSuperTrend();
    showMetrics();
}

void showMetrics()
{
    // Date time by symbol
    // datetime symbolDateTime = (datetime)SymbolInfoInteger(_Symbol, SYMBOL_TIME);
    Comment(
        "\nExpert: ", expertUID, "\n",
        "MT5 Server Time: ", TimeCurrent(), "\n",
        //"Local Time: ", TimeLocal(), "\n",
        //"Symbol DateTime: ", symbolDateTime, "\n",

        "Last Bar Timestamp: ", lastBarTime, "\n",
        "Last Bar Type: ", EnumToString(t1Bar), "\n",
        //"Last Bar High: ", DoubleToString(getBarHigh(T_1), _Digits), "\n",
        //"Last Bar Low: ", DoubleToString(getBarLow(T_1), _Digits), "\n",
        //"Last Bar Open: ", DoubleToString(getBarOpen(T_1), _Digits), "\n",
        //"Last Bar Close: ", DoubleToString(getBarClose(T_1), _Digits), "\n",

        "ATR", atrPeriod, " :", DoubleToString(atr[T_1], _Digits), "\n",
        //"T   ATR", atrPeriod, " :",  DoubleToString(atr[T], _Digits), "\n",
        //"T-2 EMA", emaPeriod, " :", DoubleToString(ema[T_2], _Digits), "\n",
        //"T-1 EMA", emaPeriod, " :", DoubleToString(ema[T_1], _Digits), "\n",
        "T   EMA", emaPeriod, " :", DoubleToString(ema[T], _Digits), "\n",

        "SuperTrend", superTrendPeriod, " :", DoubleToString(superTrend[T], _Digits), "\n",

        "Donchian", donchianPeriod, " Upper :", DoubleToString(donchianUpper[T], _Digits), "\n",
        "Donchian", donchianPeriod, " Mid :", DoubleToString(donchianMid[T], _Digits), "\n",
        "Donchian", donchianPeriod, " Lower :", DoubleToString(donchianLower[T], _Digits), "\n");
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void resetBars()
{
    t2BarHigh = getBarHigh(2);
    t2BarLow = getBarLow(2);
    t2BarOpen = getBarOpen(2);
    t2BarClose = getBarClose(2);

    t1BarHigh = getBarHigh(1);
    t1BarLow = getBarLow(1);
    t1BarOpen = getBarOpen(1);
    t1BarClose = getBarClose(1);

    if (t1BarClose > t1BarOpen)
    {
        t1Bar = BULLISH;
    }
    else if (t1BarClose < t1BarOpen)
    {
        t1Bar = BEARISH;
    }
    else
    {
        t1Bar = DOJI;
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void bufferAtr()
{
    CopyBuffer(atrHandle, MAIN_LINE, 0, 2, atr);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void bufferDonchian()
{
    CopyBuffer(donchianHandle, DONCHIAN_UPPER_BAND, 0, 1, donchianUpper);
    // Print( "Donchian DONCHIAN_UPPER_BAND: ", donchianUpper[0]);
    CopyBuffer(donchianHandle, DONCHIAN_MIDDLE, 0, 1, donchianMid);
    // Print("Donchian DONCHIAN_MIDDLE: ", donchianMid[0]);
    CopyBuffer(donchianHandle, DONCHIAN_LOWER_BAND, 0, 1, donchianLower);
    // Print("Donchian DONCHIAN_LOWER_BAND: ", donchianLower[0]);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void bufferSuperTrend()
{
    CopyBuffer(superTrendHandle, MAIN_LINE, 0, 2, superTrend);
}

//+------------------------------------------------------------------+
//| Process EMA data                                                                 |
//+------------------------------------------------------------------+
void bufferEma()
{
    CopyBuffer(emaHandle, MAIN_LINE, 0, 3, ema);
}

//+------------------------------------------------------------------+
//| FILTERS                                                          |
//+------------------------------------------------------------------+
bool conditionIsTradingHours()
{
    MqlDateTime currentTime;
    TimeToStruct(TimeCurrent(), currentTime);
    return currentTime.hour >= tradingStartHour && currentTime.hour < tradingCloseHour;
}

/***
 *
   bool myLotCalc(string symbol, double stopLossPoints, double accountCcyAmountToRisk, double &lotSize) {

      //double available_capital = fmin( fmin( AccountInfoDouble(ACCOUNT_EQUITY), AccountInfoDouble(ACCOUNT_BALANCE)), AccountInfoDouble(ACCOUNT_MARGIN_FREE));

      double lotSize = 0;
      //double volumeMax = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
      //double volumeMin = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
      //double volumeStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
      double tickSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
      double tickValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
      double point = SymbolInfoDouble(symbol, SYMBOL_POINT);

      string baseCurrency = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
      string quoteCurrency = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
      string marginCurrency = SymbolInfoString(symbol, SYMBOL_CURRENCY_MARGIN);

      string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);

      double requiredUnitTickValue = accountCcyAmountToRisk / stopLossPoints;

      double exchangeRate = 1;

      if(StringLen(baseCurrency) == 0  || StringLen(quoteCurrency) == 0) {
         return false;
      }
      if(StringCompare(accountCurrency, quoteCurrency) != 0) {
         if(StringCompare(accountCurrency, baseCurrency) == 0) {
            SymbolInfoDouble(_Symbol, SYMBOL_ASK, exchangeRate);
         } else {
            string conversionSymbol = "";
            StringConcatenate(conversionSymbol, accountCurrency, quoteCurrency);
            bool isCustom = false;
            if(SymbolExist(conversionSymbol, isCustom)) {
              SymbolInfoDouble(conversionSymbol, SYMBOL_ASK, exchangeRate);
            } else {
               return false;
            }
         }
      }
      double quoteCcyAmountToRisk = accountCcyAmountToRisk * exchangeRate;
      double tickUnitValue = quoteCcyAmountToRisk / stopLossPoints;
      lotSize = tickUnitValue / tickSize / 100000;

      return true;
   }

*/

//+------------------------------------------------------------------+
//| STRATEGIES                                                       |
//+------------------------------------------------------------------
double strategyPositionSizing(double entryPrice, double stopLossPrice)
{
    double stopDistancePoints = MathAbs(entryPrice - stopLossPrice);
    double lotSize = 0;
    if (lotMode == LOT_MODE_FIXED)
    {
        lotSize = positionSize;
    }
    else if (lotMode == LOT_MODE_MONETARY)
    {
        lotSize = calculateLotSize(_Symbol, stopDistancePoints, positionSize);
    }
    else if (lotMode == LOT_MODE_PERCENT)
    {
        double availableCapital = getAvailableCapital();
        double riskMonetaryValue = (availableCapital * positionSize) / 100.0;
        lotSize = calculateLotSize(_Symbol, stopDistancePoints, riskMonetaryValue);
    }
    normalizeLotSize(_Symbol, lotSize);
    return lotSize;
}
bool strategyExit()
{
    // for (int i = 0; i < PositionsTotal(); i++)
    // {

    //     double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    //     double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    //     ulong ticket = PositionGetTicket(i);
    //     double ticketOpen = PositionGetDouble(POSITION_PRICE_OPEN);
    //     double ticketSL = PositionGetDouble(POSITION_SL);
    //     double ticketTP = PositionGetDouble(POSITION_TP);
    //     // if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
    // }
    return false;
}
void strategyEntry()
{
}
void signalEma()
{
}
void signalDonchian()
{
}
void signalSuperTrend()
{
}

//+------------------------------------------------------------------+
//| POSITION ENTRY METHODS                                           |
//+------------------------------------------------------------------+
bool conditionNewEntry()
{
    return conditionIsTradingHours() && getTotalPositionCount() < 1;
}

bool open(const ENUM_ORDER_TYPE orderType, double size, double price, double stopLoss, double takeProfit, string comment)
{
    return trade.PositionOpen(_Symbol, orderType, size, price, stopLoss, takeProfit, comment);
}

bool close(ulong ticket)
{
    return trade.PositionClose(ticket);
}

//+------------------------------------------------------------------+
//| STOP MANAGEMENT METHODS                                          |
//+------------------------------------------------------------------+
bool checkTrailingStop()
{
    return false;
}

bool trailStop()
{
    return false;
}

//+------------------------------------------------------------------+
//| OTHER CALLBACK METHODS                                           |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
}
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
{
    //---
}
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
{
    //---
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    //---
}
//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol)
{
    //---
}

//+------------------------------------------------------------------+
//| TRADE TESTER METHODS                                             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
{
    //---
    double ret = 0.0;
    //---

    //---
    return (ret);
}
//+------------------------------------------------------------------+
//| TesterInit function                                              |
//+------------------------------------------------------------------+
void OnTesterInit()
{
    //---
}
//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass()
{
    //---
}
//+------------------------------------------------------------------+
//| TesterDeinit function                                            |
//+------------------------------------------------------------------+
void OnTesterDeinit()
{
    //---
}
//+------------------------------------------------------------------+
