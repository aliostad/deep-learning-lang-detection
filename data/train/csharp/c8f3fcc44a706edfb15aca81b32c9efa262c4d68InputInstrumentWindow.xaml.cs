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

using PostProcessor.Helpers;
using PostProcessor.Entity;


namespace PostProcessor.Windows
{
	/// <summary>
	/// Interaction logic for InputInstrumentWindow.xaml
	/// </summary>
	public partial class InputInstrumentWindow : Window
	{
		public enum InputInstrumentResults
		{
			Undefined,
			Apply,
			Ignore,
			IgnoreAll,
			Abort
		}


		public InputInstrumentResults InputInstrumentResult
		{
			get;
			private set;
		}


		public string InstrumentName
		{
			get { return txtInstrumentName.Text; }
		}


		public InputInstrumentWindow(int t, int lnum, string[] lines)
		{
			InitializeComponent();

			InputInstrumentResult = InputInstrumentResults.Undefined;

			txtLineNum.Text = (lnum + 1).ToString();
			txtInstrumentNum.Text = t.ToString();

			linesView.SetLines(lines, lnum);
		}


		private void InputInstrumentWindow_Closing(object sender, System.ComponentModel.CancelEventArgs e)
		{
			if (InputInstrumentResult != InputInstrumentResults.Undefined)
			{
				return;
			}

			if (MessageBox.Show("Прервать обработку?", "Внимание", MessageBoxButton.YesNoCancel) == MessageBoxResult.Yes)
			{
				InputInstrumentResult = InputInstrumentResults.Abort;
			}
			else
			{
				e.Cancel = true;
			}
		}



		private void ApplyButton_Click(object sender, RoutedEventArgs e)
		{
			ApplyInstrument();
		}


		private void IgnoreButton_Click(object sender, RoutedEventArgs e)
		{
			txtInstrumentName.Text = string.Empty;
			InputInstrumentResult = InputInstrumentResults.Ignore;
			Close();
		}


		private void txtInstrumentName_PreviewKeyDown(object sender, KeyEventArgs e)
		{
			if (e.Key == Key.Enter)
			{
				ApplyInstrument();
			}
		}


		private void ApplyInstrument()
		{
			if (string.IsNullOrWhiteSpace(txtInstrumentName.Text))
			{
				AnimationHelper.AnimateTextBox(txtInstrumentName);
			}
			else
			{
				InputInstrumentResult = InputInstrumentResults.Apply;
				Close();
			}
		}


		private void IgnoreAllButton_Click(object sender, RoutedEventArgs e)
		{
			InputInstrumentResult = InputInstrumentResults.IgnoreAll;
			Close();
		}
	}
}
