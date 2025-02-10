//+------------------------------------------------------------------+
//|                                                       Helper.mqh |
//|                                                       Chuan Wang |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Chuan Wang"
#property link "https://www.mql5.com"

//+-CONSTANTS--------------------------------------------------------+
static int MAX_ORDERS = 1;
static double POINT_TOLERANCE = 3;

//+-DEFINITIONS------------------------------------------------------+

enum LotMode
{
    LOT_MODE_FIXED,
    LOT_MODE_PERCENT,
    LOT_MODE_MONETARY
};

enum BarOffset
{
    T = 0,
    T_1 = 1,
    T_2 = 2
};
enum DonchianBand
{
    DONCHIAN_UPPER_BAND = 0,
    DONCHIAN_MIDDLE = 1,
    DONCHIAN_LOWER_BAND = 2
};

//+------------------------------------------------------------------+
//| UTILITY METHODS                                                  |
//+------------------------------------------------------------------+
void indicatorRelease(int handle)
{
    if (handle != INVALID_HANDLE)
    {
        IndicatorRelease(handle);
    }
}
double symbolInfoDouble(ENUM_SYMBOL_INFO_DOUBLE key)
{
    return NormalizeDouble(SymbolInfoDouble(_Symbol, key), _Digits);
}

int getTotalPositionCount()
{
    return PositionsTotal();
}

double getAvailableCapital()
{
    return MathMin(
        MathMin(AccountInfoDouble(ACCOUNT_EQUITY), AccountInfoDouble(ACCOUNT_BALANCE)),
        AccountInfoDouble(ACCOUNT_MARGIN_FREE));
}

double calculateLotSize(const string symbol, const double stopLossPoints, const double riskMonetaryValue)
{
    //string currency   = AccountInfoString(ACCOUNT_CURRENCY);
    //double tickSize   = SymbolInfoDouble(symbl,SYMBOL_TRADE_TICK_SIZE);
    double tickValue  = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);

    //double pointSize  = SymbolInfoDouble(symbl,SYMBOL_POINT);
    //double PointValue = tickValue * pointSize / tickSize;

   // double risk_money = risk/100.0*capital;
   // double lots = risk_money/ sl_points/ PointValue;
   double lotSize = riskMonetaryValue/ stopLossPoints/ tickValue;

   //Print("Lot size = " + DoubleToString(lots,2));
   //Print("Risked amount = " +DoubleToString(risk_money,2));
   return lotSize;
}

void normalizeLotSize(const string symbol, double &lotSize) {
    double lotSizeStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
    double lotSizeMin  = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    double lotSizeMax  = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
   //Make sure lotsizes are OK within broker restrictions
   lotSize = NormalizeDouble(MathRound(lotSize/ lotSizeStep) * lotSizeStep, 2);
   lotSize = MathMax(lotSizeMin, MathMin(lotSizeMax, lotSize));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool initBuffer(const double &buffer[])
{
    return ArraySetAsSeries(buffer, true);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getBarHigh(int barIndex)
{
    return iHigh(_Symbol, _Period, barIndex);
}
double getBarLow(int barIndex)
{
    return iLow(_Symbol, _Period, barIndex);
}
double getBarOpen(int barIndex)
{
    return iOpen(_Symbol, _Period, barIndex);
}
double getBarClose(int barIndex)
{
    return iClose(_Symbol, _Period, barIndex);
}
datetime getCurrentBarTime()
{
    return iTime(_Symbol, _Period, 0);
}
void printBarHLOC(BarOffset offset)
{
    Print("High: ", DoubleToString(iHigh(_Symbol, _Period, offset), _Digits));
    Print("Low: ", DoubleToString(iLow(_Symbol, _Period, offset), _Digits));
    Print("Open: ", DoubleToString(iOpen(_Symbol, _Period, offset), _Digits));
    Print("Close: ", DoubleToString(iClose(_Symbol, _Period, offset), _Digits));
}
