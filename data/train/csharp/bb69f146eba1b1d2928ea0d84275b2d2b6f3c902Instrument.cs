using TheGapFillers.MarketData.Models;

namespace TheGapFillers.Portrack.Models.Application
{
	public class Instrument
	{
		public Instrument()
		{
			InstrumentData = new InstrumentData();
		}

		public int InstrumentId { get; set; }
		public string Ticker { get; set; }
		public string Name { get; set; }
		public string Currency { get; set; }
		public InstrumentData InstrumentData { get; set; }
		public Quote Quote { get; set; }
		public InstrumentType Type {get;set;}
	}


	public class InstrumentData
	{
		
	}

	public enum InstrumentType
	{
		Exchange,
		Stock,
		Etf,
		Fx
	}
  
}
