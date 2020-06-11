using Core.TransactionServer.Agent.Reset;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Core.TransactionServer.Agent.Util;

namespace Core.TransactionServer.Agent.Test.Reset
{
    //internal sealed class InstrumentHistorySettingData
    //{
    //    private struct InstrumentHistorySettingKey : IEquatable<InstrumentHistorySettingKey>
    //    {
    //        private Guid _accountId;
    //        private Guid _instrumentId;
    //        private DateTime _tradeDay;

    //        internal InstrumentHistorySettingKey(Guid accountId, Guid instrumentId, DateTime tradeDay)
    //        {
    //            _accountId = accountId;
    //            _instrumentId = instrumentId;
    //            _tradeDay = tradeDay;
    //        }

    //        internal Guid AccountId
    //        {
    //            get { return _accountId; }
    //        }

    //        internal Guid InstrumentId
    //        {
    //            get { return _instrumentId; }
    //        }

    //        internal DateTime TradeDay
    //        {
    //            get { return _tradeDay; }
    //        }

    //        public override bool Equals(object obj)
    //        {
    //            return this.Equals((InstrumentHistorySettingKey)obj);
    //        }

    //        public override int GetHashCode()
    //        {
    //            return this.AccountId.GetHashCode() ^ this.InstrumentId.GetHashCode() ^ this.TradeDay.GetHashCode();
    //        }

    //        public bool Equals(InstrumentHistorySettingKey other)
    //        {
    //            return this.AccountId == other.AccountId && this.InstrumentId == other.InstrumentId && this.TradeDay == other.TradeDay;
    //        }
    //    }

    //    private Dictionary<InstrumentHistorySettingKey, InstrumentTradeDaySetting> _data = new Dictionary<InstrumentHistorySettingKey, InstrumentTradeDaySetting>();

    //    internal static readonly InstrumentHistorySettingData Default = new InstrumentHistorySettingData();

    //    static InstrumentHistorySettingData() { }

    //    private InstrumentHistorySettingData()
    //    {
    //        this.Add(Guid.Parse("606D464F-4B7A-4481-97D0-00CF23C8DAE9"), Guid.Parse("2E42C798-97E7-4702-AFBA-0E6ABA0575D6"), DateTime.Now.Date);
    //    }

    //    internal InstrumentTradeDaySetting GetInstrumentTradeDaySetting(Guid accountId, Guid instrumentId, DateTime tradeDay)
    //    {
    //        InstrumentTradeDaySetting result = null;
    //        _data.TryGetValue(new InstrumentHistorySettingKey(accountId, instrumentId, tradeDay), out result);
    //        return result;
    //    }

    //    private void Add(Guid accountId, Guid instrumentId, DateTime tradeDay)
    //    {
    //        var Setting = new InstrumentTradeDaySetting
    //        {
    //            InterestMultiple = 2,
    //            BuyPrice = PriceHelper.CreatePrice("1.15", instrumentId, tradeDay),
    //            SellPrice = PriceHelper.CreatePrice("1.16", instrumentId, tradeDay),
    //            ResetTime = tradeDay.AddDays(1).AddHours(7).AddMinutes(40),
    //            ValueDate = tradeDay.AddDays(-1),
    //            BeginTime = tradeDay.AddHours(7).AddMinutes(40),
    //            ShouldValueCurrentDayPL = true,
    //            IsUseSettlementPriceForInterest = false,
    //            StoragePerLotInterestRateBuy = 0.90m,
    //            StoragePerLotInterestRateSell = 0.70m,
    //            InterestRateBuy = 2.50m,
    //            InterestRateSell = -0.6m,
    //            IsMonthLastDay = false,
    //            WeekDay = 4,
    //            IsInterestUseAccountCurrency = false
    //        };
    //        _data.Add(new InstrumentHistorySettingKey(accountId, instrumentId, tradeDay), Setting);
    //    }

    //}
}
