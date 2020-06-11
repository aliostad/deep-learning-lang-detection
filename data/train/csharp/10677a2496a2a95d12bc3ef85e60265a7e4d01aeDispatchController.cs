using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using COP4710.Models;
using COP4710.Models.Enumerations;
using COP4710.DataAccess;
using COP4710.Attributes;

namespace COP4710.Controllers
{
    [Authorization]
    public class DispatchController : Controller
    {
        //
        // GET: /Dispatch/

        public ActionResult Index(int? page)
        {
            if (page.HasValue)
            {
                ViewBag.Page = page;
                return View(DispatchDAO.List(page.Value));
            }
            else
            {
                ViewBag.Page = page;
                Boolean disablePaging = false;
                Boolean.TryParse(ConfigurationManager.AppSettings["DisablePaging"].ToString(), out disablePaging);

                if (disablePaging == false)
                    return RedirectToAction("Index", new { @page = 0 });
                else
                    return View(DispatchDAO.List());
            }
        }




        //
        // GET: /Dispatch/Details/5

        public ActionResult Details(int id)
        {
            DispatchModel dispatch = DispatchDAO.GetDispatchByID(id);

            if (dispatch != null)
                return View(dispatch);
            else
                return RedirectToAction("index");
        }

        //
        // GET: /Dispatch/Create

        public ActionResult Create()
        {
            return View(new DispatchModel());
        }

        //
        // POST: /Dispatch/Create

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                DispatchModel form = new DispatchModel();

                TryUpdateModel<DispatchModel>(form, collection.ToValueProvider());

                int rowsAffected = DispatchDAO.Insert(form);

                return RedirectToAction("Index");

            }
            catch
            {
                return RedirectToAction("Create");
            }
        }

        //
        // GET: /Dispatch/Edit/5

        [Authorization(UserRole = AccountType.Administrator)]
        public ActionResult Edit(int id)
        {
            if (id > 0)
                return View(DispatchDAO.GetDispatchByID(id));
            else
                return RedirectToAction("Index");
        }

        //
        // POST: /Dispatch/Edit/5


        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            DispatchModel form = new DispatchModel();

            try
            {

                TryUpdateModel<DispatchModel>(form, collection.ToValueProvider());

                int rowsAffected = DispatchDAO.UpdateForm(form);
            }
            catch
            {
                return View();
            }

            try
            {
                return RedirectToAction("Edit", new { id = form.FormID });
            }
            catch
            {
                return RedirectToAction("Index");
            }

        }



        public List<SelectListItem> ListETA()
        {
            List<SelectListItem> list = new List<SelectListItem>();

            for (int i = 0; i <= 60; i++)
            {
                list.Add(new SelectListItem() { Text = i.ToString(), Value = i.ToString() });
            }

            return list;
        }
    }
}
