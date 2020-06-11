using System.Collections.Generic;
using NewWave.Midi;

namespace NewWave.Core
{
	public class InstrumentTrack
	{
		/// <summary>
		/// MIDI voice.
		/// </summary>
		public readonly Instrument Instrument;

		/// <summary>
		/// Panning. 0 = left, 64 = center, 127 = right.
		/// </summary>
		public readonly Pan Pan;

		/// <summary>
		/// The collection of notes played by this instrument.
		/// The outer lists are per-measure; the inner lists
		/// are per-tick.
		/// </summary>
		public readonly List<List<Note>> Notes;

		public InstrumentTrack(Instrument instrument, Pan pan, List<List<Note>> notes)
		{
			Instrument = instrument;
			Pan = pan;
			Notes = notes;
		}
	}
}
