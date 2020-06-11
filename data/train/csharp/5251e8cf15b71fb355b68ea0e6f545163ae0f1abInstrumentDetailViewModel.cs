using System.Threading.Tasks;
using System.Windows.Input;
using RiskAnalysisTool.Instruments;
using RiskAnalysisTool.MobileApp.Infrastructure;

namespace RiskAnalysisTool.MobileApp.ViewModels
{
    public abstract class InstrumentDetailViewModel<T> : FunctionViewModel<T>, IModelViewModel<T>
        where T : Instrument, new()
    {
        private bool _includeMarketQuote;
        private T _instrument;
        private string _symbol;

        protected InstrumentDetailViewModel()
        {
            _includeMarketQuote = true;
            _instrument = new T();
            SaveCommand = new AsyncCommand(Save);
        }

        public bool IncludeMarketQuote
        {
            get { return _includeMarketQuote; }
            set { SetProperty(ref _includeMarketQuote, value); }
        }

        public T Instrument
        {
            get { return _instrument; }
            set
            {
                SetProperty(ref _instrument, value);
                LoadModel(_instrument);
            }
        }

        public ICommand SaveCommand { get; private set; }

        public string Symbol
        {
            get { return _symbol; }
            set { SetProperty(ref _symbol, value); }
        }

        public virtual void LoadModel(T instrument)
        {
            this.Symbol = instrument.Symbol;
        }

        public async Task Save()
        {
            UpdateModel(_instrument);
            await this.CloseAsync(_instrument);
        }

        public virtual void UpdateModel(T instrument)
        {
            instrument.Symbol = this.Symbol;
        }
    }
}