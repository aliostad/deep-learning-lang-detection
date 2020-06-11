using System;
namespace SmartQuant
{
	public class Leg
	{
		protected internal int instrumentId;
		protected internal Instrument instrument;
		protected internal double weight;
		public Instrument Instrument
		{
			get
			{
				return this.instrument;
			}
		}
		public double Weight
		{
			get
			{
				return this.weight;
			}
			set
			{
				this.weight = value;
			}
		}
		internal Leg()
		{
		}
		public Leg(Instrument instrument)
		{
			this.instrument = instrument;
			this.weight = 0.0;
		}
		public Leg(Instrument instrument, double weight)
		{
			this.instrument = instrument;
			this.weight = weight;
		}
	}
}
