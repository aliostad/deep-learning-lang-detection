using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Db2File.Code.Common
{
    static class ControlExtensions
    {
        public static void Invoke(this Control control, Action action)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(action);
            }
            else
            {
                action();
            }
        }

        public static void Invoke<T>(this Control control, Action<T> action, T arg)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(action, arg);
            }
            else
            {
                action(arg);
            }
        }
    }
}
