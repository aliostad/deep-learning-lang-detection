using System;
using System.Windows.Forms;

namespace XTools {
    public static class WindowsFormsTool {

        public static void InvokeAction(this Control control, Action action) {
            if (control.InvokeRequired)
                control.Invoke(action);
            else
                action();
        } // end method



        public static T InvokeFunc<T>(this Control control, Func<T> func) {
            if (control.InvokeRequired)
                return (T)control.Invoke(func);
            else
                return func();
        } // end method

    } // end class
} // end namespace