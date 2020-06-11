using System;

namespace Decorator
{
    /// <summary>
    /// 装饰类,传入被装饰的类就是装饰过程
    /// </summary>
    public sealed class ActionExecuted : Controller
    {
        private readonly Controller _controller;

        public ActionExecuted(Controller controller)
        {
            _controller = controller;
        }

        public override void Action()
        {
            if (_controller != null)
                _controller.Action();

            Console.WriteLine("日志写入成功!");
        }
    }
}