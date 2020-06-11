using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BandAide.Web.Models
{
    public enum Proficiency
    {
        Novice,
        NoviceIntermediate,
        Intermediate,
        IntermediatePro,
        Pro,
        Virtuoso
    }

    public class InstrumentSkill
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid Id { get; set; }

        public ApplicationUser ApplicationUser { get; set; }
        public virtual Instrument Instrument { get; set; }
        public Proficiency Proficiency { get; set; }
        public string BackgroundDescription { get; set; }

        //constructors
        public InstrumentSkill()
        {

        }

        public InstrumentSkill(Instrument instrument, Proficiency proficiency, string background,
            ApplicationUser applicationUser)
        {
            ApplicationUser = applicationUser;
            Instrument = instrument;
            Proficiency = proficiency;
            BackgroundDescription = background;
        }
    }
}