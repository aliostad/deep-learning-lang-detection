using System;
using Creational.Factory_Method.Concretes;
using Creational.Factory_Method.Interfaces;

namespace Creational.Factory_Method
{
    public class ConcreteInstrumentFactory : InstrumentFactory
    {
        public override IFactory GetInstrument(InstrumentType instrument)
        {
            switch (instrument)
            {
                case InstrumentType.Fender:
                    return new Fender();
                case InstrumentType.Gibson:
                    return new Gibson();
                default:
                    throw new ApplicationException($"Instrument type {instrument} cannot be created");
            }
        }
    }
}
