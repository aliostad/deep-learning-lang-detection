using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Windows.Forms;

namespace Wolfje.Plugins.SEconomy.Forms {
    public static class FormExtensions {

        /// <summary>
        /// Lambda wrapper for control.invoke, used to invoke things on the main GUI thread.
        /// </summary>
        internal static void MainThreadInvoke(this Control control, Action func) {
            if (control.InvokeRequired) {
                control.Invoke(func);
            } else {
                func();
            }
        }

    }
}
