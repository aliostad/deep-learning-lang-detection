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
    /// DispatchPointUserControl.xaml 的交互逻辑
    /// </summary>
    public partial class DispatchPointUserControl : UserControl
    {
        public DispatchPointUserControl()
        {
            InitializeComponent();
        }

        public static readonly DependencyProperty DispatchPointProperty = DependencyProperty.Register("DispatchPoint", typeof(DispatchPointViewModel), typeof(DispatchPointUserControl));

        public DispatchPointViewModel DispatchPoint
        {
            get
            {
                return (DispatchPointViewModel)GetValue(DispatchPointProperty);
            }
            set
            {
                SetValue(DispatchPointProperty, value);
            }
        }
    }
}
