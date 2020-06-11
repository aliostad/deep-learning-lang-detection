using System;
using LinFu.AOP.Interfaces;
using WPFCoreTools;

namespace LinFuInterceptorTools
{
    public class ViewModelInvokeWrapper<T> : IInvokeWrapper where T : IViewModel
    {
        readonly T _target;

        public ViewModelInvokeWrapper(T target)
        {
            _target = target;
        }

        public void BeforeInvoke(IInvocationInfo info)
        {
            Console.WriteLine("Before Invoke - {0}", info.TargetMethod);
        }

        public void AfterInvoke(IInvocationInfo info, object returnValue)
        {
             Console.WriteLine("After Invoke - {0}", info.TargetMethod);
        }

        public object DoInvoke(IInvocationInfo info)
        {
            Console.WriteLine("Do Invoke - {0}", info.TargetMethod);
            object result = info.TargetMethod.Invoke(_target, info.Arguments);
            return result;
        }
    }
}