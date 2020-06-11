using System;
using FreeQuant.Data;
using FreeQuant.FIX;

namespace FreeQuant.Simulation
{
	class SimpleDataObject : IDataObject
	{
		public int DataType;
		public DateTime DateTime { get; set; }
		public IFIXInstrument Instrument { get; private set; }
		public byte ProviderId { get; set; }
		public SimpleDataObject(IFIXInstrument instrument, Trade trade)
		{
			this.DateTime = trade.DateTime;
			this.Instrument = instrument;
			this.DataType = 0;
		}

		public SimpleDataObject(IFIXInstrument instrument, Quote quote)
		{
			this.DateTime = quote.DateTime;
			this.Instrument = instrument;
			this.DataType = 1;
		}
	}
}

