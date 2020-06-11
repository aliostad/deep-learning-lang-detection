using OpenQuant.API;
using FreeQuant.FIX;
using FreeQuant.Instruments;

namespace OpenQuant.Shared.Instruments
{
	class InstrumentTypeGroupNode : GroupNode
	{
		private InstrumentType instrumentType;

		public InstrumentTypeGroupNode(InstrumentType instrumentType)
		{
			this.instrumentType = instrumentType;
			this.SetText(instrumentType.ToString());
		}

		// base use FreeQuant.Instruments.Instrument
		public override bool IsInstrumentValid(FreeQuant.Instruments.Instrument instrument)
		{
			return OpenQuant.Shared.APITypeConverter.InstrumentType.Convert(instrument.SecurityType) == this.instrumentType;
//			return OpenQuant.Instruments[instrument.Symbol].Type == this.instrumentType;
		}
	}
}
