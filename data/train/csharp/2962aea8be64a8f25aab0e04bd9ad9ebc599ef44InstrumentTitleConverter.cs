using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using RiskAnalysisTool.Instruments;
using RiskAnalysisTool.Utilities;
using Xamarin.Forms;

namespace RiskAnalysisTool.MobileApp.Converters
{
    class InstrumentTitleConverter : DynamicVisitor<Instrument>, IValueConverter
    {
        private object _result;

        public string ConvertSymbol(string symbol)
        {
            if (symbol == null)
            {
                return "";
            }

            return symbol.Trim().Trim('$');
        }

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            Instrument instrument = value as Instrument;
            if (instrument == null)
            {
                return null;
            }

            this.Visit(instrument);
            return _result;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotSupportedException();
        }

        protected void OnVisit(InterestRateSwap instrument)
        {
            _result = string.Format("Interest Rate Swap - {0}", instrument.IsPayFloating ? "Pay Floating" : "Pay Fixed");
        }

        protected void OnVisit(CrossCurrencySwap instrument)
        {
            _result = string.Format("Cross Currency Swap - {0} {1}",
                instrument.PaySymbol == null ? "Receive" : "Pay",
                this.ConvertSymbol(instrument.PaySymbol ?? instrument.ReceiveSymbol));
        }

        protected void OnVisit(EquitySwap instrument)
        {
            _result = string.Format("Equity Swap: {0}",
                this.ConvertSymbol(instrument.PaySymbol ?? instrument.ReceiveSymbol)
                );
        }

        protected void OnVisit(Bond instrument)
        {
            _result = string.Format("Bond: {0}", this.ConvertSymbol(instrument.Symbol));
        }

        protected void OnVisit(CreditDefaultSwap instrument)
        {
            _result = string.Format("Credit Default Swap: {0}", this.ConvertSymbol(instrument.Symbol));
        }

        protected void OnVisit(ImpliedVolatility instrument)
        {
            _result = string.Format("Implied Volatility: {0}", this.ConvertSymbol(instrument.Symbol));
        }

        protected void OnVisit(Correlation instrument)
        {
            _result = string.Format("Corrleation: {0} - {1}",
               this.ConvertSymbol(instrument.Symbol1),
               this.ConvertSymbol(instrument.Symbol2)
               );
        }
    }
}
