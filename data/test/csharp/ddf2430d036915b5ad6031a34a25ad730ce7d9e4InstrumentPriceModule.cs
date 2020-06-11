using System;
using System.Reactive.Concurrency;
using Instrument.Services;
using Microsoft.Practices.Prism.Modularity;
using Microsoft.Practices.Unity;

namespace Instrument
{
    public class InstrumentPriceModule : IModule
    {
        private readonly IUnityContainer _container;
        private readonly IObservable<InstrumentPrice> _prices;

        public InstrumentPriceModule(IUnityContainer container, IObservable<InstrumentPrice> prices)
        {
            _container = container;
            _prices = prices;
        }

        public void Initialize()
        {
            var instrumentPriceService = new CachingInstrumentPriceService(_prices, TaskPoolScheduler.Default);

            _container.RegisterInstance<IInstrumentPriceService>(instrumentPriceService);
        }
    }
}
