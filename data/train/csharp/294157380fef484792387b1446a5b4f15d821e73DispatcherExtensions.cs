using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Threading;

namespace Metro_Tables.Code {
	public static class DispatcherExtensions {
		public static void Dispatcher(this UIElement element, Action invokeAction) {
			if (element.Dispatcher.CheckAccess()) {
				invokeAction.Invoke();
			}
			else element.Dispatcher.Invoke(invokeAction);
		}
		public static void Dispatcher(this Application app, Action invokeAction) {
			if (app.Dispatcher.CheckAccess()) {
				invokeAction.Invoke();
			}
			else app.Dispatcher.Invoke(invokeAction);
		}
	}
}
