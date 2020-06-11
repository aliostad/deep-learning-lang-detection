using System.ComponentModel;
using System.Windows.Input;
using Shared;

namespace Instrument.Ui.ViewModels
{
    public class InstrumentGridViewModel
    {
        private ObservableKeyedCollection<string, InstrumentPriceViewModel> _instrumentPrices;
        public event PropertyChangedEventHandler PropertyChanged;

        public ICommand ShowHistoricalPrices { get; set; }

        public ObservableKeyedCollection<string, InstrumentPriceViewModel> InstrumentPrices
        {
            get { return _instrumentPrices; }
            set
            {
                if (_instrumentPrices != value)
                {
                    _instrumentPrices = value;
                    PropertyChanged.Raise(this, () => InstrumentPrices);
                }
            }
        }
    }
}
