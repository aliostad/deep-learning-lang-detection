using NinjaTrader_Client.Trader.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NinjaTrader_Client.Trader.TradingAPIs
{
    public abstract class ITradingAPI
    {
        public abstract bool openLong(string instrument);
        public abstract bool openShort(string instrument);

        public abstract bool closePositions(string instrument);

        public abstract bool closeShort(string instrument);
        public abstract bool closeLong(string instrument);

        public abstract double getBid(string instrument);
        public abstract double getAsk(string instrument);

        public double getAvgPrice(string instrument)
        {
            return (getBid(instrument) + getAsk(instrument)) / 2d;
        }

        public abstract long getNow();
        public abstract TradePosition getLongPosition(string instrument);
        public abstract TradePosition getShortPosition(string instrument);
        public abstract List<TradePosition> getHistory(string instrument);

        public abstract bool isUptodate(string instrument);
    }
}
