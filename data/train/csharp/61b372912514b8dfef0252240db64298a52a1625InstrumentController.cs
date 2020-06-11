using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using MMApp.Data;
using MMApp.Domain.Models;
using MMApp.Domain.Repositories;

namespace MMApp.Web.Controllers.Music
{
    public class InstrumentController : Controller
    {
        //private readonly IMusicRepository _dashboard = new MusicRepository();
        private readonly IMusicRepository _dashboardSP = new MusicSPRepository();

        public ActionResult Index()
        {
            if (TempData["CustomError"] != null)
            {
                ModelState.AddModelError(string.Empty, TempData["CustomError"].ToString());
            }

            return View(new List<Instrument>(_dashboardSP.GetAll<Instrument>().Cast<Instrument>()));
        }

        public ActionResult AddInstrument()
        {
            if (TempData["CustomError"] != null)
            {
                ModelState.AddModelError(string.Empty, TempData["CustomError"].ToString());
            }

            return View(new Instrument());
        }

        [HttpPost]
        public ActionResult AddInstrument(Instrument instrument)
        {
            if (_dashboardSP.CheckDuplicate<Instrument>(instrument.InstrumentName, instrument.Website))
            {
                TempData["CustomError"] = "Instrument ( " + instrument.InstrumentName + " ) already exists!";
                ModelState.AddModelError("CustomError", "Instrument ( " + instrument.InstrumentName + " ) already exists!");
            }

            if (ModelState.IsValid)
            {
                _dashboardSP.Add(instrument);

                return RedirectToAction("Index");
            }

            return RedirectToAction("AddInstrument");
        }

        public ActionResult UpdateInstrument(int instrumentId)
        {
            if (TempData["CustomError"] != null)
            {
                ModelState.AddModelError(string.Empty, TempData["CustomError"].ToString());
            }

            return View(_dashboardSP.Find<Instrument>(instrumentId));
        }

        [HttpPost]
        public ActionResult UpdateInstrument(Instrument instrument)
        {
            var model = (Instrument)_dashboardSP.Find<Instrument>(instrument.Id);

            if (model.InstrumentName == instrument.InstrumentName && model.Website == instrument.Website)
            {
                TempData["CustomError"] = "Instrument Name didn't change!";
                ModelState.AddModelError("CustomError", "Instrument Name didn't change!");
            }

            if (_dashboardSP.CheckDuplicate<Instrument>(instrument.InstrumentName, instrument.Website))
            {
                TempData["CustomError"] = "Instrument ( " + instrument.InstrumentName + " ) already exists!";
                ModelState.AddModelError("CustomError", "Instrument ( " + instrument.InstrumentName + " ) already exists!");
            }

            if (ModelState.IsValid)
            {
                _dashboardSP.Update(instrument);

                return RedirectToAction("Index");
            }

            return RedirectToAction("UpdateInstrument", "Instrument", new { instrumentId = instrument.Id });
        }

        public ActionResult RemoveInstrument(int instrumentId, string instrumentName)
        {
            if (_dashboardSP.CheckDelete<Instrument>(instrumentId))
            {
                TempData["CustomError"] = "Can't Delete. There are instruments for Musician ( " + instrumentName + " )";
                ModelState.AddModelError("CustomError", "Can't Delete. There are instruments for Musician ( " + instrumentName + " )");
            }
            else
            {
                _dashboardSP.Remove<Instrument>(instrumentId);
            }

            return RedirectToAction("Index");
        }
    }
}
