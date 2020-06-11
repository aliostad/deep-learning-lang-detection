using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TheGrid.Model.Effect;

namespace TheGrid.Model.Instrument
{
    [Serializable]
    public class InstrumentEffect : InstrumentBase
    {
        public ChannelEffect ChannelEffect { get; set; }
        public bool FixedValue { get; set; }

        public InstrumentEffect()
        {
        }

        public InstrumentEffect(ChannelEffect channelEffect)
        {
            this.ChannelEffect = channelEffect;
        }
    }
}
