using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ExplosionArithmetics.App.Util
{
    public static class FormUtil
    {
        public static void HandlInvoke(Control control, Action action)
        {
            var invoker = new MethodInvoker(action.Invoke);
            if (control.InvokeRequired)
            {
                control.Invoke(invoker);
            }
            else
            {
                invoker.Invoke();
            }
        }
    }
}
