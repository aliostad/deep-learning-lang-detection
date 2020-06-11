using System;

namespace SharpMock.Core.Interception.InterceptionStrategies
{
    public class BeforeCall : IInterceptionStrategy
    {
        private readonly Function<Delegate> callBinder;

        public BeforeCall(Function<Delegate> callBinder)
        {
            this.callBinder = callBinder;
        }

        public void Intercept(IInvocation invocation)
        {
            var invokeBefore = new InvokeWithInvocation(callBinder);
            invokeBefore.Intercept(invocation);

            var invokeCall = new InvokeOriginalCall();
            invokeCall.Intercept(invocation);
        }
    }
}