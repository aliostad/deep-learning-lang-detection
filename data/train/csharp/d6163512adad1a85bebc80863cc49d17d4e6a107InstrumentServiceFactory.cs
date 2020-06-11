using Core.TransactionServer.Agent.AccountClass;
using Core.TransactionServer.Agent.Physical;
using Core.TransactionServer.Agent.Physical.InstrumentBusiness;
using Core.TransactionServer.Agent.Quotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.TransactionServer.Agent.BLL.InstrumentBusiness
{
    internal abstract class InstrumentServiceFactory
    {
        internal abstract Instrument CreateInstrument(Account owner, Guid id, QuotationBulk initQuotation);
        internal abstract LotCalculator CreateLotCalculator(Instrument instrument);
        internal abstract OrderCollector CreateOrderCollector(Instrument instrument);
        internal abstract InstrumentCalculator CreateInstrumentCalculator(Instrument instrument);
    }

    internal sealed class GeneralInstrumentServiceFactory : InstrumentServiceFactory
    {
        internal override LotCalculator CreateLotCalculator(Instrument instrument)
        {
            return new GeneralLotCalculator(instrument);
        }

        internal override OrderCollector CreateOrderCollector(Instrument instrument)
        {
            return new GeneralOrderCollector(instrument);
        }

        internal override InstrumentCalculator CreateInstrumentCalculator(Instrument instrument)
        {
            return new GeneralInstrumentCalculator(instrument);
        }

        internal override Instrument CreateInstrument(Account owner, Guid id, QuotationBulk initQuotation)
        {
            return new Instrument(owner, id, initQuotation,this);
        }
    }

    internal sealed class PhysicalInstrumentServiceFactory : InstrumentServiceFactory
    {
        internal override LotCalculator CreateLotCalculator(Instrument instrument)
        {
            return new PhysicalLotCalculator((PhysicalInstrument)instrument);
        }

        internal override OrderCollector CreateOrderCollector(Instrument instrument)
        {
            return new PhysicalInstrumentOrderCollector((PhysicalInstrument)instrument);
        }

        internal override InstrumentCalculator CreateInstrumentCalculator(Instrument instrument)
        {
            return new PhysicalInstrumentCalculator((PhysicalInstrument)instrument);
        }

        internal override Instrument CreateInstrument(Account owner, Guid id, QuotationBulk initQuotation)
        {
            return new PhysicalInstrument(owner, id, initQuotation,this);
        }
    }

}
