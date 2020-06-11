using System;
namespace Ochestra
{
	public abstract class InstrumentPlayer
	{
		private Instrument instrument;
		private StaffSheet staff;
		private Conductor conductor;

		public Instrument Instrument
		{
			get{ return instrument; }
			set{ instrument = value; }
		}

		public StaffSheet Staff
		{
			get{ return staff; }
			set{ staff = value; }
		}

		public Conductor Conductor
		{
			get { return conductor; }
			set { conductor = value; }
		}

		public void Hold(Instrument toHold)
		{
			Instrument = toHold;
		}

		public abstract String Play();

		public void ListenTo(Conductor cond)
		{
			Conductor = cond;
		}

		public void Read(StaffSheet ss) {
			Staff = ss;
		}
	}
}

