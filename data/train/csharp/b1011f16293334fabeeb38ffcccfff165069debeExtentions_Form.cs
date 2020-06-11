using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Richard
{
    static class ControlExtensions
    {
        static public void UIThread(this Control control, Action code)
        {
            if (control.InvokeRequired)
            {
                control.BeginInvoke(code);
            }
            else
            {
                code.Invoke();
            }
        }

        static public void UIThreadBlocking(this Control control, Action code)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(code);
            }
            else
            {
                code.Invoke();
            }
        }
    }
}
