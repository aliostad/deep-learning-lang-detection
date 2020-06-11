using System;
using System.Windows.Forms;

namespace FarpostMultiThreadParser
{
    static class Helper
    {
        internal static void InvokeEx(this Control control, Action action)
        {
            if (control.InvokeRequired)
                control.Invoke(action);
            else
                action();
        }

        internal static void InvokeForm(this Form form, Action action)
        {
            if (form.InvokeRequired)
                form.Invoke(action);
            else
                action();
        }
    }
}
