using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;

namespace TaxiOnline.Toolkit.Threading.Patterns
{
    public class TimeoutHelper
    {
        public static bool InvokeWithTimeout<T>(Func<T> functionToInvoke, TimeSpan timeout, out T result)
        {
            Task<T> taskToInvoke = Task.Factory.StartNew(functionToInvoke);
            //taskToInvoke.ContinueWith(t => t.Dispose());
            if (taskToInvoke.Wait(timeout))
            {
                CheckTaskResult(taskToInvoke);
                result = taskToInvoke.Result;
                return true;
            }
            else
            {
                result = default(T);
                return false;
            }
        }

        public static bool InvokeWithTimeout<T>(Func<T> functionToInvoke, CancellationToken cancellation, out T result)
        {
            EventWaitHandle waitTask = new EventWaitHandle(false, EventResetMode.ManualReset);
            Task<T> taskToInvoke = Task.Factory.StartNew(WrapFunctionToInvoke<T>(functionToInvoke, waitTask));

            if (WaitHandle.WaitAny(new WaitHandle[] { waitTask, cancellation.WaitHandle }) == 0)
            {
                CheckTaskResult(taskToInvoke);
                result = taskToInvoke.Result;
                return true;
            }
            else
            {
                result = default(T);
                return false;
            }
        }

        public static bool InvokeWithTimeout<T>(Func<T> functionToInvoke, CancellationToken cancellation, TimeSpan timeout, out T result)
        {
            EventWaitHandle waitTask = new EventWaitHandle(false, EventResetMode.ManualReset);
            Task<T> taskToInvoke = Task.Factory.StartNew(WrapFunctionToInvoke<T>(functionToInvoke, waitTask));
            //taskToInvoke.ContinueWith(t => t.Dispose(), TaskContinuationOptions.OnlyOnFaulted);
            if (WaitHandle.WaitAny(new WaitHandle[] { waitTask, cancellation.WaitHandle }, timeout) == 0)
            {
                CheckTaskResult(taskToInvoke);
                result = taskToInvoke.Result;
                return true;
            }
            else
            {
                result = default(T);
                return false;
            }
        }

        private static void CheckTaskResult(Task taskToInvoke)
        {
            AggregateException aggregateException = taskToInvoke.Exception as AggregateException;
            if (aggregateException != null)
                throw aggregateException.InnerException;
        }

        private static Func<T> WrapFunctionToInvoke<T>(Func<T> functionToInvoke, EventWaitHandle waitTask)
        {
            return () =>
            {
                try
                {
                    return functionToInvoke();
                }
                finally
                {
                    waitTask.Set();
                }
            };
        }
    }
}
