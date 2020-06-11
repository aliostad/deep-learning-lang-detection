using OpenQuant.API;
using System.Collections;
using System.Collections.Generic;

namespace OpenQuant.API.Engine
{
	///<summary>
	///  A list of instruments
	///</summary>
	public class InstrumentList : IEnumerable
	{
		private Dictionary<string, Instrument> instruments;

		///<summary>
		///  Gets the number of instruments in this instrument list
		///</summary>
		public int Count
		{
			get
			{
				return this.instruments.Count;
			}
		}

		///<summary>
		///  Gets instrument by name 
		///</summary>
		public Instrument this[string symbol]
		{
			get
			{
				return this.instruments[symbol];
			}
		}

		internal InstrumentList()
		{
			this.instruments = new Dictionary<string, Instrument>();
		}

		///<summary>
		///  Gets enumerator
		///</summary>
		public IEnumerator GetEnumerator()
		{
			return this.instruments.Values.GetEnumerator();
		}

		///<summary>
		///  Gets if the instrument set contains a instrument with specified name
		///</summary>
		public bool Contains(string name)
		{
			return this.instruments.ContainsKey(name);
		}

		///<summary>
		///  Gets instrument by name
		///</summary>
		public bool TryGetValue(string name, out Instrument instrument)
		{
			return this.instruments.TryGetValue(name, out instrument);
		}

		///<summary>
		///  Adds instrument to the list
		///</summary>
		public void Add(Instrument instrument)
		{
			this.instruments.Add(instrument.Symbol, instrument);
		}

		///<summary>
		///  Adds instrument to the list
		///</summary>
		public void Add(string symbol)
		{
			this.Add(InstrumentManager.Instruments[symbol]);
		}

		///<summary>
		///  Clears instrument list 
		///</summary>
		public void Clear()
		{
			this.instruments.Clear();
		}

		///<summary>
		///  Removes insturment from the list 
		///</summary>
		public void Remove(string symbol)
		{
			this.instruments.Clear();
		}

		///<summary>
		///  Removes insturment from the list 
		///</summary>
		public void Remove(Instrument instrument)
		{
			this.Remove(instrument.Symbol);
		}
	}
}
