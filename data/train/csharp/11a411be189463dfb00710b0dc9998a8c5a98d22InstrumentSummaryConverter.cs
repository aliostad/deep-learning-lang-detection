using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using RiskAnalysisTool.Instruments;
using RiskAnalysisTool.Utilities;
using Xamarin.Forms;

namespace RiskAnalysisTool.MobileApp.Converters
{
    class InstrumentSummaryConverter : DynamicVisitor<Instrument>, IValueConverter
    {
        private object _result;

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
            string str1, str2;
            if(instrument.IsPayFloating)
            {
                str1 = string.Format("LIBOR{0:+#0;-#0;+#0}bps", instrument.FloatingSpread * 10000);
                str2 = string.Format("{0:#0.0%}", instrument.FixedRate);
            }
            else
            {
                str1 = string.Format("{0:#0.0%}", instrument.FixedRate);
                str2 = string.Format("LIBOR{0:+#0;-#0;+0}bps", instrument.FloatingSpread * 10000);
            }
            _result = string.Format("N: {0}, Pay: {1}, Rec: {2}", instrument.Nominal, str1, str2);
        }

        protected void OnVisit(CrossCurrencySwap instrument)
        {
            _result = string.Format("Pay: {0} x {1} , Rec: {2} x {3}", 
                instrument.PayNominal, instrument.PayRate, instrument.ReceiveNominal, instrument.ReceiveRate);
        }

        protected void OnVisit(EquitySwap instrument)
        {
            _result = string.Format("{0} div. of {1} shares @ {2:#0.0%}",
                instrument.PaySymbol != null ? "Pay":"Receive", instrument.Amount, instrument.FixedRate);
        }

        protected void OnVisit(Bond instrument)
        {
            _result = string.Format("Maturity: {0:d}, Price: {1:#0.000}", instrument.MaturityDate, instrument.Price);
        }

        protected void OnVisit(CreditDefaultSwap instrument)
        {
            _result = string.Format("Tenor: {0}, Spread: {1:#0}bps", instrument.Tenor, instrument.Spread * 10000);
        }

        protected void OnVisit(ImpliedVolatility instrument)
        {
            _result = string.Format("{0}", instrument.Value);
        }

        protected void OnVisit(Correlation instrument)
        {
            _result = string.Format("{0:#0.000}", instrument.Value);
        }
    }
}
