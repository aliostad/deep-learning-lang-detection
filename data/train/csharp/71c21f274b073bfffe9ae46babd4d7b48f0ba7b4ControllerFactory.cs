using System.Web.Mvc;
using System.Web.Routing;
using BigElectron.Data.Models;
using BusinessDirectory.Controllers;

namespace BusinessDirectory.Infrastructure
{
	/// <summary>
	/// Custom ControllerFactory to set the Domain property of BaseController
	/// </summary>
	public class ControllerFactory : IControllerFactory

	{
		private DefaultControllerFactory defaultControllerFactory = new DefaultControllerFactory();
		
		public ControllerFactory()
		{}
		
		public IController CreateController(RequestContext requestContext, string controllerName)
		{
			IController controller = 
				defaultControllerFactory.CreateController(requestContext,controllerName);
			BaseController baseController = (BaseController) controller;
			baseController.Domain = (Domain)requestContext.HttpContext.Session["Domain"];
			return baseController;
		}

		public void ReleaseController(IController controller)
		{
			defaultControllerFactory.ReleaseController(controller);
		}

	}
}