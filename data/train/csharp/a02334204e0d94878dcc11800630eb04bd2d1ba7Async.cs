using System;
using System.Windows.Forms;

namespace Cudgel
{
    internal static class Async
    {
        public static void MaybeInvoke(this Control control, Action action)
        {
            if (control != null && control.InvokeRequired)
            {
                control.Invoke(action);
            }
            else
            {
                action();
            }
        }
        public static T MaybeInvoke<T>(this Control control, Func<T> func)
        {
            if (control != null && control.InvokeRequired)
            {
                return (T)(control.Invoke(func));
            }
            else
            {
                return func();
            }
        }
    }
}
