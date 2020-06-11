using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FlyweightTräning
{
    class InstrumentFlyweightFactory
    {
        Dictionary<InstrumentType?, IInstrument> instruments = new Dictionary<InstrumentType?, IInstrument>();
        public IInstrument GetInstrument(InstrumentType type)
        {
            IInstrument instrument = null;
            bool found = instruments.TryGetValue(type, out instrument);
            if (!found)
            {
                if (type == InstrumentType.Violin)
                {
                    instrument = new Violin();
                    instruments.Add(type, instrument);
                }
                else if(type == InstrumentType.Trumpet)
                {
                    instrument = new Trumpet();
                    instruments.Add(type, instrument);
                }
                else
                {
                    instrument = new Drum();
                    instruments.Add(type, instrument);
                }                
            }
            return instrument;
        }
    }
}
