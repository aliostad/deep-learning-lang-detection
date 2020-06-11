using Creational.Builder.Interfaces;

namespace Creational.Builder.ConcreteBuilders
{
    /// <summary>
    /// A 'ConcreteBuilder' class
    /// </summary>
    public class FoderaBuilder : IInstrumentBuilder
    {
        readonly Instrument _instrument = new Instrument();

        public Instrument GetInstrument()
        {
            return _instrument;
        }

        public void SetNeck()
        {
            _instrument.Neck = "V type";
        }

        public void SetModel()
        {
            _instrument.Model = "Figured Chestnut Matt Garrison Imperial 5 Elite";
        }

        public void SetWood()
        {
            _instrument.Wood = "Ebony";
        }
    }
}
