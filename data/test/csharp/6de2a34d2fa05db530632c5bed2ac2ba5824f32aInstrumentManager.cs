using System;
using System.Linq;

namespace FastQuant
{
    public class InstrumentManager
    {
        private Framework framework;
        private int counter;

        private InstrumentList deletedInstruments = new InstrumentList();

        public InstrumentServer Server { get; set; }
        public InstrumentList Instruments { get; } = new InstrumentList();

        public InstrumentManager(Framework framework, InstrumentServer server)
        {
            this.framework = framework;
            Server = server;
        }

        public void Add(Instrument instrument, bool save = true)
        {
            if (Contains(instrument.Symbol))
                throw new ArgumentException($"Instrument with the same symbol is already present in the framework : {instrument.Symbol}");

            var i = this.deletedInstruments.Get(instrument.Symbol);
            if (i != null)
            {
                Console.WriteLine($"InstrumentManager::Add Using deleted instrument id = {i.Id} for symbol {instrument.Symbol}");
                instrument.Id = i.Id;
                this.deletedInstruments.Remove(i);
            }
            else
            {
                instrument.Id = this.counter++;
            }
            Instruments.Add(instrument);
            if (instrument.Framework == null)
                instrument.Init(this.framework);

            if (save)
            {
                instrument.Loaded = true;
                Save(instrument);
            }
            this.framework.EventServer.OnInstrumentAdded(instrument);
        }

        public void Delete(Instrument instrument)
        {
            Instruments.Remove(instrument);
            instrument.DeleteCached = true;
            this.deletedInstruments.Add(instrument);
            Save(instrument);
            this.framework.EventServer.OnInstrumentDeleted(instrument);
        }

        public void Delete(string symbol)
        {
            var i = Get(symbol);
            if (i != null)
                Delete(i);
        }

        public void Delete(int id)
        {
            var i = GetById(id);
            if (i != null)
                Delete(i);
        }

        public void Clear()
        {
            foreach (var i in Instruments)
            {
                i.Bid = null;
                i.Ask = null;
                i.Trade = null;
                i.Bar = null;
            }
            var deleted = new InstrumentList();
            foreach (var i in Instruments.Where(i => !i.Loaded))
                deleted.Add(i);
            foreach (var i in deleted)
                Delete(i);
        }

        public void Dump()
        {
            Console.WriteLine($"Instrument manager contains {Instruments.Count} intruments:");
            foreach (var i in Instruments)
                Console.WriteLine(i);
        }

        public Instrument GetById(int id)
        {
            var i = Instruments.GetById(id);
            if (i == null)
            {
                i = new Instrument(id, InstrumentType.Synthetic, Guid.NewGuid().ToString(), "", CurrencyId.USD);
                Instruments.Add(i);
            }
            return i;
        }

        public void Load()
        {
            Server.Open();
            this.counter = -1;
            var instrumentList = Server.Load();
            foreach (var i in instrumentList)
            {
                i.Init(this.framework);
                i.Loaded = true;
                if (i.DeleteCached)
                    this.deletedInstruments.Add(i);
                else
                    Instruments.Add(i);
                this.counter = Math.Max(this.counter, i.Id);
            }
            this.counter++;
        }

        public void Save(Instrument instrument)
        {
            if (instrument.Loaded)
                 Server?.Save(instrument);
        }

        public Instrument Get(string symbol) => Instruments.Get(symbol);

        public bool Contains(string symbol) => Instruments.Contains(symbol);

        public Instrument this[string symbol] => Instruments.Get(symbol);
    }
}