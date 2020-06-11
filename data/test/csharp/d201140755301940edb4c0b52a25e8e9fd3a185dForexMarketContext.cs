using System;

namespace TradeAppSample.ForexTrading
{
    public class ForexMarketContext
    {
        public ForexMarketContext(Instruments instrument) : this(instrument, MarketState.Unknown)
        {
        }

        public ForexMarketContext(Instruments instrument, MarketState state) : this(instrument, state, DateTime.UtcNow)
        {
        }

        public ForexMarketContext(Instruments instrument, MarketState state, DateTime currentTime)
        {
            Instrument = instrument;
            State = state;
            CurrentTime = currentTime;
        }

        public Instruments Instrument { get; }
        public MarketState State { get; }
        public DateTime CurrentTime { get; }
        public Tick LatestTick { get; internal set; }
    }
}