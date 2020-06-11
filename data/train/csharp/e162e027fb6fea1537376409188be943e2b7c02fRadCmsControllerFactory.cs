using System;
using System.Web.Mvc;

namespace RadCms.Mvc
{
    public class RadCmsControllerFactory: DefaultControllerFactory
    {
        public override IController CreateController(System.Web.Routing.RequestContext requestContext, string controllerName)
        {
            var controller = base.CreateController(requestContext, controllerName);

            // Enforce the controller type
            if(controller is CmsControllerBase || controller is PubControllerBase)
            {
                return controller;
            }
            else
            {
                return null;
            }
        }
        public override void ReleaseController(IController controller)
        {
            IDisposable dispose = controller as IDisposable;

            if (dispose != null)
            {
                dispose.Dispose();
            }
        }
    }
}
