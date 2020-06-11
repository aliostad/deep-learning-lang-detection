using System;
using LinFu.AOP.Interfaces;

namespace LinFuInterceptorTools
{
    public class SimpleAroundInvokeProvider : IAroundInvokeProvider
    {
        readonly IAroundInvoke _around;

        public SimpleAroundInvokeProvider(IAroundInvoke around)
        {
            _around = around;
        }

        public SimpleAroundInvokeProvider(
            IAroundInvoke around, 
            Predicate<IInvocationInfo> predicate)
        {
            _around = around;
            Predicate = predicate;
        }

        public Predicate<IInvocationInfo> Predicate { get; set; }

        public IAroundInvoke GetSurroundingImplementation(IInvocationInfo context)
        {
            if (Predicate == null)
                return _around;

            return Predicate(context) ? _around : null;
        }
    }
}