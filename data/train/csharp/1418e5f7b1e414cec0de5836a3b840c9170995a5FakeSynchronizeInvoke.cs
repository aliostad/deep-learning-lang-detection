using System;
using System.ComponentModel;
using System.Windows.Forms;

namespace GameMonitorV2.Tests.Fakes
{
    public class FakeSynchronizeInvoke : ISynchronizeInvoke
    {
        public FakeSynchronizeInvoke(bool setInvoke)
        {
            InvokeRequired = setInvoke;
        }

        public IAsyncResult BeginInvoke(Delegate method, object[] args)
        {
            ((MethodInvoker) method)();
            return null;
        }

        public object EndInvoke(IAsyncResult result)
        {
            throw new NotImplementedException();
        }

        public object Invoke(Delegate method, object[] args)
        {
            throw new NotImplementedException();
        }

        public bool InvokeRequired { get; private set; }
    }
}