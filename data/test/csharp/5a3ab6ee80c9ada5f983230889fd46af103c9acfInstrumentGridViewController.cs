using System;
using System.Linq;
using System.Reactive.Concurrency;
using System.Reactive.Disposables;
using System.Reactive.Linq;
using Instrument.Services;
using Instrument.Ui.ViewModels;
using Microsoft.Practices.Prism.Commands;
using Shared;

namespace Instrument.Ui.ViewControllers
{
    public sealed class InstrumentGridViewController : IDisposable
    {
        private readonly IInstrumentPriceService _instrumentPriceService;
        private InstrumentGridViewModel _viewModel;
        private readonly CompositeDisposable _disposable;
        private readonly TimeSpan _conflateTimeSpan;
        private readonly Action<string> _viewHistoricalPrices;
        private readonly IScheduler _uiScheduler;
        private readonly IScheduler _backgroundScheduler;

        public InstrumentGridViewController(IInstrumentPriceService instrumentPriceService, 
                                            TimeSpan conflateTimeSpan, 
                                            Action<string> viewHistoricalPrices,
                                            IScheduler uiScheduler, 
                                            IScheduler backgroundScheduler)
        {
            _instrumentPriceService = instrumentPriceService;
            _conflateTimeSpan = conflateTimeSpan;
            _viewHistoricalPrices = viewHistoricalPrices;
            _uiScheduler = uiScheduler;
            _backgroundScheduler = backgroundScheduler;
            _disposable = new CompositeDisposable();
        }

        public InstrumentGridViewModel ViewModel
        {
            get { return _viewModel; }
        }

        public void Initialize()
        {
            _viewModel = new InstrumentGridViewModel
            {
                InstrumentPrices = new ObservableKeyedCollection<string, InstrumentPriceViewModel>(ip => ip.Instrument),
                ShowHistoricalPrices = new DelegateCommand<InstrumentPriceViewModel>(vm => _viewHistoricalPrices(vm.Instrument))
            };

            _instrumentPriceService.ObserveInstrumentPrices()
                                   .GroupBy(p => p.Instrument)
                                   .Select(gp => gp.Scan(Enumerable.Empty<InstrumentPrice>(), (acum, price) => acum.StartWith(price).Take(5))
                                                   .Conflate(_conflateTimeSpan, _backgroundScheduler)) // we conflate every instrument separately
                                   .Merge()
                                   .Select(prices => prices.ToAggregatedInstrumentPrice())
                                   .SubscribeOn(_backgroundScheduler)
                                   .ObserveOn(_uiScheduler)
                                   .Subscribe(p =>
                                   {
                                       if (_viewModel.InstrumentPrices.Contains(p.Instrument))
                                       {
                                           _viewModel.InstrumentPrices[p.Instrument].Update(p);
                                       }
                                       else
                                       {
                                           _viewModel.InstrumentPrices.Add(p.ToViewModel());
                                       }
                                   })
                                   .AddToDisposable(_disposable);
        }

        public void Dispose()
        {
            _disposable.Dispose();
        }
    }
}
