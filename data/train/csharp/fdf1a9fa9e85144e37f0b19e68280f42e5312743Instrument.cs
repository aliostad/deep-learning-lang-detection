using System;
using System.Diagnostics.CodeAnalysis;

namespace CreditSuisse.TimeSerie.DataTransferObjects
{
    [SuppressMessage("ReSharper", "NonReadonlyMemberInGetHashCode")]
    public class Instrument
    {
        public Instrument()
        {
        }

        private Instrument(Instrument src)
        {
            if (src == null)
                throw new ArgumentNullException(nameof(src));

            InstrumentId = src.InstrumentId;
            Name = src.Name;
        }

        public long InstrumentId { get; set; }

        public string Name { get; set; }

        public override bool Equals(object obj)
        {
            var p = obj as Instrument;
            if (p == null)
                return false;

            return InstrumentId == p.InstrumentId
                   && Name == p.Name;
        }

        public override int GetHashCode()
        {
            return
                InstrumentId.GetHashCode() ^
                (Name ?? string.Empty).GetHashCode();
        }

        public Instrument Clone()
        {
            return new Instrument(this);
        }
    }
}