using System;
using System.ComponentModel;

namespace AzureTableBrowser.Extensions
{
    /// <summary>
    /// Helper class which lets safely invoke methods on form controls from another thread
    /// </summary>
    public static class IsynchronizeExtesnions
    {
        public static TResult SafeInvoke<T, TResult>(this T control, Func<T, TResult> call) where T : ISynchronizeInvoke
        {
            if (control.InvokeRequired)
            {
                var result = control.BeginInvoke(call, new object[] { control });
                var endResult = control.EndInvoke(result); return (TResult)endResult;
            }
            return call(control);
        }

        public static void SafeInvoke<T>(this T control, Action<T> call) where T : ISynchronizeInvoke
        {
            if (control.InvokeRequired) control.BeginInvoke(call, new object[] { control });
            else
                call(control);
        }
    }
}
