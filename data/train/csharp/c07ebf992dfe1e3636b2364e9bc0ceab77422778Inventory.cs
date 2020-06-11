using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GuitarApp
{
    class Inventory
    {
        private List<Instrument> instruments;

        public Inventory()
        {
            instruments = new List<Instrument>();
        }

        public void AddInstrument(string serialNumber, double price, InstrumentSpec spec) 
        {
            instruments.Add(new Instrument(serialNumber, price, spec));

        }

        public Instrument GetInstrument(string serialNumber)
        {
            foreach (var instrument in instruments)
            {
                if (instrument.SerialNumber.Equals(serialNumber))
                    return instrument;
            }
            return null;
        }

        public List<Instrument> Search (InstrumentSpec searchSpec)
        {
            List<Instrument> matchingInstruments = new List<Instrument>();

            foreach (var instrument in instruments)
            {
                if (instrument.Spec.Matches(searchSpec))
                    matchingInstruments.Add(instrument);
            }
            return matchingInstruments;
        }
    }
}
