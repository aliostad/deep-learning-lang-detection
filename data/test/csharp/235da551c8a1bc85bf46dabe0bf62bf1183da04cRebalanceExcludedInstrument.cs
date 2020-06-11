using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using B4F.TotalGiro.Instruments;

namespace B4F.TotalGiro.Accounts.Instructions.Exclusions
{
    public class RebalanceExcludedInstrument : RebalanceExclusion, IRebalanceExcludedInstrument
    {
        protected RebalanceExcludedInstrument() { }

        public RebalanceExcludedInstrument(ITradeableInstrument instrument)
        {
            if (instrument == null)
                throw new ApplicationException("The instrument can not be null");
            this.Instrument = instrument;
        }
        
        /// <summary>
        /// Get/set the instrument
        /// </summary>
        public virtual ITradeableInstrument Instrument { get; set; }

        public override int ComponentKey
        {
            get { return Instrument.Key; }
        }

        public override ModelComponentType ComponentType
        {
            get { return ModelComponentType.Instrument; }
        }

        public override string ComponentName
        {
            get { return Instrument.DisplayNameWithIsin; }
        }
    }
}
