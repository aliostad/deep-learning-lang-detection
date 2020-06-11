using System;
using System.Windows.Forms;

internal static class ControlExtensions
{
    public static void InvokeAuto(this Control control, Action action)
    {
        if (control.InvokeRequired)
            control.Invoke((MethodInvoker)(() => action()));
        else
            action.Invoke();
    }

    public static void InvokeAuto(this UserControl control, Action action)
    {
        if (control.InvokeRequired)
            control.Invoke((MethodInvoker)(() => action()));
        else
            action.Invoke();
    }
}