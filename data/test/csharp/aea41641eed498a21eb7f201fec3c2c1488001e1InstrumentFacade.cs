using Core.TransactionServer.Agent.Quotations;
using Core.TransactionServer.Agent.Settings;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.TransactionServer.Agent.BLL.InstrumentBusiness
{
    internal sealed class InstrumentFacade
    {
        static InstrumentFacade() { }
        internal static readonly InstrumentFacade Default = new InstrumentFacade();
        private Lazy<InstrumentServiceFactory> _generalServiceFactory;
        private Lazy<InstrumentServiceFactory> _physicalServiceFactory;
        private InstrumentFacade()
        {
            _generalServiceFactory = new Lazy<InstrumentServiceFactory>(() => new GeneralInstrumentServiceFactory());
            _physicalServiceFactory = new Lazy<InstrumentServiceFactory>(() => new PhysicalInstrumentServiceFactory());
        }

        internal AccountClass.Instrument CreateInstrument(Account owner, Guid id, QuotationBulk initQuotation)
        {
            var settingInstrument = Settings.Setting.Default.GetInstrument(id);
            if (settingInstrument.Category == iExchange.Common.InstrumentCategory.Physical)
            {
                return _physicalServiceFactory.Value.CreateInstrument(owner, id, initQuotation);
            }
            else
            {
                return _generalServiceFactory.Value.CreateInstrument(owner, id, initQuotation);
            }
        }

    }
}
