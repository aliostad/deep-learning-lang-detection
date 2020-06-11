using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebInstruments.Filters;
using WebInstruments.Models;
using WebInstruments.ViewModels;

namespace WebInstruments.Controllers
{
    [AuthorizationFilter]
    public class InstrumentTypeController : Controller
    {

        private ApplicationDbContext _context;

        public InstrumentTypeController()
        {
            _context = new ApplicationDbContext();
        }

        public ActionResult InstrumentTypeList()
        {
            var viewModel = new NewInstrumentTypeViewModel()
            {
                InstrumentTypes = _context.InstrumentTypes.ToList(),
            };

            return View(viewModel);
        }

        public ActionResult Remove(int id)
        {
            _context.InstrumentTypes.Remove(_context.InstrumentTypes.SingleOrDefault(it => it.Id == id));
            _context.SaveChanges();

            return RedirectToAction("InstrumentTypeList");
        }

        public ActionResult Save(InstrumentType instrumentType)
        {
            if (Convert.ToInt32(instrumentType.Id) == 0)
            {
                _context.InstrumentTypes.Add(instrumentType);
            }
            else
            {
                var instrumentTypeToModify = _context
                    .InstrumentTypes
                    .SingleOrDefault(i => i.Id == instrumentType.Id);

                if (instrumentTypeToModify == null)
                    return HttpNotFound();

                instrumentTypeToModify.Id = instrumentType.Id;
                instrumentTypeToModify.Name= instrumentType.Name;
            }
            _context.SaveChanges();

            return RedirectToAction("InstrumentTypeList");
        }

        [HttpPost]
        public ContentResult GetData(int id)
        {
            var instrumentType = _context.InstrumentTypes.SingleOrDefault(i => i.Id == id);
            return Content(JsonConvert.SerializeObject(instrumentType));
        }
    }
}