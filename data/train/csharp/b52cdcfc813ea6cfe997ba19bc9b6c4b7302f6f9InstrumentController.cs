using Shepherd.Business;
using Shepherd.Business.Generators;
using Shepherd.Domain;
using Shepherd.Service.DataContracts;
using Shepherd.Service.Mappers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Shepherd.WeApiService.Controllers
{
    public class InstrumentController : ApiController
    {
        public IList<InstrumentPriceDto> Get()
        {
            var instrumentsPrice = new List<InstrumentPriceDto>();
            var instrumentBusinessLogic = new InstrumentBusinessLogic(new ShepherdEntities(),
                                                                      new InstrumentGenerator(new PriceGenerator()),
                                                                      new PriceGenerator());
            var instrumentsBusinessLogic =instrumentBusinessLogic.GetStockInstruments();
            var instrumentMapper = new InstrumentMapper();

            return instrumentMapper.MapInstrumentsToInstrumentsPriceDto(instrumentsBusinessLogic);
        }
    }
}
