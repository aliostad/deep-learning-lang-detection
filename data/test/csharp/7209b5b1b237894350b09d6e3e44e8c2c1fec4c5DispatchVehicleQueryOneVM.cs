using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VehicleGPS.Models.DispatchCentre.VehicleDispatch;
using Microsoft.Practices.Prism.ViewModel;
using Microsoft.Practices.Prism.Commands;

namespace VehicleGPS.ViewModels.DispatchCentre.VehicleDispatch
{
    class DispatchVehicleQueryOneVM : NotificationObject
    {
        public DispatchVehicleInfo TaskInfo { get; set; }//派车单信息
        public DelegateCommand PrintCommand { get; set; }//打印操作 
        void PrintCommandExecute()
        {
            PrintPreview previewWnd = new PrintPreview("DispatchDocument.xaml", this.TaskInfo);
            previewWnd.ShowInTaskbar = false;
            previewWnd.ShowDialog();
        }
        public DispatchVehicleQueryOneVM()
        {
            this.PrintCommand = new DelegateCommand(this.PrintCommandExecute);
        }
    }
}
