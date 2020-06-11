namespace xofz.UI.WPF.Internal
{
    using System;
    using System.ComponentModel;
    using System.Windows.Threading;

    internal sealed class DispatcherSynchronizeInvoke : ISynchronizeInvoke
    {
        public DispatcherSynchronizeInvoke(Dispatcher dispatcher)
        {
            this.dispatcher = dispatcher;
        }

        public bool InvokeRequired => this.dispatcher.CheckAccess();

        public IAsyncResult BeginInvoke(Delegate method, object[] args)
        {
            this.dispatcher.BeginInvoke(method, args);

            return default(IAsyncResult);
        }

        public object EndInvoke(IAsyncResult result)
        {
            return null;
        }

        public object Invoke(Delegate method, object[] args)
        {
            return this.dispatcher.Invoke(method, args);
        }

        private readonly Dispatcher dispatcher;
    }
}
