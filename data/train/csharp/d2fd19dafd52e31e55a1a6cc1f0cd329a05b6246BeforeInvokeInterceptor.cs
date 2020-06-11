using System;
using System.Reflection;
using Castle.DynamicProxy;

namespace Proxii.Internal.Interceptors
{
    public class BeforeInvokeInterceptor : IInterceptor
    {
        private readonly Action _beforeInvoke;
        private readonly Action<MethodInfo> _beforeInvokeMethodInfo;
        private readonly Action<MethodInfo, object[]> _beforeInvokeMethodInfoArgs;

        public BeforeInvokeInterceptor(Action beforeInvoke)
        {
            _beforeInvoke = beforeInvoke;
        }

        public BeforeInvokeInterceptor(Action<MethodInfo> beforeInvoke)
        {
            _beforeInvokeMethodInfo = beforeInvoke;
        }

        public BeforeInvokeInterceptor(Action<MethodInfo, object[]> beforeInvoke)
        {
            _beforeInvokeMethodInfoArgs = beforeInvoke;
        }

        public void Intercept(IInvocation invocation)
        {
            if (_beforeInvoke != null)
                _beforeInvoke();
            else if (_beforeInvokeMethodInfo != null)
                _beforeInvokeMethodInfo(invocation.Method);
            else
                _beforeInvokeMethodInfoArgs(invocation.Method, invocation.Arguments);

            invocation.Proceed();
        }
    }
}
