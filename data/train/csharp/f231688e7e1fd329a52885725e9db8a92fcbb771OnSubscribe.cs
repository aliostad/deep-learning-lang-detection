using System;
namespace SmartQuant
{
	public class OnSubscribe : Event
	{
		internal Instrument instrument;
		internal InstrumentList instruments;
		internal DateTime dateTime1;
		internal DateTime dateTime2;
		public override byte TypeId
		{
			get
			{
				return 203;
			}
		}
		public OnSubscribe(Instrument instrument, DateTime dateTime1, DateTime dateTime2)
		{
			this.instrument = instrument;
			this.dateTime1 = dateTime1;
			this.dateTime2 = dateTime2;
		}
		public OnSubscribe(InstrumentList instruments)
		{
			this.instruments = instruments;
			this.dateTime1 = DateTime.MinValue;
			this.dateTime2 = DateTime.MaxValue;
		}
		public OnSubscribe(Instrument instrument)
		{
			this.instrument = instrument;
			this.dateTime1 = DateTime.MinValue;
			this.dateTime2 = DateTime.MaxValue;
		}
		public override string ToString()
		{
			return string.Concat(new object[]
			{
				"Subscribe ",
				this.instrument.symbol,
				" ",
				this.dateTime1,
				" - ",
				this.dateTime2
			});
		}
	}
}
