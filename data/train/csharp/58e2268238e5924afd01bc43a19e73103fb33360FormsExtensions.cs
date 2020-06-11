namespace System.Windows.Forms
{
    using System.ComponentModel;

    /// <summary>
    /// Description of FormsExtensions.
    /// </summary>
    public static class FormsExtensions
    {
        public static void InvokeIfNecessary(this Control control, MethodInvoker action)
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

        public static void InvokeIfNecessary(this ISynchronizeInvoke obj, MethodInvoker action)
        {
            if (obj.InvokeRequired)
            {
                var args = new object[0];
                obj.Invoke(action, args);
            }
            else
            {
                action();
            }
        }
    }
}
