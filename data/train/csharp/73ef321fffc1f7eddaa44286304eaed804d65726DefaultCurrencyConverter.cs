using FreeQuant.Instruments;
using System;

namespace OpenQuant.API
{
	class DefaultCurrencyConverter : CurrencyConverter
	{
		public override double Convert(double amount, FreeQuant.Instruments.Currency fromCurrency, FreeQuant.Instruments.Currency toCurrency)
		{
			if (fromCurrency == toCurrency)
				return amount;
			Instrument instrument1 = InstrumentManager.Instruments[fromCurrency.Code + "_" + toCurrency.Code];
			if (instrument1 != null)
				return amount * this.GetAmount(instrument1, amount);
			Instrument instrument2 = InstrumentManager.Instruments[toCurrency.Code + "_" + fromCurrency.Code];
			if (instrument2 == null)
				return amount;
			else
				return amount / this.GetAmount(instrument2, amount);
		}

		private double GetAmount(Instrument instrument, double amount)
		{
			if (instrument.Quote.DateTime != DateTime.MinValue)
				return (instrument.Quote.Ask + instrument.Quote.Bid) / 2.0;
			if (instrument.Trade.DateTime != DateTime.MinValue && instrument.Trade.DateTime >= instrument.Bar.DateTime)
				return instrument.Trade.Price;
			if (instrument.Bar.DateTime != DateTime.MinValue)
				return instrument.Bar.Close;
			else
				return 1.0;
		}
	}
}
