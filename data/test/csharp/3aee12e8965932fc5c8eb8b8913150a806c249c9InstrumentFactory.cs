using System;

namespace DesignPatterns.Creational.Factory
{
    // This is the factory. It can create an object 
    // given a type. Very simple.
    class InstrumentFactory
    {
        public IInstrument GetInstrument(InstrumentType type)
        {
            switch (type)
            {
                case InstrumentType.Violin:
                    return new Violin();
                case InstrumentType.Piano:
                    return new Piano();
                case InstrumentType.Guitar:
                    return new Guitar();
                default:
                    throw new Exception("Unknown instrument. Cannot create.");
            }
        }
    }
}
