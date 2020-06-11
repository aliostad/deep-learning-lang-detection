using System;
using System.Windows.Forms;

namespace CTLite {
    static class ControlExtensions {
        static public void UIThread(this Control control, Action code) {
            if (control.InvokeRequired) {
                control.BeginInvoke(code);
                return;
            }
            code.Invoke();
        }

        static public void UIThreadInvoke(this Control control, Action code) {
            if (control.InvokeRequired) {
                control.Invoke(code);
                return;
            }
            code.Invoke();
        }
    }
}