using System;
using System.Web.Mvc;
using System.Web.Routing;

namespace FluentHtmlExample.Core
{
    public class WindsorControllerFactory : DefaultControllerFactory
    {
        private readonly IControllerFinder controllerFinder;

        public WindsorControllerFactory(IControllerFinder controllerFinder)
        {
            this.controllerFinder = controllerFinder;
        }

        public override void ReleaseController(IController controller)
        {
            controllerFinder.Release(controller);
        }

        protected override IController GetControllerInstance(RequestContext requestContext, Type controllerType)
        {
            if (controllerType == null) return null;

            return controllerFinder.GetController(controllerType.FullName);
        }
    }
}