namespace bbv.ImageMapConverter
{
    using System;
    using System.Windows;
    using System.Windows.Threading;

    public static class DispatchService
    {
        public static void Invoke(Action action)
        {
            var dispatchObject = Application.Current.Dispatcher;
            if (dispatchObject == null || dispatchObject.CheckAccess())
            {
                action();
            }
            else
            {
                dispatchObject.Invoke(action, DispatcherPriority.ContextIdle);
            }
        }
    }
}