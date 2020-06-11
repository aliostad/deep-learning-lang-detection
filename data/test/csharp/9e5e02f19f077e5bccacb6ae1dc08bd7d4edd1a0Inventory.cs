using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InstrumentStore
{
    class Inventory
    {
        private readonly List<Instrument> _inventory;

        public Inventory(List<Instrument> inventory)
        {
            this._inventory = inventory;
        }

        public Inventory()
        {
            _inventory=new List<Instrument>();
        }

        public List<Instrument> GetInventory()
        {
            return _inventory;
        }

        public void AddInstrument(string serialNumber, double price, InstrumentSpec spec)
        {
            var instrument = new Instrument(serialNumber, price, spec);
            _inventory.Add(instrument);
        }

        public Instrument Get(string serialNumber)
        {
            return _inventory.SingleOrDefault(instrument => instrument.SerialNumber == serialNumber);
//            foreach (var instrument in _inventory)
//            {
//                if (instrument.SerialNumber.Equals(serialNumber)) return instrument;
//            }
//            return null;
        }

        public List<Instrument> SearchInstruments(InstrumentSpec searchSpec)
        {
            var matchingInstruments = new List<Instrument>();
            foreach (var instrument in _inventory)
            {
                if(instrument.Spec.Matches(searchSpec)) matchingInstruments.Add(instrument);
            }

            return matchingInstruments;
        }
    }
}
