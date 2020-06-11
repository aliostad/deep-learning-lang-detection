using System;
using System.ServiceModel.DomainServices.Client;

namespace WebManagement.Common
{
    public class InvokeOperationEventArgs : ResultsArgs
    {
        public InvokeOperationEventArgs(Exception ex)
            : base(ex)
        {
            InvokeOp = null;
        }

        public InvokeOperationEventArgs(InvokeOperation invokeOp)
            : base(null)
        {
            InvokeOp = invokeOp;
        }

        public InvokeOperationEventArgs(InvokeOperation invokeOp, Exception ex)
            : base(ex)
        {
            InvokeOp = invokeOp;
        }

        public InvokeOperation InvokeOp { get; private set; }
    }
}