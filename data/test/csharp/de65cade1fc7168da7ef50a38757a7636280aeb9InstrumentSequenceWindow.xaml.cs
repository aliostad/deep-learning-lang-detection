using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

using PostProcessor.Entity;


namespace PostProcessor.Windows
{
	/// <summary>
	/// Interaction logic for InstrumentSequenceWindow.xaml
	/// </summary>
	public partial class InstrumentSequenceWindow : Window
	{
		private List<Entity.Instrument> _instrumentSequence;
		private int _cur = 0;


		public InstrumentSequenceWindow(List<Instrument> instrumentSequence)
		{
			InitializeComponent();

			_instrumentSequence = instrumentSequence;
			UpdateInstrument();
		}


		private void btnNext_Click(object sender, RoutedEventArgs e)
		{
			_cur++;
			if (_cur == _instrumentSequence.Count)
			{
				Close();
			}
			else
			{
				UpdateInstrument();
			}
		}


		private void UpdateInstrument()
		{
			txtInstrumentNum.Text = string.Format("{0}/{1}", _cur + 1, _instrumentSequence.Count);
			txtInstrument.Text = string.Format("{0} (T{1})", _instrumentSequence[_cur].Name, _instrumentSequence[_cur].Num);

			if (_cur == _instrumentSequence.Count - 1)
			{
				btnNext.Content = "Завершить";
			}
		}
	}
}
