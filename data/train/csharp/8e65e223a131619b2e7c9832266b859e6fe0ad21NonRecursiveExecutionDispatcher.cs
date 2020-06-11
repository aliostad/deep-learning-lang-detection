using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ExecQueue
{
  public class NonRecursiveExecutionDispatcher : QueuedExecutionDispatcher
  {
    private bool _running;

    public override void BeginInvoke(Action action)
    {
      base.BeginInvoke(action);
      ExecuteAll();
    }

    public override void Invoke(Action action)
    {
      base.Invoke(action);
      ExecuteAll();
    }

    public override Task InvokeAsync(Action action)
    {
      var invokeAsync = base.InvokeAsync(action);
      ExecuteAll();
      return invokeAsync;
    }

    public override Task<TResult> InvokeAsync<TResult>(Func<TResult> action)
    {
      var invokeAsync = base.InvokeAsync(action);
      ExecuteAll();
      return invokeAsync;
    }
    public override void ExecuteAll()
    {
      if (_running)
        return;

      _running = true;
      base.ExecuteAll();
      _running = false;
    }
  }
}