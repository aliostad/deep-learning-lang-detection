using log4net;
using Protocal;
using Protocal.TradingInstrument;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading.Tasks.Dataflow;
using System.Xml.Linq;
using SystemController.Factory;
using SystemController.Persistence;
using Protocal.TypeExtensions;
using System.Diagnostics;

namespace SystemController.InstrumentBLL
{
    internal delegate void DayCloseQuotationReceivedHandle(Guid instrumentId, DateTime tradeDay);

    internal sealed class InstrumentManager
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(InstrumentManager));
        internal static readonly InstrumentManager Default = new InstrumentManager();
        private Dictionary<Guid, Instrument> _instrumentDict = new Dictionary<Guid, Instrument>();
        private object _mutex = new object();

        static InstrumentManager() { }
        private InstrumentManager() { }

        internal int Count
        {
            get
            {
                lock (_mutex)
                {
                    return _instrumentDict.Count;
                }
            }
        }

        internal DateTime? GetInstrumentTradeDay(Guid instrumentId)
        {
            lock (_mutex)
            {
                try
                {
                    return _instrumentDict[instrumentId].TradeDay;
                }
                catch (System.Collections.Generic.KeyNotFoundException ex)
                {
                    Logger.ErrorFormat("instrumentId = {0}, error = {1}", instrumentId, ex);
                    throw;
                }
            }
        }


        internal void DayCloseQuotationReceivedEventHandle(Guid instrumentId, DateTime tradeDay)
        {
            lock (_mutex)
            {
                Instrument instrument;
                if (!_instrumentDict.TryGetValue(instrumentId, out instrument))
                {
                    Logger.InfoFormat("DayCloseQuotationReceived instrument not exists. instrumentId = {0}, tradeDay = {1}", instrumentId, tradeDay);
                    return;
                }
                Logger.InfoFormat("DayCloseQuotationReceivedEventHandle instrumentId = {0}, instrument.TradeDay = {1}, tradeDay = {2}", instrumentId, instrument.TradeDay, tradeDay);
                instrument.DayCloseQuotationReceived = true;
            }
        }

        internal bool IsAllInstrumentsReceivedDayCloseQuotation(DateTime tradeDay)
        {
            lock (_mutex)
            {
                foreach (var eachInstrument in _instrumentDict.Values)
                {
                    if (!IsInstrumentReceivedDayCloseQuotation(eachInstrument, tradeDay))
                    {
                        Logger.InfoFormat("IsInstrumentReceivedDayCloseQuotation instrumentId = {0}, instrument.TradeDay = {1}, instrument.ReceivedDayCloseQuotation = {2}, tradeDay = {3}", eachInstrument.Id,
                            eachInstrument.TradeDay, eachInstrument.DayCloseQuotationReceived, tradeDay);
                        return false;
                    }
                }
                return true;
            }
        }

        private bool IsInstrumentReceivedDayCloseQuotation(Instrument instrument, DateTime tradeDay)
        {
            return (instrument.TradeDay == tradeDay.AddDays(1) && instrument.DayCloseQuotationReceived) || instrument.TradeDay > tradeDay.AddDays(1);
        }

        internal void ResetDayCloseQuotationState()
        {
            lock (_mutex)
            {
                foreach (var eachInstrument in _instrumentDict.Values)
                {
                    eachInstrument.DayCloseQuotationReceived = false;
                }
            }
        }


        internal void UpdateInstrument(Guid instrumentId, DateTime? tradeDay, DateTime? dayOpenTime, DateTime? dayCloseTime)
        {
            lock (_mutex)
            {
                Logger.InfoFormat("UpdateInstrumentDayOpenTime instrumentId={0}, tradeDay={1}, dayOpenTime={2}, dayCloseTime={3}", instrumentId, tradeDay, dayOpenTime, dayCloseTime);
                Instrument instrument;
                if (_instrumentDict.TryGetValue(instrumentId, out instrument))
                {
                    instrument.TradeDay = tradeDay;
                    instrument.DayOpenTime = dayOpenTime;
                    instrument.DayCloseTime = dayCloseTime;
                }
            }
        }

        internal void InitializeInstrument(DataSet ds)
        {
            lock (_mutex)
            {
                foreach (DataRow eachDataRow in ds.Tables["Instrument"].Rows)
                {
                    var instrument = new Instrument(eachDataRow);
                    if (!_instrumentDict.ContainsKey(instrument.Id))
                    {
                        _instrumentDict.Add(instrument.Id, instrument);
                        Logger.InfoFormat("InitializeInstrument, {0}", instrument.ToString());
                    }
                    else
                    {
                        Logger.WarnFormat("Initialize error, duplicate instrument id = {0}", instrument.Id);
                    }
                }
            }
        }

        internal Instrument GetInstrument(Guid instrumentId)
        {
            lock (_mutex)
            {
                Instrument result;
                _instrumentDict.TryGetValue(instrumentId, out result);
                return result;
            }
        }


        internal void UpdateInstrumentTradingSession(Guid instrumentId, List<TradingSession> sessions)
        {
            lock (_mutex)
            {
                Instrument instrument;
                if (_instrumentDict.TryGetValue(instrumentId, out instrument))
                {
                    instrument.UpdateSessions(sessions);
                }
            }
        }

        internal TradingSession GetCurrentTradingSession(Guid instrumentId)
        {
            lock (_mutex)
            {
                Logger.InfoFormat("GetCurrentTradingSession instrumentId = {0}", instrumentId);
                Instrument instrument;
                if (_instrumentDict.TryGetValue(instrumentId, out instrument))
                {
                    return instrument.GetCurrentSession();
                }
                return null;
            }
        }

        internal List<TradingSession> GetTradingSessions(Guid instrumentId)
        {
            lock (_mutex)
            {
                Instrument instrument;
                if (_instrumentDict.TryGetValue(instrumentId, out instrument))
                {
                    return instrument.Sessions;
                }
                return new List<TradingSession>();
            }
        }


        internal XElement CreateSqlParam(List<Guid> instrumentIds)
        {
            lock (_mutex)
            {
                XElement result = new XElement("Instruments");
                foreach (var eachInstrumentId in instrumentIds)
                {
                    var instrument = _instrumentDict[eachInstrumentId];
                    XElement item = new XElement("Instrument");
                    item.SetAttributeValue("ID", instrument.Id);
                    if (instrument.TradeDay != null)
                    {
                        item.SetAttributeValue("TradeDay", instrument.TradeDay.Value.AddDays(1).ToString("yyyy-MM-dd HH:mm:ss"));
                    }
                    else
                    {
                        //如果TradeDay为Null，表明为新增的Instrument
                        item.SetAttributeValue("TradeDay", TradeDayManager.Default.TradeDay .ToString("yyyy-MM-dd HH:mm:ss"));
                    }
                    result.Add(item);
                }
                return result;
            }
        }


        internal void AddNewInstrument(string updateXml)
        {
            try
            {
                Guid id;
                if (this.DoAddNewInstrument(updateXml, out id))
                {
                    DayCloseManager.Default.CreateAndBroadcastInstrumentDayOpenCloseTimeCommand(new List<Guid>() { id });
                }
            }
            catch (Exception ex)
            {
                Logger.Error(ex);
            }
        }

        private bool DoAddNewInstrument(string updateXml, out Guid id)
        {
            lock (_mutex)
            {
                id = Guid.Empty;
                try
                {
                    Logger.WarnFormat("AddNewInstrument content = {0}", updateXml);
                    XElement root = XElement.Parse(updateXml);
                    if (root.Name != "Update" || root.Element("Add") == null || root.Element("Add").Element("Instrument") == null)
                    {
                        return false;
                    }
                    Logger.InfoFormat("AddNewInstrument {0}", updateXml);
                    XElement instrumentNode = root.Element("Add").Element("Instrument");
                    id = instrumentNode.AttrToGuid("ID");
                    _instrumentDict.Add(id, new Instrument(id));
                    return true;
                }
                catch (Exception ex)
                {
                    Logger.Error(ex);
                    return false;
                }
            }
        }

    }


}
