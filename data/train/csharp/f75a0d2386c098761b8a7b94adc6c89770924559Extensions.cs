using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace TheCodeHaven.SauceClassGeneration
{
    public static class Extensions
    {
        public static R InvokeOnMe<T, R>(this T controlToInvokeOn, Func<R> code) where T : Control
        {
            if (controlToInvokeOn.Dispatcher.Thread != System.Threading.Thread.CurrentThread)
                return (R)controlToInvokeOn.Dispatcher.Invoke(code);
            else
                return code();
        }

        public static void InvokeOnMe<T>(this T controlToInvokeOn, Action code) where T : Control
        {
            if (controlToInvokeOn.Dispatcher.Thread != System.Threading.Thread.CurrentThread)
                controlToInvokeOn.Dispatcher.Invoke(code);
            else
                code();
        }
    }
}
