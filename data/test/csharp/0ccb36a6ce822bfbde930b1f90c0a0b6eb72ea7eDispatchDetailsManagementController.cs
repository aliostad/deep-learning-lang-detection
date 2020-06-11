using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Net;
using System.Web;
using System.Web.Mvc;
using LogistiX.Models;

namespace LogistiX.Controllers
{
    [Authorize(Roles = "Admin, Administrator")]
    public class DispatchDetailsManagementController : Controller
    {
        
        private LogistiXEntities db = new LogistiXEntities();

        // GET: DispatchDetailsManagement
        [Audit(AuditingLevel = 3)]
        public async Task<ActionResult> Index()
        {
            var tblDispatch = db.tbl_Dispatch_Details.OrderBy(t => t.Dispatch_Details);
            return View(await tblDispatch.ToListAsync());
        }

        // GET: DispatchDetailsManagement/Details/5
        [Audit(AuditingLevel = 3)]
        public async Task<ActionResult> Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            tbl_Dispatch_Details tbl_Dispatch_Details = await db.tbl_Dispatch_Details.FindAsync(id);
            if (tbl_Dispatch_Details == null)
            {
                return HttpNotFound();
            }
            return View(tbl_Dispatch_Details);
        }

        // GET: DispatchDetailsManagement/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: DispatchDetailsManagement/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Audit(AuditingLevel = 3)]
        public async Task<ActionResult> Create([Bind(Include = "Dispatch_Details_ID,Dispatch_Details")] tbl_Dispatch_Details tbl_Dispatch_Details)
        {
            if (ModelState.IsValid)
            {
                db.tbl_Dispatch_Details.Add(tbl_Dispatch_Details);
                await db.SaveChangesAsync();
                return RedirectToAction("Details", new { id = tbl_Dispatch_Details.Dispatch_Details_ID});
            }

            return View(tbl_Dispatch_Details);
        }

        // GET: DispatchDetailsManagement/Edit/5
        public async Task<ActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            tbl_Dispatch_Details tbl_Dispatch_Details = await db.tbl_Dispatch_Details.FindAsync(id);
            if (tbl_Dispatch_Details == null)
            {
                return HttpNotFound();
            }
            return View(tbl_Dispatch_Details);
        }

        // POST: DispatchDetailsManagement/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Audit(AuditingLevel = 3)]
        public async Task<ActionResult> Edit([Bind(Include = "Dispatch_Details_ID,Dispatch_Details")] tbl_Dispatch_Details tbl_Dispatch_Details)
        {
            if (ModelState.IsValid)
            {
                db.Entry(tbl_Dispatch_Details).State = EntityState.Modified;
                await db.SaveChangesAsync();
                return RedirectToAction("Details", new { id = tbl_Dispatch_Details.Dispatch_Details_ID });
            }
            return View(tbl_Dispatch_Details);
        }

        // GET: DispatchDetailsManagement/Delete/5
        public async Task<ActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            tbl_Dispatch_Details tbl_Dispatch_Details = await db.tbl_Dispatch_Details.FindAsync(id);
            if (tbl_Dispatch_Details == null)
            {
                return HttpNotFound();
            }
            return View(tbl_Dispatch_Details);
        }

        // POST: DispatchDetailsManagement/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        [Audit(AuditingLevel = 3)]
        public async Task<ActionResult> DeleteConfirmed(int id)
        {
            tbl_Dispatch_Details tbl_Dispatch_Details = await db.tbl_Dispatch_Details.FindAsync(id);
            db.tbl_Dispatch_Details.Remove(tbl_Dispatch_Details);
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
