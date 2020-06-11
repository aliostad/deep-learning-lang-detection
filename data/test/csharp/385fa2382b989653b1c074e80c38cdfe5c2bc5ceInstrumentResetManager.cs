using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.TransactionServer.Agent.Reset
{
    internal sealed class InstrumentResetter
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(InstrumentResetter));
        internal static readonly InstrumentResetter Default = new InstrumentResetter();

        static InstrumentResetter() { }
        private InstrumentResetter() { }

        internal DateTime TradeDay { get; private set; }

        internal void DoReset(Guid instrumentId, DateTime tradeDay)
        {
            ResetManager.Default.LoadHistorySetting(tradeDay);
            Parallel.ForEach(TradingSetting.Default.Accounts.Values, account =>
            {
                var instrument = account.GetInstrument(instrumentId);
                if (instrument != null && instrument.Quotation != null)
                {
                    account.DoInstrumentReset(instrumentId, tradeDay, instrument.Quotation.BuyOnCustomerSide, instrument.Quotation.SellOnCustomerSide);
                }
            });
        }

    }
}
