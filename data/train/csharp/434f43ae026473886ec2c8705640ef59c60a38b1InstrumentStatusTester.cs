using Core.TransactionServer.Agent.Settings;
using Newtonsoft.Json;
using Protocal.TradingInstrument;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace Core.TransactionServer.Agent.Market
{
    internal sealed class InstrumentStatusTester
    {
        internal static readonly InstrumentStatusTester Default = new InstrumentStatusTester();
        private TradingInfo _tradingInfo;

        private Dictionary<Guid, Protocal.TradingInstrument.InstrumentDayOpenCloseParams> _instrumentDict = new Dictionary<Guid, Protocal.TradingInstrument.InstrumentDayOpenCloseParams>();
        static InstrumentStatusTester() { }
        private InstrumentStatusTester() { }

        internal TradingInfo TradingInfo { get { return _tradingInfo; } }

        internal void Initialize(DataSet ds)
        {
            this.LoadTradingInfo(ds);
            var table = ds.Tables["TradingTime"];
            foreach (DataRow dr in table.Rows)
            {
                Guid InstrumentId = (Guid)dr["InstrumentID"];
                Protocal.TradingInstrument.InstrumentDayOpenCloseParams instrument;
                if (!_instrumentDict.TryGetValue(InstrumentId, out instrument))
                {
                    TradingTime tradingTIme = Settings.Setting.Default.GetTradingTime(InstrumentId);
                    instrument = new Protocal.TradingInstrument.InstrumentDayOpenCloseParams
                    {
                        Id = InstrumentId,
                        TradeDay = tradingTIme.DayOpenTime.Date,
                        DayOpenTime = tradingTIme.DayOpenTime,
                        DayCloseTime = tradingTIme.DayCloseTime,
                        IsTrading = true
                    };
                    _instrumentDict.Add(InstrumentId, instrument);
                }
                DateTime beginTime = (DateTime)dr["BeginTime"];
                DateTime endTime = (DateTime)dr["EndTime"];
                var session = new Protocal.TradingInstrument.TradingSession
                {
                    BeginTime = beginTime,
                    EndTime = endTime
                };
                instrument.AddSession(session);
            }
        }

        private void LoadTradingInfo(DataSet ds)
        {
            _tradingInfo = new Protocal.TradingInstrument.TradingInfo();
            _tradingInfo.TradingTimeList = new List<InstrumentTradingTime>();
            Dictionary<Guid, InstrumentTradingTime> tradingTimeDict = new Dictionary<Guid, InstrumentTradingTime>();
            var table = ds.Tables["TradingTime"];
            foreach (DataRow dr in table.Rows)
            {
                Guid instrumentId = (Guid)dr["InstrumentID"];
                InstrumentTradingTime instrumentTradingTime;
                if (!tradingTimeDict.TryGetValue(instrumentId, out instrumentTradingTime))
                {
                    instrumentTradingTime = new InstrumentTradingTime();
                    tradingTimeDict.Add(instrumentId, instrumentTradingTime);
                    instrumentTradingTime.Id = instrumentId;
                    instrumentTradingTime.Sessions = new List<TradingSession>();
                }

                DateTime beginTime = (DateTime)dr["BeginTime"];
                DateTime endTime = (DateTime)dr["EndTime"];
                var session = new Protocal.TradingInstrument.TradingSession
                {
                    BeginTime = beginTime,
                    EndTime = endTime
                };
                instrumentTradingTime.Sessions.Add(session);
            }

            var tradeDay = Setting.Default.GetTradeDay();
            _tradingInfo.TradeDayInfo = new TradeDayInfo()
            {
                 TradeDay = tradeDay.Day,
                 BeginTime = tradeDay.BeginTime,
                 EndTime = tradeDay.EndTime
            };

            foreach (var eachTradingTime in tradingTimeDict.Values)
            {
                _tradingInfo.TradingTimeList.Add(eachTradingTime);
            }


        }




        internal Protocal.Command GetUpdateInstrumentStatusCommand()
        {
            var instruments = _instrumentDict.Values.ToList();
            var content = JsonConvert.SerializeObject(instruments);
            var command = new Protocal.Command();
            command.Type = Protocal.CommandType.UpdateInstrumentStateFromDB;
            command.AppType = iExchange.Common.AppType.TransactionServer;
            command.Content = content;
            return command;
        }


    }
}
