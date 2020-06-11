using log4net;
using Protocal.TradingInstrument;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using SystemController.Factory;
using SystemController.Persistence;
using Protocal.TypeExtensions;

namespace SystemController.InstrumentBLL
{
    internal static class TradingTimeParser
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(TradingTimeParser));

        internal static List<InstrumentDayOpenCloseParams> ParseInstrumentTradingTimes(DataSet ds)
        {
            Logger.Info("ParseInstrumentTradingTimes");
            if (ds.Tables.Count == 0)
            {
                Logger.Error("LoadAndGenerateInstrumentTradingTime,  db result = 0");
                return null;
            }
            var result = new List<Protocal.TradingInstrument.InstrumentDayOpenCloseParams>();
            foreach (DataRow eachDataRow in ds.Tables["InstrumentDayOpenCloseTime"].Rows)
            {
                Guid instrumentId = (Guid)eachDataRow["InstrumentID"];
                DateTime day = (DateTime)eachDataRow["TradeDay"];
                var openCloseParam = new Protocal.TradingInstrument.InstrumentDayOpenCloseParams()
                {
                    Id = instrumentId,
                    TradeDay = day,
                    DayOpenTime = eachDataRow.GetColumn<DateTime?>("DayOpenTime"),
                    DayCloseTime = eachDataRow.GetColumn<DateTime?>("DayCloseTime"),
                    RealValueDate = eachDataRow.GetColumn<DateTime?>("RealValueDate"),
                    TradingSessions = new List<Protocal.TradingInstrument.TradingSession>(),
                    IsTrading = true
                };
                result.Add(openCloseParam);
            }

            foreach (DataRow eachDataRow in ds.Tables["TradingTime"].Rows)
            {
                Guid instrumentId = (Guid)eachDataRow["InstrumentID"];
                DateTime beginTime = (DateTime)eachDataRow["BeginTime"];
                DateTime endTime = (DateTime)eachDataRow["EndTime"];
                var openCloseParam = result.Find(m => m.Id == instrumentId);
                if (openCloseParam == null)
                {
                    Logger.WarnFormat("instrumentId = {0}, BeginTime = {1}, endTime = {2} exist in dbo.TradingTime, but not exist in dbo.InstrumentDayOpenCloseHistory ", instrumentId, beginTime, endTime);
                }
                else
                {
                    openCloseParam.AddSession(new Protocal.TradingInstrument.TradingSession() { BeginTime = beginTime, EndTime = endTime });
                }
            }
            return result;
        }
    }



    internal sealed class TradingTimeManager
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(TradingTimeManager));

        internal static readonly TradingTimeManager Default = new TradingTimeManager();

        private TradingTimeManager() { }

        internal void Process(Dictionary<InstrumentStatus, List<Guid>> status)
        {
            this.BroadcastInstrumentTradingStatus(status);
            this.HandleInstrumentsDayClose(status);
        }


        private void BroadcastInstrumentTradingStatus(Dictionary<InstrumentStatus, List<Guid>> status)
        {
            var command = MarketCommandFactory.CreateUpdateInstrumentTradingStatusCommand(status);
            Logger.InfoFormat("BroadcastInstrumentTradingStatus  {0}", command);
            Broadcaster.Default.AddCommand(command);
        }

        private void HandleInstrumentsDayClose(Dictionary<InstrumentStatus, List<Guid>> status)
        {
            foreach (var eachPair in status)
            {
                var instrumentStatus = eachPair.Key;
                var instrumentIds = eachPair.Value;
                if (instrumentStatus == InstrumentStatus.DayClose)
                {
                    DayCloseManager.Default.CreateAndBroadcastInstrumentDayOpenCloseTimeCommand(instrumentIds);
                }
            }
        }

    }

    internal sealed class DayCloseManager
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(DayCloseManager));

        internal static readonly DayCloseManager Default = new DayCloseManager();

        static DayCloseManager() { }
        private DayCloseManager() { }

        internal void CreateAndBroadcastInstrumentDayOpenCloseTimeCommand(List<Guid> instrumentIds)
        {
            Logger.InfoFormat("Begin CreateAndBroadcastInstrumentDayOpenCloseTimeCommand {0}", instrumentIds.Aggregate(string.Empty, (seed, item) => seed + ", " + item));
            List<InstrumentDayOpenCloseParams> instrumentParams = this.LoadInstrumentTradingParamAndAddCheckPoint(instrumentIds);
            if (instrumentParams != null)
            {
                var instrumentDayCloseCommand = MarketCommandFactory.CreateUpdateInstrumentDayOpenCloseTimeCommand(instrumentParams);
                if (instrumentDayCloseCommand != null)
                {
                    Broadcaster.Default.AddCommand(instrumentDayCloseCommand);
                    InstrumentDayOpenCloseTimeKeeper.Default.AddInstrumentDayOpenCloseTimeRecords(instrumentDayCloseCommand.Records);
                    Logger.InfoFormat("BroadcastInstrumentDayOpenCloseTimeCommand recordsCount = {1}, {0}", instrumentDayCloseCommand, instrumentDayCloseCommand.Records.Count);
                }
            }
        }

        private List<InstrumentDayOpenCloseParams> LoadInstrumentTradingParamAndAddCheckPoint(List<Guid> dayCloseInstruments)
        {
            var sqlParam = InstrumentManager.Default.CreateSqlParam(dayCloseInstruments);
            Logger.WarnFormat("LoadInstrumentTradingParamAndAddCheckPoint, sqlParam = {0}", sqlParam);
            var dataset = DBRepository.Default.LoadAndGenerateInstrumentTradingTime(sqlParam);
            var result = TradingTimeParser.ParseInstrumentTradingTimes(dataset);
            if (result == null) return null;
            this.UpdateInstrument(result);
            Manager.Default.LoadInstrumentTradingTimes(result);
            return result;
        }

        private void UpdateInstrument(List<Protocal.TradingInstrument.InstrumentDayOpenCloseParams> instrumentDayOpenCloseParams)
        {
            foreach (var eachInstrumentParam in instrumentDayOpenCloseParams)
            {
                InstrumentManager.Default.UpdateInstrument(eachInstrumentParam.Id, eachInstrumentParam.TradeDay, eachInstrumentParam.DayOpenTime, eachInstrumentParam.DayCloseTime);
                InstrumentManager.Default.UpdateInstrumentTradingSession(eachInstrumentParam.Id, eachInstrumentParam.TradingSessions);
            }
        }
    }

}
