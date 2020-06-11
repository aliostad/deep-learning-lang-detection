using FreeQuant.FIX;
using System;

namespace FreeQuant.Providers
{
	public class IntradayEventArgs : EventArgs
	{
		protected IFIXInstrument instrument;
		protected IMarketDataProvider provider;

		public IFIXInstrument Instrument
		{
			get
			{
				return this.instrument;
			}
		}

		public IMarketDataProvider Provider
		{
			get
			{
				return this.provider;
			}
		}

		protected IntradayEventArgs(IFIXInstrument instrument, IMarketDataProvider provider) : base()
		{
			this.instrument = instrument;
			this.provider = provider;
		}
	}
}
