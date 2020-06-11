namespace Common.WPF
{
    using System;
    using System.Windows.Threading;
    using Common.Library;

    public class DispatcherInvoker : IDispatcherInvoker
    {
        private readonly Dispatcher _dispatchObject;

        public DispatcherInvoker(Dispatcher dispatchObject)
        {
            _dispatchObject = dispatchObject;
        }

        public void Invoke(Action action)
        {
            if (_dispatchObject == null || _dispatchObject.CheckAccess())
            {
                action();
            }
            else
            {
                _dispatchObject.Invoke(action);
            }
        }
    }
}
