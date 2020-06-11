using FreeQuant.Data;
using FreeQuant.Series;
using System;

namespace FreeQuant.Instruments
{
    public class Pricer : IPricer
    {
        public virtual double Price(Instrument instrument)
        {
            if (instrument.Trade.DateTime != DateTime.MinValue && instrument.Trade.DateTime >= instrument.Bar.DateTime)
                return instrument.Trade.Price;
            if (instrument.Bar.DateTime != DateTime.MinValue)
                return instrument.Bar.Close;
            Daily last = (Daily)(instrument.GetDailySeries()).Last;
            if (last != null)
                return last.Close;
            else
                return 0.0;
        }

        public virtual double Volatility(Instrument instrument)
        {
            return 0.0;
        }

        public virtual double Delta(Instrument instrument)
        {
            return 0.0;
        }

        public virtual double Gamma(Instrument instrument)
        {
            return 0.0;
        }

        public virtual double Theta(Instrument instrument)
        {
            return 0.0;
        }

        public virtual double Vega(Instrument instrument)
        {
            return 0.0;
        }

        public virtual double Rho(Instrument instrument)
        {
            return 0.0;
        }

        public virtual double Price(Instrument instrument, DateTime dateTime)
        {
            return instrument.GetDailySeries()[dateTime.Date, EIndexOption.Prev].Close;
        }

        public virtual double Volatility(Instrument instrument, DateTime dateTime1, DateTime dateTime2)
        {
            return 0.0;
        }

        public virtual double Delta(Instrument instrument, DateTime dateTime)
        {
            return 0.0;
        }

        public virtual double Gamma(Instrument instrument, DateTime dateTime)
        {
            return 0.0;
        }

        public virtual double Theta(Instrument instrument, DateTime dateTime)
        {
            return 0.0;
        }

        public virtual double Vega(Instrument instrument, DateTime dateTime)
        {
            return 0.0;
        }

        public virtual double Rho(Instrument instrument, DateTime dateTime)
        {
            return 0.0;
        }
    }
}
