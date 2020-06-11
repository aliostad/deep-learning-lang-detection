using System;

namespace SharpMock.Core.Interception.InterceptionStrategies
{
    public class AfterCall : IInterceptionStrategy
    {
        private readonly Function<Delegate> callBinder;

        public AfterCall(Function<Delegate> callBinder)
        {
            this.callBinder = callBinder;
        }

        public void Intercept(IInvocation invocation)
        {
            var invokeCall = new InvokeOriginalCall();
            invokeCall.Intercept(invocation);

            var invokeAfter = new InvokeWithInvocation(callBinder);
            invokeAfter.Intercept(invocation);
        }
    }
}