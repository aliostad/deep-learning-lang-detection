using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace training.winform
{
    public class InstrumentViewModel : INotifyPropertyChanged
    {
        private readonly Instrument _instrument;

        public string Name => _instrument.Name;

        public InstrumentType Type => _instrument.Type;

        public double Price => _instrument.Price;

        public double MeanPrice => _instrument.MeanPrice;

        public InstrumentViewModel(Instrument instrument)
        {
            _instrument = instrument;
            _instrument.PriceUpdated += PriceUpdated;
        }

        private void PriceUpdated()
        {
            OnPropertyChanged(nameof(Price));
            OnPropertyChanged(nameof(MeanPrice));
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected virtual void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}