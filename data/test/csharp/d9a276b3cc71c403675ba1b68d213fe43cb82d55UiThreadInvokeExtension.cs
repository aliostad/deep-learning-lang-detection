using System;
using System.Windows.Forms;

namespace StockExchangeGame.UiThreadInvoke
{
    // ReSharper disable once UnusedMember.Global
    public static class UiThreadInvokeExtension
    {
        // ReSharper disable once UnusedMember.Global
        public static void UiThread(this Control control, Action code)
        {
            if (control.InvokeRequired)
            {
                control.BeginInvoke(code);
                return;
            }
            code.Invoke();
        }

        // ReSharper disable once UnusedMember.Global
        public static void UiThreadInvoke(this Control control, Action code)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(code);
                return;
            }
            code.Invoke();
        }
    }
}