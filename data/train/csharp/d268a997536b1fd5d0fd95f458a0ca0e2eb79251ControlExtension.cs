using System.Windows.Forms;

namespace SudokuSolver.Extensions
{

    public static class ControlExtension
    {
        public static void SetTextInvoke(this Control t, string s)
        {
            if (t.InvokeRequired)
            {
                t.Invoke((MethodInvoker)delegate { t.SetTextInvoke(s); });
            }
            else
                t.Text = s;
        }
        public static void SetEnableInvoke(this Control t, bool b)
        {
            if (t.InvokeRequired)
            {
                t.Invoke((MethodInvoker)delegate { t.SetEnableInvoke(b); });
            }
            else
                t.Enabled =  b;
        }
        public static Control SetSize(this Control t, int Width, int Height)
        {
            t.Size = new System.Drawing.Size(Width, Height);
            return t;
        }
    }
}
