using System;
using System.Windows.Forms;

namespace DuzyLotek
{
    public static class ControlExtensions
    {
        public static void InvokeIfRequired(this Control control, Action action)
        {
            if (control.InvokeRequired)
			{
				control.Invoke(action);
			}
            else
			{
				action();
			}
        }

        public static void InvokeIfRequired<T>(this Control control, Action<T> action, T parameter)
        {
			if (control.InvokeRequired)
			{
				control.Invoke(action, parameter);
			}
			else
			{
				action(parameter);
			}
        }
    }
}
