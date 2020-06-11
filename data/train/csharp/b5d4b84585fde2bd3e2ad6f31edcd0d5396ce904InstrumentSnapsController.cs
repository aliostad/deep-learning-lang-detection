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
using HCM.DB.Models.MarketData;

namespace HCM.Web.Controllers
{
    public class InstrumentSnapsController : Controller
    {
        private HcmContext db = new HcmContext();

        // GET: InstrumentSnaps
        public async Task<ActionResult> Index()
        {
            var instrumentSnaps = db.InstrumentSnaps.Include(i => i.Instrument);
            return View(await instrumentSnaps.ToListAsync());
        }

        // GET: InstrumentSnaps/Details/5
        public async Task<ActionResult> Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            InstrumentSnap instrumentSnap = await db.InstrumentSnaps.FindAsync(id);
            if (instrumentSnap == null)
            {
                return HttpNotFound();
            }
            return View(instrumentSnap);
        }

        // GET: InstrumentSnaps/Create
        public ActionResult Create()
        {
            ViewBag.InstrumentId = new SelectList(db.Instruments, "Id", "Name");
            return View();
        }

        // POST: InstrumentSnaps/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create([Bind(Include = "Id,InstrumentId,Date,Time,Open,Last,High,Low,Close")] InstrumentSnap instrumentSnap)
        {
            if (ModelState.IsValid)
            {
                db.InstrumentSnaps.Add(instrumentSnap);
                await db.SaveChangesAsync();
                return RedirectToAction("Index");
            }

            ViewBag.InstrumentId = new SelectList(db.Instruments, "Id", "Name", instrumentSnap.InstrumentId);
            return View(instrumentSnap);
        }

        // GET: InstrumentSnaps/Edit/5
        public async Task<ActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            InstrumentSnap instrumentSnap = await db.InstrumentSnaps.FindAsync(id);
            if (instrumentSnap == null)
            {
                return HttpNotFound();
            }
            ViewBag.InstrumentId = new SelectList(db.Instruments, "Id", "Name", instrumentSnap.InstrumentId);
            return View(instrumentSnap);
        }

        // POST: InstrumentSnaps/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit([Bind(Include = "Id,InstrumentId,Date,Time,Open,Last,High,Low,Close")] InstrumentSnap instrumentSnap)
        {
            if (ModelState.IsValid)
            {
                db.Entry(instrumentSnap).State = EntityState.Modified;
                await db.SaveChangesAsync();
                return RedirectToAction("Index");
            }
            ViewBag.InstrumentId = new SelectList(db.Instruments, "Id", "Name", instrumentSnap.InstrumentId);
            return View(instrumentSnap);
        }

        // GET: InstrumentSnaps/Delete/5
        public async Task<ActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            InstrumentSnap instrumentSnap = await db.InstrumentSnaps.FindAsync(id);
            if (instrumentSnap == null)
            {
                return HttpNotFound();
            }
            return View(instrumentSnap);
        }

        // POST: InstrumentSnaps/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> DeleteConfirmed(int id)
        {
            InstrumentSnap instrumentSnap = await db.InstrumentSnaps.FindAsync(id);
            db.InstrumentSnaps.Remove(instrumentSnap);
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
