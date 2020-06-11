using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadioStation
{
    class Musician
    {
        private string name;
        private string instrument;
        public string Name
        {
            get
            {
                return name;
            }
        }
        public string Instrument
        {
            get
            {
                return instrument;
            }
        }
        public Musician(string p_name, string p_instrument)
        {
            name = p_name;
            instrument = p_instrument;
        }
        public void Print()
        {
            if(instrument=="singer")
            {
                Console.WriteLine("{0} is a {1}", name, instrument);
            }
            else
            {
                Console.WriteLine("{0} plays the {1}", name, instrument);
            }
        }
    }
}
