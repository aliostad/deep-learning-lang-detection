namespace PricePublisher.Models
{
    public class InstrumentPriceHistory: ModelBase
    {
        private string _instrumentName;
        private decimal _price;

        public string InstrumentName
        {
            get { return _instrumentName; }
            set
            {
                _instrumentName = value;
                OnPropertyChanged("InstrumentName");
            }
        }

        public decimal Price
        {
            get { return _price; }
            set
            {
                _price = value;
                OnPropertyChanged("Price");
            }
        }
    }
}
