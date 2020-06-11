using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Cats.Areas.Logistics.Models;
using Cats.Helpers;
using Cats.Models;
using Cats.Models.Hubs;
using Cats.Models.Hubs.ViewModels;
using Cats.Services.Administration;
using Cats.Services.Common;
using Cats.Services.EarlyWarning;
using Cats.Services.Hub;
using Cats.Services.Logistics;
using Cats.Services.Procurement;
using Cats.Services.Security;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using AdminUnit = Cats.Models.AdminUnit;
using Dispatch = Cats.Models.Hubs.Dispatch;
using FDP = Cats.Models.FDP;
using ZonesViewModel = Cats.Areas.Logistics.Models.ZonesViewModel;

namespace Cats.Areas.Logistics.Controllers
{
    [Authorize]
    public class DeliveryReconcileController : Controller
    {
        private readonly IDispatchAllocationService _dispatchAllocationService;
        private readonly IDeliveryService _deliveryService;
        private readonly IDispatchService _dispatchService;
        private readonly Cats.Services.EarlyWarning.ICommodityService _commodityService;
        private readonly Cats.Services.EarlyWarning.IUnitService _unitService;
        private readonly Cats.Services.Transaction.ITransactionService _transactionService;
        private readonly Cats.Services.EarlyWarning.IAdminUnitService _adminUnitService;
        private readonly Cats.Services.EarlyWarning.IFDPService _fdpService;
        private readonly Cats.Services.Logistics.IDeliveryReconcileService _deliveryReconcileService;
        private readonly IUserAccountService _userAccountService;
        private readonly ILossReasonService _lossReasonService;

        public DeliveryReconcileController(IDispatchAllocationService dispatchAllocationService,
                                      IDeliveryService deliveryService,
            IDispatchService dispatchService,
            Cats.Services.EarlyWarning.ICommodityService commodityService, Cats.Services.EarlyWarning.IUnitService unitService, 
            Cats.Services.Transaction.ITransactionService transactionService,
            Cats.Services.EarlyWarning.IAdminUnitService adminUnitService, Cats.Services.EarlyWarning.IFDPService fdpService,
            Cats.Services.Logistics.IDeliveryReconcileService deliveryReconcileService, IUserAccountService userAccountService, ILossReasonService lossReasonService)

        {
            _dispatchAllocationService = dispatchAllocationService;
            _deliveryService = deliveryService;
            _dispatchService = dispatchService;
            _commodityService = commodityService;
            _unitService = unitService;
            _transactionService = transactionService;
            _adminUnitService = adminUnitService;
            _fdpService = fdpService;
            _deliveryReconcileService = deliveryReconcileService;
            _userAccountService = userAccountService;
            _lossReasonService = lossReasonService;
        }

        public ActionResult Index(int regionID)
        {
            ViewBag.RegionID = regionID;
            ViewBag.Region = _adminUnitService.FindById(regionID).Name;
            var zonesList = _adminUnitService.GetAllZones(regionID);
            ViewBag.ZoneCollection = BindZoneViewModel(zonesList);
            var lossReasons = _lossReasonService.GetAllLossReason().Select(t => new
                                                                                    {
                                                                                        name =
                                                                                    t.LossReasonCodeEg + "-" +
                                                                                    t.LossReasonEg,
                                                                                        Id = t.LossReasonId
                                                                                    });

            ViewData["LossReasons"] = lossReasons;
            return View();
        }

