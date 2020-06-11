using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QuickTrack.Controllers
{
    public class DispatchController : Controller
	{
		//
		// GET: /Dispatch/

		public ActionResult DispatchManagement()
        {
            return View ();
		}

		public ActionResult DispatchSchedule()
		{
			return View();
		}

        public ActionResult DispatchMonitoring()
        {
            return View ();
		}
		public ActionResult DispatchJobOrderTrans()
		{
			return View();
		}
    }
}
