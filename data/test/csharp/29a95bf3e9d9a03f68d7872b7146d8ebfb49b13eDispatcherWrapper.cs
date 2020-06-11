using System;
using System.Windows.Threading;

namespace Hestia.UI.Model
{
    public class DispatcherWrapper : IDispatcher
    {
        private readonly Dispatcher _dispatcher;

        public DispatcherWrapper(Dispatcher dispatcher)
        {
            _dispatcher = dispatcher;
        }

        public void Invoke(Action actionToInvoke, DispatcherPriority priority)
        {
            _dispatcher.Invoke(actionToInvoke, priority);
        }

        public void Invoke(Action actionToInvoke)
        {
            _dispatcher.Invoke(actionToInvoke);
        }
    }
}