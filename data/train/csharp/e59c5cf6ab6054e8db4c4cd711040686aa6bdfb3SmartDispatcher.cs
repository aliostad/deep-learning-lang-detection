using System;
using System.Windows.Threading;

namespace Heathmill.FixAT.Client
{
    public class SmartDispatcher
    {
        public static Dispatcher Dispatcher;

        public static void SetDispatcher(Dispatcher d)
        {
            Dispatcher = d;
        }

        public static void Invoke(Action action)
        {
            if (Dispatcher == null)
                action.Invoke();
            else
                Dispatcher.Invoke(action);
        }

        public static void Invoke<T>(Action<T> action, T arg)
        {
            if (Dispatcher == null)
                action.Invoke(arg);
            else
                Dispatcher.Invoke(action, arg);
        }

        public static void Invoke<T1, T2>(Action<T1, T2> action, T1 arg1, T2 arg2)
        {
            if (Dispatcher == null)
                action.Invoke(arg1, arg2);
            else
                Dispatcher.Invoke(action, arg1, arg2);
        }
    }
}
