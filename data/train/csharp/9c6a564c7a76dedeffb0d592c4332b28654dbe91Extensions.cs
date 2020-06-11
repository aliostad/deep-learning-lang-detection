using System.ComponentModel;
using System.Windows.Forms;

namespace StringArtDesigner {
    public static class Extensions {
        public static void InvokeIfRequired(this ISynchronizeInvoke obj, MethodInvoker action) {
            if (obj.InvokeRequired) {
                var args = new object[0];
                obj.Invoke(action, args);
            }
            else action();
        }
        public static void BeginInvokeIfRequired(this ISynchronizeInvoke obj, MethodInvoker action) {
            if (obj.InvokeRequired) {
                var args = new object[0];
                obj.BeginInvoke(action, args);
            }
            else action();
        }
    }
}