using System;
using System.Collections;
using System.Collections.Generic;
namespace SmartQuant
{
	public class InstrumentList : IEnumerable<Instrument>, IEnumerable
	{
		private Dictionary<string, Instrument> instrumentBySymbol = new Dictionary<string, Instrument>();
		private IdArray<Instrument> instrumentById = new IdArray<Instrument>(10000);
		private List<Instrument> instruments = new List<Instrument>();
		public int Count
		{
			get
			{
				return this.instruments.Count;
			}
		}
		public Instrument this[string symbol]
		{
			get
			{
				return this.Get(symbol);
			}
		}
		public bool Contains(string symbol)
		{
			return this.instrumentBySymbol.ContainsKey(symbol);
		}
		public bool Contains(Instrument instrument)
		{
			return this.instrumentBySymbol.ContainsKey(instrument.Symbol);
		}
		public bool Contains(int id)
		{
			return this.instrumentById[id] != null;
		}
		public void Add(Instrument instrument)
		{
			if (this.instrumentById[instrument.Id] == null)
			{
				this.instruments.Add(instrument);
				this.instrumentBySymbol[instrument.Symbol] = instrument;
				this.instrumentById[instrument.Id] = instrument;
				return;
			}
			Console.WriteLine(string.Concat(new object[]
			{
				"InstrumentList::Add Instrument ",
				instrument.Symbol,
				" with Id = ",
				instrument.Id,
				" is already in the list"
			}));
		}
		public void Remove(Instrument instrument)
		{
			this.instruments.Remove(instrument);
			this.instrumentBySymbol.Remove(instrument.Symbol);
			this.instrumentById.Remove(instrument.Id);
		}
		public Instrument Get(string symbol)
		{
			Instrument result;
			this.instrumentBySymbol.TryGetValue(symbol, out result);
			return result;
		}
		public Instrument GetByIndex(int index)
		{
			return this.instruments[index];
		}
		public Instrument GetById(int id)
		{
			return this.instrumentById[id];
		}
		public void Clear()
		{
			this.instrumentBySymbol.Clear();
			this.instrumentById.Clear();
			this.instruments.Clear();
		}
		public override string ToString()
		{
			string text = "";
			foreach (Instrument current in this.instruments)
			{
				text = text + current.symbol + "\n";
			}
			return text.Remove(text.Length - 1, 1);
		}
		public IEnumerator<Instrument> GetEnumerator()
		{
			return this.instruments.GetEnumerator();
		}
		IEnumerator IEnumerable.GetEnumerator()
		{
			return this.instruments.GetEnumerator();
		}
	}
}
