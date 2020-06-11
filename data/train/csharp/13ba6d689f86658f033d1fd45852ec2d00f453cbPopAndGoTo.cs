using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BadSnowstorm
{
    public sealed class PopAndGoTo<TController> : INavigationResult
        where TController : Controller
    {
        private readonly Controller _currentController;

        internal PopAndGoTo(Controller currentController)
        {
            _currentController = currentController;
        }

        Controller INavigationResult.GetController(IControllerFactory controllerFactory, Stack<Controller> controllerHistory)
        {
            return controllerFactory.Create<TController>();
        }
    }
}
