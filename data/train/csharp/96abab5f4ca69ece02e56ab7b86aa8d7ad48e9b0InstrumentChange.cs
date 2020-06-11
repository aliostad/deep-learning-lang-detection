using System;
using System.Collections.Generic;
using System.Text;
using Sanford.Multimedia.Midi;

namespace Music_Test.TrackEvents
{
	public class InstrumentChange : TrackEvent
	{
		public int Step { get; private set; }
		public int Channel { get; private set; }
		public int Instrument { get; private set; }

		public InstrumentChange(int step, int channel, int instrument)
		{
			this.Step = step;
			this.Channel = channel;
			this.Instrument = instrument;
		}

		public void BuildMessages(MessageQueue queue)
		{
			queue.AddMessage(new TrackMessage(Step, new ChannelMessage(ChannelCommand.ProgramChange, Channel, Instrument)));
		}
	}
}
