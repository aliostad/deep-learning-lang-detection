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
    public class InstrumentReferencesController : Controller
    {
        private HcmContext db = new HcmContext();

        // GET: InstrumentReferences
        public async Task<ActionResult> Index()
        {
            var instrumentReferences = db.InstrumentReferences.Include(i => i.Broker).Include(i => i.Instrument);
            return View(await instrumentReferences.ToListAsync());
        }

        // GET: InstrumentReferences/Details/5
        public async Task<ActionResult> Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            InstrumentReference instrumentReference = await db.InstrumentReferences.FindAsync(id);
            if (instrumentReference == null)
            {
                return HttpNotFound();
            }
            return View(instrumentReference);
        }

        // GET: InstrumentReferences/Create
        public ActionResult Create()
        {
            ViewBag.BrokerId = new SelectList(db.Brokers, "Id", "Name");
            ViewBag.InstrumentId = new SelectList(db.Instruments, "Id", "Name");
            return View();
        }

        // POST: InstrumentReferences/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create([Bind(Include = "Id,Reference,InstrumentId,BrokerId")] InstrumentReference instrumentReference)
        {
            if (ModelState.IsValid)
            {
                db.InstrumentReferences.Add(instrumentReference);
                await db.SaveChangesAsync();
                return RedirectToAction("Index");
            }

            ViewBag.BrokerId = new SelectList(db.Brokers, "Id", "Name", instrumentReference.BrokerId);
            ViewBag.InstrumentId = new SelectList(db.Instruments, "Id", "Name", instrumentReference.InstrumentId);
            return View(instrumentReference);
        }

        // GET: InstrumentReferences/Edit/5
        public async Task<ActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            InstrumentReference instrumentReference = await db.InstrumentReferences.FindAsync(id);
            if (instrumentReference == null)
            {
                return HttpNotFound();
            }
            ViewBag.BrokerId = new SelectList(db.Brokers, "Id", "Name", instrumentReference.BrokerId);
            ViewBag.InstrumentId = new SelectList(db.Instruments, "Id", "Name", instrumentReference.InstrumentId);
            return View(instrumentReference);
        }

        // POST: InstrumentReferences/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit([Bind(Include = "Id,Reference,InstrumentId,BrokerId")] InstrumentReference instrumentReference)
        {
            if (ModelState.IsValid)
            {
                db.Entry(instrumentReference).State = EntityState.Modified;
                await db.SaveChangesAsync();
                return RedirectToAction("Index");
            }
            ViewBag.BrokerId = new SelectList(db.Brokers, "Id", "Name", instrumentReference.BrokerId);
            ViewBag.InstrumentId = new SelectList(db.Instruments, "Id", "Name", instrumentReference.InstrumentId);
            return View(instrumentReference);
        }

        // GET: InstrumentReferences/Delete/5
        public async Task<ActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            InstrumentReference instrumentReference = await db.InstrumentReferences.FindAsync(id);
            if (instrumentReference == null)
            {
                return HttpNotFound();
            }
            return View(instrumentReference);
        }

        // POST: InstrumentReferences/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> DeleteConfirmed(int id)
        {
            InstrumentReference instrumentReference = await db.InstrumentReferences.FindAsync(id);
            db.InstrumentReferences.Remove(instrumentReference);
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
