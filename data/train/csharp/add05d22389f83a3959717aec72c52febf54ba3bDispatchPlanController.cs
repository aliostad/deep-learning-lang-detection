﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DRMFSS.BLL.Services;

namespace DRMFSS.Web.Controllers.Allocations
{
    public class DispatchPlanController : BaseController
    {
        private IDispatchAllocationService _dispatchAllocationService;

        public DispatchPlanController(IDispatchAllocationService dispatchAllocationService)
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
            return PartialView(_dispatchAllocationService.GetSummaryForUncommitedAllocations(GetCurrentUserProfile().DefaultHub.HubID));
        }

        public ActionResult RequistionDetails(int req)
        {
            return PartialView();
        }

    }
}
