using System;
using LinFu.AOP.Interfaces;

namespace LinFuInterceptorTools
{
    public class SimpleAroundInvoke : IAroundInvoke
    {
        public Action<IInvocationInfo, object> AfterInvokeDelegate = delegate { };
        public Action<IInvocationInfo> BeforeInvokeDelegate = delegate { };

        public void AfterInvoke(IInvocationInfo info, object returnValue)
        {
            AfterInvokeDelegate(info, returnValue);
        }

        public void BeforeInvoke(IInvocationInfo info)
        {
            BeforeInvokeDelegate(info);
        }

    }
}