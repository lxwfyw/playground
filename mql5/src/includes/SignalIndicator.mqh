//+------------------------------------------------------------------+
//|                                                         Base.mqh |
//|                                                       Chuan Wang |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Chuan Wang"
#property link      "https://www.mql5.com"

#include <helper/bar.mqh>

enum SignalIndicatorState {
    NO_ENTRY,
    ENTER_BUY,
    ENTER_SELL
};

class SignalIndicator
  {
protected:
    SignalIndicatorState signalIndicatorState;
public:
    SignalIndicator(void): signalIndicatorState(NO_ENTRY) {}
    ~SignalIndicator(void);
    virtual int init();
    virtual void onNewBar(Bar &newBar);
  };


