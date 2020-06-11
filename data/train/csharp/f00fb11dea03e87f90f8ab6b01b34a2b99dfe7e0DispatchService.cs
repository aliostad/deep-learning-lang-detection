using System;
using System.Windows;
using System.Windows.Threading;

namespace Artisan.MVVMShared
{
    /// <summary>
    /// This class is used to make thread safe calls on
    /// WPF components from the ViewModels in MVVM
    /// </summary>
    public static class DispatchService
    {
        public static void Invoke(Action action)
        {
            Dispatcher dispatchObject = Application.Current.Dispatcher;
            if (dispatchObject == null || dispatchObject.CheckAccess())
            {
                action();
            }
            else
            {
                dispatchObject.Invoke(action);
            }
        }
    }
}
