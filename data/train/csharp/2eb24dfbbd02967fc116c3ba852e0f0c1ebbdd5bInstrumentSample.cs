using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TheGrid.Model.Effect;

namespace TheGrid.Model.Instrument
{
    [Serializable]
    public class InstrumentSample : InstrumentBase
    {
        public Sample Sample { get; set; }
        public EffectProperty EffectProperty { get; set; }

        public InstrumentSample()
        {
        }

        public InstrumentSample(Sample sample)
        {
            this.Sample = sample;
        }
    }
}
