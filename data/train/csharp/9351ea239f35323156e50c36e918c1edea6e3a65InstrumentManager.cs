using System;
using System.Collections.Generic;
using System.Linq;
using Midi;
using Orphee.CreationShared.Interfaces;

namespace Orphee.CreationShared
{
    /// <summary>
    /// Class managing the instruments
    /// </summary>
    public class InstrumentManager : IInstrumentManager
    {
        /// <summary>List of all the instrument available </summary>
        public Instrument CurrentInstrument { get; set; }
        /// <summary>Current instrument </summary>
        public List<MyInstrument> InstrumentList { get; private set; }

        /// <summary>
        /// Constructor
        /// </summary>
        public InstrumentManager()
        {
            this.InstrumentList = new List<MyInstrument>();
            var instrumentTmpList = Enum.GetValues(typeof(Instrument)).Cast<Instrument>().ToList();
            foreach (var instrument in instrumentTmpList)
                this.InstrumentList.Add(new MyInstrument() { InstrumentName = instrument.Name(), Instrument = instrument});
        }

        public int GetInstrumentIndex(Instrument instrument)
        {
            for (var index = 0; index < this.InstrumentList.Count; index++)
            {
                if (this.InstrumentList[index].Instrument == instrument)
                    return index;
            }
            return 0;
        }
    }
}
