//+---------------------------------------------------------------------------+
//|                                                    MASi_ML-CustomAuto.mq4 |
//|                                         Copyright 2017, Terentyev Aleksey |
//|                                 https://www.mql5.com/ru/users/terentyev23 |
//+---------------------------------------------------------------------------+
#property copyright     "Copyright 2017, Terentyev Aleksey"
#property link          "https://www.mql5.com/ru/users/terentyev23"
#property description   ""
#property version       "1.0"
#property strict

//---------------------Indicators---------------------------------------------+
#property indicator_separate_window
#property indicator_minimum -1
#property indicator_maximum 1
#property indicator_buffers 2
#property indicator_plots   2
//--- plot
#property indicator_label1  "Buy"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
#property indicator_label2  "Sell"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  3
//--- indicator buffers
double      GreenBuffer[], RedBuffer[];

//+---------------------------------------------------------------------------+
int OnInit()
{
    return INIT_SUCCEEDED;
}

//+---------------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    int limit = rates_total - prev_calculated;
    if( prev_calculated > 0 ) {
        limit++;
    }
    double tmp = 0.0;
    for( int idx = 0; idx < limit; idx++ ) {
        GreenBuffer[idx] = 0.0;
        RedBuffer[idx] = 0.0;
        tmp = iCustomAuto(idx, Symbol(), Period());
        if( tmp > 0 ) {
            GreenBuffer[idx] = tmp;
        } else if( tmp < 0 ) {
            RedBuffer[idx] = tmp;
        }
    }
    return rates_total;
}

//+---------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}

//+---------------------------------------------------------------------------+
double iCustomAuto(const int bar, 
                   const string symbol = NULL, const int period = PERIOD_CURRENT)
{   // Generate custom signals for ML
    if( bar >= Bars-2 || 2 >= bar ) {
        return 0.0;
    }
    // double ema22,
    double ema21, ema20, ema2_, ema2__, result = 0.0;
    // ema22 = iMA( symbol, period, 2, 0, MODE_EMA, PRICE_OPEN, bar+2 );
    ema21 = iMA( symbol, period, 2, 0, MODE_EMA, PRICE_OPEN, bar+1 );
    ema20 = iMA( symbol, period, 2, 0, MODE_EMA, PRICE_OPEN, bar );
    ema2_ = iMA( symbol, period, 2, 0, MODE_EMA, PRICE_OPEN, bar-1 );
    ema2__ = iMA( symbol, period, 2, 0, MODE_EMA, PRICE_OPEN, bar-2 );
    if( ema20 < ema2_ ) {
        result = 1.0;
        if( ema21 < ema20 ) {
            result = 0.6;
        }
        if( ema2_ > ema2__ ) { // ema22 < ema21 && ema21 > ema20 && 
            result = 0.3;
        }
    } else if( ema20 > ema2_ ) {
        result = -1.0;
        if( ema21 > ema20 ) {
            result = -0.6;
        }
        if( ema2_ < ema2__ ) { // ema22 > ema21 && ema21 < ema20 && 
            result = -0.3;
        }
    }
    return result;
}