        public ActionResult ReadDispatchesNotReconciled([DataSourceRequest]DataSourceRequest request, int FDPID)
        {
            var dispatch = _dispatchService.Get(t => t.FDPID == FDPID, null, "FDP,DispatchAllocation").OrderByDescending(t => t.DispatchDate);
            var dispatchViewModelForReconciles = BindDispatchViewModelForReconciles(dispatch);
            var dispatchViewModelForReconciled = dispatchViewModelForReconciles as List<DispatchViewModelForReconcile> ?? dispatchViewModelForReconciles.ToList();
            foreach (var dispatchViewModelForReconcile in dispatchViewModelForReconciled)
            {
                var dispatchId = dispatchViewModelForReconcile.DispatchID;
                var deliveryReconcile = _deliveryReconcileService.Get(t => t.DispatchID == dispatchId).FirstOrDefault();
                dispatchViewModelForReconcile.GRNReconciled = deliveryReconcile != null;
                if (deliveryReconcile != null)
                {
                    dispatchViewModelForReconcile.DeliveryReconcileID = deliveryReconcile.DeliveryReconcileID;
                    dispatchViewModelForReconcile.GRN = deliveryReconcile.GRN;
                    dispatchViewModelForReconcile.WayBillNo = deliveryReconcile.WayBillNo;
                    dispatchViewModelForReconcile.ReceivedAmount = deliveryReconcile.ReceivedAmount;
                    dispatchViewModelForReconcile.ReceivedDate = deliveryReconcile.ReceivedDate;
                    dispatchViewModelForReconcile.LossAmount = deliveryReconcile.LossAmount;
                    dispatchViewModelForReconcile.LossReasonId = (int) deliveryReconcile.LossReason;
                    dispatchViewModelForReconcile.TransactionGroupID = deliveryReconcile.TransactionGroupID;
                }
                    
            }
            var dispatchView = SetDatePreference(dispatchViewModelForReconciled).ToList();
            return Json(dispatchView.ToDataSourceResult(request), JsonRequestBehavior.AllowGet);
        }
        public ActionResult DeliveryReconcileUpdate([DataSourceRequest] DataSourceRequest request, DispatchViewModelForReconcile dispatchViewModelForReconcile)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if(dispatchViewModelForReconcile.DeliveryReconcileID!=null)
                    {
                        var deliveryReconcile =
                            _deliveryReconcileService.FindById((int) dispatchViewModelForReconcile.DeliveryReconcileID);
                        deliveryReconcile.GRN = dispatchViewModelForReconcile.GRN;
                        deliveryReconcile.FDPID = dispatchViewModelForReconcile.FDPID;
                        deliveryReconcile.DispatchID = dispatchViewModelForReconcile.DispatchID;
                        deliveryReconcile.WayBillNo = dispatchViewModelForReconcile.WayBillNo;
                        deliveryReconcile.RequsitionNo = dispatchViewModelForReconcile.RequisitionNo;
                        deliveryReconcile.HubID = dispatchViewModelForReconcile.HubID;
                        deliveryReconcile.GIN = dispatchViewModelForReconcile.GIN;
                        deliveryReconcile.ReceivedAmount = (dispatchViewModelForReconcile.ReceivedAmount ?? 0);
                        deliveryReconcile.ReceivedDate = (dispatchViewModelForReconcile.ReceivedDate ?? DateTime.Now);
                        deliveryReconcile.LossAmount = dispatchViewModelForReconcile.LossAmount;
                        deliveryReconcile.LossReason = dispatchViewModelForReconcile.LossReasonId;
                        _deliveryReconcileService.EditDeliveryReconcile(deliveryReconcile);
                        ModelState.AddModelError("Success", @"Success: Delivery Reconcilation Data Updated.");
                    }
                    else
                    {
                        var dvmfr = dispatchViewModelForReconcile;
                        if (dvmfr.GRN != null  && dvmfr.RequisitionNo != null && dvmfr.GIN != null 
                            && dvmfr.ReceivedAmount != null && dvmfr.ReceivedDate != null)
                        {
                            var deliveryReconcile = new DeliveryReconcile
                            {
                                GRN = dvmfr.GRN,
                                FDPID = dvmfr.FDPID,
                                DispatchID = dvmfr.DispatchID,
                                WayBillNo = dvmfr.WayBillNo,
                                RequsitionNo = dvmfr.RequisitionNo,
                                HubID = dvmfr.HubID,
                                GIN = dvmfr.GIN,
                                ReceivedAmount =
                                    (dvmfr.ReceivedAmount ?? 0),
                                ReceivedDate =
                                    (dvmfr.ReceivedDate ?? DateTime.Now),
                                LossAmount = dvmfr.LossAmount,
                                LossReason = dvmfr.LossReasonId
                            };
                            _deliveryReconcileService.AddDeliveryReconcile(deliveryReconcile);
                            _transactionService.PostDeliveryReconcileReceipt(deliveryReconcile.DeliveryReconcileID);
                            ModelState.AddModelError("Success", @"Success: Delivery Reconcilation Data Added.");
                        }
                    }
                    
