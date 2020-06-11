using System;
using System.Windows.Forms;

namespace AlphaBetaCut
{
    public static class HandleCtrlInOtherThread
    {
        public static void HandleCtrlInBackGroundThread(Control ctrl, Action action)
        {
            if (ctrl.InvokeRequired)
            {
                ctrl.Invoke(action);
            }
            else
            {
                action.Invoke();
            }
        }

        public static void HandleCtrlInBackGroundThread<T>(
                Control ctrl,
                Action<T> action,
                T t)
        {
            if (ctrl.InvokeRequired)
            {
                ctrl.Invoke(action, t);
            }
            else
            {
                action.Invoke(t);
            }
        }
    }
}
