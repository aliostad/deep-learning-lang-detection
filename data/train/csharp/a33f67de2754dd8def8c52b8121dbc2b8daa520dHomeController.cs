using Eagle.Core;
using Eagle.Core.Generators;
using MeGrab.Application;
using MeGrab.DataObjects;
using MeGrab.Dispatcher.Filters;
using MeGrab.Domain;
using MeGrab.Infrastructure;
using MeGrab.ServiceContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MeGrab.Dispatcher.Controllers
{
    //[SSOAuthorize("http://localhost:10800/Home/Index", new string[] { "Dispatch" })]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Dispatch(RedPacketGrabActivityDataObject redPacketGrabActivity)
        {
            using (IRedPacketDispatchService redPacketDispatchService = ServiceLocator.Instance.GetService<IRedPacketDispatchService>()) 
            {
                DispatchRequest dispatchRequest = new DispatchRequest();

                dispatchRequest.DispatcherName = "Philips"; //this.User.Identity.Name;
                dispatchRequest.RedPacketGrabActivity = redPacketGrabActivity;
                redPacketDispatchService.Dispatch(dispatchRequest);
            }

            return View("Index");
        }
    }
}
