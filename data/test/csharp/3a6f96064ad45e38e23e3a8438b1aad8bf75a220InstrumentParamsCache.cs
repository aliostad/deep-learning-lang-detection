using System.Collections.Generic;
using ITGlobal.DeadlockDetection;
using Polygon.Diagnostics;
using Polygon.Connector;
using Polygon.Messages;

namespace Polygon.Connector.InteractiveBrokers
{
    internal sealed class InstrumentParamsCache
    {
        private readonly ILockObject syncRoot = DeadlockMonitor.Cookie<InstrumentParamsCache>();
        private readonly Dictionary<Instrument, InstrumentParams> cachedInstrumentParams = new Dictionary<Instrument, InstrumentParams>();

        public InstrumentParams GetInstrumentParams(Instrument instrument)
        {
            using (syncRoot.Lock())
            {
                InstrumentParams instrumentParams;
                if (!cachedInstrumentParams.TryGetValue(instrument, out instrumentParams))
                {
                    instrumentParams = new InstrumentParams { Instrument = instrument };
                    cachedInstrumentParams.Add(instrument, instrumentParams);
                }

                return instrumentParams;
            }
        }
    }
}

