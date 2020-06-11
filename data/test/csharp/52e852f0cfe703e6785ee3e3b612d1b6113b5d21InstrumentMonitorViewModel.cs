using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using ReactiveUI.Xaml;
using ReactiveUI;

namespace InstrumentMonitor
{
    /// <summary>
    /// The InstrumentMonitorViewModel class wires up the bulk of the application and handles updates from the pricing service
    /// in addition to any users input.
    /// </summary>
    public class InstrumentMonitorViewModel : ReactiveObject
    {
        #region Private Members

        private PricingService _pricingService;
        private bool _bloombergStarted;
        private bool _reutersStarted;
        private ObservableCollection<InstrumentMonRow> _InstrumentRows;

        #endregion

        #region Public Members

        public ReactiveCommand StartBloombergCommand { get; private set; }
        public ReactiveCommand StartReutersCommand { get; private set; }

        public string BloombergText
        {
            get
            {
                if (_bloombergStarted)
                    return "Stop Bloomberg";
                else
                    return "Start Bloomberg";
            }
        }

        public string ReutersText
        {
            get
            {
                if (_reutersStarted)
                    return "Stop Reuters";
                else
                    return "Start Reuters";
            }
        }

        public ObservableCollection<InstrumentMonRow> InstrumentRows
        {
            get
            {
                return _InstrumentRows;
            }
            set
            {
                _InstrumentRows = value;
            }
        }

        #endregion

        #region Constructors

        public InstrumentMonitorViewModel()
        {
            _pricingService = new PricingService();
            _InstrumentRows = new ObservableCollection<InstrumentMonRow>();

            WireCommands();
            BuildInstrumentRows();

            //Setup Subscription to Pricing Service
            _pricingService.Quotes.Subscribe(quote =>
                {
                    InstrumentMonRow instrument = _InstrumentRows.FirstOrDefault(a => a.InstrumentID == quote.InstrumentID);

                    if (instrument.IsSubscribed)
                    {
                        instrument.Bid = quote.Bid;
                        instrument.Ask = quote.Ask;
                        instrument.Price = quote.Price;
                        instrument.PriceSource = quote.PriceSource;
                    }

                });

        }

        #endregion

        #region Private Methods

        private void BuildInstrumentRows()
        {
            foreach (Instrument instrument in _pricingService.GetInstuments())
            {
                InstrumentMonRow row = new InstrumentMonRow(instrument);
                _InstrumentRows.Add(row);
            }
        }

        private void WireCommands()
        {
            StartBloombergCommand = new ReactiveCommand();
            StartBloombergCommand
                .Subscribe(_ =>
                     {                         
                         _bloombergStarted = !_bloombergStarted;
                         this.RaisePropertyChanged(x => x.BloombergText);

                         if (_bloombergStarted)
                             _pricingService.StartBloombergFeed();
                         else
                             _pricingService.StopBloommbergFeed();
                         
                     }
            );

            StartReutersCommand = new ReactiveCommand();
            StartReutersCommand
                .Subscribe(_ =>
                    {
                        _reutersStarted = !_reutersStarted;
                        this.RaisePropertyChanged(x => x.ReutersText);

                        if (_reutersStarted)
                            _pricingService.StartReutersFeed();
                        else
                            _pricingService.StopReutersFeed();
                    });
        }

        #endregion
    }
}
