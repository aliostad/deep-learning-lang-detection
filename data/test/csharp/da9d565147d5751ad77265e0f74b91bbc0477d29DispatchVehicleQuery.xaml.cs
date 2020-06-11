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
using VehicleGPS.ViewModels.DispatchCentre.VehicleDispatch;
using VehicleGPS.Models.DispatchCentre.VehicleDispatch;

namespace VehicleGPS.Views.Control.DispatchCentre.VehicleDispatch
{
    /// <summary>
    /// DispatchVehicleQuery.xaml 的交互逻辑
    /// </summary>
    public partial class DispatchVehicleQuery : Window
    {
        public DispatchVehicleQuery(string taskid)
        {
            InitializeComponent();
            this.DataContext = new DispatchVehicleQueryViewModel(taskid);
        }
        public DispatchVehicleQuery(List<DispatchVehicleInfo> dispatchList)
        {
            InitializeComponent();
            this.DataContext = new DispatchVehicleQueryViewModel(dispatchList);
        }
    }
}
