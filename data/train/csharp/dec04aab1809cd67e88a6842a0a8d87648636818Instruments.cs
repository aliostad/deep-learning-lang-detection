using MusicSchoolClass.Base;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MusicSchoolClass.Models
{

    [Table("Instruments")]
    public class Instruments : EntityBase
    {
        #region Attributes
        private Int32 id;
        private String instrumentName;
        private String instrumentCategory;
        private String instrumentTallCat;
        private Boolean location;

        #endregion
        #region Properties
        [Key]
        [Column("id")]
        public int Id
        {
            get { return id; }
            set { id = value; OnPropertyChanged("Id"); }

        }
        [Column("instrumentName")]
        public String InstrumentName
        {
            get{return instrumentName;}
            set{instrumentName = value;this.OnPropertyChanged("InstrumentName");}
        }

        [Column("instrumentCategory")]
        public String InstrumentCategory
        {
            get{return instrumentCategory;}
            set{instrumentCategory = value;this.OnPropertyChanged("InstrumentCategory");}
        }

        [Column("instrumentTallCat")]
        public String InstrumentTallCat
        {
            get{return instrumentTallCat;}
            set{instrumentTallCat = value;this.OnPropertyChanged("InstrumentTallCat");}
        }

        [Column("location")]
        public bool Location
        {
            get{return location;}
            set{location = value;this.OnPropertyChanged("Location");}
        }

       
        #endregion

        #region Constructors

        #endregion
        #region Methods
        public override string ToString()
        {
            return this.instrumentName + " " + this.instrumentTallCat ;
        }
        #endregion
    }
}