using System.Collections.Generic;

namespace RicksApp
{
    class Inventory
    {
        readonly List<Instrument> _inventory;

        public Inventory()
        {
            _inventory = new List<Instrument>();

        }

        public void AddInstrument(Instrument instrument)
        {
            _inventory.Add(instrument);
        }

        public Instrument GetInstrument(string serialNumber)
        {
            foreach (var instrument in _inventory)
            {
                if (instrument.SerialNumber == serialNumber)
                {
                    return instrument;
                }
            }
            return null;
        }

        public List<Instrument> SearchInstrument(InstrumentSpec searchedSpec)
        {
            var matchingInstrument = new List<Instrument>();
            foreach (var instrument in _inventory)
            {
                if(instrument.Spec.CompareSpecWith(searchedSpec))
                matchingInstrument.Add(instrument);
            }
            return matchingInstrument;
        }
    }
}
