using System;

namespace Decorator
{
    /// <summary>
    /// 装饰类,传入被装饰的类就是装饰过程
    /// </summary>
    public sealed class ActionExecuting : Controller
    {
        private readonly Controller _controller;

        public ActionExecuting(Controller controller)
        {
            _controller = controller;
        }

        public override void Action()
        {
            Console.WriteLine("身份验证成功!");

            if (_controller != null)
                _controller.Action();
        }
    }
}