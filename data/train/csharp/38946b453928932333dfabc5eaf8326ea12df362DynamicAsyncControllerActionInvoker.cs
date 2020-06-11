using System.Web.Mvc;
using System.Web.Mvc.Async;

namespace DynamicMvcStage.Core.Controllers
{
    public class DynamicAsyncControllerActionInvoker : AsyncControllerActionInvoker
    {
        private readonly IDynamicControllerContextManager dynamicControllerContextManager;

        public DynamicAsyncControllerActionInvoker(IDynamicControllerContextManager dynamicControllerContextManager)
        {
            this.dynamicControllerContextManager = dynamicControllerContextManager;
        }

        protected override ControllerDescriptor GetControllerDescriptor(ControllerContext controllerContext)
        {
            DynamicControllerContext dynamicControllerContext = dynamicControllerContextManager.GetContext((string)controllerContext.RouteData.Values["controller"]);
            if (dynamicControllerContext == null) return base.GetControllerDescriptor(controllerContext);
            return new ReflectedControllerDescriptor(dynamicControllerContext.ControllerType);
        }
    }
}
