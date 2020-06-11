using System;
using System.Web.Mvc;

namespace Machine.MsMvc
{
  public class AsyncResult : ActionResult
  {
    readonly Func<AsyncCallback, IAsyncResult> _beginInvoke;
    readonly Func<IAsyncResult, ActionResult> _endInvoke;

    public AsyncResult(Func<AsyncCallback, IAsyncResult> beginInvoke, Func<IAsyncResult, ActionResult> endInvoke)
    {
      _beginInvoke = beginInvoke;
      _endInvoke = endInvoke;
    }

    public override void ExecuteResult(ControllerContext context)
    {
      var controller = GetAsyncController(context);

      var result = controller.BeginAsync(_beginInvoke, _endInvoke);
    }

    protected virtual AsyncController GetAsyncController(ControllerContext context)
    {
      var controller = context.Controller as AsyncController;

      if (controller == null)
      {
        throw new Exception("Can only use AsyncResults in AsyncControllers");
      }

      return controller;
    }
  }
}