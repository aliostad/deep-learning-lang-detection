using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Scada.Data.Client
{
    static class ControlInvoke
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
