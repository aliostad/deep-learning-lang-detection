using System;
using System.Reflection;
using Castle.DynamicProxy;

namespace Proxii.Internal.Interceptors
{
	public class AfterInvokeInterceptor : IInterceptor
	{
		private readonly Action _afterInvoke;
        private readonly Action<MethodInfo> _afterInvokeMethodInfo;
        private readonly Action<MethodInfo, object[]> _afterInvokeMethodInfoArgs;

		public AfterInvokeInterceptor(Action afterInvoke)
		{
			_afterInvoke = afterInvoke;
		}

        public AfterInvokeInterceptor(Action<MethodInfo> afterInvoke)
        {
            _afterInvokeMethodInfo = afterInvoke;
        }

        public AfterInvokeInterceptor(Action<MethodInfo, object[]> afterInvoke)
        {
            _afterInvokeMethodInfoArgs = afterInvoke;
        }

		public void Intercept(IInvocation invocation)
		{
			invocation.Proceed();

            if (_afterInvoke != null)
                _afterInvoke();
            else if (_afterInvokeMethodInfo != null)
                _afterInvokeMethodInfo(invocation.Method);
            else
                _afterInvokeMethodInfoArgs(invocation.Method, invocation.Arguments);
		}
	}
}
