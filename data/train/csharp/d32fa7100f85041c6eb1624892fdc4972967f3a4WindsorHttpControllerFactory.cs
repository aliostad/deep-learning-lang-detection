using System;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Dispatcher;
using Castle.MicroKernel;

namespace Infrastructure
{
    public class WindsorHttpControllerFactory : IHttpControllerFactory
    {
        private readonly IKernel _kernel;

        public WindsorHttpControllerFactory(IKernel kernel)
        {
            _kernel = kernel;
        }

        public IHttpController CreateController(HttpControllerContext controllerContext, string controllerName)
        {
            var controller =
                _kernel.Resolve<IHttpController>(String.Format("Web.Api.Controllers.{0}Controller", controllerName));

            controllerContext.Controller = controller;
            controllerContext.ControllerDescriptor = new HttpControllerDescriptor(GlobalConfiguration.Configuration,
                                                                                  controllerName, controller.GetType());
            return controllerContext.Controller;
        }

        public void ReleaseController(IHttpController controller)
        {
            _kernel.ReleaseComponent(controller);
        }
    }
}