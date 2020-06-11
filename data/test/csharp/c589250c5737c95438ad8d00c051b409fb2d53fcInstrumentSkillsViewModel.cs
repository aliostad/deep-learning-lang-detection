using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BandAide.web.Models.ViewModels
{
    public class InstrumentSkillsViewModel
    {
        public List<InstrumentSkill> UserInstrumentSkills { get; set; } 
        public List<Instrument> AllInstruments { get; set; }
        public List<Instrument> PlayedInstruments { get; set; }
        public List<Instrument> UnplayedInstruments { get; set; }
         
        public SelectList InstrumentsSelectList { get; set; }
       
        public Guid UserId { get; set; }

        public Instrument SelectedInstrument { get; set; }
        public Guid SelectedInstrumentId { get; set; }

        public int SelectedProficiency { get; set; }
        public string About { get; set; }

        //constructors
        public InstrumentSkillsViewModel() { }
        public InstrumentSkillsViewModel(ApplicationDbContext context, User user)
        {
            UserInstrumentSkills = user.InstrumentSkills;
            AllInstruments = context.Instruments.ToList();
            PlayedInstruments = UserInstrumentSkills.Select(x=>x.Instrument).ToList();
            UnplayedInstruments = AllInstruments.Where(x => !PlayedInstruments.Contains(x)).ToList();
            InstrumentsSelectList = new SelectList(UnplayedInstruments,"Id","Name",UnplayedInstruments[0]);
            UserId = Guid.Parse(user.Id);
        }

    }
}