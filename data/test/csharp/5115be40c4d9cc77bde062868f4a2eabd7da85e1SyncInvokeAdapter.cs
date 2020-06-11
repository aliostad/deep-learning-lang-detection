namespace Intel.UPNP
{
    using System;
    using System.Threading;

    public sealed class SyncInvokeAdapter
    {
        public UPnPArgument[] Arguments = new UPnPArgument[0];
        public UPnPService.UPnPServiceInvokeErrorHandler InvokeErrorHandler = null;
        public UPnPInvokeException InvokeException = null;
        public UPnPService.UPnPServiceInvokeHandler InvokeHandler = null;
        public ManualResetEvent Result = new ManualResetEvent(false);
        public object ReturnValue = null;

        public SyncInvokeAdapter()
        {
            this.InvokeHandler = new UPnPService.UPnPServiceInvokeHandler(this.InvokeSink);
            this.InvokeErrorHandler = new UPnPService.UPnPServiceInvokeErrorHandler(this.InvokeFailedSink);
        }

        private void InvokeFailedSink(UPnPService sender, string MethodName, UPnPArgument[] Args, UPnPInvokeException e, object Tag)
        {
            this.Arguments = Args;
            this.InvokeException = e;
            this.Result.Set();
        }

        private void InvokeSink(UPnPService sender, string MethodName, UPnPArgument[] Args, object Val, object Tag)
        {
            this.ReturnValue = Val;
            this.Arguments = Args;
            this.Result.Set();
        }
    }
}

