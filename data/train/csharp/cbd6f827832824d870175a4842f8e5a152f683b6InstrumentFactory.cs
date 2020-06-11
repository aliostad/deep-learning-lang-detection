using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1.FactoryPattern
{
    class InstrumentFactory
    {

        public ISample CreateInstrument(InstrumentalEnum.InstrumentEnum instrument)
        {
            switch (instrument)
            {
                case InstrumentalEnum.InstrumentEnum.Piano:
                    return new FactoryPattern.Pinano();
                case InstrumentalEnum.InstrumentEnum.Flute:
                    return new FactoryPattern.Flute();
                default:
                    throw new ArgumentException();
            }
        }

    }
}
