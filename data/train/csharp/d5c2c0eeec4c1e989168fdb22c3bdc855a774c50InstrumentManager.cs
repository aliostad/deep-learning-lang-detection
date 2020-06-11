namespace OpenQuant.API
{
	///<summary>
	///  An Instrument manager
	///</summary>
	public static class InstrumentManager
	{
		///<summary>
		///  Gets instrument list
		///</summary>
		public static InstrumentList Instruments
		{
			get
			{
				//FIXME
				return OpenQuant.Instruments;
			}
		}

		///<summary>
		///  Removes instrument 
		///</summary>
		public static void Remove(Instrument instrument)
		{
			//FIXME
			OpenQuant.Instruments.Remove(instrument);
			FreeQuant.Instruments.InstrumentManager.Remove(instrument.instrument);
		}

		///<summary>
		///  Removes instrument
		///</summary>
		public static void Remove(string symbol)
		{
			//FIXME
			OpenQuant.Instruments.Remove(symbol);
			FreeQuant.Instruments.InstrumentManager.Remove(symbol);
		}
	}
}
