using BAL;
using MehulIndustries.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ViewModels;

namespace MehulIndustries.Controllers
{
    [AuthorizeWebForm]
    public class DispatchController : BaseController
    {
        //
        // GET: /Dispatch/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetOrderDetail(int ID, int DispatchID)
        {
            var order = OrderLogic.GetOrderByID(ID).FirstOrDefault();
            ViewBag.Parties = PartyLogic.GetPartyByID(order.PartyID);
            ViewBag.Transports = TransportLogic.GetTransportByID(0);
            ViewBag.Products = ProductLogic.GetFinishedProducts();
            ViewBag.Addresses = PartyAddressLogic.GetPartyAddress(order.PartyID);
            var dispatch = new Dispatch();
            if (DispatchID == 0)
            {
                dispatch.DONo = DispatchLogic.GetMaxDispatchNo();
                dispatch.DODate = DateTime.Now;
            }
            else
            {
                dispatch = DispatchLogic.GetDispatchByID(DispatchID).FirstOrDefault();
            }
            dispatch.order = order;
            dispatch.details = DispatchLogic.GetDispatchDetail(DispatchID, order.ID);
            if (DispatchID > 0)
            {
                dispatch.order.PartyID = dispatch.PartyID;
                dispatch.order.DeliveryAddressID = dispatch.DeliveryAddressID;
                dispatch.order.TransportID = dispatch.TransportID;
                dispatch.order.BookingAt = dispatch.BookingAt;
            }
            return PartialView("_DispatchDetails", dispatch);
        }

        public ActionResult Add(int ID)
        {
            ViewBag.ViewID = ID;
            if (ID > 0)
            {
                ViewBag.OrderID = DispatchLogic.GetDispatchByID(ID).FirstOrDefault().OrderID;
            }

            ViewBag.Parties = PartyLogic.GetOrderedParties();
            return View();
        }

        [HttpPost]
        public ActionResult Add(Dispatch dispatch)
        {
            ResponseMsg response = new ResponseMsg();
            dispatch.CreatedBy = ((Employee)Session["User"]).ID;
            if (DispatchLogic.SaveDispatch(dispatch))
            {
                response.IsSuccess = true;
                response.ResponseValue = DispatchLogic.GetDispatchByDONo(dispatch.DONo);
            }
            else
            {
                response.IsSuccess = false;
            }
            return Json(response);
        }

        public string CheckDuplicateDONo(string DONo, string ID)
        {
            var dispatches = DispatchLogic.GetDispatchByID(0);
            if (dispatches != null && dispatches.Count() > 0)
            {
                if (Convert.ToInt32(ID) > 0)
                {
                    dispatches = dispatches.Where(x => x.DONo == DONo && x.ID != Convert.ToInt32(ID));
                }
                else
                {
                    dispatches = dispatches.Where(x => x.DONo == DONo);
                }
                if (dispatches.Count() > 0)
                {
                    return "false";
                }
                else
                {
                    return "true";
                }
            }
            else
            {
                return "true";
            }
        }

        public ActionResult Delete(string ID)
        {
            ResponseMsg response = new ResponseMsg();
            response.IsSuccess = true;
            response.ResponseValue = DispatchLogic.DeleteDispatch(ID);
            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetAll()
        {
            return View(DispatchLogic.GetDispatchByID(0));
        }

        public PartialViewResult GetDetailForDispatchRegister(string ID)
        {
            var order = DispatchLogic.GetDispatchByID(Convert.ToInt32(ID)).FirstOrDefault();
            return PartialView("_DispatchDetailForRegister", order);
        }

        public FileContentResult Print(int ID)
        {
            var filename = DispatchLogic.Print(ID, Server.MapPath(ConfigurationManager.AppSettings["ReportFolderPath"]), currUser.Name);
            return File(System.IO.File.ReadAllBytes(Server.MapPath(ConfigurationManager.AppSettings["ReportFolderPath"] + "/" + filename)), "application/pdf");
        }
    }
}
