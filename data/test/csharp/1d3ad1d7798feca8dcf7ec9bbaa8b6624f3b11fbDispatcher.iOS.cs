using Foundation;
using System.Threading;

namespace System.Windows.Threading
{
    public partial class Dispatcher
    {
        private static readonly NSObject invoker = new NSObject();

        /// <summary>
        /// Invoke in UI thread.
        /// </summary>
        public void BeginInvoke(Action a)
        {
            invoker.BeginInvokeOnMainThread(a.Invoke);
        }

        /// <summary>
        /// Invoke in UI thread.
        /// </summary>
        public void BeginInvoke(Delegate d, params object[] args)
        {
            invoker.BeginInvokeOnMainThread(new DelegateWrapper(d, args).Invoke);
        }

        /// <summary>
        /// Is current thread the UI thread.
        /// </summary>
        public bool CheckAccess()
        {
            return SynchronizationContext.Current != null;
        }

        private static object InvokeInternal(Delegate d, object[] args)
        {
            var wrapper = new DelegateWrapper(d, args);
            invoker.InvokeOnMainThread(wrapper.Invoke);
            return wrapper.Result;
        }

        private class DelegateWrapper
        {
            private readonly Delegate target;
            private readonly object[] args;
            private object result;

            public DelegateWrapper(Delegate target, object[] args)
            {
                this.target = target;
                this.args = args;
            }

            public object Result
            {
                get { return result; }
            }

            public void Invoke()
            {
                result = target.DynamicInvoke(args);
            }
        }
    }
}
