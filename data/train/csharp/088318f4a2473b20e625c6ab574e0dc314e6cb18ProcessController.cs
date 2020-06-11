using Orkidea.Pioneer.Business;
using Orkidea.Pioneer.Entities;
using Orkidea.Pioneer.Webfront.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Orkidea.Pioneer.Webfront.Controllers
{
    public class ProcessController : Controller
    {
        ProcessBiz processBiz = new ProcessBiz();
        //
        // GET: /Process/
        //[Authorize]
        public ActionResult Index()
        {
            return View();
        }
        [Authorize]
        public ActionResult List()
        {
            List<Process> lstProcess = processBiz.GetProcessList();
            return View(lstProcess);
        }

        //
        // GET: /Process/Details/5
        [Authorize]
        public ActionResult Details(int id)
        {
            #region User identification
            System.Security.Principal.IIdentity context = HttpContext.User.Identity;

            int user = 0;

            if (context.IsAuthenticated)
            {

                System.Web.Security.FormsIdentity ci = (System.Web.Security.FormsIdentity)HttpContext.User.Identity;
                string[] userRole = ci.Ticket.UserData.Split('|');
                user = int.Parse(userRole[0]);
            }

            #endregion

            ProcessDocumentBiz processDocumentBiz = new ProcessDocumentBiz();
            Process process = processBiz.GetProcessbyKey(new Process() { id = id });
            vmProcess oProcess = new vmProcess() { id = id, nombre = process.nombre, descripcion = process.descripcion, archivoCaracterizacion = process.archivoCaracterizacion };

            ActivityLogBiz.SaveActivityLog(new ActivityLog() { idUsuario = user, accion = "Proceso " + process.nombre, fecha = DateTime.Now });

            oProcess.lstDocumentType = processDocumentBiz.GetDocumentTypeByProcess(process);

            return View(oProcess);
        }

        //
        // GET: /Process/Create
        //[Authorize]
        public ActionResult Create()
        {
            vmProcess process = new vmProcess();
            return View(process);
        }

        //
        // POST: /Process/Create
        [HttpPost]
        public ActionResult Create(Process process)
        {
            try
            {
                if (string.IsNullOrEmpty(process.descripcion))
                    process.descripcion = "";
                if (string.IsNullOrEmpty(process.archivoCaracterizacion))
                    process.archivoCaracterizacion = "";

                processBiz.SaveProcess(process);
                return RedirectToAction("List");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Process/Edit/5
        [Authorize]
        public ActionResult Edit(int id)
        {
            Process process = processBiz.GetProcessbyKey(new Process() { id = id });

            vmProcess oProcess = new vmProcess() { id = process.id, archivoCaracterizacion = process.archivoCaracterizacion, descripcion = process.descripcion, nombre = process.nombre };
            ViewBag.idProcess = id;

            return View(oProcess);
        }

        //
        // POST: /Process/Edit/5
        //[Authorize]
        [HttpPost]
        public ActionResult Edit(int id, Process process)
        {
            try
            {
                if (string.IsNullOrEmpty(process.descripcion))
                    process.descripcion = "";
                if (string.IsNullOrEmpty(process.archivoCaracterizacion))
                    process.archivoCaracterizacion = "";

                process.id = id;
                processBiz.SaveProcess(process);
                return RedirectToAction("List");
            }
            catch
            {
                return View();
            }
        }


        // POST: /Process/Delete/5        
        [Authorize]
        public ActionResult Delete(int id, Process process)
        {

            {
                try
                {
                    process.id = id;
                    processBiz.DeleteProcess(process);
                    return RedirectToAction("List");
                }
                catch
                {
                    return RedirectToAction("List");
                }
            }
        }
    }
}
