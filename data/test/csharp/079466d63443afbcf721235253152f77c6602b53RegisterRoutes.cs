using System.Web.Mvc;
using System.Web.Routing;
using ThreeBytes.Core.Bootstrapper.Extensions.Mvc;

namespace ThreeBytes.Email.Dispatch.List.Frontend.Installers
{
    public class RegisterRoutes : IRegisterRoutes
    {
        public void Register(RouteCollection routes)
        {
            routes.MapRoute(
                "DispatchList",
                "Dispatch/List",
                new { controller = "EmailDispatchList", action = "List" }
            );

            routes.MapRoute(
                "DispatchListGetPageParams",
                "Dispatch/GetPage",
                new { controller = "EmailDispatchList", action = "GetPage" }
            );

            routes.MapRoute(
                "DispatchListGetPage",
                "Dispatch/GetPage/{page}/{datetime}",
                new { controller = "EmailDispatchList", action = "GetPage", page = "", datetime = "" }
            );

            routes.MapRoute(
                "DispatchListGet",
                "Dispatch/List/Get/{id}",
                new { controller = "EmailDispatchList", action = "Get", id = "" }
            );

            routes.MapRoute(
                "DispatchListGetNewerThanPageParams",
                "Dispatch/List/GetNewerThan",
                new { controller = "EmailDispatchList", action = "GetNewerThan" }
            );

            routes.MapRoute(
                "DispatchListGetNewerThan",
                "Dispatch/List/GetNewerThan/{datetime}",
                new { controller = "EmailDispatchList", action = "GetNewerThan", datetime = "" }
            );
        }
    }
}