using System.Collections;
using UnityEngine;
using MusicVR.Scales;

namespace MusicVR.Composition
{	
	/// <summary>
	/// Command to change scale (major, minor, pentatonic) of instrument
	/// </summary>
	public class ToggleScaleCommand : UndoableCommand
	{
		private InstrumentData m_instrument;
		public ToggleScaleCommand(InstrumentData instrument)
		{
			m_instrument = instrument;
		}

		public override void Execute()
		{
			if (!m_instrument.InstrumentDefinition.IsDrum)
			{
				var scaleNames = System.Enum.GetNames(typeof(E_Scales));
				int newScale = MathHelper.Mod((int)m_instrument.Scale + 1, scaleNames.Length);
				m_instrument.Scale = (E_ConverterType)newScale;
			}
		}

		public override void Undo()
		{
			if (!m_instrument.InstrumentDefinition.IsDrum)
			{
				var scaleNames = System.Enum.GetNames(typeof(E_Scales));
				int newScale = MathHelper.Mod(((int)m_instrument.Scale + -1), scaleNames.Length);
				m_instrument.Scale = (E_ConverterType)newScale;
			}
		}
	}
}