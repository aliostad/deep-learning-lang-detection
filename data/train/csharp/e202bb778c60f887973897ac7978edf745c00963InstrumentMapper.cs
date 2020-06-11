using Musicfy.Bll.Models;
using Musicfy.Dal.Entities;

namespace Musicfy.Bll.Mappers
{
    public static class InstrumentMapper
    {
        public static InstrumentModel ToInstrumentModel(Instrument instrument)
        {
            if (instrument == null)
            {
                return null;
            }

            return new InstrumentModel
            {
                Id = instrument.Id,
                Name = instrument.Name
            };
        }

        public static Instrument ToInstrument(InstrumentModel instrumentModel)
        {
            if (instrumentModel == null)
            {
                return null;
            }

            return new Instrument
            {
                Id = instrumentModel.Id,
                Name = instrumentModel.Name
            };
        }

        public static void RefreshInstrument(Instrument instrument, InstrumentModel instrumentModel)
        {
            instrument.Name = instrumentModel.Name;
        }
    }
}