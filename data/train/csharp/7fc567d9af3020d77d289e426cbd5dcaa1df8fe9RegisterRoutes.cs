using System.Web.Mvc;
using System.Web.Routing;
using ThreeBytes.Core.Bootstrapper.Extensions.Mvc;

namespace ThreeBytes.Email.Dispatch.View.Frontend.Installers
{
    public class RegisterRoutes : IRegisterRoutes
    {
        public void Register(RouteCollection routes)
        {
            routes.MapRoute(
                "DispatchUserDetails",
                "Dispatch/Details",
                new { controller = "EmailDispatchView", action = "Details" }
            );

            routes.MapRoute(
                "DispatchGetDetailsNoPageParams",
                "Dispatch/GetDetails",
                new { controller = "EmailDispatchView", action = "GetDetails" }
            );

            routes.MapRoute(
                "DispatchGetDetails",
                "Dispatch/GetDetails/{id}",
                new { controller = "EmailDispatchView", action = "GetDetails" }
            );
        }
    }
}