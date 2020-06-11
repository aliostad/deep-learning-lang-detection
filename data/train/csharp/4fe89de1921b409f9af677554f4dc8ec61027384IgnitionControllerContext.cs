using System.Web.Mvc;
using Glass.Mapper.Sc;

namespace Ignition.Core.Mvc
{
    public class IgnitionControllerContext : ControllerContext
    {
	    private readonly ControllerContext _controllerContext;
	    public ISitecoreContext Context { get; set; }
        public IgnitionControllerContext(ControllerContext controllerContext, ISitecoreContext context) : base(controllerContext)
        {
	        _controllerContext = controllerContext;
	        Context = context;
        }

        public IgnitionControllerContext(ControllerContext context) : base(context)
        {
        }
    }
}
