using Creational.Builder.Interfaces;

namespace Creational.Builder
{
    /// <summary>
    /// The 'Director' class
    /// </summary>
    public class InstrumentCreator
    {
        private readonly IInstrumentBuilder _instrumentBuilder;

        public InstrumentCreator(IInstrumentBuilder builder)
        {
            _instrumentBuilder = builder;
        }

        public void CreateInstrument()
        {
            _instrumentBuilder.SetModel();
            _instrumentBuilder.SetNeck();
            _instrumentBuilder.SetWood();
        }

        public Instrument GetInstrument()
        {
            return _instrumentBuilder.GetInstrument();
        }
    }
}
