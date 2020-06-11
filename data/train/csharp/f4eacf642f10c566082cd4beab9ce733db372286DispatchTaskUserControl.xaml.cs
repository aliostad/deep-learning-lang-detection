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
using System.Windows.Navigation;
using System.Windows.Shapes;
using VehicleGPS.ViewModels.DispatchCentre.VehicleDispatch;

namespace VehicleGPS.Views.Control.DispatchCentre.VehicleDispatch
{
    /// <summary>
    /// DispatchTaskUserControl.xaml 的交互逻辑
    /// </summary>
    public partial class DispatchTaskUserControl : UserControl
    {
        public DispatchTaskUserControl()
        {
            InitializeComponent();
        }

        public static readonly DependencyProperty DispatchTaskProperty = DependencyProperty.Register("DispatchTask", typeof(VehicleDispatchItemViewModel), typeof(DispatchTaskUserControl));

        public VehicleDispatchItemViewModel DispatchTask
        {
            get
            {
                return (VehicleDispatchItemViewModel)GetValue(DispatchTaskProperty);
            }
            set
            {
                SetValue(DispatchTaskProperty, value);
            }
        }

        private void Image_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            DispatchVehicle infoWin = new DispatchVehicle(this.DataContext);
            infoWin.Owner = Window.GetWindow(this);
            infoWin.ShowDialog();
        }

        private void DestImage_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            //VehicleInfo vehicleInfoWin = new VehicleInfo(this.DataContext);
            //vehicleInfoWin.Owner = Window.GetWindow(this);
            //vehicleInfoWin.ShowDialog();
        }
    }
}
