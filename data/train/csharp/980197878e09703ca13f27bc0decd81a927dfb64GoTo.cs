using System.Collections.Generic;

namespace BadSnowstorm
{
    public sealed class GoTo<TController> : INavigationResult
        where TController : Controller
    {
        private readonly Controller _currentController;

        internal GoTo(Controller currentController)
        {
            _currentController = currentController;
        }

        Controller INavigationResult.GetController(IControllerFactory controllerFactory, Stack<Controller> controllerHistory)
        {
            var controller = controllerFactory.Create<TController>();
            controllerHistory.Push(_currentController);
            return controller;
        }
    }
}