using System.Collections.Generic;

namespace Composer.Infrastructure.Dimensions
{
    public class Instrument : DimensionBase
    {

    }

    public static class Instruments
    {
        public static List<Instrument> InstrumentList = new List<Instrument>();

        public static Instrument Instrument = null;

        static Instruments()
        {
            Initialize();
        }
        public static void Initialize()
        {
            InstrumentList.Clear();
            InstrumentList.Add(item: new Instrument() { Id = 0, Name = "Piano", Caption = "", Description = "" } );
            Instrument = InstrumentList[0];
        }
    }
}