using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace BlowOutBrianMarchant.Models
{
    [Table("Instrument")]
    public class Instrument
    {
        [Key]
        public int InstrumentID { get; set; }

        [Required (ErrorMessage = "Please Enter the Type of Instrument")]
        [DisplayName ("Instrument")]
        public string InstrumentDescription { get; set; }

        [Required(ErrorMessage = "Please Enter the instrument condition 'New' or 'Used'")]
        [DisplayName("Condition")]
        public string InstrumentCondition { get; set; }

        [Required(ErrorMessage = "Please Enter the instrument price")]
        [DisplayName("Price")]
        public decimal InstrumentPrice { get; set; }

        [DisplayName("Client ID")]
        public int? ClientID { get; set; }
    }
}