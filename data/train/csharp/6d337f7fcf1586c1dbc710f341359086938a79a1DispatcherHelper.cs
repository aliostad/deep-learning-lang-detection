using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Threading;

namespace AnalyzerHybrid.Model.Helpers {
    public static class DispatchService {
        public static void Invoke(Action action) {
            Dispatcher dispatchObject = Application.Current.Dispatcher;
            if (dispatchObject == null || dispatchObject.CheckAccess()) {
                action();
            } else {
                dispatchObject.Invoke(action);
            }
        }
    }
}
