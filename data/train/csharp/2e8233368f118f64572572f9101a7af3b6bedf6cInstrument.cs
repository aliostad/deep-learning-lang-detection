using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InstrumentStore
{
    class Instrument
    {
        public string SerialNumber { get; private set; }
        public double Price { get; set; }
        public InstrumentSpec Spec { get; private set; }

        public Instrument(string serialNumber, double price, InstrumentSpec spec)
        {
            SerialNumber = serialNumber;
            Price = price;
            Spec = spec;
        }
       

    }
}
