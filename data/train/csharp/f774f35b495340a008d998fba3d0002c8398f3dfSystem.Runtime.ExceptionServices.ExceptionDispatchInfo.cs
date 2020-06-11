using System;
using System.Collections.Generic;
using System.Reactive.Linq;
using System.Reactive.Threading.Tasks;
using MS.Core;

namespace System.Runtime.ExceptionServices
{
    public static class __ExceptionDispatchInfo
    {
        public static IObservable<System.Runtime.ExceptionServices.ExceptionDispatchInfo> Capture(
            IObservable<System.Exception> source)
        {
            return Observable.Select(source,
                (sourceLambda) => System.Runtime.ExceptionServices.ExceptionDispatchInfo.Capture(sourceLambda));
        }


        public static IObservable<System.Reactive.Unit> Throw(
            this IObservable<System.Runtime.ExceptionServices.ExceptionDispatchInfo> ExceptionDispatchInfoValue)
        {
            return
                Observable.Do(ExceptionDispatchInfoValue,
                    (ExceptionDispatchInfoValueLambda) => ExceptionDispatchInfoValueLambda.Throw()).ToUnit();
        }


        public static IObservable<System.Exception> get_SourceException(
            this IObservable<System.Runtime.ExceptionServices.ExceptionDispatchInfo> ExceptionDispatchInfoValue)
        {
            return Observable.Select(ExceptionDispatchInfoValue,
                (ExceptionDispatchInfoValueLambda) => ExceptionDispatchInfoValueLambda.SourceException);
        }
    }
}