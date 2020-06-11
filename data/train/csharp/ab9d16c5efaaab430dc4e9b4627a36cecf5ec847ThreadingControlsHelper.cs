using System.Windows.Forms;

namespace DrawEA
{
    public static class ThreadingControlsHelper
    {
        public static void SyncInvoke(
            Control control,
            MethodInvoker del)
        {
            if ((control != null) && control.InvokeRequired)
                control.Invoke(del, null);
            else
                del();
        }

        public static void SyncBeginInvoke(
            Control control,
            MethodInvoker del)
        {
            if ((control != null) && control.InvokeRequired)
                control.BeginInvoke(del, null);
            else
                del();
        }
    }
}
