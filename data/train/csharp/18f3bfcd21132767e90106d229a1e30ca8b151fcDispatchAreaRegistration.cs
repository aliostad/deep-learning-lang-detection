using System.Web.Mvc;

namespace DMS.Areas.Dispatch
{
    public class DispatchAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Dispatch";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Dispatch_default",
                "Dispatch/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
