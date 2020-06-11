using System.Collections.Concurrent;

namespace RoutableActor
{
    public static class ControllerFactory
    {
        private static readonly ConcurrentDictionary<int, Controller> _controllers;

        public static ConcurrentDictionary<int, Controller> Controllers => _controllers;

        static ControllerFactory()
        {
            _controllers = _controllers ?? new ConcurrentDictionary<int, Controller>();
        }

        public static Controller GetController(int controllerId)
        {
            Controller controller;
            if (!_controllers.TryGetValue(controllerId, out controller))
            {
                controller = new Controller(controllerId);
                _controllers.TryAdd(controllerId, controller);
            }

            return controller;
        }
    }
}
