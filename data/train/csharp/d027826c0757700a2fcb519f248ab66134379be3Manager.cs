using log4net;
using Protocal;
using Protocal.TradingInstrument;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;

namespace SystemController.InstrumentBLL
{
    internal sealed class CheckPoint : IComparable<CheckPoint>
    {
        private Guid _instrumentId;
        private DateTime _checkTime;
        private InstrumentStatus _status;

        internal CheckPoint(Guid instrumentId, DateTime checkTime, InstrumentStatus status, DateTime tradeDay)
        {
            _instrumentId = instrumentId;
            _checkTime = checkTime;
            _status = status;
            this.TradeDay = tradeDay;
        }

        internal Guid InstrumentId
        {
            get { return _instrumentId; }
        }

        internal DateTime CheckTime
        {
            get { return _checkTime; }
        }

        internal InstrumentStatus Status
        {
            get { return _status; }
        }

        internal DateTime TradeDay
        {
            get;
            private set;
        }


        public int CompareTo(CheckPoint other)
        {
            return this.CheckTime.CompareTo(other.CheckTime);
        }

        public override string ToString()
        {
            return string.Format("instrumentId = {0}, checkTime = {1}, status = {2}, tradeDay = {3}", this.InstrumentId, this.CheckTime, this.Status, this.TradeDay);
        }
    }

    internal struct InstrumentCheckTimeKey : IEquatable<InstrumentCheckTimeKey>
    {
        private Guid _id;
        private DateTime _checkTime;

        internal InstrumentCheckTimeKey(Guid id, DateTime checkTime)
        {
            _id = id;
            _checkTime = checkTime;
        }

        internal Guid Id
        {
            get { return _id; }
        }

        internal DateTime CheckTime
        {
            get { return _checkTime; }
        }

        public bool Equals(InstrumentCheckTimeKey other)
        {
            return this.Id == other.Id && this.CheckTime == other.CheckTime;
        }

        public override bool Equals(object obj)
        {
            return this.Equals((InstrumentCheckTimeKey)obj);
        }

        public override int GetHashCode()
        {
            return this.Id.GetHashCode() ^ this.CheckTime.GetHashCode();
        }
    }


    public sealed class Manager
    {
        public static readonly Manager Default = new Manager();
        private static readonly TimeCheckPointComparer TimeCheckComparer = new TimeCheckPointComparer();
        private static readonly ILog Logger = LogManager.GetLogger(typeof(Manager));
        private Protocal.Common.Heap<CheckPoint> _checkPointHeap = new Protocal.Common.Heap<CheckPoint>();
        private HashSet<InstrumentCheckTimeKey> _loadedInstrumentCheckPoints = new HashSet<InstrumentCheckTimeKey>();
        private object _mutex = new object();
        static Manager() { }

        private Manager()
        {
            new Thread(this.TimePointCheckHandle)
            {
                IsBackground = true
            }.Start();
        }


        internal void LoadInstrumentTradingTimeFromDB()
        {
            lock (_mutex)
            {
                var tradingParams = TradingTimeFactory.Default.Create();
                this.LoadInstumentTradingTimeCommon(tradingParams);
            }
        }


        internal void LoadInstrumentTradingTimes(List<Protocal.TradingInstrument.InstrumentDayOpenCloseParams> instrumentDayOpenCloseParams)
        {
            lock (_mutex)
            {
                this.LoadInstumentTradingTimeCommon(instrumentDayOpenCloseParams);
            }
        }


        private void LoadInstumentTradingTimeCommon(List<Protocal.TradingInstrument.InstrumentDayOpenCloseParams> instrumentDayOpenCloseParams)
        {
            Logger.InfoFormat("LoadInstumentTradingTimeCommon, instrumentParamsCount = {0}", instrumentDayOpenCloseParams.Count);
            InstrumentTradingStatusBuilderProxy builder = new InstrumentTradingStatusBuilderProxy();
            foreach (var eachInstrumentDayOpenCloseParam in instrumentDayOpenCloseParams)
            {
                this.LoadTimeCheckPoints(eachInstrumentDayOpenCloseParam, builder);
            }
            if (builder.ExistsStatus())
            {
                Logger.Info("LoadInstumentTradingTimeCommon");
                this.OnInstrumentsStatusChanged(builder.StatusDict);
            }
        }

