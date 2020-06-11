using System;
using System.Web.Http.Controllers;
using System.Web.Http.Dispatcher;
using Castle.Windsor;

namespace Api.Rest.Infrastructure
{
	public class WindsorHttpControllerFactory : IHttpControllerFactory
	{
		private const string ControllerSuffix = "Controller";
		private readonly IWindsorContainer _windsorContainer;

		public WindsorHttpControllerFactory(IWindsorContainer windsorContainer)
		{
			if (windsorContainer == null)
				throw new ArgumentNullException("windsorContainer", "The instance of the container cannot be null.");

			_windsorContainer = windsorContainer;
		}

		public IHttpController CreateController(HttpControllerContext controllerContext, string controllerName)
		{
			var controllerFullName = string.Format("{0}.{1}{2}", typeof(OrderController).Namespace, controllerName, ControllerSuffix);
			var controllerType = Type.GetType(controllerFullName);

			controllerContext.ControllerDescriptor = new HttpControllerDescriptor(controllerContext.Configuration, controllerName, controllerType);
			controllerContext.Controller = _windsorContainer.Resolve(controllerType) as IHttpController;

			return controllerContext.Controller;
		}

		public void ReleaseController(IHttpController controller)
		{
			var disposableController = controller as IDisposable;
			if (disposableController != null)
				disposableController.Dispose();

			_windsorContainer.Release(controller);
		}
	}
}