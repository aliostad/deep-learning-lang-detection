using System;
using System.ComponentModel;
using System.Windows.Forms;

namespace DLog.NET.Extenstions
{
    public static class Extensions
    {
        //public static void InvokeIfRequired<T>(this T c, Action<T> action) where T : Control
        //{
        //    if (c.InvokeRequired)
        //        c.Invoke(new Action(() => action(c)));
        //    else
        //        action(c);
        //}

        public static void InvokeIfRequired(this ISynchronizeInvoke obj,
                                         MethodInvoker action)
        {
            if (obj.InvokeRequired)
            {
                var args = new object[0];
                obj.Invoke(action, args);
            }
            else
            {
                action();
            }
        }

    }
}
