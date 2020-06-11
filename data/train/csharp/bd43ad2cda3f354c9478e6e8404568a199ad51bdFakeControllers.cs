using System.Web.Mvc;

namespace SharpRouting
{
    // Optimal controller
    public class SelfRegisteringController : Controller
    {
        public static void RegisterRoutes(IRouteBuilder r)
        {
            r.Url("a").IsAction("A");
        }
    }

    // Controllers without RegisterRoutes
    public class RootController : Controller { }
    public class XController    : Controller { }
    public class YController    : Controller { }

    // Invalid controller types
    internal        class InternalController     : Controller { }
    public abstract class AbstractController     : Controller { }
    public          class ControllerWronglyNamed : Controller { }
    public          class NotAnIController                    { }
}

public class NoNamespaceController : Controller { }
