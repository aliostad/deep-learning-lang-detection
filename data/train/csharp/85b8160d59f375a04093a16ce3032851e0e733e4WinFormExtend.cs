using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace System.Windows.Forms
{
	public static class WinFormExtend
	{
		public static void TryInvoke(this Control control, Action action)
		{
			if (control.InvokeRequired)
			{
				control.Invoke(action);
			}
			else
				action();
		}

		public static T TryInvoke<T>(this Control control, Func<T> action)
		{
			if (control.InvokeRequired)
			{
				return (T)control.TryInvoke(new Func<T>(action));
			}
			else
				return action();
		}
	}
}
