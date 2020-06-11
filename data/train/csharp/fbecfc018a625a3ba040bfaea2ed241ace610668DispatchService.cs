using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Threading;

namespace ResxUnusedFinder
{
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

        public static void BeginInvoke(Action action)
        {
            Dispatcher dispatchObject = Application.Current.Dispatcher;

            dispatchObject.BeginInvoke(action);
        }
    }
}
