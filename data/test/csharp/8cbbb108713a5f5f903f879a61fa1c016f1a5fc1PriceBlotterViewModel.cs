using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Reactive.Linq;
using System.Reactive.Disposables;
using System.Threading.Tasks;
using System.Windows.Input;
using PricePublisher.Commands;
using PricePublisher.Container;
using PricePublisher.DomainEntities;
using PricePublisher.Models;
using PricePublisher.Services;
using System.Reactive.Subjects;
using System.Collections.Generic;

namespace PricePublisher.ViewModels
{ 
    public class PriceBlotterViewModel: ModelBase, IDisposable,IObservable<KeyValuePair<string, InstrumentPriceUpdate[]>>
    {
        private ObservableCollection<InstrumentPrice> _instrumentPrices;
        private readonly TaskFactory _instrumentUpdaterTaskFactory;
        public ICommand DoubleClickPriceCommand {  get; private set; }
        public event EventHandler<PriceHistoryEventArgs> DisplayPriceHistory;
        private readonly CompositeDisposable _compositeDisposable;
        private readonly IPriceAggregatorService _priceAggregatorService;
        private readonly Subject<KeyValuePair<string,InstrumentPriceUpdate[]>> _instrumentPriceUpdateSubject;

        public PriceBlotterViewModel():this(new DependencyContainer())
        {
        }

        public PriceBlotterViewModel(IDependencyContainer container)
        {
            _instrumentPriceUpdateSubject = new Subject<KeyValuePair<string, InstrumentPriceUpdate[]>>();
            DoubleClickPriceCommand = new DelegateCommand(o => o != null, o =>
            {
                var evt = DisplayPriceHistory;
                if (evt != null)
                {
                    string selectedPriceInstrument = ((InstrumentPrice)o).InstrumentName;
                    evt(this, new PriceHistoryEventArgs(selectedPriceInstrument));
                }
            });

            _instrumentUpdaterTaskFactory = new TaskFactory(TaskScheduler.FromCurrentSynchronizationContext());
            _priceAggregatorService = container.Resolve<IPriceAggregatorService>();

            IDisposable aggregatedPriceChangeSubscription = _priceAggregatorService.Subscribe(new System.Reactive.AnonymousObserver<AggregatedPriceChangeNotification>(item =>
            {
                _instrumentUpdaterTaskFactory.StartNew(() =>
                {
                    AggregatedPriceChangeNotification tmpNotification = item;
                    UpdateDataSource(tmpNotification);
                    if (!_compositeDisposable.IsDisposed)
                    {
                        _instrumentPriceUpdateSubject.OnNext(new KeyValuePair<string, InstrumentPriceUpdate[]>(tmpNotification.LatestUpdate.Instrument, tmpNotification.RecentPriceChanges));
                    }
                });
            }));

            _priceAggregatorService.SubScribeToNotifications();

            _compositeDisposable = new CompositeDisposable(aggregatedPriceChangeSubscription, _instrumentPriceUpdateSubject, (IDisposable)container);
        }

        public ObservableCollection<InstrumentPrice> InstrumentPrices
        {
            get
            {
                if (_instrumentPrices == null)
                {
                    _instrumentPrices = new ObservableCollection<InstrumentPrice>();
                    OnPropertyChanged("InstrumentPrices");
                }

                return _instrumentPrices;
            }
            set
            {
                _instrumentPrices = value;
                OnPropertyChanged("InstrumentPrices");
            }
        }

        public void UpdateDataSource(AggregatedPriceChangeNotification value)
        {
            AggregatedPriceChangeNotification tmpValue = value;
            InstrumentPrice instrumentPrice = InstrumentPrices.FirstOrDefault(x => x.InstrumentName == value.LatestUpdate.Instrument);
            if (instrumentPrice == null)
            {
                InstrumentPrices.Add(new InstrumentPrice
                {
                    AveragePrice = value.AveragePrice,
                    InstrumentName = value.LatestUpdate.Instrument,
                    Price = value.LatestUpdate.Price,
                    RecentPriceChanges = new ObservableCollection<InstrumentPriceHistory>(value.RecentPriceChanges.Where(x => x != null).Select(x => new InstrumentPriceHistory
                    { InstrumentName = x.Instrument, Price = x.Price }
                    )),
                    PriceChangeStatus = value.PriceChangeStatus,
                    AveragePriceChangeStatus = value.AveragePriceChangeStatus
                });
            }
            else
            {
                instrumentPrice.AveragePrice = value.AveragePrice;
                instrumentPrice.InstrumentName = value.LatestUpdate.Instrument;
                instrumentPrice.Price = value.LatestUpdate.Price;
                instrumentPrice.RecentPriceChanges = 
                    new ObservableCollection<InstrumentPriceHistory>(
                        value
                        .RecentPriceChanges
                        .Where(x => x != null)
                        .Select(x => new InstrumentPriceHistory { InstrumentName= x.Instrument, Price = x.Price }
                ));
                instrumentPrice.PriceChangeStatus = value.PriceChangeStatus;
                instrumentPrice.AveragePriceChangeStatus = value.AveragePriceChangeStatus;
            }
        }

        public void Dispose()
        {
            if(_compositeDisposable != null) { _compositeDisposable.Dispose(); }
        }

        public IDisposable Subscribe(IObserver<KeyValuePair<string, InstrumentPriceUpdate[]>> observer)
        {
            return _instrumentPriceUpdateSubject.Subscribe(observer);
        }
    }
}
