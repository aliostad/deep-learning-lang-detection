using System;
using System.Collections.Generic;
using System.Reactive.Concurrency;
using System.Reactive.Linq;
using Instrument;
using Instrument.Services;
using Xbehave;
using Xunit;
using Xunit.Extensions;

namespace InstrumentViewer.Tests.Instrument.Services
{
    public class CachingInstrumentPriceServiceScenarios
    {
        public static IEnumerable<object[]> ObserveInstrumentPricesTestData
        {
            get
            {
                yield return new object[]
                {
                    new[] { new InstrumentPrice("A", 10M), new InstrumentPrice("B", 20M) },
                    new[] { new InstrumentPrice("A", 10M), new InstrumentPrice("B", 20M) }
                };
                yield return new object[]
                {
                    new[] { new InstrumentPrice("A", 10M), new InstrumentPrice("A", 20M) },
                    new[] { new InstrumentPrice("A", 20M) }
                };
            }
        }

        [Scenario]
        [PropertyData("ObserveInstrumentPricesTestData")]
        public void ObserveInstrumentPrices(IEnumerable<InstrumentPrice> prices, IEnumerable<InstrumentPrice> expectedPrices, CachingInstrumentPriceService service)
        {
            var result = new List<InstrumentPrice>();

            ("Given the prices " + prices.ToSummary())
                .f(() => { });

            "And the service"
                .f(() => service = new CachingInstrumentPriceService(prices.ToObservable(), ImmediateScheduler.Instance, 1));

            "When ObserveInstrumentPrices() is called"
                .f(() => service.ObserveInstrumentPrices().Subscribe(p => result.Add(p)));

            ("Then the received prices are " + expectedPrices.ToSummary())
                .f(() => Assert.Equal(expectedPrices, result));
        }
    }
}
