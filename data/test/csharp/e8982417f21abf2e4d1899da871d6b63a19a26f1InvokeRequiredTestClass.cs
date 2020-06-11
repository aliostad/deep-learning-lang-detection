using System;
using System.ComponentModel;
using System.Threading;
using DelftTools.Utils.Aop;

namespace DelftTools.TestUtils.TestClasses
{
    public class InvokeRequiredTestClass : ISynchronizeInvoke
    {
        private readonly Thread mainThread;

        public InvokeRequiredTestClass()
        {
            mainThread = Thread.CurrentThread;
        }

        public int CallsUsingInvokeCount { get; private set; }

        public int CallsWithoutInvokeCount { get; private set; }

        #region ISynchronizeInvoke Members

        public IAsyncResult BeginInvoke(Delegate method, object[] args)
        {
            return null;
        }

        public object EndInvoke(IAsyncResult result)
        {
            return null;
        }

        public object Invoke(Delegate method, object[] args)
        {
            CallsUsingInvokeCount++;

            method.Method.Invoke(this, args);

            return null;
        }

        public bool InvokeRequired
        {
            get { return Thread.CurrentThread != mainThread; }
        }

        #endregion

        [InvokeRequired]
        public void SynchronizedMethod()
        {
            if(!InvokeRequired)
            {
                CallsWithoutInvokeCount++;
            }
        }
    }
}