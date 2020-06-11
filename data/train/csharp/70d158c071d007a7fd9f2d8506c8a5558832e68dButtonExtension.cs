using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ECM_Gui.ClassExtension
{
    public static class ButtonExtension
    {

        public static void SetTextInvoke(this ButtonBase b, String c)
        {
            if (b.InvokeRequired)
                b.Invoke((MethodInvoker)delegate { b.SetTextInvoke(c); });
            else
                b.Text = c;
        }
        public static void SetEnabledInvoke(this ButtonBase b, bool v)
        {
            if (b.InvokeRequired)
                b.Invoke((MethodInvoker)delegate { b.SetEnabledInvoke(v); });
            else
                b.Enabled = v;
        }

    }
}
