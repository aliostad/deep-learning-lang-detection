using Protocal;
using Protocal.TradingInstrument;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;
using SystemController.InstrumentBLL;

namespace SystemController.Factory
{
    internal static class MarketCommandFactory
    {
        internal static Protocal.UpdateInstrumentDayOpenCloseTimeMarketCommand CreateUpdateInstrumentDayOpenCloseTimeCommand(List<InstrumentDayOpenCloseParams> instrumentParams)
        {
            if (instrumentParams == null || instrumentParams.Count == 0) return null;

            var result = new Protocal.UpdateInstrumentDayOpenCloseTimeMarketCommand
            {
                Records = new List<InstrumentDayOpenCloseTimeRecord>()
            };

            foreach (var eachInstrumentParam in instrumentParams)
            {
                result.Records.Add(new Protocal.InstrumentDayOpenCloseTimeRecord
                {
                    Id = eachInstrumentParam.Id,
                    TradeDay = eachInstrumentParam.TradeDay,
                    DayOpenTime = eachInstrumentParam.DayOpenTime,
                    DayCloseTime = eachInstrumentParam.DayCloseTime,
                    NextDayOpenTime = eachInstrumentParam.NextDayOpenTime,
                    ValueDate = eachInstrumentParam.ValueDate,
                    RealValueDate = eachInstrumentParam.RealValueDate
                });
            }
            return result;
        }


        internal static Protocal.UpdateInstrumentTradingStatusMarketCommand CreateUpdateInstrumentTradingStatusCommand(Dictionary<InstrumentStatus, List<Guid>> statusDict)
        {
            var command = new Protocal.UpdateInstrumentTradingStatusMarketCommand();
            command.SourceType = iExchange.Common.AppType.SystemController;
            command.InstrumentStatus = CreateInstrumentStatusInfoDict(statusDict);
            return command;
        }


        private static Dictionary<InstrumentStatus, List<Protocal.InstrumentStatusInfo>> CreateInstrumentStatusInfoDict(Dictionary<InstrumentStatus, List<Guid>> statusDict)
        {
            Dictionary<InstrumentStatus, List<Protocal.InstrumentStatusInfo>> instrumentStatusDict = new Dictionary<InstrumentStatus, List<InstrumentStatusInfo>>(statusDict.Count);
            foreach (var eachPair in statusDict)
            {
                var status = eachPair.Key;
                var instruments = eachPair.Value;
                foreach (var eachInstrument in instruments)
                {
                    List<InstrumentStatusInfo> infoList;
                    if (!instrumentStatusDict.TryGetValue(status, out infoList))
                    {
                        infoList = new List<InstrumentStatusInfo>();
                        instrumentStatusDict.Add(status, infoList);
                    }
                    var tradeDay = InstrumentManager.Default.GetInstrumentTradeDay(eachInstrument);
                    infoList.Add(new InstrumentStatusInfo { Id = eachInstrument, TradeDay = tradeDay});
                }
            }
            return instrumentStatusDict;
        }


        internal static Protocal.AccountResetMarketCommand CreateAccountResetCommand(DateTime tradeDay)
        {
            return new Protocal.AccountResetMarketCommand { TradeDay = tradeDay };
        }

        internal static Protocal.UpdateTradeDayInfoMarketCommand CreateUpdateTradeDayInfoCommand()
        {
            var tradeDayInfo = TradeDayManager.Default.TradeDayInfo;
            var result = new Protocal.UpdateTradeDayInfoMarketCommand
            {
                TradeDay = tradeDayInfo.TradeDay,
                BeginTime = tradeDayInfo.BeginTime,
                EndTime = tradeDayInfo.EndTime,
                IsTrading = tradeDayInfo.IsTrading
            };
            return result;
        }

    }

}
