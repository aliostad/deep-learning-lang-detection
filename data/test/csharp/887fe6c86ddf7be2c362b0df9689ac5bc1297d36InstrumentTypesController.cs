using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Net;
using System.Web;
using System.Web.Mvc;
using HCM.DB;
using HCM.DB.Models.Core;

namespace HCM.Web.Controllers
{
    public class InstrumentTypesController : Controller
    {
        private HcmContext db = new HcmContext();

        // GET: InstrumentTypes
        public async Task<ActionResult> Index()
        {
            return View(await db.InstrumentTypes.ToListAsync());
        }

        // GET: InstrumentTypes/Details/5
        public async Task<ActionResult> Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            InstrumentType instrumentType = await db.InstrumentTypes.FindAsync(id);
            if (instrumentType == null)
            {
                return HttpNotFound();
            }
            return View(instrumentType);
        }

        // GET: InstrumentTypes/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: InstrumentTypes/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create([Bind(Include = "Id,Name")] InstrumentType instrumentType)
        {
            if (ModelState.IsValid)
            {
                db.InstrumentTypes.Add(instrumentType);
                await db.SaveChangesAsync();
                return RedirectToAction("Index");
            }

            return View(instrumentType);
        }

        // GET: InstrumentTypes/Edit/5
        public async Task<ActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            InstrumentType instrumentType = await db.InstrumentTypes.FindAsync(id);
            if (instrumentType == null)
            {
                return HttpNotFound();
            }
            return View(instrumentType);
        }

        // POST: InstrumentTypes/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit([Bind(Include = "Id,Name")] InstrumentType instrumentType)
        {
            if (ModelState.IsValid)
            {
                db.Entry(instrumentType).State = EntityState.Modified;
                await db.SaveChangesAsync();
                return RedirectToAction("Index");
            }
            return View(instrumentType);
        }

        // GET: InstrumentTypes/Delete/5
        public async Task<ActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            InstrumentType instrumentType = await db.InstrumentTypes.FindAsync(id);
            if (instrumentType == null)
            {
                return HttpNotFound();
            }
            return View(instrumentType);
        }

        // POST: InstrumentTypes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> DeleteConfirmed(int id)
        {
            InstrumentType instrumentType = await db.InstrumentTypes.FindAsync(id);
            db.InstrumentTypes.Remove(instrumentType);
            await db.SaveChangesAsync();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
