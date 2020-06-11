using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace _70483
{
    /*     
    * 
    * Abstract Methods Example
    *           
    */

    public abstract class MusicalInstrument
    {
        public abstract void tune();

        public class Piano : MusicalInstrument
        {
            public override void tune()
            {
                Console.WriteLine("Tunning Piano");
            }
        }

        public class Guitar : MusicalInstrument
        {
            public override void tune()
            {
                Console.WriteLine("Tunning Guitar");
            }
        }

        public class BassGuitar : MusicalInstrument
        {
            public override void tune()
            {
                Console.WriteLine("Tunning BassGuitar");
            }
        }
    }
  
    class Program
    {
        static void Main(string[] args)
        { 
            //Using Generics
            {
                List<MusicalInstrument> instrumentList = new List<MusicalInstrument>()
                {                
                    new MusicalInstrument.Piano(),
                    new MusicalInstrument.Guitar(),
                    new MusicalInstrument.BassGuitar()                    
                };

                foreach (var musicalInstrument in instrumentList)
                {
                    musicalInstrument.tune();
                }
            }
        }
    }
}
