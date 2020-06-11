using NinjaTrader.Cbi;
using NinjaTrader.Strategy;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    class Portfolio
    {
        private readonly Dictionary<Instrument, TradingPosition> positionPerInstrument = new Dictionary<Instrument, TradingPosition>();

        public IEnumerable<TradingPosition> Positions
        {
            get
            {
                return positionPerInstrument.Values;
            }
        }

        public void RemovePosition(TradingPosition position)
        {
            positionPerInstrument.Remove(position.Instrument);
        }

        public void AddPosition(TradingPosition position)
        {
            positionPerInstrument.Add(position.Instrument, position);
        }

        internal TradingPosition GetPosition(Instrument instrument)
        {
            return positionPerInstrument[instrument];
        }

        internal bool TryGetPosition(Instrument instrument, out TradingPosition position)
        {
            return positionPerInstrument.TryGetValue(instrument, out position);
        }

        public Portfolio Clone(Strategy strategy)
        {
            Portfolio result = new Portfolio();
            foreach (TradingPosition position in positionPerInstrument.Values)
            {
                result.positionPerInstrument.Add(position.Instrument, position);
            }
            return result;
        }

        internal void UpdateWithFactualData(IEnumerable<Position> actualPositions)
        {
            foreach (Position actualPosition in actualPositions)
            {
                TradingPosition position;
                if (positionPerInstrument.TryGetValue(actualPosition.Instrument, out position))
                {
                    position.AssignFrom(actualPosition);
                }
            }
        }
    }
}
