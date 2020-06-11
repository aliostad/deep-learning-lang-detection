using System;
using System.Linq;
using LiteDispatch.Domain.Entities;
using LiteDispatch.Web.BusinessAdapters;
using LiteDispatch.Web.Services;

namespace LiteDispatch.Web.Controllers
{
  using System.Web.Mvc;

  public class HomeController : Controller
  {
    public HomeController()
    {
      DispatchAdapter = new DispatchAdapter();
    }

    public DispatchAdapter DispatchAdapter { get; set; }

    [Authorize]
    public ActionResult Index()
    {
      ViewBag.Message = User.Identity.IsAuthenticated 
        ? LiteDispatchSession.UserProfile().HaulierName 
        : "Register before using the application";

      UpdateStats();

      return View();
    }

    private void UpdateStats()
    {
      var lastDispatch = DispatchAdapter.GetLastDispatch();
      var last30Days = DispatchAdapter.GetDispatchesBetweenDates(DateTime.Now.Date.AddDays(-30), DateTime.Now.Date.AddDays(1));
      var lastSevenDays = last30Days.Where(d => d.CreationDate >= DateTime.Now.Date.AddDays(-7) && d.CreationDate <= (DateTime.Now.Date.AddDays(1))).ToList();

      if (lastDispatch == null)
      {
        ViewBag.LastDispatchMsg = "Dispatch Notes were not found";
        ViewBag.LastSevenDaysMsg = "Dispatch Notes were not found";
        ViewBag.Last30DaysMsg = "Dispatch Notes were not found";
        return;
      }

      ViewBag.LastDispatchMsg = string.Format("{0:g} - Number of lines: {1} - State: {2} - User: {3}",
                                              lastDispatch.CreationDate, lastDispatch.Lines.Count,
                                              lastDispatch.DispatchNoteStatus, lastDispatch.User);

      ViewBag.LastSevenDaysMsg =
        string.Format(
          "Total Dispatch Notes: {0} - Total Number of Lines: {1} - New Dispatches: {2} - Received Dispatches: 0",
          lastSevenDays.Count, lastSevenDays.SelectMany(d => d.Lines).Count(),
          lastSevenDays.Count(d => d.DispatchNoteStatus == DispatchNoteStatusEnum.New));

      ViewBag.Last30DaysMsg =
        string.Format(
          "Total Dispatch Notes: {0} - Total Number of Lines: {1} - New Dispatches: {2} - Received Dispatches: 0",
          last30Days.Count, last30Days.SelectMany(d => d.Lines).Count(),
          last30Days.Count(d => d.DispatchNoteStatus == DispatchNoteStatusEnum.New));
    }

    public ActionResult About()
    {
      ViewBag.Message = "Your app description page.";

      return View();
    }

    public ActionResult Contact()
    {
      ViewBag.Message = "Your contact page.";

      return View();
    }
  }
}
