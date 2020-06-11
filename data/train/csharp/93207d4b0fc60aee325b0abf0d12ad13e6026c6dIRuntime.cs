using System;
//using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;

namespace FoundationLibrary
{
    public interface IRuntime<T>:IFactory
    {
        #region Events
            event ErrorHandler<T> OnRuntimeError;
            event EventHandler<T> OnRuntimeEvent;
            event BeginInvokeEventHandler<T> OnRuntimeBeginInvokeEvent;
            event EndInvokeEventHandler<T> OnRuntimeEndInvokeEvent;
            event InvokeErrorEventHandler<T> OnRuntimeInvokeErrorEvent;
        #endregion
    }
}
