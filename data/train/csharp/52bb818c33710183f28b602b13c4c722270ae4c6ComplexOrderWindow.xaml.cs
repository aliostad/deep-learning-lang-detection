using System.Windows;
using LoonieTrader.App.ViewModels;
using LoonieTrader.App.ViewModels.Windows;
using LoonieTrader.Library.ViewModels;

namespace LoonieTrader.App.Views
{
    public partial class ComplexOrderWindow : Window
    {
        public ComplexOrderWindow()
        {
            InitializeComponent();
        }

        public void ShowInstrument(InstrumentViewModel instrument)
        {
            var vm = DataContext as ComplexOrderWindowViewModel;
            vm.Instrument = instrument;
            vm.SelectedInstrument = instrument;
            Show();
        }
    }
}
