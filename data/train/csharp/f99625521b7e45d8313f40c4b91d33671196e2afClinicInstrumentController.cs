using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DENTALMIS.Model;
using DENTALMIS.Web.Models.ClinicDescriptionModel;
using DENTALMIS.Web.Models.EmployeeViewModel;

namespace DENTALMIS.Web.Controllers
{
    public class ClinicInstrumentController :BaseController
    {
        //
        // GET: /ClinicInstrument/
        public ActionResult Index(ClinicInstrumentViewModel model)
        {
            ModelState.Clear();
            var totalrecords = 0;
            model.Name = model.SearchbyName;

           
            model.ClinicalInstruments = ClinicInstrumentManager.GetAllInstrumentByPaging(out totalrecords, model);



            model.TotalRecords = totalrecords;

            return View(model);

        }



        public ActionResult Edit(ClinicInstrumentViewModel model)
        {
           
            if (model.InstrumentId > 0)
            {
                ClinicalInstrument clIns = ClinicInstrumentManager.GetInstrumentById(model.InstrumentId);

                model.InstrumentId = clIns.InstrumentId;
                model.Name = clIns.Name;
                model.Description = clIns.Description;
                model.Market = clIns.Market;
               

               

            }

            return View(model);
        }

        public JsonResult Save(ClinicInstrumentViewModel model)
        {
            int saveIndex = 0;

            ClinicalInstrument clinicalInstrument = new ClinicalInstrument();

            clinicalInstrument.InstrumentId = model.InstrumentId;
            clinicalInstrument.Name = model.Name;
            clinicalInstrument.Description = model.Description;
            clinicalInstrument.Market = model.Market;




            saveIndex = model.InstrumentId == 0 ? ClinicInstrumentManager.Save(clinicalInstrument) : ClinicInstrumentManager.Edit(clinicalInstrument);


            return Reload(saveIndex);
        }
        public JsonResult Delete(ClinicInstrumentViewModel model)
        {
            int deleteIndex = 0;
            try
            {
                deleteIndex = ClinicInstrumentManager.Delete(model.InstrumentId);
            }
            catch (Exception exception)
            {

                throw new Exception(exception.Message);
            }
            return deleteIndex > 0 ? Reload() : ErroResult("Failed To Delete");
        }
	}
}
