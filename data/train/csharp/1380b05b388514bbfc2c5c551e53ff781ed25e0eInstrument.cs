using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XMLSorting
{
    public enum InstrumentType
    {
        brass, drum, stringed, keyboard
    }

    public class Instrument
    {
        public String Name { get; set; }
        public InstrumentType Type { get; set; }
        public override string ToString()
        {
            return "instrument";
        }

        public override bool Equals(object obj)
        {
            var instrument = obj as Instrument;
            if (instrument != null)
            {
                return this.Name == instrument.Name && this.Type == instrument.Type;
            }
            else
            {
                throw new InvalidCastException("Compare with other musician!");
            }
        }
    }
}
