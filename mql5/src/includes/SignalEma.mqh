//+------------------------------------------------------------------+
//|                                                    SignalEma.mqh |
//|                                                       Chuan Wang |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Chuan Wang"
#property link      "https://www.mql5.com"

#include <helper\signalindicator.mqh>
#include <helper\helper.mqh>

class SignalEma : public SignalIndicator
  {
private:
    int period;
    int emaHandle;
    double ema[];
public:
    SignalEma(void);
    ~SignalEma(void);
    virtual int init();
    virtual void onNewBar(Bar &newBar);
  };

int SignalEma::init() {
   emaHandle = iMA(_Symbol, _Period, period, 0, MODE_EMA, PRICE_CLOSE);
   if (emaHandle == INVALID_HANDLE)
    {
        Alert("Failed to create handle for indicator for the symbol %s/%s, error code %d",
                    _Symbol, EnumToString(_Period), GetLastError());
        return (INIT_FAILED);
    }
    else { return initBuffer(ema); }
}

void SignalEma::onNewBar(Bar &newBar) {

}