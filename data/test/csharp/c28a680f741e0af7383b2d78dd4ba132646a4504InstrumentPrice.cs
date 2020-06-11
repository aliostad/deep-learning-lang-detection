using System;

namespace Instrument
{
    public class InstrumentPrice : IEquatable<InstrumentPrice>
    {
        public bool Equals(InstrumentPrice other)
        {
            if (ReferenceEquals(null, other)) return false;
            if (ReferenceEquals(this, other)) return true;
            return string.Equals(Instrument, other.Instrument) && Price == other.Price;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != GetType()) return false;
            return Equals((InstrumentPrice) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return ((Instrument != null ? Instrument.GetHashCode() : 0)*397) ^ Price.GetHashCode();
            }
        }

        public InstrumentPrice(string instrument, decimal price)
        {
            Instrument = instrument;
            Price = price;
        }

        public string Instrument { get; private set; }
        public decimal Price { get; private set; }

        public override string ToString()
        {
            return new {Instrument, Price}.ToString();
        }
    }
}
