using System.Collections.Generic;

namespace Generics
{
    class InstrumentCollection :
        SortedDictionary<string, HashSet<Instrument>>
    {
        public InstrumentCollection Add(string instrumentType,Instrument instrument)
        {
            if(!ContainsKey(instrumentType))
            {
                Add(instrumentType, new HashSet<Instrument>(new InstrumentComparer()));
            }
            this[instrumentType].Add(instrument);
            return this;
        }
        
    }

    class InstrumentCollectionSorted :
        SortedDictionary<string, SortedSet<Instrument>>
    {
        public InstrumentCollectionSorted Add(string instrumentType, Instrument instrument)
        {
            if (!ContainsKey(instrumentType))
            {
                Add(instrumentType, new SortedSet<Instrument>(new InstrumentComparer()));
            }
            this[instrumentType].Add(instrument);
            return this;
        }

    }


}
