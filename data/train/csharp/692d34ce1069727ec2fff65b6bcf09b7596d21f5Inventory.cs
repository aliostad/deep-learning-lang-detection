using OOADExercise.Exercise_2_4___RicksGuitarInventory;
using System.Collections.Generic;
using System.Linq;

namespace OOADExercise.Exercise_2
{
    public class Inventory
    {
        // Have a generic list of objects
        private List<object> inventory;
        
        public Inventory()
        {
            // Instantiation
            inventory = new List<object>();
        }

        // addGuitar() takes in all properties required to create a new Guitar instance, creates one, and adds it to the inventory
        public void addInstrument(string serialNumber, double price, InstrumentSpec spec)
        {
            Instrument instrument = new Instrument(serialNumber, price, spec);
            inventory.Add(instrument);
        }

        public Instrument getInstrument(string serialNumber)
        {
            foreach (Instrument instrument in inventory)
            {
                if (instrument.getSerialNumber().Equals(serialNumber))
                    return instrument;
            }
            return null;
        }

        // The search method compares each property of the Guitar object it's passed in to each Guitar object in Rick's inventory
        // Returns a list of guitars that match the customers specifications of the instrument.
        public List<Instrument> search(InstrumentSpec searchSpec)
        {
            // Delegate responsibility to compare the specifications of instruments
            List<Instrument> matchingInstruments = new List<Instrument>();
            foreach (Instrument instrument in inventory)
            {
                if (instrument.getSpec().matches(searchSpec))
                    matchingInstruments.Add(instrument);
            }
            return matchingInstruments;
        }
    }
}
