using FreeQuant.Data;
using FreeQuant.Instruments;
using System.Collections.Generic;

namespace FreeQuant.Trading
{
	public class BarSlice
	{
		private int instrumentCount;

		public Dictionary<Instrument, Bar> Table { get; private set; }

		public bool IsComplete
		{
			get
			{
				return this.Table.Count == this.instrumentCount;
			}
		}

		internal BarSlice(int instrumentCount)
		{
			this.instrumentCount = instrumentCount;
			this.Table = new Dictionary<Instrument, Bar>();
		}

		internal void Add(Instrument instrument, Bar bar)
		{
			this.Table[instrument] = bar;
		}

		internal void Clear()
		{
			this.Table.Clear();
		}
	}
}
