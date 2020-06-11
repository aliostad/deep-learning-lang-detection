using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MWV.Models;
using MWV.DBContext;
using MWV.Repository.Implementation;

namespace MWV.Controllers
{
    public class Truck_dispatch_detailController : Controller
    {
        private MWVDBContext db = new MWVDBContext();
        [HandleModelStateException]
        protected override void OnActionExecuting(ActionExecutingContext context)
        {
            base.OnActionExecuting(context);
            // your code here
            if (!Request.IsAuthenticated)
            {
                this.ModelState.AddModelError("440", "Session Timeout");
                throw new ModelStateException(this.ModelState);

            }
        }

        // GET: /Truck_dispatch_detail/
        [HandleModelStateException]
        public ActionResult Index()
        {
            var truck_dispatch_details = db.Truck_dispatch_details.Include(t => t.Order).Include(t => t.Order_products).Include(t => t.Truck_dispatches);
            return View(truck_dispatch_details.ToList());
        }

        // GET: /Truck_dispatch_detail/Details/5
        [HandleModelStateException]
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Truck_dispatch_details truck_dispatch_details = db.Truck_dispatch_details.Find(id);
            if (truck_dispatch_details == null)
            {
                return HttpNotFound();
            }
            return View(truck_dispatch_details);
        }

        // GET: /Truck_dispatch_detail/Create
        [HandleModelStateException]
        public ActionResult Create()
        {
            //ViewBag.order_id = new SelectList(db.Orders, "order_id", "status");
            ViewBag.order_id = new SelectList(db.Orders, "order_id", "order_id");
            ViewBag.order_product_id = new SelectList(db.Order_products, "order_product_id", "product_code");
            //ViewBag.truck_dispatch_id = new SelectList(db.Truck_dispatches, "truck_dispatch_id", "truck_no");
            ViewBag.truck_dispatch_id = new SelectList(db.Truck_dispatches, "truck_dispatch_id", "truck_dispatch_id");
            return View();
        }

        // POST: /Truck_dispatch_detail/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [HandleModelStateException]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "truck_dispatch_id,order_id,order_product_id,qty")] Truck_dispatch_details truck_dispatch_details)
        {
            truck_dispatch_details.truck_dispatch_id = Convert.ToInt16(Request.UrlReferrer.Segments[3]);
            truck_dispatch_details.order_id = Convert.ToInt16(Request["order_id"]);
            truck_dispatch_details.order_product_id = Convert.ToInt16(Request["order_product_id"]);
            truck_dispatch_details.qty = Convert.ToInt16(Request["qty"]);

            if (ModelState.IsValid)
            {
                db.Truck_dispatch_details.Add(truck_dispatch_details);
                db.SaveChanges();
                //return RedirectToAction("Index");
            }

            ViewBag.order_id = new SelectList(db.Orders, "order_id", "status", truck_dispatch_details.order_id);
            ViewBag.order_product_id = new SelectList(db.Order_products, "order_product_id", "product_code", truck_dispatch_details.order_product_id);
            ViewBag.truck_dispatch_id = new SelectList(db.Truck_dispatches, "truck_dispatch_id", "truck_no", truck_dispatch_details.truck_dispatch_id);
            // return View(truck_dispatch_details);
            return RedirectToAction("Edit", "Truck_dispatch", new { id = truck_dispatch_details.truck_dispatch_id });
        }

        // GET: /Truck_dispatch_detail/Edit/5
        [HandleModelStateException]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Truck_dispatch_details truck_dispatch_details = db.Truck_dispatch_details.Find(id);
            if (truck_dispatch_details == null)
            {
                return HttpNotFound();
            }
            ViewBag.order_id = new SelectList(db.Orders, "order_id", "status", truck_dispatch_details.order_id);
            ViewBag.order_product_id = new SelectList(db.Order_products, "order_product_id", "product_code", truck_dispatch_details.order_product_id);
            ViewBag.truck_dispatch_id = new SelectList(db.Truck_dispatches, "truck_dispatch_id", "truck_no", truck_dispatch_details.truck_dispatch_id);
            return View(truck_dispatch_details);
        }

        // POST: /Truck_dispatch_detail/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [HandleModelStateException]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "truck_dispatch_details_id,truck_dispatch_id,order_id,order_product_id,qty")] Truck_dispatch_details truck_dispatch_details)
        {
            if (ModelState.IsValid)
            {
                db.Entry(truck_dispatch_details).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.order_id = new SelectList(db.Orders, "order_id", "status", truck_dispatch_details.order_id);
            ViewBag.order_product_id = new SelectList(db.Order_products, "order_product_id", "product_code", truck_dispatch_details.order_product_id);
            ViewBag.truck_dispatch_id = new SelectList(db.Truck_dispatches, "truck_dispatch_id", "truck_no", truck_dispatch_details.truck_dispatch_id);
            //return View(truck_dispatch_details);
            return RedirectToAction("Edit", "Truck_dispatch", new { id = truck_dispatch_details.truck_dispatch_id });
        }

        // GET: /Truck_dispatch_detail/Delete/5
        [HandleModelStateException]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Truck_dispatch_details truck_dispatch_details = db.Truck_dispatch_details.Find(id);
            if (truck_dispatch_details == null)
            {
                return HttpNotFound();
            }
            return View(truck_dispatch_details);
        }

        // POST: /Truck_dispatch_detail/Delete/5
        [HttpPost, ActionName("Delete")]
        [HandleModelStateException]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Truck_dispatch_details truck_dispatch_details = db.Truck_dispatch_details.Find(id);
            db.Truck_dispatch_details.Remove(truck_dispatch_details);
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
