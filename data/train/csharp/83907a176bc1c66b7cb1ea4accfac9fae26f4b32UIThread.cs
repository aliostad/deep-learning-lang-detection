using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Threading;

namespace ClassLibraryHelper.Threading
{
    public class UIThread
    {
        public static void Invoke(Action action)
        {
            Invoke(action, DispatcherPriority.Send);
        }

        public static void BeginInvoke(Action action)
        {
            BeginInvoke(action, DispatcherPriority.Send);
        }

        public static void BeginInvoke(Action action, DispatcherPriority priority)
        {
            Application.Current.Dispatcher.BeginInvoke(priority, action);
        }

        public static void Invoke(Action action, DispatcherPriority priority)
        {
            Application.Current.Dispatcher.Invoke(priority, action);
        }
    }
}
