using Shepherd.Domain;
using Shepherd.Service.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Shepherd.Service.Mappers
{
    public class InstrumentMapper
    {
        public IList<InstrumentPriceDto> MapInstrumentsToInstrumentsPriceDto(IList<Instrument> instruments)
        {
            var instrumentsPrice = new List<InstrumentPriceDto>();
            foreach(var intstrument in instruments)
            {
                instrumentsPrice.Add(MapInstrumentToInstrumentPriceDto(intstrument));
            }

            return instrumentsPrice;
        }

        private InstrumentPriceDto MapInstrumentToInstrumentPriceDto(Instrument instrument)
        {
            return new InstrumentPriceDto() { InstrumentName = instrument.Name,
                                           PriceValue = instrument.Prices.FirstOrDefault().Value,
                                           DeltaValue = instrument.Prices.FirstOrDefault().DeltaValue,
                                           DeltaPercentageValue = instrument.Prices.FirstOrDefault().DeltaPercentageValue};
        }
    }
}