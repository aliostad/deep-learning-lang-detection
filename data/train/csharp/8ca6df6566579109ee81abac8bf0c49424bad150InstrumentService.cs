using Shepherd.Business.Interfaces;
using Shepherd.Common.AOP;
using Shepherd.Domain;
using Shepherd.Service.DataContracts;
using Shepherd.Service.Mappers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel.Activation;
using System.Web;

namespace Shepherd.Service
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class InstrumentService : IInstrumentService
    {
        private IInstrumentBusinessLogic _instrumentBusinessLogic;
        private InstrumentMapper _instrumentMapper;

        public InstrumentService(IInstrumentBusinessLogic instrumentBusinessLogic,
                                 InstrumentMapper instrumentMapper)
        {
            _instrumentBusinessLogic = instrumentBusinessLogic;
            _instrumentMapper = instrumentMapper;
        }

        [ExceptionAspect]
        [TransactionScopeAspect]
        public IList<InstrumentPriceDto> Load(string instrumentsNumber)
        {
            var instruments = _instrumentBusinessLogic.Load(Convert.ToInt16(instrumentsNumber));
            return _instrumentMapper.MapInstrumentsToInstrumentsPriceDto(instruments);
        }

        [ExceptionAspect]
        [TransactionScopeAspect]
        public void UpdatePrices()
        {
            _instrumentBusinessLogic.UpdatePrices();
        }

        [ExceptionAspect]
        public IList<InstrumentPriceDto> GetStockInstruments()
        {
            var instrumentsPrice = new List<InstrumentPriceDto>();
            var instruments = _instrumentBusinessLogic.GetStockInstruments();
            Price instrumentCurrentPrice;
            foreach(var instrument in instruments)
            {
                instrumentCurrentPrice = _instrumentBusinessLogic.GetInstrumentCurrentPrice(instrument.Id);
                instrumentsPrice.Add(new InstrumentPriceDto
                {
                    InstrumentId = instrument.Id,
                    InstrumentName = instrument.Name,
                    PriceValue = instrumentCurrentPrice.Value,
                    DeltaValue = instrumentCurrentPrice.DeltaValue,
                    DeltaPercentageValue = instrumentCurrentPrice.DeltaPercentageValue
                });
            }

            return instrumentsPrice;
        }
    }
}