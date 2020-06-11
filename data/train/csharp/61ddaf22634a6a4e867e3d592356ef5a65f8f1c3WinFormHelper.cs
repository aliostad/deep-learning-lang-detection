using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace RoseBench
{
    public class WinFormHelper
    {
        public static void TryInvoke(Control control, Action action)
        {
            if (control.InvokeRequired)
            {
                //var result = control.BeginInvoke(action);
                //var endResult = control.EndInvoke(result);
                control.Invoke(action);
            }
            else
                action();
        }


        public static object TryInvoke(Control control, Func<object> action)
        {
            if (control.InvokeRequired)
            {
                //var result = control.BeginInvoke(action);
                //var endResult = control.EndInvoke(result);
                return control.Invoke(action);
            }
            else
                return action();
        }
    }
}
