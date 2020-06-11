using Host.Contract;
using Host.PL.Frame;

namespace Host.PL
{
    public class InstrumentListViewModel : BindableBase
    {
        private InstrumentListViewModel() { }

        private static readonly InstrumentListViewModel instance = new InstrumentListViewModel();
        public static InstrumentListViewModel Instance { get { return instance; } }

        private Instrument[] instruments;
        public Instrument[] Instruments
        {
            get
            {
                return this.instruments;
            }
            set
            {
                this.instruments = value;
                this.NotifyPropertyChanged("Instruments");
            }
        }

        public Command ChooseQuotationCommand
        {
            get
            {
                return new Command(this.DoChooseQuotation);
            }
        }
        private void DoChooseQuotation(object obj)
        {
            if (obj != null)
            {
                QuotationListViewModel.Instance.TryAdd(((Instrument)obj).InstrumentID);
                MainViewModel.Instance.QuotationIsSelected = true;
            }
        }
    }
}