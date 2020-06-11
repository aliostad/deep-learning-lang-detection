using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GiM.Classes.Programm_Classes;

namespace GiM.Classes.Data_Classes
{
    [Serializable]
    public class Instrument 
    {
        public string Name { get; set; }
        
        public InstrumentFamily Family { get; set; }
        public InstrumentType Type { get; set; }
        public InstrumentFeature Feature { get; set; }

        public Instrument(InstrumentFamily family, InstrumentType type, InstrumentFeature feature)
        {
            this.Family = family;
            this.Type = type;
            this.Feature = feature;
        }

    }
}
