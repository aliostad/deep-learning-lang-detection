using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace iExchange.StateServer.Adapter.AccountBLL
{
    internal sealed class AccountInstrument
    {
        internal AccountInstrument(Account owner, Instrument instrument)
        {
            this.Owner = owner;
            this.Instrument = instrument;
            this.InstrumentId = instrument.Id;
        }

        internal Account Owner { get; private set; }
        internal Instrument Instrument { get; private set; }

        internal Guid InstrumentId { get; private set; }

        internal decimal BuyLotBalanceSum { get; private set; }

        internal decimal SellLotBalanceSum { get; private set; }

        public override int GetHashCode()
        {
            return this.InstrumentId.GetHashCode();
        }

        public override bool Equals(object obj)
        {
            if (obj == null) return false;
            AccountInstrument other = obj as AccountInstrument;
            if (other == null) return false;
            return this.InstrumentId == other.InstrumentId;
        }

    }
}