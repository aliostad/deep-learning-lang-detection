using System;
using System.Collections.Generic;

namespace InstrumentAppV2
{
	public class Inventory
	{
		private List<Instrument> inventory = null;

		public Inventory() {
			inventory = new List<Instrument>();
		}

		public void addInstrument(String serialNumber, double price,
			InstrumentSpec spec) {
			Instrument instrument = new Instrument(serialNumber, price, spec);
			inventory.Add(instrument);
		}

		public Instrument getInstrument(String serialNumber) {
			foreach (Instrument instrument in inventory) {
				if (instrument.SerialNumber.Equals (serialNumber))
					return instrument;
			}
			return null;
		}

		public List<Instrument> search(InstrumentSpec searchSpec) {

			List<Instrument> matchingInstruments = new List<Instrument>();

			foreach (Instrument instrument in inventory) {
				if(instrument.Spec.matches(searchSpec)){
					matchingInstruments.Add(instrument);
				}
			}
			return matchingInstruments;
		}
	}
}

