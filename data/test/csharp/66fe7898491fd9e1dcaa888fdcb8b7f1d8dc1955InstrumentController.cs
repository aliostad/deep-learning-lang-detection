using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using WebInstruments.Models;
using WebInstruments.ViewModels;
using WebInstruments.Filters;

namespace WebInstruments.Controllers
{
    [AuthorizationFilter]
    public class InstrumentController : Controller
    {
        private ApplicationDbContext _context;

        public InstrumentController()
        {
            _context = new ApplicationDbContext();
        }

        public ActionResult InstrumentList()
        {
            var viewModel = new NewInstrumentViewModel()
            {
                InstrumentTypes = _context.InstrumentTypes.ToList(),
                MeasurementUnits = _context.MeasurementUnits.ToList(),
                Suppliers = _context.Suppliers.ToList(),
                Instruments = _context.Instruments.ToList()
            };

            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Save(NewInstrumentViewModel viemModel)
        {
            var instrument = viemModel.Instrument;

            if (instrument.Id == 0)
            {
                instrument.RegisterDate = DateTime.Now;
                instrument.IdUser = _context.UsersS.FirstOrDefault().Id;

                _context.Instruments.Add(instrument);
            }
            else
            {
                var instrumentToModify = _context
                    .Instruments
                    .SingleOrDefault(i => i.Id == instrument.Id);

                if (instrumentToModify == null)
                    return HttpNotFound();

                instrumentToModify.Code = instrument.Code;
                instrumentToModify.IdMeasurementUnit = instrument.IdMeasurementUnit;
                instrumentToModify.MinimumValue = instrument.MinimumValue;
                instrumentToModify.MaximumValue = instrument.MaximumValue;
                instrumentToModify.IdSupplier = instrument.IdSupplier;
                instrumentToModify.IdInstrumentType = instrument.IdInstrumentType;
            }


            _context.SaveChanges();

            return RedirectToAction("InstrumentList", "Instrument");
        }

        

        [HttpPost]
        public ActionResult Remove(int id)
        {
            _context.Instruments.Remove(_context.Instruments.SingleOrDefault(i => i.Id == id));
            _context.SaveChanges();

            return RedirectToAction("InstrumentList", "Instrument");
        }

        [HttpPost]
        public ContentResult getData(int id)
        {
            var instrument = _context.Instruments.SingleOrDefault(i => i.Id == id);
            return Content(JsonConvert.SerializeObject(instrument));
        }
    }
}