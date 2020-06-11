using Newtonsoft.Json;
using SetGenerator.Service;
using SetGenerator.WebUI.ViewModels;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using SetGenerator.Data.Repositories;
using SetGenerator.Domain.Entities;
using SetGenerator.WebUI.Common;

namespace SetGenerator.WebUI.Controllers
{
    [RoutePrefix("Instruments")]
    public class InstrumentsController : Controller
    {
        private readonly IInstrumentRepository _instrumentRepository;
        private readonly ISongRepository _songRepository;
        private readonly IValidationRules _validationRules;
        private readonly User _currentUser;
        private readonly CommonSong _common;

        public InstrumentsController(   IInstrumentRepository instrumentRepository,
                                        ISongRepository songRepository,
                                        IValidationRules validationRules,
                                        IAccount account)
        {
            _instrumentRepository = instrumentRepository;
            _songRepository = songRepository;
            _validationRules = validationRules;

            var currentUserName = GetCurrentSessionUser();
            if (currentUserName.Length > 0)
                _currentUser = account.GetUserByUserName(currentUserName);
            _common = new CommonSong(account, currentUserName);
        }

        [Authorize]
        public ActionResult Index(int? id)
        {
            return View(LoadInstrumentViewModel(0, null));
        }

        [HttpGet]
        public JsonResult GetData()
        {
            var vm = new
            {
                InstrumentList = GetInstrumentList(),
                TableColumnList = _common.GetTableColumnList(_currentUser.Id, Constants.UserTable.InstrumentId)
            };

            return Json(vm, JsonRequestBehavior.AllowGet);
        }

        private IEnumerable<InstrumentDetail> GetInstrumentList()
        {
            var instrumentList = _instrumentRepository.GetAll();
            var songInstrumentIds = _songRepository.GetSongInstrumentIds();

            var result = instrumentList
                .GroupJoin(songInstrumentIds, instrument => instrument.Id, songInstrumentId => songInstrumentId,
                (i, si) => new InstrumentDetail
            {
                Id = i.Id,
                Name = i.Name,
                Abbreviation = i.Abbreviation,
                IsSongInstrument = si.Any()
            }).OrderBy(x => x.Name).ToArray();

            return result;
        }

        public string GetCurrentSessionUser()
        {
            return (System.Web.HttpContext.Current.User.Identity.Name);
        }

        private static InstrumentViewModel LoadInstrumentViewModel(int selectedId, List<string> msgs)
        {
            var model = new InstrumentViewModel
            {
                SelectedId = selectedId,
                Success = (msgs == null),
                ErrorMessages = msgs
            };

            return model;
        }

        [HttpGet]
        public PartialViewResult GetInstrumentEditView(int id)
        {
            return PartialView("_InstrumentEdit", LoadInstrumentEditViewModel(id));
        }

        private InstrumentEditViewModel LoadInstrumentEditViewModel(int id)
        {
            Instrument instrument = null;

            if (id > 0)
            {
                instrument = _instrumentRepository.Get(id);
            }
            var vm = new InstrumentEditViewModel
            {
                Name = (instrument != null) ? instrument.Name : string.Empty,
                Abbreviation = (instrument != null) ? instrument.Abbreviation : string.Empty
            };

            return vm;
        }

        [HttpPost]
        public JsonResult Save(string instrument)
        {
            var i = JsonConvert.DeserializeObject<InstrumentDetail>(instrument);
            IEnumerable<string> msgs;
            var instrumentId = i.Id;

            if (instrumentId > 0)
            {
                msgs = ValidateInstrument(i.Name, i.Abbreviation, false);
                if (msgs == null)
                    UpdateInstrument(i);
            }
            else
            {
                msgs = ValidateInstrument(i.Name, i.Abbreviation, true);
                if (msgs == null)
                    instrumentId = AddInstrument(i);
            }

            return Json(new
            {
                InstrumentList = GetInstrumentList(),
                SelectedId = instrumentId,
                Success = (null == msgs),
                ErrorMessages = msgs
            }, JsonRequestBehavior.AllowGet);
        }

        private IEnumerable<string> ValidateInstrument(string name, string abbreviation, bool addNew)
        {
            return _validationRules.ValidateInstrument(name, abbreviation, addNew);
        }

        [HttpPost]
        public JsonResult Delete(int id)
        {
            _instrumentRepository.Delete(id);

            return Json(new
            {
                InstrumentList = GetInstrumentList(),
                Success = true,
            }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult SaveColumns(string columns)
        {
            _common.SaveColumns(columns, Constants.UserTable.InstrumentId);
            return Json(JsonRequestBehavior.AllowGet);
        }

        private int AddInstrument(InstrumentDetail instrumentDetail)
        {
            var i = new Instrument
            {
                Name = instrumentDetail.Name,
                Abbreviation = instrumentDetail.Abbreviation
            };

            return _instrumentRepository.Add(i);
        }

        private void UpdateInstrument(InstrumentDetail instrumentDetail)
        {
            var instrument = _instrumentRepository.Get(instrumentDetail.Id);

            if (instrument != null)
            {
                instrument.Name = instrumentDetail.Name;
                instrument.Abbreviation = instrumentDetail.Abbreviation;
            };

            _instrumentRepository.Update(instrument);
        }
    }
}
