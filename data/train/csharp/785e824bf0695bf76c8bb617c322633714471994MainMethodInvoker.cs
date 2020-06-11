namespace DelegateOfMainExample.MethodInvokers
{
    using System;

    public class MainMethodInvoker
    {
        #region MyImplementation
        /*  I could not find a way to resolve the ambiguous call when the method signatures were of Func<string[], int> and Action<string[]>
         *  So I had to better define their names as opposed to naming them all InvokeMethod()
         *  This is how I would implement it but below this is another option
         */
        public void InvokeActionMethod(Action methodToInvoke)
        {
            methodToInvoke();
        }

        public void InvokeActionMethod(Action<string[]> methodToInvoke, string[] args)
        {
            methodToInvoke(args);
        }

        public int InvokeFunctionMethod(Func<int> methodToInvoke)
        {
            return methodToInvoke();
        }

        public int InvokeFunctionMethod(Func<string[], int> methodToInvoke, string[] args)
        {
            return methodToInvoke(args);
        }
        #endregion

        #region AlternativeOption

        public void InvokeMethod(Action methodToInvoke)
        {
            methodToInvoke();
        }

        //Delegate the argument type to alter resolution (though from what I recall this isn't/wasn't desired) *(see below)
        public void InvokeMethod(Action<string[]> methodToInvoke, string[] args)
        {
            methodToInvoke(args);
        }

        public TReturnValue InvokeMethod<TReturnValue>(Func<TReturnValue> methodToInvoke)
        {
            return methodToInvoke();
        }

        public TReturnValue InvokeMethod<TReturnValue>(Func<string[], TReturnValue> methodToInvoke, string[] args)
        {
            return methodToInvoke(args);
        }

        // *(continued)I thought of a few more options if the above wasn't acceptable either
        public void InvokeMethod(Func<int> methodToInvoke, out int returnValue){
            returnValue = methodToInvoke();
        }
        public void InvokeMethod(Func<string[], int> methodToInvoke, string[] args, out int returnValue)
        {
            returnValue = methodToInvoke(args);
        }

        #endregion
    }
}
