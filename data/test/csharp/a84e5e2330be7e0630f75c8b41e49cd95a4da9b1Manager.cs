using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using iExchange.Common;
using System.Threading;
using Core.TransactionServer.Agent.Settings;
using Core.TransactionServer.Agent.Framework;
using Core.TransactionServer.Agent.Quotations;
using log4net;
using Protocal.CommonSetting;

namespace Core.TransactionServer.Agent.Market
{
    public sealed class MarketManager
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(MarketManager));
        public static readonly MarketManager Default = new MarketManager();
        private Dictionary<Guid, Instrument> _instruments;
        private object _mutex = new object();

        static MarketManager() { }

        private MarketManager()
        {
            _instruments = new Dictionary<Guid, Instrument>(50);
        }

        internal static DateTime Now
        {
            get { return DateTime.Now; }
        }


        internal Instrument this[Guid instrumentId]
        {
            get
            {
                lock (_mutex)
                {
                    Instrument result = null;
                    _instruments.TryGetValue(instrumentId, out result);
                    return result;
                }
            }
        }

        internal void OnInstrumentUpdated(Settings.Instrument instrument, Settings.InstrumentUpdateType updateType)
        {
            lock (_mutex)
            {
                Logger.InfoFormat("Market manager update instrument, updateType = {0}, instrument = {1}", updateType, instrument);
                if (updateType == Settings.InstrumentUpdateType.Add)
                {
                    _instruments.Add(instrument.Id, new Instrument(instrument.Id));
                }
                else if (updateType == Settings.InstrumentUpdateType.Delete)
                {
                    _instruments.Remove(instrument.Id);
                }
            }
        }


        public void LoadInstruments()
        {
            lock (_mutex)
            {
                foreach (var eachInstrument in Settings.Setting.Default.Instruments.Values)
                {
                    if (!_instruments.ContainsKey(eachInstrument.Id))
                    {
                        _instruments.Add(eachInstrument.Id, new Instrument(eachInstrument.Id));
                    }
                }
            }
        }


        internal void LoadQuotations(IDBRow overridedQuotationRow, Dictionary<Guid, QuotePolicy2QuotationDict> instrumentQuotations)
        {
            lock (_mutex)
            {
                Guid instrumentId = (Guid)overridedQuotationRow["InstrumentID"];
                Instrument instrument = _instruments[instrumentId];
                string ask = overridedQuotationRow["Ask"] == DBNull.Value ? null : (string)overridedQuotationRow["Ask"];
                string bid = overridedQuotationRow["Bid"] == DBNull.Value ? null : (string)overridedQuotationRow["Bid"];
                string high = overridedQuotationRow["High"] == DBNull.Value ? null : (string)overridedQuotationRow["High"];
                string low = overridedQuotationRow["Low"] == DBNull.Value ? null : (string)overridedQuotationRow["Low"];
                DateTime timestamp = (DateTime)overridedQuotationRow["Timestamp"];
                Quotation quotation = Quotation.Create(instrumentId, ask, bid, high, low, timestamp, Settings.Setting.Default);

                Guid quotePolicyId = (Guid)overridedQuotationRow["QuotePolicyID"];
                QuotePolicy2QuotationDict dict;
                if (!instrumentQuotations.TryGetValue(instrumentId, out dict))
                {
                    dict = new QuotePolicy2QuotationDict();
                    instrumentQuotations.Add(instrumentId, dict);
                }
                dict.Add(quotePolicyId, quotation);
            }
        }


        public void UpdateQuotation(QuotationBulk quotationBulk)
        {
            lock (_mutex)
            {
                foreach (var eachInstrument in _instruments.Values)
                {
                    QuotePolicy2QuotationDict dict;
                    if (quotationBulk.TryGetValue(eachInstrument.Id, out dict))
                    {
                        eachInstrument.UpdateQuotation(quotationBulk);
                    }
                }
            }
        }

        internal Quotation GetQuotation(Guid instrumentId, IQuotePolicyProvider provider)
        {
            lock (_mutex)
            {
                Instrument instrument;
                if (!_instruments.TryGetValue(instrumentId, out instrument))
                {
                    return null;
                }
                return instrument.GetQuotation(provider);
            }
        }

    }
}