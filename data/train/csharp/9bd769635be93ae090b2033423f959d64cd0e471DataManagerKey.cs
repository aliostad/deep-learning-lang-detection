using System;

namespace Trader.Server.Bll
{
    class DataManagerKey
    {
        private readonly Guid _InstrumentId;
        private readonly string _DataCycle;
        private DataManagerKey(Guid instrumentId, string dataCycle)
        {
            this._InstrumentId = instrumentId;
            this._DataCycle = dataCycle;
        }
        public static DataManagerKey Create(Guid instrumentId, string dataCycle)
        {
            return new DataManagerKey(instrumentId, dataCycle);
        }

        public override bool Equals(object o)
        {
            var dataManagerKey = (DataManagerKey)o;
            return (dataManagerKey._InstrumentId.Equals(this._InstrumentId)
                    && dataManagerKey._DataCycle.Equals(this._DataCycle));
        }

        public override int GetHashCode()
        {
            return this._InstrumentId.GetHashCode() ^ this._DataCycle.GetHashCode();
        }
    }
}