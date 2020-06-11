using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BandAide.Web.Models
{
    public class NeedMembersQueryResultViewModel
    {
        public List<ApplicationUser> Users { get; set; }
        public Band Band { get; set; }
        public Instrument Instrument { get; set; }
        public NeedMembersQueryResultViewModel(Band band, Instrument instrument,List<ApplicationUser> users)
        {
            Band = band;
            Instrument = instrument;
            Users = users;
        }
    }
}