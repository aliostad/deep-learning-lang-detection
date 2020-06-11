using System;
using System.Diagnostics;

namespace EulerSolutions.Common
{
    public class ActionRunner : IActionRunner
    {
        public TimeSpan TimeElapsed { get; private set; }

        public void Invoke(Action action)
        {
            Invoke<object>(() =>
            {
                action.Invoke();
                return null;
            });
        }

        public TReturn Invoke<TReturn>(Func<TReturn> func)
        {
            var stopwatch = new Stopwatch();
            try
            {
                stopwatch.Start();
                return func.Invoke();
            }
            finally
            {
                stopwatch.Stop();
                TimeElapsed = stopwatch.Elapsed;
            }
        }
    }
}