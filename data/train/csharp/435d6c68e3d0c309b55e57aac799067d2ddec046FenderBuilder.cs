using Creational.Builder.Interfaces;

namespace Creational.Builder.ConcreteBuilders
{
    /// <summary>
    /// A 'ConcreteBuilder' class
    /// </summary>
    public class FenderBuilder : IInstrumentBuilder
    {
        readonly Instrument _instrument = new Instrument();

        public Instrument GetInstrument()
        {
            return _instrument;
        }

        public void SetNeck()
        {
            _instrument.Neck = "C type";
        }

        public void SetModel()
        {
            _instrument.Model = "1975 Jazz Bass Re-Issue";
        }
        
        public void SetWood()
        {
            _instrument.Wood = "Alder";
        }
    }
}
