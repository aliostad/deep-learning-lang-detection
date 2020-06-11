using System.Web.Mvc;

namespace SiteBlue.Areas.dispatch
{
    public class dispatchAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "dispatch";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "dispatch_default",
                "dispatch/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
