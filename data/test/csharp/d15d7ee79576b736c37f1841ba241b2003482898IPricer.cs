using System;

namespace FreeQuant.Instruments
{
	public interface IPricer
	{
		double Price(Instrument instrument);
		double Volatility(Instrument instrument);
		double Delta(Instrument instrument);
		double Gamma(Instrument instrument);
		double Theta(Instrument instrument);
		double Vega(Instrument instrument);
		double Rho(Instrument instrument);
		double Price(Instrument instrument, DateTime dateTime);
		double Volatility(Instrument instrument, DateTime dateTime1, DateTime dateTime2);
		double Delta(Instrument instrument, DateTime dateTime);
		double Gamma(Instrument instrument, DateTime dateTime);
		double Theta(Instrument instrument, DateTime dateTime);
		double Vega(Instrument instrument, DateTime dateTime);
		double Rho(Instrument instrument, DateTime dateTime);
	}
}
