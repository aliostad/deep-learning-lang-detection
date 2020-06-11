using System;
using System.Windows;

namespace ResxCleaner.Services
{
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
                dispatchObject.Invoke(action);
            }
        }

        public static void BeginInvoke(Action action)
        {
            var dispatchObject = Application.Current.Dispatcher;

            dispatchObject.BeginInvoke(action);
        }
    }
}
