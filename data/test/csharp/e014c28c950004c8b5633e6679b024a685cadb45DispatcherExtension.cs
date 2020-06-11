using System;
using System.Windows.Threading;

namespace Tools.Extension
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
            dispatcher?.Invoke(new Action(() =>
            {
                action?.Invoke(param);
            }));
        }
    }
}
