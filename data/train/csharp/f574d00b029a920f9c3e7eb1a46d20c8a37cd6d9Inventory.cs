using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GuitarApp1
{
	public enum Type
	{
		ACOUSITC,
		ELECTRIC
	}

	public enum Builder
	{
		FENDER,
		MARTIN,
		GIBSON,
		COLLINGS,
		OLSON,
		RYAN,
		PRS,
		ANY
	}

	public enum Wood
	{
		INDIAN_ROSEWOOD,
		BRAZILIAN_ROSEWOOD,
		MAHOGANY,
		MAPLE,
		COCOBOLO,
		CEDAR,
		ADIRONDACK,
		ALDER,
		SITKA
	}

	public enum InstrumentType
	{
		GUITAR, 
		BANJO, MANDOLIN, 
		DOBRO,
		FIDDLE,
		BASS
	}

	public class Inventory
	{
		private List<Instrument> instruments;

		public Inventory()
		{
			instruments = new List<Instrument>();
		}

		public void addInstrument(string serialNumber, double price, InstrumentSpec spec)
		{
			Instrument instrument = new Instrument(serialNumber, price, spec);
			instruments.Add(instrument);
		}

		public Instrument getInstrument(string serialNumber)
		{
			foreach (Instrument g in this.instruments)
			{
				if (g.getSerialNumber() == serialNumber)
				{
					return g;
				}
			}

			return null;
		}

		public List<Instrument> search(InstrumentSpec searchSpec)
		{
			List<Instrument> toRet = new List<Instrument>();

			foreach (Instrument instrument in this.instruments)
			{
				if (searchSpec.Equals(instrument.getSpec()))
				{
					toRet.Add(instrument);
				}
			}
			return toRet;
		}

		public List<Guitar> search(GuitarSpec searchGuitar)
		{
			List<Guitar> matches = new List<Guitar>();
			foreach (Instrument guitar in this.instruments)
			{
				InstrumentSpec spec = guitar.getSpec();
				if (searchGuitar.Equals(spec))
					matches.Add((Guitar)guitar);
			}
			return matches;
		}

		public List<Mandolin> search(MandolinSpec searchGuitar)
		{
			List<Mandolin> matches = new List<Mandolin>();
			foreach (Instrument mandolin in this.instruments)
			{
				InstrumentSpec spec = mandolin.getSpec();
				if (searchGuitar.Equals(spec))
					matches.Add((Mandolin)mandolin);
			}
			return matches;
		}

		public bool compareStrings(string one, string two)
		{
			if (one != null && one != "" && one == two)
			{
				return true;
			}
			return false;
		}
	}
}
