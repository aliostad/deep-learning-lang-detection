using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BandAide.Web.Models.ViewModels
{
    public class NeedBandQueryViewModel
    {
        private readonly IEnumerable<Instrument> _instruments;
        public ApplicationUser User { get; set; }

        public Instrument SelectedInstrument { get; set; }
        public SelectList MyInstrumentsSelectList { get; set; }
        public SelectListItem SelectedInstrumentSelectListItem { get; set; }
        public Guid SelectedInstrumentId { get; set; }
        public List<InstrumentSkill> MyInstrumentSkills { get; set; }
        public List<Band> SearchResults { get; set; }

        public NeedBandQueryViewModel(ApplicationUser user)
        {
            User = user;
            MyInstrumentSkills = user.InstrumentSkills.OrderByDescending(x => x.Proficiency).ToList();
            List<Instrument> instruments= MyInstrumentSkills.Select(instrumentSkill => instrumentSkill.Instrument).ToList();
            MyInstrumentsSelectList = new SelectList(instruments, "Id", "Name");
        }

        public NeedBandQueryViewModel(ApplicationUser user, Instrument instrument)
        {
            User = user;
            SelectedInstrument = instrument;
        }
    }
}