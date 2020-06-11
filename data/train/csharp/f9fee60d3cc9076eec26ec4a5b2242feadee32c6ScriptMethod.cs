using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Management.Automation;
using System.Windows.Forms;

namespace de.mastersign.shell
{
    public class ScriptMethod
    {
        public ScriptBlock Block { get; private set; }

        public static implicit operator ScriptMethod(ScriptBlock block)
        {
            return new ScriptMethod(block);
        }

        public static implicit operator ScriptBlock(ScriptMethod method)
        {
            return method.Block;
        }

        public static explicit operator ThreadStart(ScriptMethod method)
        {
            return method.SimpleInvoke;
        }

        public static explicit operator EventHandler(ScriptMethod method)
        {
            return method.EventHandlerInvoke;
        }

        public ScriptMethod(ScriptBlock block)
        {
            Block = block;
        }

        public void SimpleInvoke()
        {
            Block.Invoke();
        }

        public void EventHandlerInvoke(object sender, EventArgs ea)
        {
            Block.Invoke(sender, ea);
        }

        public void SendOrPostCallbackInvoke(object state)
        {
            Block.Invoke(state);
        }

        public Thread CreateThread()
        {
            return new Thread(SimpleInvoke);
        }

        public static Thread CreateThread(ScriptMethod method)
        {
            return method.CreateThread();
        }

        public void InvokeForGuiSync(Control control)
        {
            if (control != null && !control.IsDisposed && control.InvokeRequired)
            {
                try
                {
                    control.Invoke((MethodInvoker)SimpleInvoke);
                }
                catch (InvalidOperationException)
                {
                    SimpleInvoke();
                }
            }
            else
            {
                SimpleInvoke();
            }
        }

        public void InvokeForGuiAsync(Control control)
        {
            if (control.InvokeRequired)
            {
                control.BeginInvoke((MethodInvoker) SimpleInvoke);
            }
            else
            {
                SimpleInvoke();
            }
        }
    }
}
