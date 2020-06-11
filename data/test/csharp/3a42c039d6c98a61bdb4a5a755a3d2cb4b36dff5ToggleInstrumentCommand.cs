using System.Collections;
using UnityEngine;
using MusicVR.Instruments;

namespace MusicVR.Composition
{	
	/// <summary>
	/// Command to change chosen instrument type (eg, marimba, drums)
	/// </summary>
	public class ToggleInstrumentCommand : UndoableCommand
	{
		private InstrumentData m_instrument;
		public ToggleInstrumentCommand(InstrumentData instrument)
		{
			m_instrument = instrument;
		}

		public override void Execute()
		{
			var instruments = InstrumentDefinitions.Instance.Instruments;
			var currInstrument = instruments.FindIndex((i) => i == m_instrument.InstrumentDefinition);
			int newInstrument = MathHelper.Mod(((int)currInstrument + 1), instruments.Count);
			m_instrument.InstrumentDefinition = InstrumentDefinitions.Instance.Instruments[newInstrument];
		}

		public override void Undo()
		{
			var instruments = InstrumentDefinitions.Instance.Instruments;
			var currInstrument = instruments.FindIndex((i) => i == m_instrument.InstrumentDefinition);
			int newInstrument = MathHelper.Mod(((int)currInstrument - 1), instruments.Count);
			m_instrument.InstrumentDefinition = InstrumentDefinitions.Instance.Instruments[newInstrument];
		}
	}
}