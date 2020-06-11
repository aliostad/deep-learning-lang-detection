using System;
using System.Collections.Generic;
using B4F.TotalGiro.Instruments;
using B4F.TotalGiro.Communicator.ExternalInterfaces;

namespace B4F.TotalGiro.Communicator
{
	public class InstrumentSymbol : Symbol, IInstrumentSymbol
	{
		protected InstrumentSymbol() {	}

        public InstrumentSymbol(IExternalInterface externalInterface, string externalSymbol, IInstrument instrument)
            : base(externalInterface, externalSymbol)
		{
			this.Instrument = instrument;
		}

        public IInstrument Instrument { get; set; }


	}
}
