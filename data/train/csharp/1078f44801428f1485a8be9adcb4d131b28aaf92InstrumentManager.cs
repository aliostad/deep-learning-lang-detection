using System;
namespace SmartQuant
{
	public class InstrumentManager
	{
		private Framework framework;
		private InstrumentServer server;
		private InstrumentList instruments;
		private int next_id;
		public InstrumentList Instruments
		{
			get
			{
				return this.instruments;
			}
		}
		public InstrumentServer Server
		{
			get
			{
				return this.server;
			}
		}
		public Instrument this[string symbol]
		{
			get
			{
				return this.instruments.Get(symbol);
			}
		}
		public InstrumentManager(Framework framework, InstrumentServer server)
		{
			this.framework = framework;
			this.server = server;
			this.server.Open();
			this.next_id = -1;
			this.instruments = server.Load();
			for (int i = 0; i < this.instruments.Count; i++)
			{
				this.instruments.GetByIndex(i).isPersistent = true;
				int id = this.instruments.GetByIndex(i).Id;
				if (id > this.next_id)
				{
					this.next_id = id;
				}
			}
			this.next_id++;
		}
		public Instrument GetById(int id)
		{
			Instrument instrument = this.instruments.GetById(id);
			if (instrument == null)
			{
				instrument = new Instrument(id, InstrumentType.Synthetic, Guid.NewGuid().ToString(), "", 1);
				this.instruments.Add(instrument);
			}
			return instrument;
		}
		public Instrument Get(string symbol)
		{
			return this.instruments.Get(symbol);
		}
		public bool Contains(string symbol)
		{
			return this.instruments.Contains(symbol);
		}
		public void Add(Instrument instrument, bool save = true)
		{
			if (this.Contains(instrument.symbol))
			{
				throw new ApplicationException("Instrument with the same symbol is already present in the framework : " + instrument.symbol);
			}
			instrument.Id = this.next_id;
			this.next_id++;
			this.instruments.Add(instrument);
			if (save && this.server != null)
			{
				this.server.Save(instrument);
			}
			this.framework.eventServer.OnInstrumentAdded(instrument);
		}
		public void Delete(Instrument instrument)
		{
			this.instruments.Remove(instrument);
			if (this.server != null && instrument.isPersistent)
			{
				this.server.Delete(instrument);
			}
			this.framework.eventServer.OnInstrumentDeleted(instrument);
		}
		public void Delete(string symbol)
		{
			Instrument instrument = this.Get(symbol);
			if (instrument != null)
			{
				this.Delete(instrument);
			}
		}
		public void Clear()
		{
			foreach (Instrument current in this.instruments)
			{
				current.bid = null;
				current.ask = null;
				current.trade = null;
			}
			InstrumentList instrumentList = new InstrumentList();
			foreach (Instrument current2 in this.instruments)
			{
				if (!current2.isPersistent)
				{
					instrumentList.Add(current2);
				}
			}
			foreach (Instrument current3 in instrumentList)
			{
				this.Delete(current3);
			}
		}
		public void Save(Instrument instrument)
		{
			if (this.server != null)
			{
				instrument.isPersistent = true;
				this.server.Save(instrument);
			}
		}
		public void Dump()
		{
			Console.WriteLine("Instrument manager contains " + this.instruments.Count + " intruments:");
			foreach (Instrument current in this.instruments)
			{
				Console.WriteLine(current);
			}
		}
	}
}
