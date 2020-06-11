using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Patient_Transport_Migration.Models.DAL;
using Patient_Transport_Migration.Models.POCO;

namespace Patient_Transport_Migration.Controllers
{
    public class DispatchWerknemersController : Controller
    {
        private Context db = new Context();

        // GET: DispatchWerknemers
        public ActionResult Index()
        {
            return View(db.tblDispatchWerknemers.ToList());
        }

        // GET: DispatchWerknemers/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DispatchWerknemer dispatchWerknemer = db.tblDispatchWerknemers.Find(id);
            if (dispatchWerknemer == null)
            {
                return HttpNotFound();
            }
            return View(dispatchWerknemer);
        }

        // GET: DispatchWerknemers/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: DispatchWerknemers/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,Gebruikersnaam")] DispatchWerknemer dispatchWerknemer)
        {
            if (ModelState.IsValid)
            {
                db.tblDispatchWerknemers.Add(dispatchWerknemer);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(dispatchWerknemer);
        }

        // GET: DispatchWerknemers/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DispatchWerknemer dispatchWerknemer = db.tblDispatchWerknemers.Find(id);
            if (dispatchWerknemer == null)
            {
                return HttpNotFound();
            }
            return View(dispatchWerknemer);
        }

        // POST: DispatchWerknemers/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,Gebruikersnaam")] DispatchWerknemer dispatchWerknemer)
        {
            if (ModelState.IsValid)
            {
                db.Entry(dispatchWerknemer).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(dispatchWerknemer);
        }

        // GET: DispatchWerknemers/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DispatchWerknemer dispatchWerknemer = db.tblDispatchWerknemers.Find(id);
            if (dispatchWerknemer == null)
            {
                return HttpNotFound();
            }
            return View(dispatchWerknemer);
        }

        // POST: DispatchWerknemers/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            DispatchWerknemer dispatchWerknemer = db.tblDispatchWerknemers.Find(id);
            db.tblDispatchWerknemers.Remove(dispatchWerknemer);
            db.SaveChanges();
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
