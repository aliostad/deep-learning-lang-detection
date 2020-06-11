using Sisgim.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net;

namespace Sisgim.Controllers
{
    public class MusicalInstrumentController : Controller
    {
        private SISGIMEntities dbSisgim = new SISGIMEntities();

        [Authorize]
        // GET: MusicalInstrument
        public ActionResult Index(String nombreInstrumento)
        {
            var instrumento = from s in dbSisgim.INSTRUMENTOMUSICAL select s;
            if (!string.IsNullOrEmpty(nombreInstrumento))
            {
                instrumento = instrumento.Where(a => a.NOMBRE.Contains(nombreInstrumento));
            }
            return View(instrumento);
        }

        // GET: MusicalInstrument/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: MusicalInstrument/Create
        [HttpPost]
        public ActionResult Create(INSTRUMENTOMUSICAL instrument)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var a = instrument;
                    a.NOMBREPROFESOR = User.Identity.Name;
                    dbSisgim.INSTRUMENTOMUSICAL.Add(a);
                    dbSisgim.SaveChanges();
                    dbSisgim.Dispose();
                    return RedirectToAction("Index");
                }
                return View(instrument);
            }
            catch
            {
                return View(instrument);
            }
        }

        // GET: MusicalInstrument/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            var instrument = dbSisgim.INSTRUMENTOMUSICAL.Find(id);

            if (instrument == null)
            {
                return HttpNotFound();
            }

            return View(instrument);
        }

        // POST: MusicalInstrument/Edit/5
        [HttpPost]
        public ActionResult Edit(INSTRUMENTOMUSICAL instrument)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    dbSisgim.Entry(instrument).State = EntityState.Modified;
                    dbSisgim.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View(instrument);
            }
            catch
            {
                return View(instrument);
            }
        }

        // GET: MusicalInstrument/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            var instrument = dbSisgim.INSTRUMENTOMUSICAL.Find(id);

            if (instrument == null)
            {
                return HttpNotFound();
            }

            return View(instrument);
        }

        // POST: MusicalInstrument/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, INSTRUMENTOMUSICAL instrument)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    instrument = dbSisgim.INSTRUMENTOMUSICAL.Find(id);
                    if (instrument == null)
                    {
                        return HttpNotFound();
                    }
                    dbSisgim.INSTRUMENTOMUSICAL.Remove(instrument);
                    dbSisgim.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View(instrument);
            }
            catch
            {
                return View(instrument);
            }
        }
    }
}