        private void LoadTimeCheckPoints(InstrumentDayOpenCloseParams instrumentTradingParam, InstrumentTradingStatusBuilderProxy tradingStatus)
        {
            if (instrumentTradingParam.IsTrading)
            {
                this.AddCheckPoint(instrumentTradingParam.Id, instrumentTradingParam.DayOpenTime.Value, InstrumentStatus.DayOpen, instrumentTradingParam.TradeDay, tradingStatus);
                this.AddCheckPoint(instrumentTradingParam.Id, instrumentTradingParam.DayCloseTime.Value, InstrumentStatus.DayClose, instrumentTradingParam.TradeDay, tradingStatus);
                foreach (var eachSession in instrumentTradingParam.TradingSessions)
                {
                    this.AddCheckPoint(instrumentTradingParam.Id, eachSession.BeginTime, InstrumentStatus.SessionOpen, instrumentTradingParam.TradeDay, tradingStatus);
                    this.AddCheckPoint(instrumentTradingParam.Id, eachSession.EndTime, InstrumentStatus.SessionClose, instrumentTradingParam.TradeDay, tradingStatus);
                }
                if (instrumentTradingParam.DayCloseTime != null)
                {
                    DateTime acceptEndTime = instrumentTradingParam.DayCloseTime.Value.AddMinutes(-instrumentTradingParam.LastAcceptTimeSpan);
                    this.AddCheckPoint(instrumentTradingParam.Id, acceptEndTime, InstrumentStatus.StopPlace, instrumentTradingParam.TradeDay, tradingStatus);
                }
            }
        }

        private void AddCheckPoint(Guid instrumentId, DateTime checkTime, InstrumentStatus status, DateTime tradeDay, InstrumentTradingStatusBuilderProxy tradingStatus)
        {
            CheckPoint checkPoint = new CheckPoint(instrumentId, checkTime, status, tradeDay);
            var now = DateTime.Now;
            Logger.InfoFormat("add check point, {0}", checkPoint.ToString());
            if (checkPoint.CheckTime <= now)
            {
                tradingStatus.Add(checkPoint.InstrumentId, checkPoint.Status, checkPoint.CheckTime, tradeDay);
            }
            else
            {
                if (_loadedInstrumentCheckPoints.Contains(new InstrumentCheckTimeKey(instrumentId, checkTime))) return;
                _loadedInstrumentCheckPoints.Add(new InstrumentCheckTimeKey(instrumentId, checkTime));
                _checkPointHeap.Add(checkPoint);
            }
        }

        private void TimePointCheckHandle()
        {
            while (true)
            {
                Thread.Sleep(1000);
                try
                {
                    this.DoTimePointCheck();
                }
                catch (Exception ex)
                {
                    Logger.Error(ex);
                }
            }
        }


        private void DoTimePointCheck()
        {
            Logger.InfoFormat("check point counts = {0}", _checkPointHeap.Count);
            InstrumentTradingStatusBuilderProxy statusBuilder = null;
            lock (_mutex)
            {
                while (_checkPointHeap.Count > 0 && _checkPointHeap.Pick().CheckTime <= DateTime.Now)
                {
                    CheckPoint point = _checkPointHeap.Pop();
                    _loadedInstrumentCheckPoints.Remove(new InstrumentCheckTimeKey(point.InstrumentId, point.CheckTime));
                    Logger.InfoFormat("Dequeue, current check point {0}", point);
                    if (statusBuilder == null) statusBuilder = new InstrumentTradingStatusBuilderProxy();
                    statusBuilder.Add(point.InstrumentId, point.Status, point.CheckTime, point.TradeDay);
                }
            }
            if (statusBuilder != null)
            {
                this.OnInstrumentsStatusChanged(statusBuilder.StatusDict);
            }
        }



        private void OnInstrumentsStatusChanged(Dictionary<InstrumentStatus, List<Guid>> status)
        {
            TradingTimeManager.Default.Process(status);
        }


        private sealed class TimeCheckPointComparer : IComparer<CheckPoint>
        {
            public int Compare(CheckPoint x, CheckPoint y)
            {
                return x.CheckTime.CompareTo(y.CheckTime);
            }
        }
    }
}
