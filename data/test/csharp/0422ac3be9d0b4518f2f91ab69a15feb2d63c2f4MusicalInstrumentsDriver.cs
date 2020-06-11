using AbstractFactory.MusicalInstruments.Abstract_Classes;
using AbstractFactory.MusicalInstruments.Concrete_Classes.InstrumentFactory_Extensions;
using System;

namespace AbstractFactory.MusicalInstruments.Driver_Classes {
    class MusicalInstrumentsDriver {
        static void Main(string[] args) {
            InstrumentFactory medievalFactory = new MedievalInstrumentFactory();
            InstrumentFactory modernFactory = new ModernInstrumentFactory();

            Instrument instrument = medievalFactory.OrderInstrument("string");
            Console.WriteLine(instrument);

            instrument = modernFactory.OrderInstrument("string");
            Console.WriteLine(instrument);

            Console.ReadLine();

            /* Console output:

            The following instrument sounds Warm, Bright, Nasal,
            Name: Theorbo
            Materials: Wood from Maple and Spruce trees, Catgut (not literally gut from cats
            ),

            The following instrument sounds Buzzing, Noisy,
            Name: Electric Guitar
            Materials: Carbon Fiber, Strong Steel,

             */
        }
    }
}
