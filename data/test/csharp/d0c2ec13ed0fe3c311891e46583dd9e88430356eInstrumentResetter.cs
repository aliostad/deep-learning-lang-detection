using Core.TransactionServer.Agent.AccountClass;
using Core.TransactionServer.Agent.BLL.AccountBusiness;
using Core.TransactionServer.Agent.Framework;
using Core.TransactionServer.Agent.Physical.InstalmentBusiness;
using Core.TransactionServer.Agent.Quotations;
using Core.TransactionServer.Agent.Reset.Exceptions;
using Core.TransactionServer.Agent.Util;
using iExchange.Common;
using log4net;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.TransactionServer.Agent.Reset
{
    internal sealed class InstrumentResetter
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(InstrumentResetter));

        private Account _account;
        private InstrumentManager _instrumentManager;
        private InstrumentDayClosePriceFactory _instrumentDayClosePriceFactory;
        private Lazy<InstalmentResetter> _instalmentResetter;

        internal InstrumentResetter(Account account, InstrumentManager instrumentManager)
        {
            _account = account;
            _instrumentManager = instrumentManager;
            _instrumentDayClosePriceFactory = new InstrumentDayClosePriceFactory(account);
            _instalmentResetter = new Lazy<InstalmentResetter>(() => new InstalmentResetter(_instrumentManager, _account));
        }

        internal void DoInstrumentReset(Guid instrumentId, DateTime tradeDay, List<TradingDailyQuotation> closeQuotations)
        {
            var tradeDayInfo = _account.LoadHistorySettingForSetClosePrice(instrumentId, tradeDay);
            var settingInstrument = Settings.Setting.Default.GetInstrument(instrumentId, tradeDay);
            var instrument = _account.GetInstrument(instrumentId);
            this.DoResetByClosePrice(instrument, tradeDay, closeQuotations, tradeDayInfo);
            if (settingInstrument.IsPhysical)
            {
                _instalmentResetter.Value.PayoffInstalment(_account, instrumentId, tradeDay, tradeDayInfo);
            }
            if (instrument.LastResetDay == null || instrument.LastResetDay.Value < tradeDay)
            {
                _instrumentManager.UpdateLastResetDay(instrumentId, tradeDay);
            }
            instrument.InvalidateCache();
        }


        internal void DoInstrumentReset(DateTime tradeDay)
        {
            if (_instrumentManager.Count == 0) return;
            foreach (var eachInstrument in _instrumentManager.Instruments)
            {
                this.ProcessIndividualInstrument(eachInstrument, tradeDay);
                eachInstrument.InvalidateCache();
            }
        }

        private void ProcessIndividualInstrument(Instrument instrument, DateTime tradeDay)
        {
            if (this.CanInstrumentBeginReset(instrument.Id, tradeDay))
            {
                this.DoInstrumentResetHelper(instrument, tradeDay);
            }
        }

        private bool CanInstrumentBeginReset(Guid instrumentId, DateTime tradeDayDate)
        {
            if (!_account.CanDoReset(tradeDayDate)) return false;
            if (this.IsAlreadyReseted(instrumentId, tradeDayDate)) return false;
            DateTime baseTime = Market.MarketManager.Now;
            DateTime resetTime = this.GetResetTime(tradeDayDate, instrumentId).Value;
            return resetTime <= baseTime;
        }


        private void DoInstrumentResetHelper(Instrument instrument, DateTime tradeDay)
        {
            if (this.IsAlreadyReseted(instrument.Id, tradeDay)) return;
            if (!this.HasExecutedOrder(instrument.Id, tradeDay))
            {
                Logger.WarnFormat("accountId = {0}, instrumentId = {1}, tradeDay = {2} not exists executed orders", _account.Id, instrument.Id, tradeDay);
                instrument.LastResetDay = tradeDay;
                return;
            }
            this.DoResetCommon(instrument, tradeDay);
        }


        private void DoResetCommon(AccountClass.Instrument instrument, DateTime tradeDay)
        {
            try
            {
                Logger.InfoFormat("doInstrumentReset accountId = {0}, instrumentId = {1}, tradeDay = {2}, lastResetDay = {3}", _account.Id, instrument.Id, tradeDay, instrument.LastResetDay);
                var resetHistorySettingDict = _account.LoadHistorySetting(instrument.Id, tradeDay);
                this.DoResetCore(instrument, resetHistorySettingDict);
                var settingInstrument = Settings.Setting.Default.GetInstrument(instrument.Id, tradeDay);
                if (settingInstrument.IsPhysical)
                {
                    _instalmentResetter.Value.PayoffInstalment(_account, instrument.Id, tradeDay, resetHistorySettingDict);
                }
                _instrumentManager.UpdateLastResetDay(instrument.Id, tradeDay);
                Logger.InfoFormat("doInstrumentReset completed accountId = {0}, instrumentId = {1}, tradeDay = {2}", _account.Id, instrument.Id, tradeDay);
            }
            catch (OrderConvertException orderConvertException)
            {
                Logger.ErrorFormat("msg = {0}, accountId={1}, instrumentId={2}, orderId={3}", orderConvertException.Message, orderConvertException.AccountId, orderConvertException.InstrumentId, orderConvertException.OrderId);
                throw;
            }
        }


        private void DoResetCore(AccountClass.Instrument instrument, Dictionary<DateTime, TradeDayInfo> resetHistorySettingDict)
        {
            foreach (var eachResetHistorySetting in resetHistorySettingDict.Values)
            {
                var settingInstrument = Settings.Setting.Default.GetInstrument(instrument.Id, eachResetHistorySetting.TradeDay);
                var closeQuotation = _instrumentDayClosePriceFactory.GetQuotation(settingInstrument, eachResetHistorySetting.TradeDay);
                this.DoResetPerTradeDay(instrument, eachResetHistorySetting, closeQuotation);
            }
        }

        private void DoResetByClosePrice(AccountClass.Instrument instrument, DateTime tradeDay, List<TradingDailyQuotation> closeQuotations, TradeDayInfo tradeDayInfo)
        {
            var settingInstrument = Settings.Setting.Default.GetInstrument(instrument.Id, tradeDay);
            var resetItem = instrument.GetResetItem(tradeDay);
            if (resetItem != null)
            {
                Logger.InfoFormat("DoResetByClosePrice modifyClosePrice lastResetItem instrumentId = {0}, tradeDay = {1}, resetBalance = {2}", instrument.Id, tradeDay, resetItem.ResetBalance);
                _account.AddBalance(settingInstrument.CurrencyId, -resetItem.ResetBalance, tradeDayInfo.Settings.ResetTime);
            }
            var quotation = _instrumentDayClosePriceFactory.GetQuotation(settingInstrument, closeQuotations);
            if (quotation == null)
            {
                this.PrintErrorInfo(instrument, tradeDay, closeQuotations);
            }
            this.DoResetPerTradeDay(instrument, tradeDayInfo, quotation);
        }

        private void PrintErrorInfo(AccountClass.Instrument instrument, DateTime tradeDay, List<TradingDailyQuotation> closeQuotations)
        {
            StringBuilder sb = new StringBuilder(500);
            sb.AppendLine(string.Format("DoResetByClosePrice instrumentId = {0}, tradeDay = {1}", instrument.Id, tradeDay));
            IQuotePolicyProvider provider = this._account;
            sb.AppendLine(string.Format("account privateQuotePolicyId = {0}, publicQuotePolicyId = {1}  ", provider.PrivateQuotePolicyId, provider.PublicQuotePolicyId));
            sb.Append("Close quotations:");
            foreach (var quotation in closeQuotations)
            {
                sb.AppendLine(quotation.ToString());
            }
            Logger.Warn(sb.ToString());
        }


        private void DoResetPerTradeDay(AccountClass.Instrument instrument, TradeDayInfo eachResetHistorySetting, InstrumentCloseQuotation closeQuotation)
        {
            var settingInstrument = Settings.Setting.Default.GetInstrument(instrument.Id, eachResetHistorySetting.TradeDay);
            var calculator = TradeDayCalculatorFactory.CreateForReset(eachResetHistorySetting, closeQuotation, Settings.Setting.Default);
            calculator.Calculate();
            _account.AddBalance(settingInstrument.CurrencyId, calculator.Balance, calculator.ResetTime);
            OrderDayHistorySaver.Save(_account, instrument, calculator, eachResetHistorySetting, settingInstrument);
        }


        private bool IsAlreadyReseted(Guid instrumentId, DateTime tradeDay)
        {
            DateTime? lastResetDay = _instrumentManager.GetLastResetDay(instrumentId);
            return lastResetDay != null && lastResetDay.Value >= tradeDay;
        }

        private bool HasExecutedOrder(Guid instrumentId, DateTime tradeDay)
        {
            if (!this.ExistsExecutedOrders(instrumentId)) return false;
            DateTime? resetTime = this.GetResetTime(tradeDay, instrumentId);
            if (resetTime == null) return false;
            foreach (var eachTran in _account.Transactions)
            {
                if (eachTran.ExecuteTime == null) continue;
                if (eachTran.InstrumentId == instrumentId && eachTran.ExecuteTime <= resetTime)
                {
                    foreach (var eachOrder in eachTran.Orders)
                    {
                        if (eachOrder.IsExecuted) return true;
                    }
                }
            }
            return false;
        }

        private DateTime? GetResetTime(DateTime tradeDate, Guid instrumentId)
        {
            ResetManager.Default.LoadHistorySetting(tradeDate, string.Format("InstrumentResetter.GetResetTime instrumentId = {0}", instrumentId));
            DateTime? resetTime = null;
            var instrumentDayOpenCloseHistory = InstrumentDayOpenCloseHistoryRepository.Default.Get(instrumentId, tradeDate, true);
            if (instrumentDayOpenCloseHistory != null)
            {
                resetTime = instrumentDayOpenCloseHistory.DayCloseTime;
            }
            else
            {
                var tradeDay = Settings.Setting.Default.GetTradeDay(tradeDate);
                if (tradeDay != null)
                {
                    resetTime = tradeDay.EndTime;
                }
            }
            return resetTime;
        }


        private bool ExistsExecutedOrders(Guid instrumentId)
        {
            foreach (var eachTran in _account.GetTransactions(instrumentId))
            {
                foreach (var eachOrder in eachTran.Orders)
                {
                    if (eachOrder.IsExecuted) return true;
                }
            }
            return false;
        }
    }


    internal sealed class InstalmentResetter
    {
        private InstrumentManager _instrumentManager;
        private Account _account;

        internal InstalmentResetter(InstrumentManager instrumentManager, Account account)
        {
            _instrumentManager = instrumentManager;
            _account = account;
        }

        internal void PayoffInstalment(Account account, Guid instrumentId, DateTime tradeDay, Dictionary<DateTime, TradeDayInfo> tradeDayDataDict)
        {
            foreach (var eachInstalmentParam in this.GetInstalmentParams(account, instrumentId, tradeDay, tradeDayDataDict))
            {
                InstalmentManager instalmentManager = new InstalmentManager(eachInstalmentParam);
                instalmentManager.Payoff();
            }
        }

        internal void PayoffInstalment(Account account, Guid instrumentId, DateTime tradeDay, TradeDayInfo tradeDayInfo)
        {
            InstalmentManager instalmentManager = new InstalmentManager(this.GetInstalmentParam(account, tradeDay, tradeDayInfo));
            instalmentManager.Payoff();
        }


        private List<InstalmentPayOffParameter> GetInstalmentParams(Account account, Guid instrumentId, DateTime tradeDay, Dictionary<DateTime, TradeDayInfo> tradeDayDataDict)
        {
            List<InstalmentPayOffParameter> result = new List<InstalmentPayOffParameter>();
            DateTime? lastResetTradeDay = _instrumentManager.GetLastResetDay(instrumentId);
            if (lastResetTradeDay == null)
            {
                var tradeDayData = tradeDayDataDict[tradeDay];
                result.Add(this.GetInstalmentParam(account, tradeDay, tradeDayData));
            }
            else
            {
                for (DateTime eachTradeDay = lastResetTradeDay.Value.AddDays(1); eachTradeDay <= tradeDay; eachTradeDay = eachTradeDay.AddDays(1))
                {
                    var eachTradeDayData = tradeDayDataDict[eachTradeDay];
                    result.Add(this.GetInstalmentParam(account, eachTradeDay, eachTradeDayData));
                }
            }
            return result;
        }

        private InstalmentPayOffParameter GetInstalmentParam(Account account, DateTime tradeDay, TradeDayInfo tradeDayInfo)
        {
            return new InstalmentPayOffParameter(_account.GetInstalmentOrders(), account, tradeDayInfo.Instrument, tradeDayInfo.Settings.BuyPrice, tradeDayInfo.Settings.SellPrice, tradeDay);
        }
    }



    internal static class HistoryDataRepository
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(HistoryDataRepository));

        internal static Dictionary<DateTime, TradeDayInfo> LoadHistorySetting(this Account account, Guid instrumentId, DateTime tradeDay)
        {
            Dictionary<DateTime, TradeDayInfo> result = new Dictionary<DateTime, TradeDayInfo>();
            DateTime? lastResetDay = account.GetInstrumentLastResetDay(instrumentId);
            if (lastResetDay == null)
            {
                var data = account.LoadHistoryDataPerTradeDay(instrumentId, tradeDay);
                result.Add(tradeDay, data);
            }
            else
            {
                for (DateTime eachTradeDay = lastResetDay.Value.AddDays(1); eachTradeDay <= tradeDay; eachTradeDay = eachTradeDay.AddDays(1))
                {
                    var data = account.LoadHistoryDataPerTradeDay(instrumentId, eachTradeDay);
                    result.Add(eachTradeDay, data);
                }
            }
            return result;
        }

        internal static TradeDayInfo LoadHistorySettingForSetClosePrice(this Account account, Guid instrumentId, DateTime tradeDay)
        {
            return account.LoadHistoryDataPerTradeDay(instrumentId, tradeDay);
        }


        private static TradeDayInfo LoadHistoryDataPerTradeDay(this Account account, Guid instrumentId, DateTime tradeDay)
        {
            var instrumentTradeDaySetting = ResetManager.Default.LoadInstrumentHistorySettingAndData(account.Id, instrumentId, tradeDay);
            if (instrumentTradeDaySetting == null) return null;
            var data = new TradeDayInfo(account, instrumentId, tradeDay, instrumentTradeDaySetting, null, Settings.Setting.Default);
            return data;
        }
    }

    internal sealed class InstrumentCloseQuotation
    {
        internal InstrumentCloseQuotation(Settings.Instrument instrument, DB.DBMapping.InstrumentDayClosePrice quotation)
        {
            this.InstrumentId = instrument.Id;
            this.QuotePolicyId = quotation.QuotePolicyID;
            this.InitializePrice(instrument, quotation.Ask, quotation.Bid);
        }

        internal InstrumentCloseQuotation(Settings.Instrument instrument, iExchange.Common.TradingDailyQuotation quotation)
        {
            this.InstrumentId = instrument.Id;
            this.QuotePolicyId = quotation.QuotePolicyId;
            this.InitializePrice(instrument, quotation.Ask, quotation.Bid);
        }

        private void InitializePrice(Settings.Instrument instrument, string ask, string bid)
        {
            Price askPrice = ask.CreatePrice(instrument);
            Price bidPirce = bid.CreatePrice(instrument);
            this.BuyPrice = Quotation.GetBuyPriceForReset(instrument.IsNormal, askPrice, bidPirce);
            this.SellPrice = Quotation.GetSellPriceForReset(instrument.IsNormal, askPrice, bidPirce);
        }

        internal Guid InstrumentId { get; private set; }
        internal Guid QuotePolicyId { get; private set; }
        internal Price BuyPrice { get; private set; }
        internal Price SellPrice { get; private set; }

        public override string ToString()
        {
            return string.Format("InstrumentId = {0} , QuotePolicyId = {1} , BuyPrice = {2} , SellPrice  = {3}", this.InstrumentId, this.QuotePolicyId, this.BuyPrice, this.SellPrice);
        }

    }

    internal sealed class InstrumentDayClosePriceFactory
    {
        private Account _account;

        internal InstrumentDayClosePriceFactory(Account account)
        {
            _account = account;
        }

        internal InstrumentCloseQuotation GetQuotation(Settings.Instrument instrument, DateTime tradeDay)
        {
            var closePrices = ResetManager.Default.GetInstrumentDayClosePrice(instrument.Id, tradeDay);
            if (closePrices == null || closePrices.Count == 0) return null;
            var quotations = new List<InstrumentCloseQuotation>(closePrices.Count);
            foreach (var eachPrice in closePrices)
            {
                quotations.Add(new InstrumentCloseQuotation(instrument, eachPrice));
            }
            return this.GetQuotation(instrument, quotations);
        }

        internal InstrumentCloseQuotation GetQuotation(Settings.Instrument instrument, List<TradingDailyQuotation> closeQuotations)
        {
            var quotations = new List<InstrumentCloseQuotation>(closeQuotations.Count);
            foreach (var eachCloseQuotation in closeQuotations)
            {
                quotations.Add(new InstrumentCloseQuotation(instrument, eachCloseQuotation));
            }
            return this.GetQuotation(instrument, quotations);
        }

        private InstrumentCloseQuotation GetQuotation(Settings.Instrument instrument, List<InstrumentCloseQuotation> quotations)
        {
            if (quotations.Count == 0) return null;
            Dictionary<Guid, InstrumentCloseQuotation> quotationPerQuotePolicy = new Dictionary<Guid, InstrumentCloseQuotation>();
            foreach (var eachQuotation in quotations)
            {
                if (!quotationPerQuotePolicy.ContainsKey(eachQuotation.QuotePolicyId))
                {
                    quotationPerQuotePolicy.Add(eachQuotation.QuotePolicyId, eachQuotation);
                }
            }
            InstrumentCloseQuotation result = ((IQuotePolicyProvider)_account).Get<InstrumentCloseQuotation>(delegate(Guid id, out InstrumentCloseQuotation q)
            {
                return quotationPerQuotePolicy.TryGetValue(id, out q);
            });
            return result;
        }

    }

}
