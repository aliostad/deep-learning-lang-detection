using iExchange.Common;
using Infragistics.Controls.Interactions;
using ManagerConsole.Model;
using ManagerConsole.ViewModel;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
using CommonInstrumentForFloatingPLCalc = Manager.Common.ReportEntities.InstrumentForFloatingPLCalc;


namespace ManagerConsole.UI
{
    /// <summary>
    /// Interaction logic for ChangePriceForFPLCalc.xaml
    /// </summary>
    public partial class ChangePriceForFPLCalc : XamDialogWindow
    {
        private string _ExchangCode;
        private ObservableCollection<InstrumentForFloatingPLCalc> _InstrumentForFloatingPLCalcList;
        public ChangePriceForFPLCalc(string exchangeCode)
        {
            InitializeComponent();
            this.ExchangeCodeTextBlock.Text = exchangeCode;
            this._ExchangCode = exchangeCode;
            this._InstrumentForFloatingPLCalcList = new ObservableCollection<InstrumentForFloatingPLCalc>();
            this.GetInstrumentForFloatingPLCalc();
        }

        private void GetInstrumentForFloatingPLCalc()
        {
            ConsoleClient.Instance.GetInstrumentForFloatingPLCalc(this._ExchangCode, this.GetInstrumentForFloatingPLCalcCallback);
        }

        public void GetInstrumentForFloatingPLCalcCallback(List<CommonInstrumentForFloatingPLCalc> instrumentForFloatingPLCalcs)
        {
            this.Dispatcher.BeginInvoke((Action<List<CommonInstrumentForFloatingPLCalc>>)delegate(List<CommonInstrumentForFloatingPLCalc> result)
            {
                foreach (CommonInstrumentForFloatingPLCalc commonEntity in result)
                {
                    this._InstrumentForFloatingPLCalcList.Add(new InstrumentForFloatingPLCalc(commonEntity));
                }
                this._ChangePriceGrid.ItemsSource = this._InstrumentForFloatingPLCalcList;
            }, instrumentForFloatingPLCalcs);
        }

        private void ChangePriceGrid_Click(object sender, Infragistics.Controls.Grids.CellClickedEventArgs e)
        {
            InstrumentForFloatingPLCalc instrumentForPL = e.Cell.Row.Data as InstrumentForFloatingPLCalc;

            this.InstrumentText.Text = instrumentForPL.InstrumentCode;
            this.BidText.Text = instrumentForPL.Bid;
            this.SpreadText.Text = instrumentForPL.SpreadPoint.ToString();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (!this.CheckData()) return;
            InstrumentForFloatingPLCalc instrumentForPL = this._ChangePriceGrid.ActiveCell.Row.Data as InstrumentForFloatingPLCalc;
            int spreadPoint = int.Parse(this.SpreadText.Text);
            ConsoleClient.Instance.UpdateInstrumentForFloatingPLCalc(this._ExchangCode, instrumentForPL.InstrumentId, this.BidText.Text, spreadPoint, this.UpdateInstrumentForFloatingPLCalcCallback);
        }

        private bool CheckData()
        {
            if (!Toolkit.IsValidNumber(this.SpreadText.Text))
            {
                return false;
            }
            if (!Toolkit.IsNumber(this.BidText.Text))
            {
                return false;
            }
            return true;
        }

        private void SetInstrumentForFloatingPLCalc()
        {
            InstrumentForFloatingPLCalc instrumentForPL = this._ChangePriceGrid.ActiveCell.Row.Data as InstrumentForFloatingPLCalc;
            if (instrumentForPL == null) return;

            instrumentForPL.Bid = this.BidText.Text;
            ExchangeSettingManager settingManager= App.MainFrameWindow.ExchangeDataManager.GetExchangeSetting(this._ExchangCode);
            InstrumentClient instrument = settingManager.GetInstrument(instrumentForPL.InstrumentId);
            if (instrument == null) return;
            int spread = int.Parse(this.SpreadText.Text);
            Price bidPrice = new Price(instrumentForPL.Bid, instrument.NumeratorUnit, instrument.Denominator);
            Price askPrice = bidPrice + spread;
            instrumentForPL.Ask = askPrice.ToString();
            instrumentForPL.SpreadPoint = spread;
        }

        private void UpdateInstrumentForFloatingPLCalcCallback(bool isSucceed)
        {
            this.Dispatcher.BeginInvoke((Action<bool>)delegate(bool result)
            {
                if (result)
                {
                    this.SetInstrumentForFloatingPLCalc();
                    MessageBox.Show("Update Succeed!");
                }
                else
                {
                    MessageBox.Show("Update Failed!");
                }
            }, isSucceed);
        }
    }
}
