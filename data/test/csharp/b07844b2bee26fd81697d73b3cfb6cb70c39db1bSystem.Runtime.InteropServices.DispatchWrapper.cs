using System;
using System.Collections.Generic;
using System.Reactive.Linq;
using System.Reactive.Threading.Tasks;
using MS.Core;

namespace System.Runtime.InteropServices
{
    public static class __DispatchWrapper
    {
        public static IObservable<System.Object> get_WrappedObject(
            this IObservable<System.Runtime.InteropServices.DispatchWrapper> DispatchWrapperValue)
        {
            return Observable.Select(DispatchWrapperValue,
                (DispatchWrapperValueLambda) => DispatchWrapperValueLambda.WrappedObject);
        }
    }
}