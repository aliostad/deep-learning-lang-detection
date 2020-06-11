using System;

namespace NWiretap.Instruments
{
    public abstract class InstrumentBase : IInstrument
    {
        protected object SyncRoot = new object();

        private readonly string _instrumentIdent, _instrumentGroup;
        private readonly Type _owningType;

        protected InstrumentBase(Type owningType, string instrumentGroup, string instrumentName)
        {
            _owningType = owningType;
            _instrumentGroup = instrumentGroup;
            _instrumentIdent = instrumentName;
        }

        public Type OwningType
        {
            get { return _owningType; }
        }

        public string InstrumentGroup
        {
            get { return _instrumentGroup; }
        }

        public string InstrumentIdent
        {
            get { return _instrumentIdent; }
        }

        public abstract string InstrumentType { get; }

        public abstract InstrumentMeasurementBase GetMeasurement();
    }
}
