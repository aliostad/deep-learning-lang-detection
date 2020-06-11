using System;
using System.Windows.Forms;

namespace SimpleExtension
{
    /// <summary>
    ///     Class ControlExtensions.
    /// </summary>
    public static class ControlExtension
    {
        /// <summary>
        ///     Thread invoke for Control
        /// </summary>
        /// <param name="control">The control.</param>
        /// <param name="code">The code.</param>
        public static void UiThreadInvoke(this Control control, Action code)
        {
            if (control.InvokeRequired)
                control.Invoke(code);
            else
                code.Invoke();
        }

        /// <summary>
        ///     Thread invoke for UserControl
        /// </summary>
        /// <param name="control">The control.</param>
        /// <param name="code">The code.</param>
        public static void UiThreadInvoke(this UserControl control, Action code)
        {
            if (control.InvokeRequired)
                control.Invoke(code);
            else
                code.Invoke();
        }
    }
}