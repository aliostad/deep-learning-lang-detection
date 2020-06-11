using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace MyDentApplication
{
	/// <summary>
	/// Interaction logic for EditInstrumentModal.xaml
	/// </summary>
	public partial class EditInstrumentModal : Window
	{
        #region Instance variables
        private int _instrumentId;
        #endregion

        #region Constructors
        public EditInstrumentModal(int instrumentId, string instrumentName)
		{
			this.InitializeComponent();

            _instrumentId = instrumentId;
            txtInstrumentName.ToolTip = txtInstrumentName.Text = instrumentName;
		}
        #endregion

        #region Window event handlers
        private void btnUpdateInstrument_Click(object sender, System.Windows.RoutedEventArgs e)
		{
            string instrumentName = txtInstrumentName.Text.Trim();

            if (AreValidFields(instrumentName) == false)
            {
                return;
            }

            Model.Instrument instrumentToUpdate = Controllers.BusinessController.Instance.FindById<Model.Instrument>(_instrumentId);

            if (instrumentToUpdate != null)
            {
                instrumentToUpdate.Name = instrumentName;

                if (Controllers.BusinessController.Instance.Update<Model.Instrument>(instrumentToUpdate))
                {
                    this.Close();
                    return;
                }
            }

            MessageBox.Show("No se pudo actualizar el instrumento", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
		}

		private void btnCancel_Click(object sender, System.Windows.RoutedEventArgs e)
		{
            this.Close();
        }
        #endregion

        #region Window's logic
        private bool AreValidFields(string instrumentName)
        {
            if (string.IsNullOrEmpty(instrumentName))
            {
                MessageBox.Show("Ingrese el nombre del instrumento", "Información", MessageBoxButton.OK, MessageBoxImage.Information);
                return false;
            }

            return true;
        }
        #endregion
    }
}