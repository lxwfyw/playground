//+------------------------------------------------------------------+
//|                                                          Bar.mqh |
//|                                                       Chuan Wang |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Chuan Wang"
#property link      "https://www.mql5.com"

enum BarType
{
    BULLISH,
    BULLISH_BODY_ENGULFING,
    BULLISH_PINBAR,
    BEARISH,
    BEARISH_BODY_ENGULFING,
    BEARISH_PINBAR,
    DOJI,
    UNDEFINED
};

struct Bar {

    double high;
    double low;
    double open;
    double close;
    BarType barType;
    datetime openTime;
};