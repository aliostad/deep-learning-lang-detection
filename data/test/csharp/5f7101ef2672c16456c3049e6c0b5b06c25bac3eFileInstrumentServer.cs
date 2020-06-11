using System.IO;

namespace FastQuant
{
    public class FileInstrumentServer : InstrumentServer
    {
        private bool opened;
        private DataFile dataFile;

        public FileInstrumentServer(Framework framework, string fileName, string host = null, int port = -1): base(framework)
        {
            this.dataFile = new DataFile(fileName, framework.StreamerManager);
        }

        public override void Close()
        {
            if (this.opened)
            {
                this.dataFile.Close();
                this.opened = false;
            }
        }

        public override void Delete(Instrument instrument) => this.dataFile.Delete(instrument.Symbol);

        public override void Flush() => this.dataFile.Flush();

        public override InstrumentList Load()
        {
            this.instruments.Clear();
            foreach (var key in this.dataFile.Keys.Values)
            {
                if (key.TypeId == ObjectType.Instrument)
                {
                    var instrument = (Instrument)this.dataFile.Get(key.Name);
                    this.instruments.Add(instrument);
                }
            }
            return this.instruments;
        }

        public override void Open()
        {
            if (!this.opened)
            {
                this.dataFile.Open(FileMode.OpenOrCreate);
                this.opened = true;
            }
        }

        public override void Save(Instrument instrument) => this.dataFile.Write(instrument.Symbol, instrument);
    }
}