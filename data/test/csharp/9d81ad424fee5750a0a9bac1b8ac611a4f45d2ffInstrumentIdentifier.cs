using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SyndicateLogic.Entities
{
    [Table("app.instrumentIdentifiers")]
    public class InstrumentIdentifier
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        [Index, ForeignKey("Instrument")]
        public int InstrumentID { get; set; }
        public virtual Instrument Instrument { get; set; }
        [Index, MaxLength(30)]
        public string Text { get; set; }
    }
}
