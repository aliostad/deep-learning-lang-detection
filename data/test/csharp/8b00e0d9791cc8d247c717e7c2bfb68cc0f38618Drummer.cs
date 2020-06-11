using System;
using System.Collections.Generic;
namespace Ochestra
{
	public class Drummer : InstrumentPlayer, TimeKeeper
	{
		private List<InstrumentPlayer> subsribers;

		public Drummer(Instrument toHold)
		{
			Hold(toHold);
		}

		public List<InstrumentPlayer> Subscibers
		{
			get{ return subsribers;}
			set{ subsribers = value;}
		}

		public void Subscribe(InstrumentPlayer player)
		{
			Subscibers.Add(player);
		}

		public void Syncronize()
		{
			Beat();
		}

		private String Beat() {
			String output = Play();
			foreach (InstrumentPlayer player in subsribers){
				output+= "\n" + player.Play();
			}
			return output;
		}

		public override String Play() {
			return Instrument.Play(Note.A);
		}
	}
}

