using System.Windows;
using LoonieTrader.App.ViewModels.Parts;
using LoonieTrader.Library.ViewModels;

namespace LoonieTrader.App.Views
{
    public partial class ChartWindow : Window
    {
        public ChartWindow()
        {
            InitializeComponent();
        }

        public void ShowInstrument(InstrumentViewModel instrument)
        {
            var vm = DataContext as SciChartPartViewModel;
            if (vm != null)
            {
                vm.Instrument = instrument;
            }

            Show();
        }
    }
}
