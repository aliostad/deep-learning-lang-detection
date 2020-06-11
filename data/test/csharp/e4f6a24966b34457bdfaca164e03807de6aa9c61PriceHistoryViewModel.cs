using PricePublisher.DomainEntities;
using PricePublisher.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Reactive.Linq;

namespace PricePublisher.ViewModels
{
    public class PriceHistoryViewModel: ModelBase, IDisposable
    {

        ObservableCollection<InstrumentPriceHistory> _priceHistory;
        IObservable<KeyValuePair<string, InstrumentPriceUpdate[]>> _priceInstrumentHistoryObservable;
        IDisposable priceInstrumentHistorySubscription;
        private readonly TaskFactory _instrumentUpdaterTaskFactory;

        public ObservableCollection<InstrumentPriceHistory> PriceHistory
        {
            get
            {
                if (_priceHistory == null)
                {
                    _priceHistory = new ObservableCollection<InstrumentPriceHistory>();
                }
                OnPropertyChanged("PriceHistory");
                return _priceHistory;
            }
            set
            {
                _priceHistory = value;
                OnPropertyChanged("PriceHistory");
            }
        }

        public PriceHistoryViewModel(IObservable<KeyValuePair<string, InstrumentPriceUpdate[]>> priceInstrumentHistoryObservable, string instrument)
        {
            this._priceInstrumentHistoryObservable = priceInstrumentHistoryObservable;
            _instrumentUpdaterTaskFactory = new TaskFactory(TaskScheduler.FromCurrentSynchronizationContext());

            priceInstrumentHistorySubscription = _priceInstrumentHistoryObservable
                .Where(x=>x.Key == instrument)
                .Subscribe(new System.Reactive.AnonymousObserver<KeyValuePair<string, InstrumentPriceUpdate[]>>(items =>
            {
                _instrumentUpdaterTaskFactory.StartNew(() => {
                    PriceHistory.Clear();
                    foreach (var item in items.Value.Select(x => new InstrumentPriceHistory { InstrumentName = x.Instrument, Price = x.Price }))
                    {
                        PriceHistory.Add(item);
                    }
                });
            }));
        }

        public void Dispose()
        {
            if (priceInstrumentHistorySubscription != null) { priceInstrumentHistorySubscription.Dispose(); }
        }
    }
}
