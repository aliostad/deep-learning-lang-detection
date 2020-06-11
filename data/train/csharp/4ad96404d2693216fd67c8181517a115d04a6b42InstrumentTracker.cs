using System.Collections.Generic;
using System.Linq;
using NWiretap.Instruments;

namespace NWiretap
{
    internal static class InstrumentTracker
    {
        public static IList<TrackedInstrument> Instruments = new List<TrackedInstrument>();
        public static object SyncRoot = new object();

        public static void TrackInstrument(IInstrument instrument)
        {
            lock(SyncRoot)
            {
                Instruments.Add(new TrackedInstrument(instrument));
            }
            
        }

        public static void RemoveInstrument(IInstrument instrument)
        {
            lock(SyncRoot)
            {
                var trackedInstrument = Instruments.Single(a => a.Instrument == instrument);
                Instruments.Remove(trackedInstrument);
            }
        }
    }

    internal class TrackedInstrument
    {
        private static int _instrumentId;

        public IInstrument Instrument { get; private set; }
        public int InstrumentID { get; private set; }

        public TrackedInstrument(IInstrument instrument)
        {
            Instrument = instrument;
            InstrumentID = _instrumentId++;
        }
    }
}
