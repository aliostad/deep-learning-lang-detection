using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LaserModulation.Instruments.Classes
{
    public class InstrumentStauts
    {
        string instrumentModel;
        string status;
        
        public InstrumentStauts(string model, string newStatus)
        {
            InstrumentModel = model;
            Status = newStatus;
        }
        public string InstrumentModel
        {
            get
            {
                return instrumentModel;
            }

            internal set
            {
                instrumentModel = value;
            }
        }

        public string Status
        {
            get
            {
                return status;
            }

            internal set
            {
                status = value;
            }
        }
    }
}
