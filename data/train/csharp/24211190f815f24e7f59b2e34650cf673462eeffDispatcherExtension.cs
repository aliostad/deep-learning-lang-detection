using System;
using System.Collections;
using System.Threading;
using System.Windows.Threading;

namespace Excalibur.Extensions
{
    static public class DispatcherExtension
    {
        static public void InvokeAction(this Dispatcher dispatcher, Action action)
        {
            dispatcher?.Invoke(new Action(() =>
            {
                action?.Invoke();
            }));
        }

        static public void InvokeAction<T>(this Dispatcher dispatcher, Action<T> action, T param)
        {
            if (dispatcher.Thread != Thread.CurrentThread)
            {

            }
            dispatcher?.Invoke(new Action(() =>
            {
                action?.Invoke(param);
            }));
        }
    }
}
