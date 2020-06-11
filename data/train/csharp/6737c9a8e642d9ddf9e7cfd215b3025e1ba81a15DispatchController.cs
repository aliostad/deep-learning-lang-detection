using LiteDispatch.Web.Services;

namespace LiteDispatch.Web.Controllers
{
  using System;
  using System.Linq;
  using System.Web;
  using System.Web.Mvc;
  using BusinessAdapters;
  using Domain.Entities;
  using Domain.Models;
  using Hubs;
  using Microsoft.AspNet.SignalR;
  using Models;
  using WebMatrix.WebData;

  public class DispatchController : Controller
  {
    public DispatchController()
    {
      DispatchAdapter = new DispatchAdapter();
    }

    public DispatchAdapter DispatchAdapter { get; set; }

    public ActionResult Index()
    {
      if (TempData.ContainsKey("NotificationMsg"))
      {
        ViewBag.NotificationMsg = TempData["NotificationMsg"];
      }
      return View();
    }

    public ActionResult UploadFile(UploadDispatchModel model, HttpPostedFileBase uploadedFile)
    {
      var invalidFlag = IsInvalidUploadFile(uploadedFile);
      if (!ModelState.IsValid || invalidFlag)
      {
        ModelState.AddModelError("", "Please, check that all fields were entered correctly");
        if (invalidFlag)
        {
          ModelState.AddModelError("", InvalidUploadFileNotification(uploadedFile));
        }
        return View("Index", model);
      }
      return RedirectToAction("ValidateDispatch", model);
    }

    public ActionResult DisplayDispatch(long listadoId)
    {
      var listado = DispatchAdapter.GetDispathNoteById(listadoId);
      return View(listado);
    }

    private bool IsInvalidUploadFile(HttpPostedFileBase uploadedFile)
    {
      if (uploadedFile == null) return true;
      if (uploadedFile.ContentType != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") return true;
      return false;
    }

    private string InvalidUploadFileNotification(HttpPostedFileBase uploadedFile)
    {
      if (uploadedFile == null) return "Select an excel document with the dispatch information";
      if (uploadedFile.ContentType != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
      {
        return "The uploaded file is not an XLSX Excel document";
      }
      return "The uploaded file is invalid";
    }

    public ActionResult ValidateDispatch(UploadDispatchModel model)
    {
      var dispatch = GetDispatchNote(model);
      const string msg = "{0} - New dispatch note was created with date {1:d} and contains {2} lines";
      ViewBag.Message = string.Format(msg, dispatch.HaulierName, dispatch.DispatchDate, dispatch.Lines.Count);
      LiteDispatchSession.LastDispatch = dispatch;
      return View(dispatch);
    }

    public ActionResult PrintDispatch(long listadoId)
    {
      var dispatch = DispatchAdapter.GetDispathNoteById(listadoId);
      return View(dispatch);
    }      

    public ActionResult Enquiry()
    {
      var model = DispatchAdapter.GetAllDispatches();
      model = model.OrderByDescending(d => d.LastUpdate);
      return View(model);
    }

    public ActionResult ExcelTemplate()
    {
      return File("~/Content/documents/Dispatch_Template.xlsx", "application/vnd.ms-excel", "Dispatch_Template.xlsx");
    }

    private DispatchNoteModel GetDispatchNote(UploadDispatchModel model)
    {
      
      var result = new DispatchNoteModel {DispatchNoteStatus = DispatchNoteStatusEnum.New, DispatchDate = model.DispatchDate.Value, HaulierName = "UnKnown", TruckReg = model.TruckReg, DispatchReference = model.ReferenceNumber};
      var haulier = LiteDispatchSession.UserHaulier();      
      result.HaulierId = haulier.Id;
      result.HaulierName = haulier.Name;
      var linea = new DispatchLineModel
        {
          Id = 1,
          ProductType = "Fresh",
          Product = "Hake",
          Metric = "Kg",
          Quantity = 25,
          ShopId = 18,
          Client = "RedSquid"
        };

      result.Lines.Add(linea);

      linea = new DispatchLineModel
      {
        Id = 2,
        ProductType = "Frozen",
        Product = "Frozen Squid",
        Metric = "Pallet",
        Quantity = 4,
        ShopId = 4,
        ShopLetter = "A",
        Client = "Alaska Brothers"
      };

      result.Lines.Add(linea);

      linea = new DispatchLineModel
      {
        Id = 3,
        ProductType = "Shellfish",
        Product = "Mussel",
        Metric = "Sac",
        Quantity = 20,
        ShopId = 112,
        Client = "Irish Seafoods"
      };

      result.Lines.Add(linea);

      return result;
    }

    public ActionResult Confirm()
    {
      TempData["NotificationMsg"] = "Last dispatch note was confirmed";
      var dispatchModel = LiteDispatchSession.LastDispatch;
      dispatchModel.CreationDate = DateTime.Now;
      dispatchModel.User = WebSecurity.CurrentUserName;
      var savedDispatch = DispatchAdapter.SaveDispatch(dispatchModel);
      var hubContext = GlobalHost.ConnectionManager.GetHubContext<LiteDispatchHub>();
      hubContext.Clients.All.newDispatch(savedDispatch.Id);
      return RedirectToAction("Enquiry");
    }

    public ActionResult GetDispatchNoteDetails(long dispatchId)
    {
      var dispatch = DispatchAdapter.GetDispathNoteById(dispatchId);
      return PartialView(dispatch);
    }

    public ActionResult Discard()
    {
      TempData["NotificationMsg"] = "Last dispatch note was discarded";
      return RedirectToAction("Index");
    }
  }
}