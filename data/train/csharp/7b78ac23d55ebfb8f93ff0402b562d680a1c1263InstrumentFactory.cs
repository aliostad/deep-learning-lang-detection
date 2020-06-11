using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GuitarAndBass
{
    class InstrumentFactory
    {
        public StrumInstrument makeInstrument(string newInstrumentType)
        {
            if (newInstrumentType.Equals("g", StringComparison.InvariantCultureIgnoreCase))
            {
                return new Guitar();
            }
            else if(newInstrumentType.Equals("b", StringComparison.InvariantCultureIgnoreCase))
            {
                return new Bass();
            }
            else
            {
                return null;
            }
        }
    }
}
