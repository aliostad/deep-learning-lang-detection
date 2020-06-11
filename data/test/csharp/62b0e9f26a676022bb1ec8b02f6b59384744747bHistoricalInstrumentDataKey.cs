using System;
using System.Collections.Generic;

namespace B4F.TotalGiro.Instruments
{
    [Serializable]
    public class HistoricalInstrumentDataKey
    {
        protected HistoricalInstrumentDataKey() { }

        public HistoricalInstrumentDataKey(IInstrument instrument, DateTime date)
        {
            this.instrument = instrument;
            this.date = date;
        }

        public IInstrument Instrument
        {
            get { return instrument; }
            set { instrument = value; }
        }

        public DateTime Date
        {
            get { return date; }
            set { date = value; }
        }

        #region Overrides

        public override bool Equals(object obj)
        {
            bool retVal = false;
            HistoricalInstrumentDataKey key = obj as HistoricalInstrumentDataKey;

            if (this == null && obj == null)
                retVal = true;
            else if (key == null)
                retVal = false;
            else if (this != null && key != null)
            {
                if (this.Instrument.Equals(key.Instrument) && this.Date.Equals(key.Date))
                    retVal = true;
            }
            return retVal;
        }

        public override int GetHashCode()
        {
            return instrument.GetHashCode();
        }

        #endregion

        #region Privates

        private IInstrument instrument;
        private DateTime date;
        
        #endregion
    }
}
