using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Framework.UI.Helpers
{
    public static class CrossThreadingHelpers
    {
        public delegate void InvokeControlCallback(Control ctl, object input, Action<object> action);
        public static void InvokeControl(Control ctl, object input, Action<object> action)
        {
            if (ctl != null && ctl.InvokeRequired)
            {
                InvokeControlCallback d = new InvokeControlCallback(InvokeControl);
                ctl.Invoke(d, ctl, input, action);
                return;
            }
            action.Invoke(input);
        }
    }
}
