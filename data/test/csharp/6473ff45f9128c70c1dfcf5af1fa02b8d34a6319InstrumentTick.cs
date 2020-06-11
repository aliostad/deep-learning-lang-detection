using System;
using RestSharp.Deserializers;

namespace Next.Dtos
{
    public abstract class InstrumentTick : EventArgs, ITick
    {
        protected InstrumentTick()
        {
            Instrument= new InstrumentDescriptor(int.MinValue, null);
        }
        public InstrumentDescriptor Instrument { get; set; }
        public string I { get { return Instrument.Identifier; } set { Instrument.Identifier = value; } }
        public int M { get { return Instrument.MarketId; } set { Instrument.MarketId = value; } }
        public string T { get; set; }
    }
}