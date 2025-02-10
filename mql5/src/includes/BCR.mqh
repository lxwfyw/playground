//+------------------------------------------------------------------+
//|                                              IndicatorSignal.mqh |
//|                                                       Chuan Wang |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Chuan Wang"
#property link      "https://www.mql5.com"

enum BCRSignalState {
    NO_ENTRY,
    BAR_BREAK,
    BAR_CLOSE,
    RETEST,
    ENTER_LONG,
    ENTER_SHORT
};

struct BCR {

//private:
    double patternInvalidationPrice;
    double necklinePrice;
    BCRSignalState bcrState;
//public:
//    BCR(void): patternInvalidationPrice(0.0), necklinePrice(0.0), currentState(NO_ENTRY) {}
//    ~BCR(void) {}
//    void setPatternInvalidationPrice(double value) {patternInvalidationPrice = value;}
//    void setNecklinePrice(double value) {necklinePrice = value;}
//    void setSignalState(BCRSignalState value) {currentState = value;}
};
