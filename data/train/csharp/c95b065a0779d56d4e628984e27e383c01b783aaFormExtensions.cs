using System.Windows.Forms;

namespace WindowsVolumeOSD.Extensions
{
    public static class FormExtensions
    {
        /// <summary>
        /// Extension to simplify the InvokeRequired/Invoke pattern
        /// http://stackoverflow.com/questions/2367718/automating-the-invokerequired-code-pattern
        /// </summary>
        /// <param name="control"></param>
        /// <param name="action"></param>
        public static void InvokeIfRequired(this Control control, MethodInvoker action)
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
    }
}
