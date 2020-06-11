using FreeQuant.Data;
using FreeQuant.Instruments;
using System.Collections.Generic;

namespace OpenQuant.Trading
{
	public class BarSlice
	{
		private int instrumentCount;
		private Dictionary<Instrument, Bar> table;

		public Dictionary<Instrument, Bar> Table
		{
			get
			{
				return this.table;
			}
		}

		public bool IsComplete
		{
			get
			{
				return this.table.Count == this.instrumentCount;
			}
		}

		internal BarSlice(int instrumentCount)
		{
			this.instrumentCount = instrumentCount;
			this.Init();
		}

		private void Init()
		{
			this.table = new Dictionary<Instrument, Bar>();
		}

		internal void AddBar(Instrument instrument, Bar bar)
		{
			this.table[instrument] = bar;
		}

		internal void Reset()
		{
			this.table.Clear();
		}
	}
}
