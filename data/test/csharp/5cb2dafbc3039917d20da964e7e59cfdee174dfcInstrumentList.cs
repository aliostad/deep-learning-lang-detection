using System.Collections;
using System.Collections.Generic;

namespace OpenQuant.API
{
	public class InstrumentList : IEnumerable
	{
		private Dictionary<string, Instrument> list = new Dictionary<string, Instrument>();

		public int Count
		{
			get
			{
				return this.list.Count;
			}
		}

		public Instrument this [string symbol]
		{
			get
			{
				Instrument instrument = (Instrument)null;
				this.list.TryGetValue(symbol, out instrument);
				return instrument;
			}
		}

		internal void Add(string symbol, Instrument instrument)
		{
			this.list.Add(symbol, instrument);
		}

		internal void Remove(string symbol)
		{
			this.list.Remove(symbol);
		}

		internal void Remove(Instrument instrument)
		{
			this.list.Remove(instrument.Symbol);
		}

		public IEnumerator GetEnumerator()
		{
			return (IEnumerator)this.list.Values.GetEnumerator();
		}
	}
}
