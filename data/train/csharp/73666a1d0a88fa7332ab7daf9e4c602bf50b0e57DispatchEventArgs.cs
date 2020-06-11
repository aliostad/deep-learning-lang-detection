using DriverSolutions.BOL.Models.ModuleDispatches;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DriverSolutions.ModuleDispatches
{
    public class DispatchEventArgs:EventArgs
    {
        public DispatchModel Dispatch { get; private set; }
        public DialogResult DialogResult { get; private set; }

        public DispatchEventArgs(DispatchModel disp, DialogResult result)
        {
            this.Dispatch = disp;
            this.DialogResult = result;
        }
    }
}
