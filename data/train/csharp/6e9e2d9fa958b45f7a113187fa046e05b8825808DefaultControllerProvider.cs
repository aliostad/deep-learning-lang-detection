using System.Collections.Generic;
using System;

namespace Galssoft.VKontakteWM.Components.MVC
{
    public class DefaultControllerProvider : IControllerProvider
    {
        private Dictionary<string, Controller> controllerCache;
        private Dictionary<Type, Controller> typeMap;

        public DefaultControllerProvider()
        {
            controllerCache = new Dictionary<string, Controller>();
            typeMap = new Dictionary<Type, Controller>();

        }

        #region IControllerProvider Members

        public Controller GetController(string name)
        {
            Controller controller = null;

            if (!controllerCache.TryGetValue(name, out controller))
            {
                throw new ArgumentException("Controller is not registered.");
            }

            return controller;
        }

        public Controller GetController<T>()
        {
            Controller controller = null;

            if (!typeMap.TryGetValue(typeof(T), out controller))
            {
                throw new ArgumentException("Controller is not registered.");
            }

            return controller;
        }

        public Controller GetController(Type type)
        {
            Controller controller = null;

            if (!typeMap.TryGetValue(type, out controller))
            {
                throw new ArgumentException("Controller is not registered.");
            }

            return controller;
        }

        public Controller GetController<T>(IView view)
        {
            Controller controller = null;

            if (!typeMap.TryGetValue(typeof(T), out controller))
            {
                controller = this.CreateController(typeof(T));
                controller.View = view;
            }

            return controller;
        }

        public void RegisterController(Controller controller)
        {
            if (!controllerCache.ContainsKey(controller.Name))
            {
                controllerCache.Add(controller.Name, controller);
                typeMap.Add(controller.GetType(), controller);
            }
        }

        #endregion

        private Controller CreateController(Type type)
        {
            return (Controller)Activator.CreateInstance(type);
        }
    }
}