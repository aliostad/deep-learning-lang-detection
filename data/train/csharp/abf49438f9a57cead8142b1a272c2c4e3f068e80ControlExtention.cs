using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuantBox.APIProvider
{
    public static class ControlExtention
    {
        public delegate void InvokeHandler();

        public static void SafeInvoke(this Control control, InvokeHandler handler)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(handler);
            }
            else
            {
                handler();
            }
        }
    }
}
