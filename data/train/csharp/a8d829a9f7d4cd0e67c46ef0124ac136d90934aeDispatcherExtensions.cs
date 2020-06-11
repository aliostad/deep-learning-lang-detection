using System;
using System.Diagnostics.Contracts;

namespace LordJZ.Threading
{
    public static class DispatcherExtensions
    {
        public static void InvokeOrDo(this IDispatcher dispatcher, Action action)
        {
            Contract.Requires(action != null, "action");

            if (dispatcher != null && dispatcher.InvokeRequired)
                dispatcher.Invoke(action);
            else
                action();
        }

        public static T InvokeOrDo<T>(this IDispatcher dispatcher, Func<T> func)
        {
            Contract.Requires(func != null, "func");

            if (dispatcher != null && dispatcher.InvokeRequired)
                return dispatcher.Invoke(func);
            else
                return func();
        }

        public static void BeginInvokeOrDo(this IDispatcher dispatcher, Action action)
        {
            Contract.Requires(action != null, "action");

            if (dispatcher != null && dispatcher.InvokeRequired)
                dispatcher.BeginInvoke(action);
            else
                action();
        }
    }
}
