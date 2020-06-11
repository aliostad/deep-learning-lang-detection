using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CAP_JADE_Interface
{
    public delegate void SafeInvokeDelegate(System.Action action);
    public class SafeInvoke
    {
        private readonly System.Windows.Forms.Control _threadControl;

        public SafeInvoke()
        {
            _threadControl = new System.Windows.Forms.Control();
        }

        public void Invoke(System.Action action)
        {
            if (_threadControl.InvokeRequired)
                _threadControl.Invoke(new SafeInvokeDelegate(Invoke), new object[] { action });
            else if (action != null) action();
        }
    }
}
