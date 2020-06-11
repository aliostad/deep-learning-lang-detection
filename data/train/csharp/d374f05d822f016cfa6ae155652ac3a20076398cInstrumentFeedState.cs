using System.Threading;
using FeedEngine.Contracts;

namespace FeedEngine.Gateway
{
    internal class InstrumentFeedState
    {

        public string Instrument { get; private set; }
        public Quote LastQuote { get; set; }
        public Quote LastValidQuote { get; set; }

        private long _version = long.MinValue;
        public long Version { get { return _version; } }

        public InstrumentFeedState(string instrument)
        {
            Instrument = instrument;
        }

        public long NextVersion()
        {
            return Interlocked.Increment(ref _version);
        }
    }
}