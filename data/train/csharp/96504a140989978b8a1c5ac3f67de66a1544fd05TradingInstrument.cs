using iExchange.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Core.TransactionServer.Agent.Market;
using log4net;
using Core.TransactionServer.Agent.BLL.AccountBusiness;

namespace Core.TransactionServer.Agent.BLL.InstrumentBusiness
{
    internal sealed class TradingInstrument
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(TradingInstrument));

        internal TradingInstrument(Settings.Instrument instrument)
        {
            this.SettingInstrument = instrument;
            this.TradingStatus = new TradingStatus(instrument.Id);
        }

        internal Guid Id
        {
            get
            {
                return this.SettingInstrument.Id;
            }
        }

        internal DateTime TradeDay { get; set; }

        internal Settings.Instrument SettingInstrument { get; private set; }

        internal Protocal.TradingInstrument.TradingSession CurrentTradingSession
        {
            get
            {
                return ServerFacade.Default.GatewayProxy.GetCurrentTradingSession(this.Id);
            }
        }

        internal TradingStatus TradingStatus { get; private set; }

        internal DateTime DayOpenTime
        {
            get { return this.SettingInstrument.DayOpenTime; }
        }

        internal DateTime DayCloseTime
        {
            get { return this.SettingInstrument.DayCloseTime; }
        }

        internal DateTime ValueDate
        {
            get { return this.SettingInstrument.ValueDate; }
        }

        internal DateTime NextDayOpenTime
        {
            get { return this.SettingInstrument.NextDayOpenTime; }
        }

        internal bool IsActive
        {
            get
            {
                return this.SettingInstrument.IsActive;
            }
        }

        internal bool IsPriceEnabled
        {
            get
            {
                return this.SettingInstrument.IsPriceEnabled;
            }
        }

        internal bool IsPlaceAllowed
        {
            get
            {
                return this.TradingStatus.IsPlaceAllowed;
            }
        }

        internal bool CanPlacePendingOrderAtAnyTime
        {
            get
            {
                return this.SettingInstrument.CanPlacePendingOrderAtAnyTime;
            }
        }

        internal bool MustUseNightNecessaryWhenTrading
        {
            get
            {
                return this.SettingInstrument.MustUseNightNecessaryWhenTrading;
            }
        }

        internal bool ShouldUseDayNecessary
        {
            get
            {
#if RESET
                return !this.MustUseNightNecessaryWhenTrading;
#else
                if (this.TradingStatus.Status.IsTradeDayClose())
                {
                    return false;
                }
                else
                {
                    if (this.IsTrading)
                    {
                        return !this.MustUseNightNecessaryWhenTrading;
                    }
                    else
                    {
                        return !Settings.Setting.Default.SystemParameter.UseNightNecessaryWhenBreak;
                    }
                }
#endif
            }
        }

        internal bool IsTrading
        {
            get { return this.TradingStatus.IsTrading; }
        }

        public bool CanTrade(DateTime baseTime, PlaceContext context)
        {
            if (!context.IsBook)
            {
                return this.IsTrading && this.CanTradeCommon(this.SettingInstrument, baseTime);
            }
            else
            {
                var instrument = Settings.Setting.Default.GetInstrument(this.SettingInstrument.Id, context.TradeDay);
                return this.CanTradeCommon(instrument, context.ExecuteTime.Value);
            }
        }

        private bool CanTradeCommon(Settings.Instrument instrument, DateTime baseTime)
        {
            return instrument.IsActive && instrument.DayOpenTime <= baseTime && baseTime <= instrument.DayCloseTime;
        }



        public bool CanPlace(DateTime baseTime, bool isPending, Quotations.Quotation quotation, PlaceContext context, out string errorDetail)
        {
            errorDetail = string.Empty;
            var instrument = this.SettingInstrument;
            bool isPlaceAllowd = this.IsPlaceAllowed;
            if (context.IsBook)
            {
                baseTime = context.ExecuteTime.Value;
                isPlaceAllowd = true;
            }
            if (context.IsBook)
            {
                instrument = Settings.Setting.Default.GetInstrument(instrument.Id, context.TradeDay);
            }
            if (!instrument.IsActive) return false;
            if (instrument.ExchangeSystem != ExchangeSystem.Local) return true;

            if (isPlaceAllowd && (instrument.DayOpenTime + TimeSpan.FromSeconds(instrument.FirstOrderTime)) <= baseTime && baseTime <= instrument.DayCloseTime)
            {
                bool isOnPriceLimit = InstrumentPriceStatusManager.Default.IsOnPriceLimit(instrument.OriginCode);
                if (instrument.IsPriceEnabled && !isOnPriceLimit)
                {
                    if (instrument.InactiveTime <= 0)
                    {
                        return true;
                    }
                    else
                    {
                        DateTime compareTime = quotation != null ? quotation.Timestamp : instrument.PriceEnableTime;
                        if (compareTime < instrument.PriceEnableTime)
                        {
                            compareTime = instrument.PriceEnableTime;
                        }

                        double inActiveTime = (Market.MarketManager.Now - compareTime).TotalSeconds;

                        if (inActiveTime < instrument.InactiveTime)
                        {
                            return true;
                        }
                        else
                        {
                            errorDetail = string.Format("instrument id = {0} exceed inactive time = {1}, instrument.InactiveTime = {2} compareTime = {3}, priceEnableTime = {4} QuotationTimestatp = {5}", instrument.Id, inActiveTime, instrument.InactiveTime,compareTime, instrument.PriceEnableTime, quotation!= null? quotation.Timestamp.ToString(): string.Empty);
                            return false;
                        }
                    }
                }
                else
                {
                    errorDetail = string.Format("IsPriceEnabled = {0}, isOnPriceLimit = {1}", instrument.IsPriceEnabled, isOnPriceLimit);
                    return false;
                }

            }
            else
            {
                errorDetail = string.Format("baseTime={0}, isPending={1}; isActive={2}, isPlaceAllowed={3}, isPriceEnabled={4},dayOpenTime={5},dayCloseTime={6}, CanPlacePendingOrderAtAnyTime = {7}", baseTime, isPending, instrument.IsActive, isPlaceAllowd, instrument.IsPriceEnabled, instrument.DayOpenTime, instrument.DayCloseTime, instrument.CanPlacePendingOrderAtAnyTime);
                return instrument.CanPlacePendingOrderAtAnyTime && isPending;
            }
        }

        internal void UpdateTradingStatus(Protocal.TradingInstrument.InstrumentStatus status)
        {
            this.TradingStatus.UpdateStatus(status);
        }

        internal void UpdateTradingTime(DateTime? dayOpenTime, DateTime? dayCloseTime, DateTime? valueDate, DateTime? nextDayOpenTime)
        {
            this.SettingInstrument.UpdateTradingTime(dayOpenTime, dayCloseTime, valueDate, nextDayOpenTime);
        }
    }

    internal sealed class TradingStatus
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(TradingStatus));
        private Guid _instrumentId;

        internal bool IsTrading { get; private set; }
        internal bool IsPlaceAllowed { get; private set; }

        internal TradingStatus(Guid instrumentId)
        {
            _instrumentId = instrumentId;
        }

        internal Protocal.TradingInstrument.InstrumentStatus Status { get; private set; }

        internal void UpdateStatus(Protocal.TradingInstrument.InstrumentStatus status)
        {
            Logger.InfoFormat("UpdateStatus instrumentId = {0}, status = {1}", _instrumentId, status);
            this.Status = status;
            switch (status)
            {
                case Protocal.TradingInstrument.InstrumentStatus.NotInTrading:
                    this.Update(false);
                    break;
                case Protocal.TradingInstrument.InstrumentStatus.DayOpen:
                    this.Update(true);
                    break;
                case Protocal.TradingInstrument.InstrumentStatus.SessionOpen:
                    this.Update(true);
                    break;
                case Protocal.TradingInstrument.InstrumentStatus.SessionClose:
                    this.Update(false);
                    break;
                case Protocal.TradingInstrument.InstrumentStatus.StopPlace:
                    this.DisablePlaceAllowed();
                    break;
                case Protocal.TradingInstrument.InstrumentStatus.DayClose:
                    this.Update(false);
                    break;
                case Protocal.TradingInstrument.InstrumentStatus.DayCloseQuotationReceived:
                    this.Update(false);
                    break;
                default:
                    break;
            }
        }

        internal void Update(bool canTrade)
        {
            this.IsTrading = canTrade;
            this.IsPlaceAllowed = canTrade;
        }

        internal void DisablePlaceAllowed()
        {
            this.IsPlaceAllowed = false;
        }
    }
}
