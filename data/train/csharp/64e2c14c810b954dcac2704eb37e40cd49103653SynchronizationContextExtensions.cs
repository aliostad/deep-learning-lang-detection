using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace BBG.Extensions
{
    public static class SynchronizationContextExtensions
    {
        public static void Invoke(this SynchronizationContext syncCtx, Action func)
        {
            var invokeCtx = new InvokeCtx()
            {
                Function = func,
                Error = null
            };
            syncCtx.Send(InvokeFunc, invokeCtx);
            if (invokeCtx.Error != null) throw invokeCtx.Error;
        }
        public static TOut Invoke<TOut>(this SynchronizationContext syncCtx, Func<TOut> func)
        {
            var invokeCtx = new InvokeCtx<TOut>()
            {
                Function = func,
                Result = default(TOut),
                Error = null
            };
            syncCtx.Send(InvokeFunc<TOut>, invokeCtx);
            if (invokeCtx.Error != null) throw invokeCtx.Error;
            return invokeCtx.Result;
        }
        private static void InvokeFunc(object ctx)
        {
            var invokeCtx = (InvokeCtx)ctx;
            try
            {
                invokeCtx.Function();
            }
            catch (Exception ex)
            {
                invokeCtx.Error = ex;
            }
        }
        private static void InvokeFunc<TOut>(object ctx)
        {
            var invokeCtx = (InvokeCtx<TOut>)ctx;
            try
            {
                invokeCtx.Result = invokeCtx.Function();
            }
            catch (Exception ex)
            {
                invokeCtx.Error = ex;
            }
        }
        private class InvokeCtx
        {
            public Action Function;
            public Exception Error;
        }
        private class InvokeCtx<TOut>
        {
            public Func<TOut> Function;
            public TOut Result;
            public Exception Error;
        }
    }
}
