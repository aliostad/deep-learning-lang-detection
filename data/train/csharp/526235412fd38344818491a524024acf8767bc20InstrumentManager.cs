using Core.TransactionServer.Agent.Framework;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.TransactionServer.Agent.BLL.AccountBusiness
{
    internal sealed class InstrumentManager
    {
        private BusinessRecordDictionary<Guid,AccountClass.Instrument> _instruments;
        private Account _owner;

        private static readonly ILog Logger = LogManager.GetLogger(typeof(InstrumentManager));

        internal InstrumentManager(Account owner)
        {
            _owner = owner;
            _instruments = new BusinessRecordDictionary<Guid, AccountClass.Instrument>("Instruments", owner);
        }

        internal IEnumerable<AccountClass.Instrument> Instruments
        {
            get
            {
                return _instruments.GetValues();
            }
        }

        internal int Count
        {
            get { return _instruments.Count; }
        }

        internal void Add(AccountClass.Instrument instrument)
        {
            if (!_instruments.ContainsKey(instrument.Id))
            {
                _instruments.AddItem(instrument, OperationType.AsNewRecord);
            }
        }

        internal void ClearResetItems()
        {
            foreach (var eachInstrument in _instruments.GetValues())
            {
                eachInstrument.ClearResetItems();
            }
        }

        internal bool Exists(Guid instrumentId)
        {
            return _instruments.ContainsKey(instrumentId);
        }

        internal AccountClass.Instrument Get(Guid instrumentId)
        {
            AccountClass.Instrument result;
            _instruments.TryGetValue(instrumentId, out result);
            return result;
        }

        internal decimal GetResetBalanceGreatThanTradeDay(Guid currencyId, DateTime tradeDay)
        {
            decimal resetBalance = 0m;
            if (_owner.IsMultiCurrency)
            {
                foreach (var eachInstrument in _instruments.GetValues())
                {
                    if (eachInstrument.CurrencyId == currencyId)
                    {
                        resetBalance += this.GetInstrumentResetBalanceGreateThanTradeDay(eachInstrument, tradeDay);
                    }
                }
            }
            else
            {
                foreach (var eachInstrument in _instruments.GetValues())
                {
                    resetBalance += this.GetInstrumentResetBalanceGreateThanTradeDay(eachInstrument, tradeDay);
                }
            }
            return resetBalance;
        }

        private decimal GetInstrumentResetBalanceGreateThanTradeDay(AccountClass.Instrument instrument, DateTime tradeDay)
        {
            var resetItems = instrument.ResetItems;
            if (resetItems == null || resetItems.Count() == 0) return 0m;
            decimal result = 0m;
            foreach (var eachResetItem in resetItems)
            {
                if (eachResetItem.TradeDay > tradeDay)
                {
                    result += eachResetItem.ResetBalance;
                }
            }
            return result;
        }



        internal DateTime? GetLastResetDay(Guid instrumentId)
        {
            AccountClass.Instrument instrument;
            if (_instruments.TryGetValue(instrumentId, out instrument))
            {
                return instrument.LastResetDay;
            }
            else
            {
                return null;
            }
        }

        internal void SetInstrumentLastResetDay(Guid instrumentId, DateTime lastResetDay)
        {
            AccountClass.Instrument instrument;
            if (_instruments.TryGetValue(instrumentId, out instrument))
            {
                instrument.LastResetDay = lastResetDay;
                Logger.InfoFormat("SetInstrumentLastResetDay accountId = {0}, instrumentId = {1}, lastResetDay = {2}", _owner.Id, instrument.Id, lastResetDay);
            }
            else
            {
                Logger.WarnFormat("Can't find instrument= {0} for account = {1}", instrumentId, _owner.Id);
            }
        }


        internal void UpdateLastResetDay(Guid instrumentId, DateTime resetDay)
        {
            AccountClass.Instrument instrument;
            if (_instruments.TryGetValue(instrumentId, out instrument))
            {
                instrument.LastResetDay = resetDay;
            }
        }
    }
}
