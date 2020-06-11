using System.Collections.Generic;
using ITGlobal.DeadlockDetection;
using Polygon.Diagnostics;
using Polygon.Connector;
using Polygon.Messages;

namespace Polygon.Connector.InteractiveBrokers
{
    /// <summary>
    ///     Потокобезопасный контейнер номеров тикеров, связанных с тем или иным инструментом
    /// </summary>
    internal class TickerContainer
    {
        protected readonly ILockObject syncRoot = DeadlockMonitor.Cookie<TickerContainer>();
        private readonly Dictionary<int, Instrument> instrumentByTicker = new Dictionary<int, Instrument>();
        private readonly Dictionary<Instrument, int> tickerByInstrument = new Dictionary<Instrument, int>();

        public void Store(int tickerId, Instrument instrument)
        {
            using (syncRoot.Lock())
            {
                instrumentByTicker[tickerId] = instrument;
                tickerByInstrument[instrument] = tickerId;
            }
        }

        public bool TryGetTickerId(Instrument instrument, out int tickerId)
        {
            using (syncRoot.Lock())
            {
                return tickerByInstrument.TryGetValue(instrument, out tickerId);
            }
        }

        public bool TryGetInstrument(int tickerId, out Instrument instrument)
        {
            using (syncRoot.Lock())
            {
                return instrumentByTicker.TryGetValue(tickerId, out instrument);
            }
        }

        public virtual void RemoveTickerId(int tickerId)
        {
            using (syncRoot.Lock())
            {
                Instrument instrument;
                if (instrumentByTicker.TryGetValue(tickerId, out instrument))
                {
                    tickerByInstrument.Remove(instrument);
                }

                instrumentByTicker.Remove(tickerId);
            }
        }
    }

    /// <summary>
    ///     Контейнер PendingTestResult для тиков
    /// </summary>
    internal sealed class PendingResultTickerContainer : TickerContainer
    {
        private readonly Dictionary<int, PendingTestResult> testResultByTicker = new Dictionary<int, PendingTestResult>();

        public bool TryGetInstrumentAndPendingTestResult(int tickerId, out Instrument instrument, out PendingTestResult pendingTestResult)
        {
            using (syncRoot.Lock())
            {
                if (TryGetInstrument(tickerId, out instrument))
                {
                    if (testResultByTicker.TryGetValue(tickerId, out pendingTestResult))
                    {
                        testResultByTicker.Remove(tickerId);
                    }
                    return true;
                }

                pendingTestResult = null;
                return false;
            }
        }

        public void Store(int tickerId, Instrument instrument, PendingTestResult pendingTestResult)
        {
            using (syncRoot.Lock())
            {
                Store(tickerId, instrument);

                testResultByTicker[tickerId] = pendingTestResult;
            }
        }

        public override void RemoveTickerId(int tickerId)
        {
            using (syncRoot.Lock())
            {
                base.RemoveTickerId(tickerId);

                if (testResultByTicker.ContainsKey(tickerId))
                {
                    testResultByTicker.Remove(tickerId);
                }
            }
        }

    }


}

