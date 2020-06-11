namespace System.Windows.Threading
{
    public sealed class DispatcherWrapper : IDispatcher
    {
        private readonly Dispatcher dispatcher;

        public DispatcherWrapper(Dispatcher dispatcher)
        {
            this.dispatcher = dispatcher;
        }

        public bool CheckAccess()
        {
            return dispatcher.CheckAccess();
        }

        public DispatcherOperation BeginInvoke(Delegate method, params object[] args)
        {
            return dispatcher.BeginInvoke(method, args);
        }

        public void Invoke(Action callback)
        {
            dispatcher.Invoke(callback);
        }

        public TResult Invoke<TResult>(Func<TResult> callback)
        {
            return dispatcher.Invoke(callback);
        }

        public void InvokeShutdown()
        {
            dispatcher.InvokeShutdown();
        }
    }
}