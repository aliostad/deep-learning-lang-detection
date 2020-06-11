namespace System.Windows.Threading
{
    public sealed partial class Dispatcher
    {
        /// <summary>
        /// Is current thread the UI thread.
        /// </summary>
        public bool CheckAccess()
        {
            return true;
        }

        /// <summary>
        /// Invoke in UI thread.
        /// </summary>
        public void BeginInvoke(Action a)
        {
            a.Invoke();
        }

        /// <summary>
        /// Invoke in UI thread.
        /// </summary>
        public void BeginInvoke(Delegate d, params object[] args)
        {
            d.DynamicInvoke(args);
        }

        private static object InvokeInternal(Delegate d, object[] args)
        {
            return d.DynamicInvoke(args);
        }
    }
}