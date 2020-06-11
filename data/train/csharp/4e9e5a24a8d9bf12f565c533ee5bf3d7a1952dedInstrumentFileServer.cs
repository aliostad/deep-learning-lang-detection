using System;

namespace FreeQuant.Instruments
{
    class InstrumentFileServer : IInstrumentServer
    {
        public InstrumentFileServer()
        {
        }

        public void Open(Type connectionType, string connectionString)
        {
        }

        public InstrumentList Load()
        {
            return new InstrumentList();
        }

        public void Save(Instrument instrument)
        {
        }

        public void Remove(Instrument instrument)
        {
        }

        public void Close()
        {
        }
    }
}

