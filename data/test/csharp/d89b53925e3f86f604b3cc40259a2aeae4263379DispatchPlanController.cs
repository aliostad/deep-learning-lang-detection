using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Cats.Services.Hub;
using Cats.Web.Hub;

namespace Cats.Areas.Hub.Controllers.Allocations
{
    public class DispatchPlanController : BaseController
    {
        private IDispatchAllocationService _dispatchAllocationService;

        public DispatchPlanController(IDispatchAllocationService dispatchAllocationService, IUserProfileService userProfileService)
            : base(userProfileService)
        {
            this._dispatchAllocationService = dispatchAllocationService;
        }
        //
        // GET: /DispatchPlan/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ListRequisitions()
        {
            return PartialView(_dispatchAllocationService.GetSummaryForUncommitedAllocations(GetCurrentUserProfile().DefaultHub.Value));
        }

        public ActionResult RequistionDetails(int req)
        {
            return PartialView();
        }

    }
}
