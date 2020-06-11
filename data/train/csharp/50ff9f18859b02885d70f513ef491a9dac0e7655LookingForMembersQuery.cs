using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace BandAide.web.Models
{
    public class LookingForMembersQuery
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid Id { get; set; }
        public Band Band { get; set; }
        public Instrument Instrument { get; set; }
        public int Hits { get; set; }
        public DateTime CreatedOn { get; set; }

        public LookingForMembersQuery(Band band, Instrument instrument)
        {
            Band = band;
            Instrument = instrument;
            CreatedOn=DateTime.Now;
        }

        public List<User> Execute(ApplicationDbContext context)
        {
            return
                context.Users.Where(x => x.MyQueries.Select(y => y.InstrumentSkill.Instrument) == Instrument).ToList();
        } 

    }
}