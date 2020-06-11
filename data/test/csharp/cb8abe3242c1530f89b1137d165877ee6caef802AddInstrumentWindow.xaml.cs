using System.Windows;
using System.Windows.Controls;
using MME.Data;
using MME.Sound.Waves;

namespace MME
{
    /// <summary>
    ///     Interaction logic for AddInstrumentWindow.xaml
    /// </summary>
    public partial class AddInstrumentWindow
    {
        private InstrumentData _instrumentData = new InstrumentData();

        public AddInstrumentWindow()
        {
            InitializeComponent();
        }

        private void OkButton_OnClick(object sender, RoutedEventArgs e)
        {
            switch (SelectedItem.Text)
            {
                case "SineWave":
                    _instrumentData.InstrumentFunction = new SineWave();
                    break;
                case "SquareWave":
                    _instrumentData.InstrumentFunction = new SquareWave();
                    break;
                case "TriangleWave":
                    _instrumentData.InstrumentFunction = new TriangleWave();
                    break;
                case "SawtoothWave":
                    _instrumentData.InstrumentFunction = new SawtoothWave();
                    break;

                default:
                    _instrumentData = null;
                    break;
            }

            _instrumentData.InstrumentName = InstrumentName.Text;

            Close();
        }

        public InstrumentData Open()
        {
            ShowDialog();

            return _instrumentData;
        }

        private void SelectedItem_OnSelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (OkButton == null) return;

            OkButton.IsEnabled = true;
        }
    }
}