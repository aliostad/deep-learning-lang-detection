using System;
using System.Windows.Threading;

namespace MyPomodoro.MVVM
{
    public class InjectableDispatcher : IInjectableDispatcher
    {
        private readonly Dispatcher _dispatcher;

        public InjectableDispatcher(Dispatcher dispatcher)
        {
            _dispatcher = dispatcher;
        }

        public void BeginInvoke(Action d)
        {
            _dispatcher.BeginInvoke(d, DispatcherPriority.Normal);
        }

        public void BeginInvoke(Action d, params object[] args)
        {
            _dispatcher.BeginInvoke(d, DispatcherPriority.Normal, args);
        }

        public void Invoke(Action action)
        {
            _dispatcher.Invoke(action);
        }
    }
}
