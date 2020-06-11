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
using Distributr.Core.Resources.Util;
using Distributr.WPF.Lib.ViewModels.Transactional.SalesmanOrders;
using StructureMap;

namespace Distributr.WPF.UI.Views.DispatchPendingOrdersToPhone
{ public partial class DispatchOptions : Window
    {
        public ListSalesmanOrdersViewModel.EnumSelectedDispatchMode SelectedDispatchOption;
        private IMessageSourceAccessor _messageResolver = ObjectFactory.GetInstance<IMessageSourceAccessor>();

        public DispatchOptions()
        {
            InitializeComponent();
            LabelControls();
        }

        void LabelControls()
        {
            Title = _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.title");
            lblSummary.Content = _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.summarytitle");
            lblOptions.Content = _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.options.title");

            rbDispatchFulfilled.Content = _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.options.dispatchfulfilled");
            rbDispatchWithPartial.Content = _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.options.dispatchfulfilledandunfulfilled");
            rbProcessAndDispatchFulfilled.Content = _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.options.processfulfillableanddispatchall");
            rbProcessDispatchWithPartial.Content = _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.options.processanddispatchall");

            OKButton.Content = _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.ok");
            CancelButton.Content = _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.cancel");
        }

        private void OKButton_Click(object sender, RoutedEventArgs e)
        {
            if (rbDispatchFulfilled.IsChecked == true || rbDispatchWithPartial.IsChecked == true || rbProcessAndDispatchFulfilled.IsChecked == true || rbProcessDispatchWithPartial.IsChecked == true)
                this.DialogResult = true;
            else
                MessageBox.Show(_messageResolver.GetText("sl.dispatchOrders.dispatchoptions.selectoption")/*"Please select an option to proceed with dispath."*/
                    , _messageResolver.GetText("sl.dispatchOrders.dispatch.messagebox.caption") /*"Distributr: Dispatch Orders"*/
                    , MessageBoxButton.OK);
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }

        private void btnDispatchInfo_Click(object sender, RoutedEventArgs e)
        {
            var btn = sender as Button;
            string msg = "";
            switch (btn.Name)
            {
                case "btnDispatchFulfilled":
                    msg = /*"Dispatches only those orders which have been fulfilled.";*/
                        _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.options.option1.info");
                    break;
                case "btnDispatchWithPartial":
                    msg = /*"Dispatches the fulfilled orders and dispatches unfulfilled orders partially without processing them.";*/
                        _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.options.option2.info");
                    break;
                case "btnProcessAndDispatchFulfilled":
                    msg = /*"Processes fulfillable back orders and dispatches them together with other already fulfilled orders.";*/
                        _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.options.option3.info");
                    break;
                case "btnProcessDispatchWithPartial":
                    msg = /*"Processes back orders. Dispatches fulfilled orders, processed back orders and partiall dispatches unprocessed back orders.";*/
                        _messageResolver.GetText("sl.dispatchOrders.dispatchoptions.options.option4.info");
                    break;
            }

            MessageBox.Show(msg
                , _messageResolver.GetText("sl.dispatchOrders.dispatch.messagebox.caption") /*"Distributr: Dispatch Orders"*/
                , MessageBoxButton.OK);
        }

        private void rbDispatchOption_Checked(object sender, RoutedEventArgs e)
        {
            var rb = sender as RadioButton;
            switch (rb.Name)
            {
                case "rbDispatchFulfilled":
                    SelectedDispatchOption = ListSalesmanOrdersViewModel.EnumSelectedDispatchMode.DispatchFulfilled;
                    break;
                case "rbDispatchWithPartial":
                    SelectedDispatchOption = ListSalesmanOrdersViewModel.EnumSelectedDispatchMode.DispatchWithPartialDispatch;
                    break;
                case "rbProcessDispatchWithPartial":
                    SelectedDispatchOption = ListSalesmanOrdersViewModel.EnumSelectedDispatchMode.ProcessAndDispatchAll;
                    break;
                case "rbProcessAndDispatchFulfilled":
                    SelectedDispatchOption = ListSalesmanOrdersViewModel.EnumSelectedDispatchMode.ProcessFulfillableAndDispatchFulfilled;
                    break;
            }
        }
    }
}
