using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WedderburnTestReportsWeb.Models
{
    public class Instrument
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [Display(Name ="UOM")]
        public UnitOfMeasure UnitOfMeasure { get; set; }

        [Display(Name ="Location")]
        public string InstrumentLocation { get; set; }

        [Required]
        [Display(Name ="Make")]
        public string InstrumentMake { get; set; }

        [Required]
        [Display(Name = "Model")]
        public string InstrumentModel { get; set; }

        [Required]
        [Display(Name = "Type")]
        public string InstrumentType { get; set; }

        [Required]
        [Display(Name = "Class")]
        public InstrumentClass InstrumentClass { get; set; }

        [Required]
        [Display(Name = "Capacity")]
        public int InstrumentCapacity { get; set; }

        [Required]
        [Display(Name = "e/d")]
        public int InstrumentGraduation { get; set; }

        [Required]
        [Display(Name = "UOM")]
        public UnitOfMeasure InstrumentGraduationUnitOfMeasure { get; set; }

        [Required]
        [Display(Name = "Serial Number")]
        public string InstrumentSerialNumber { get; set; }

        [Required]
        [Display(Name = "NMI")]
        public string InstrumentNmiNumber { get; set; }
    }

    public enum UnitOfMeasure
    {
        g, kg, t
    }

    public enum InstrumentClass
    {
        I, II, III, IIII, NA
    }
}