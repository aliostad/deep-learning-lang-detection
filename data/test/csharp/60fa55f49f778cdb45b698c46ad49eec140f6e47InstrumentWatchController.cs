using System;
using System.Collections.Generic;
using System.Reactive.Disposables;
using System.Reactive.Linq;
using System.Threading;
using IW.Model;

namespace IW.Controller
{
    public class InstrumentWatchController
    {
        public IObservable<InstrumentMarketData> InstrumentMarketDataObservable
        {
            get
            {
                return Observable.Create<InstrumentMarketData>(o =>
                {
                    Observable.Range(0, 100).Subscribe(r => o.OnNext(GetInstrumentMarketData()));

                    return Disposable.Empty;
                });
            }
        }

        public IObservable<InstrumentMarketData> GetInstrumentMarketDataObservable(IEnumerable<string> instrumentIds)
        {
            return Observable.Create<InstrumentMarketData>(o =>
            {
                foreach (var instrumentId in instrumentIds)
                {
                    o.OnNext(GetInstrumentMarketData(instrumentId));
                }
                //o.OnError(new Exception("aaaaaaaaaaaaaaaa"));
                o.OnCompleted();

                return Disposable.Empty;
            });
        }

        private static InstrumentMarketData GetInstrumentMarketData(string instrumentId)
        {
            Thread.Sleep(TimeSpan.FromMilliseconds(200));

            return new InstrumentMarketData(instrumentId);
        }

        private static InstrumentMarketData GetInstrumentMarketData()
        {
            Thread.Sleep(TimeSpan.FromMilliseconds(200));

            return InstrumentMarketData.New;
        }
    }
}