                    //return RedirectToAction("Index", new {regionID = });
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("Errors", @"Error: FDP not registered. All fields need to be filled.");
                }
            }
            return Json(new[] { dispatchViewModelForReconcile }.ToDataSourceResult(request, ModelState));
        }
        public ActionResult ReadFDPs([DataSourceRequest]DataSourceRequest request, int selectedWoreda)
        {
            var fpdList = _fdpService.Get(t => t.AdminUnitID == selectedWoreda).ToList();
            var fdpViewModels = BindFDPViewModel(fpdList);
            return Json(fdpViewModels.ToList(), JsonRequestBehavior.AllowGet);
        }
        public ActionResult ReadZones([DataSourceRequest]DataSourceRequest request, int regionID)
        {
            var zonesList = _adminUnitService.GetAllZones(regionID);
            var zoneViewModel = BindZoneViewModel(zonesList);
            return Json(zoneViewModel.ToList(), JsonRequestBehavior.AllowGet);
        }
        private IEnumerable<ZonesViewModel> BindZoneViewModel(IEnumerable<AdminUnit> zones)
        {
            var zoneViewModels = new List<ZonesViewModel>();
            foreach (var zone in zones)
            {
                var zoneViewModel = new ZonesViewModel();
                zoneViewModel.AdminUnitID = zone.AdminUnitID;
                zoneViewModel.Zone = zone.Name;
                foreach (var woreda in zone.AdminUnit1)
                {
                    var woredaViewModel = new WoredaViewModel {Woreda = woreda.Name, AdminUnitID = woreda.AdminUnitID};
                    var woreda1 = woreda;
                    var fdpsInWoreda = _fdpService.Get(t => t.AdminUnitID == woreda1.AdminUnitID, null, "AdminUnit").ToList();
                    woredaViewModel.FDPs = BindFDPViewModel(fdpsInWoreda);
                    zoneViewModel.Woredas.Add(woredaViewModel);
                }
                zoneViewModels.Add(zoneViewModel);
            }
            return zoneViewModels;
        }
        private IEnumerable<FDPViewModel> BindFDPViewModel(IEnumerable<FDP> fdps)
        {
            var fdpViewModels = new List<FDPViewModel>();
            foreach (var fdp in fdps)
            {
                var fdpViewModel = new FDPViewModel {Name = fdp.Name, FDPID = fdp.FDPID, AdminUnitID = fdp.AdminUnitID};
                fdpViewModels.Add(fdpViewModel);
            }
            return fdpViewModels;
        }
        private IEnumerable<DispatchViewModelForReconcile> BindDispatchViewModelForReconciles(IEnumerable<Dispatch> dispatches)
        {
            var dispatchViewModelForReconciles = new List<DispatchViewModelForReconcile>();
            foreach (var dispatch in dispatches)
            {
                var firstOrDefault = dispatch.DispatchDetails.FirstOrDefault();
                if (firstOrDefault != null)
                {
                    var dispatchViewModelForReconcile = new DispatchViewModelForReconcile();
                    dispatchViewModelForReconcile.DispatchID = dispatch.DispatchID;
                    dispatchViewModelForReconcile.FDP = dispatch.FDP.Name;
                    dispatchViewModelForReconcile.DispatchedByStoreMan = dispatch.DispatchedByStoreMan;
                    dispatchViewModelForReconcile.DispatchDate = dispatch.DispatchDate;
                    dispatchViewModelForReconcile.RequisitionNo = dispatch.RequisitionNo;
                    dispatchViewModelForReconcile.GIN = dispatch.GIN;
                    dispatchViewModelForReconcile.BidNumber = dispatch.BidNumber;
                    dispatchViewModelForReconcile.DriverName = dispatch.DriverName;
                    if (dispatch.DispatchAllocation != null && dispatch.DispatchAllocation.Year != null)
                    {
                        dispatchViewModelForReconcile.MonthYear = dispatch.DispatchAllocation.Month.ToString() + " - " + dispatch.DispatchAllocation.Year.ToString();
                    }
                    dispatchViewModelForReconcile.WeighBridgeTicketNumber = dispatch.WeighBridgeTicketNumber??"";
                    dispatchViewModelForReconcile.CreatedDate = dispatch.CreatedDate;
                    dispatchViewModelForReconcile.DispatchAllocationID = dispatch.DispatchAllocationID??new Guid();
                    dispatchViewModelForReconcile.FDPID = dispatch.FDPID??0;
                    dispatchViewModelForReconcile.Region = dispatch.FDP.AdminUnit.AdminUnit2.AdminUnit2.Name;
                    dispatchViewModelForReconcile.Zone = dispatch.FDP.AdminUnit.AdminUnit2.Name;
                    dispatchViewModelForReconcile.Woreda = dispatch.FDP.AdminUnit.Name;
                    dispatchViewModelForReconcile.HubID = dispatch.HubID;
                    dispatchViewModelForReconcile.PlateNo_Prime = dispatch.PlateNo_Prime;
                    dispatchViewModelForReconcile.PlateNo_Trailer = dispatch.PlateNo_Trailer??"";
                    dispatchViewModelForReconcile.Remark = dispatch.Remark ?? "";
                    dispatchViewModelForReconcile.Round = dispatch.Round;
                    dispatchViewModelForReconcile.TransporterID = dispatch.TransporterID;
                    dispatchViewModelForReconcile.CommodityID = firstOrDefault.CommodityID;
                    dispatchViewModelForReconcile.Commodity = firstOrDefault.Commodity.Name;
                    dispatchViewModelForReconcile.Quantity = firstOrDefault.RequestedQuantityInMT;
                    dispatchViewModelForReconcile.QuantityInUnit = firstOrDefault.RequestedQunatityInUnit;
                    dispatchViewModelForReconcile.UnitID = firstOrDefault.UnitID;

                    dispatchViewModelForReconciles.Add(dispatchViewModelForReconcile);
                }
            }
            return dispatchViewModelForReconciles;
        }

        private IEnumerable<DispatchViewModelForReconcile> SetDatePreference(IEnumerable<DispatchViewModelForReconcile> dispatches)
        {
            var datePref = _userAccountService.GetUserInfo(HttpContext.User.Identity.Name).DatePreference;

            var dispatchViewModels = dispatches as List<DispatchViewModelForReconcile> ?? dispatches.ToList();
            foreach (var dispatchViewModel in dispatchViewModels)
            {
                dispatchViewModel.CreatedDatePref =
                    dispatchViewModel.CreatedDate.ToCTSPreferedDateFormat(datePref);
                dispatchViewModel.DispatchDatePref =
                    dispatchViewModel.DispatchDate.ToCTSPreferedDateFormat(datePref);
            }
            return dispatchViewModels;
        }
    }
}
