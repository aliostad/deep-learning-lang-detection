using StorageControl.Domain.Contracts.Interfaces;
using StorageControl.Web.Controllers.Base;
using StorageControl.Web.Models.InstrumentTypes;
using System;
using System.Linq;
using System.Web.Mvc;

namespace StorageControl.Web.Controllers
{
    public class InstrumentTypesController : BaseController
    {
        public IInstrumentTypesRepository InstrumentTypesRepository { get; set; }

        public InstrumentTypesController(IInstrumentTypesRepository instrumentTypesRepository)
        {
            this.InstrumentTypesRepository = instrumentTypesRepository;
        }

        public ViewResult Index()
        {
            InstrumentTypesListModel model = new InstrumentTypesListModel();
            model.InstrumentTypes = InstrumentTypesRepository.List().ToList();

            return View(model);
        }

        public ViewResult Create()
        {
            InstrumentTypesCreateModel model = new InstrumentTypesCreateModel();
            return View(model);
        }

        [HttpPost]
        public ActionResult Create(InstrumentTypesCreateModel model)
        {
            ValidateModel(model);
            if (ModelState.IsValid)
            {
                try
                {
                    int result = InstrumentTypesRepository.Create(model.InstrumentType);

                    Success(string.Format("Tipo '{0}' criado. :)", model.InstrumentType.Name));
                    return RedirectToAction("Index");
                }
                catch
                {
                    Error("Ocorreu um erro ao processar sua requisição. :(");
                    return View("Error");
                }
            }
            else
            {
                Warning(BuildErrorMessage(GetErrors()));
                return View(model);
            }
        }

        public ActionResult Edit(int id)
        {
            if (id > 0)
            {
                InstrumentTypesEditModel model = new InstrumentTypesEditModel();
                model.InstrumentType = InstrumentTypesRepository.Get(id);

                return View(model);
            }
            else
            {
                return View("Error");
            }
        }

        [HttpPost]
        public ActionResult Edit(int id, InstrumentTypesEditModel model)
        {
            ValidateModel(model);
            if (ModelState.IsValid)
            {
                try
                {
                    model.InstrumentType.Id = id;
                    int result = InstrumentTypesRepository.Update(model.InstrumentType);

                    Success("Tipo atualizado.");
                    return RedirectToAction("Index");
                }
                catch
                {
                    return View("Error");
                }
            }
            else
            {
                Warning(BuildErrorMessage(GetErrors()));
                return RedirectToAction("Edit");
            }
        }

        public ActionResult Delete(int id)
        {
            if (id > 0)
            {
                InstrumentTypesDeleteModel model = new InstrumentTypesDeleteModel();
                model.InstrumentType = InstrumentTypesRepository.Get(id);

                return View(model);
            }
            else
            {
                return View("Error");
            }
        }

        [HttpPost]
        public ActionResult Delete(int id, InstrumentTypesDeleteModel model)
        {
            if (id > 0)
            {
                try
                {
                    int result = InstrumentTypesRepository.Delete(id);

                    if (result > 0)
                    {
                        Success(string.Format("Tipo '{0}' excluído. :)", model.InstrumentType.Name));
                        return RedirectToAction("Index");
                    }
                    else
                    {
                        Error("Houve um problema ao processar sua requisição. :( Tente noavmente.");
                        return View(model);
                    }
                }
                catch(Exception e)
                {
                    return View("Error");
                }
            }
            else
            {
                return View("Error");
            }
        }

        #region [Model Validation]
        private void ValidateModel(InstrumentTypesCreateModel model)
        {
            if (model.InstrumentType.Name == null || model.InstrumentType.Name == string.Empty)
            {
                ModelState.AddModelError("Name",
                    "Parece que o campo Nome não foi preenchido. :( Preencha-o e tente novamente.");
            }
        }

        private void ValidateModel(InstrumentTypesEditModel model)
        {
            if (model.InstrumentType.Id < 0)
            {
                ModelState.AddModelError("Id", "Tipo inexistente. :(");
            }
            else if (model.InstrumentType.Name == null || 
                model.InstrumentType.Name == string.Empty)
            {
                ModelState.AddModelError("Name",
                    "Parece que o campo Nome não foi preenchido. :( Preencha-o e tente novamente.");
            }
        }
        #endregion
    }
}
