using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FlyweightTräning
{
    class Program
    {
        static void Main(string[] args)
        {
            InstrumentFlyweightFactory factory = new InstrumentFlyweightFactory();
            IInstrument instrument1 = factory.GetInstrument(InstrumentType.Violin);
            IInstrument instrument2 = factory.GetInstrument(InstrumentType.Violin);
            IInstrument instrument3 = factory.GetInstrument(InstrumentType.Drum);
            IInstrument instrument4 = factory.GetInstrument(InstrumentType.Drum);
            IInstrument instrument5 = factory.GetInstrument(InstrumentType.Trumpet);
            IInstrument instrument6 = factory.GetInstrument(InstrumentType.Trumpet);
            Console.WriteLine(instrument1.GetHashCode());
            Console.WriteLine(instrument2.GetHashCode());
            Console.WriteLine(instrument3.GetHashCode());
            Console.WriteLine(instrument4.GetHashCode());
            Console.WriteLine(instrument5.GetHashCode());
            Console.WriteLine(instrument6.GetHashCode());
            Console.ReadLine();
        }
    }
}
