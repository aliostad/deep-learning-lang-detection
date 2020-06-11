using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Threading.Tasks;
using RiskAnalysisTool.Instruments;
using RiskAnalysisTool.MobileApp.Infrastructure;
using XLabs;
using XLabs.Forms.Mvvm;

namespace RiskAnalysisTool.MobileApp.ViewModels
{
    public class MarketDataListViewModel : ViewModel
    {
        private readonly AsyncCommand<string> _addInstrumentCommand;
        private readonly AsyncCommand<Instrument> _editInstrumentCommand;
        private readonly RelayCommand<Instrument> _removeInstrumentCommand;
        private ObservableCollection<Instrument> _instruments;

        public MarketDataListViewModel()
        {
            _instruments = new ObservableCollection<Instrument>();
            _addInstrumentCommand = new AsyncCommand<string>(AddInstrument);
            _editInstrumentCommand = new AsyncCommand<Instrument>(EditInstrument);
            _removeInstrumentCommand = new RelayCommand<Instrument>(RemoveInstrument);
        }

        public AsyncCommand<string> AddInstrumentCommand
        {
            get { return _addInstrumentCommand; }
        }

        public AsyncCommand<Instrument> EditInstrumentCommand
        {
            get { return _editInstrumentCommand; }
        }

        public ObservableCollection<Instrument> Instruments
        {
            get { return _instruments; }
            set { SetProperty(ref _instruments, value); }
        }

        public RelayCommand<Instrument> RemoveInstrumentCommand
        {
            get { return _removeInstrumentCommand; }
        }

        public async Task AddInstrument(string instrumentType)
        {
            Instrument instrument;

            switch (instrumentType)
            {
                case "Volatility":
                    instrument = await ShowInstrumentDetailPage<ImpliedVolatility, VolatilityDetailViewModel>();
                    break;
                case "Bond":
                    instrument = await ShowInstrumentDetailPage<Bond, BondDetailViewModel>();
                    break;
                case "CDS":
                    instrument = await ShowInstrumentDetailPage<CreditDefaultSwap, CreditDefaultSwapDetailViewModel>();
                    break;
                case "Correlation":
                    instrument = await ShowInstrumentDetailPage<Correlation, CorrelationDetailViewModel>();
                    break;
                default:
                    throw new ArgumentException("Invalid instrument type: " + instrumentType, "instrumentType");
            }

            if (instrument != null)
            {
                _instruments.Add(instrument);
            }
        }

        public async Task EditInstrument(Instrument instrument)
        {
            Instrument updated;
            if (instrument.GetType() == typeof(ImpliedVolatility))
            {
                updated = await ShowInstrumentDetailPage<ImpliedVolatility, VolatilityDetailViewModel>((ImpliedVolatility)instrument);
            }
            else if (instrument.GetType() == typeof(Bond))
            {
                updated = await ShowInstrumentDetailPage<Bond, BondDetailViewModel>((Bond)instrument);
            }
            else if (instrument.GetType() == typeof(CreditDefaultSwap))
            {
                updated = await ShowInstrumentDetailPage<CreditDefaultSwap, CreditDefaultSwapDetailViewModel>((CreditDefaultSwap)instrument);
            }
            else if (instrument.GetType() == typeof(Correlation))
            {
                updated = await ShowInstrumentDetailPage<Correlation, CorrelationDetailViewModel>((Correlation)instrument);
            }
            else
            {
                throw new NotSupportedException("Unsupported market data of type " + instrument.GetType());
            }

            if (updated != null)
            {
                int index = _instruments.IndexOf(instrument);
                _instruments[index] = null;
                _instruments[index] = updated;
            }
        }

        public void RemoveInstrument(Instrument instrument)
        {
            _instruments.Remove(instrument);
        }

        private async Task<TModel> ShowInstrumentDetailPage<TModel, TViewModel>(TModel instrument = null)
            where TViewModel : InstrumentDetailViewModel<TModel>
            where TModel : Instrument, new()
        {
            if (instrument == null)
            {
                instrument = new TModel();
            }

            TModel inst = await this.InvokeAsync<TViewModel, TModel>((vm, v) =>
            {
                vm.IncludeMarketQuote = true;
                vm.LoadModel(instrument);
            });

            return inst;
        }
    }
}